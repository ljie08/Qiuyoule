//
//  MXssIntegralListViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//积分明细页面

#import "MXssIntegralListViewController.h"
#import "MXssIntegralListTableViewCell.h"//积分明细cell页面
#import "MXssSignInScoreDetailModel.h"//积分明细model

@interface MXssIntegralListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic , assign) NSInteger page ;//页数加载
@property (nonatomic , assign)BOOL isHeaderRefresh;

@end

@implementation MXssIntegralListViewController
{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableview];
    //页数
    self.page = 1;
    self.isHeaderRefresh = YES;
     self.modelArr = [NSMutableArray array];
    [self SignInScoreDetailMoreData];//积分明细列表
    //上拉下拉刷新
    self.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.modelArr = [NSMutableArray array];
        //页数
        self.page = 1;
        self.isHeaderRefresh = YES;
        [self SignInScoreDetailMoreData];//积分明细列表
    }];
    self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.modelArr.count %10 == 0) {
                self.page ++ ;
                self.isHeaderRefresh = NO;
                [self SignInScoreDetailMoreData];
            }
            [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
        });
        
    }];
}


- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
//    if (weakSelf.modelArr.count == 0) {
//        [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
//        //消除尾部"没有更多数据"的状态
//        weakSelf.mainTableview.mj_footer.hidden = YES ;
//    }else{
        [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
//    }
}
#pragma mark ---SignInScoreDetailData积分明细数据
-(void)SignInScoreDetailMoreData{
    
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMySignInScoreDetail_PATH;//积分明细列表

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    [paraDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
     [paraDic setObject:@"10" forKey:@"limit"];//分页起始位置
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"积分明细列表==%@",personDic);
         [weakSelf.mainTableview.mj_header endRefreshing];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
            [SVProgressHUD dismiss];
            [self.mainTableview.mj_header endRefreshing];
            if (self.isHeaderRefresh == YES) {
                    [weakSelf.modelArr removeAllObjects];
            }
             NSDictionary *quanziDict = personDic[@"data"];
            NSMutableArray * array = [MXssSignInScoreDetailModel mj_objectArrayWithKeyValuesArray:quanziDict] ;
            [weakSelf.modelArr addObjectsFromArray:array];
            if (weakSelf.modelArr.count == 0) {
                [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                //消除尾部"没有更多数据"的状态
                weakSelf.mainTableview.mj_footer.hidden = YES ;
            }else{
                [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                //消除尾部"没有更多数据"的状态
//                weakSelf.mainTableview.mj_footer.hidden = YES ;
            }
            if (self.modelArr.count < 10) {
                [weakSelf.mainTableview.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.mainTableview.mj_footer endRefreshing];
            }
            [weakSelf.mainTableview reloadData];
        }else {
            if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
                //请先登录
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                login.isPageNumber = 1;
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
            }else {
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
            }
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        [self.mainTableview.mj_header endRefreshing];
        [self.mainTableview.mj_footer endRefreshing];
    }];
}
#pragma mark-set/get
-(UITableView *)mainTableview{
    if (_mainTableview == nil) {
        _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME  - scaleWithSize(44)) style:UITableViewStyleGrouped];
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        //        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏整体cell线
        //        _mainTableview.backgroundColor = kWhiteColor;
        _mainTableview.backgroundColor = mx_Wode_backgroundColor;
        [_mainTableview registerClass:[MXssIntegralListTableViewCell class] forCellReuseIdentifier:@"collectionCell"];
        _mainTableview.showsVerticalScrollIndicator = false;//上下滑动关闭滚动的显示
        //        _mainTableview.showsVerticalScrollIndicator = false;
        /**
         *  将tableview的分割线补满
         */
        if ([_mainTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableview setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_mainTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableview setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _mainTableview;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return scaleWithSize(1.0f);//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark mainTableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.modelArr.count) {
        return self.modelArr.count;
    }else {
    return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return scaleWithSize(60);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 0) {
    static NSString *CellIdentifier = @"collectionCell";//cell重用问题
    MXssIntegralListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXssIntegralListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //            cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
    //    cell.textLabel.text = @"ahsjrtr";
    if (self.modelArr.count) {
        MXssSignInScoreDetailModel *model = self.modelArr[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.integralTitleLabel.text = model.remarks;
        cell.integralTimeLabel.text = model.createTime;
    cell.integralNumberSumLabel.text = [NSString stringWithFormat:@"积分：%@",model.restScore];
//        if (model.scoreStatus.integerValue == 1) {
         if (model.scoreValue.integerValue > 0) {
            cell.integralNumberLabel.text = [NSString stringWithFormat:@"+%@",model.scoreValue];
        }else {
            cell.integralNumberLabel.text = [NSString stringWithFormat:@"%@",model.scoreValue];
        }
    }
    return cell;
    
}
// 隐藏多余cell
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//cell点击
    NSLog(@"我的积分明细点击cell?????==%ld",indexPath.row);
//    MXSSMyPostDetailsViewController *postDetailsVC = [[MXSSMyPostDetailsViewController  alloc] init];
//    [self.navigationController pushViewController:postDetailsVC animated:YES];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
