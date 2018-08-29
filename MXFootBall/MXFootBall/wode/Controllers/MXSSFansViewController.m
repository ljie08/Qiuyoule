//
//  MXSSFansViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSFansViewController.h"
#import "MXSSFansTableViewCell.h"
#import "MXssFansModel.h"//粉丝列表model
#import "MXssMyAttentionModel.h"//关注列表model
#import "MXSYJPersonController.h"//个人详情
#import "MXSYJHallModel.h"

@interface MXSSFansViewController ()<UITableViewDelegate,UITableViewDataSource>
//{
//    MJRefreshAutoNormalFooter *_refreshFooter;
//}
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic,assign) BOOL buttonIsSwitch;//
//@property (nonatomic,strong) MXssFansModel *fansModels;//粉丝列表model
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *attentionArr;//关注数组
@property (nonatomic , assign) NSInteger page ;//页数加载
@property (nonatomic , assign) NSInteger pageAtte;//
@property (nonatomic , assign)BOOL isHeaderRefresh;
@end

@implementation MXSSFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = mx_Wode_backgroundColor;
    [self.view addSubview:self.mainTableview];
    self.modelArr = [NSMutableArray array];
    self.attentionArr = [NSMutableArray array];
    //页数
    self.page = 1;
    self.pageAtte = 1;
    [self FindFansMoreData];

    //上拉下拉刷新
    self.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
            self.modelArr = [NSMutableArray array];
            self.page = 1 ;
        }else {
            self.attentionArr = [NSMutableArray array];
            self.pageAtte = 1 ;
        }
        
        self.isHeaderRefresh = YES;
        [self FindFansMoreData];
    }];
    self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
                if (self.modelArr.count %10 == 0) {
                    self.page ++ ;
                    self.isHeaderRefresh = NO;
                    [self FindFansMoreData];
                }
            }else {
                if (self.attentionArr.count %10 == 0) {
                    self.pageAtte ++ ;
                    self.isHeaderRefresh = NO;
                    [self FindFansMoreData];
                }
            }
            [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
        });
    }];
}

#pragma mark ---findFansData粉丝列表数据
-(void)FindFansMoreData{
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = @"";
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
        url = MXWodemFindFans_PATH;//我的粉丝列表
        [paraDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    } else {
        [paraDic setObject:[NSString stringWithFormat:@"%ld",self.pageAtte] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
        url = MXWodeMyAttentionList_PATH;//我的关注列表
    }
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    [paraDic setObject:@"10" forKey:@"limit"];//分页起始位置
    [SVProgressHUD showWithStatus:@"正在加载..."];
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"请求数据粉丝？关注？列表==%@",personDic);
        [weakSelf.mainTableview.mj_header endRefreshing];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
            [SVProgressHUD dismiss];
            [self.mainTableview.mj_header endRefreshing];
            if (self.isHeaderRefresh == YES) {
                if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
                    [weakSelf.modelArr removeAllObjects];
                }else {
                    [weakSelf.attentionArr removeAllObjects];
                }
            }
            NSDictionary *quanziDict = personDic[@"data"];
            if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
                //粉丝列表
                NSMutableArray * array = [MXssFansModel mj_objectArrayWithKeyValuesArray:quanziDict] ;
                [weakSelf.modelArr addObjectsFromArray:array];
                if (weakSelf.modelArr.count == 0) {
                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                    //消除尾部"没有更多数据"的状态
                    weakSelf.mainTableview.mj_footer.hidden = YES ;
                }else{
                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                }
                if (self.modelArr.count < 10) {
                    [weakSelf.mainTableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelf.mainTableview.mj_footer endRefreshing];
                }
                [weakSelf.mainTableview reloadData];
                //消除尾部"没有更多数据"的状态
//                weakSelf.mainTableview.mj_footer.hidden = YES ;
            }else {//我的关注列表
                 NSMutableArray * array = [MXssMyAttentionModel mj_objectArrayWithKeyValuesArray:quanziDict] ;
                
                [weakSelf.attentionArr addObjectsFromArray:array];
                
                if (self.attentionArr.count == 0) {
                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                    //消除尾部"没有更多数据"的状态
                    weakSelf.mainTableview.mj_footer.hidden = YES ;
                }else{
                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                }
                if (self.attentionArr.count < 10) {
                    [weakSelf.mainTableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelf.mainTableview.mj_footer endRefreshing];
                }
                [weakSelf.mainTableview reloadData];
                //消除尾部"没有更多数据"的状态
//                weakSelf.mainTableview.mj_footer.hidden = YES ;
            }
            
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
    }];
}

#pragma mark-set/get
-(UITableView *)mainTableview{
    if (_mainTableview == nil) {
        if(UI_IS_IPHONEX){//判断机型X
            _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME) style:UITableViewStyleGrouped];
        }else{
            _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - scaleWithSize(30)) style:UITableViewStyleGrouped];
        }
        
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        //        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏整体cell线
        _mainTableview.backgroundColor = [UIColor clearColor];
        [_mainTableview registerClass:[MXSSFansTableViewCell class] forCellReuseIdentifier:@"fansCell"];
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
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    [self.mainTableview reloadData];
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
    if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
//        [self initTitleViewWithTitle:@"粉丝"];
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"粉丝界面\"}"];
    }else {
//        [self initTitleViewWithTitle:@"关注"];
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"关注界面\"}"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"粉丝界面\"}"];
    }else{
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"关注界面\"}"];
    }
        [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}

#pragma mark mainTableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
        if (self.modelArr.count>0) {
            return self.modelArr.count;
        }else {
            return 0;
        }
    }else {
        if (self.attentionArr.count>0) {
            return self.attentionArr.count;
        }else {
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return scaleWithSize(70);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 0) {
    static NSString *CellIdentifier = @"fansCell";//cell重用问题
    MXSSFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXSSFansTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //    MXSSFansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fansCell" forIndexPath:indexPath];
    //            cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
    if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
        if (self.modelArr.count>0) {
            
            MXssFansModel *fansModels = self.modelArr[indexPath.row];
            cell.fansNickNameLabel.text = fansModels.username;
            cell.fansGradeLabel.text = fansModels.levelName;
            cell.fansSignatureLabel.text = fansModels.userSign;
            [ cell.fansTouImageLabel sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", fansModels.headerPic]] placeholderImage:[UIImage imageNamed:@"saishi_morentouxiang"]];
            //判断是否关注 if //my_guangzhu   my_meiguanzhu

            if ([fansModels.isAttention isEqualToString:@"0"]){
                [cell.fansGuanzhuBut setBackgroundImage:[UIImage imageNamed:@"my_guangzhu"] forState:UIControlStateNormal];
            }else if ([fansModels.isAttention isEqualToString:@"1"]) {
                [cell.fansGuanzhuBut setBackgroundImage:[UIImage imageNamed:@"my_yiguan"] forState:UIControlStateNormal];
            }else  if ([fansModels.isAttention isEqualToString:@"2"]){
                [cell.fansGuanzhuBut setBackgroundImage:[UIImage imageNamed:@"my_huguan"] forState:UIControlStateNormal];
            }
        }
    }
    if ([self.titleNameGuanOrFen isEqualToString:@"关注"]) {
        //my_guangzhu   my_meiguanzhu
        if (self.attentionArr.count>0) {
            
            MXssMyAttentionModel *attentionModels = self.attentionArr[indexPath.row];
            if ([attentionModels.isAttention isEqualToString:@"0"]){
                [cell.fansGuanzhuBut setBackgroundImage:[UIImage imageNamed:@"my_guangzhu"] forState:UIControlStateNormal];
            }else if ([attentionModels.isAttention isEqualToString:@"1"]){
                [cell.fansGuanzhuBut setBackgroundImage:[UIImage imageNamed:@"my_yiguan"] forState:UIControlStateNormal];
            }else if ([attentionModels.isAttention isEqualToString:@"2"]){
                [cell.fansGuanzhuBut setBackgroundImage:[UIImage imageNamed:@"my_huguan"] forState:UIControlStateNormal];
            }
            
            cell.fansNickNameLabel.text = attentionModels.username;
            cell.fansGradeLabel.text = attentionModels.levelName;
            cell.fansSignatureLabel.text = attentionModels.userSign;
            [ cell.fansTouImageLabel sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", attentionModels.headerPic]] placeholderImage:[UIImage imageNamed:@"saishi_morentouxiang"]];
        }
    }
    cell.fansGuanzhuBut.tag = indexPath.row;
    [cell.fansGuanzhuBut addTarget:self action:@selector(buttonGuanzhuClick:) forControlEvents:UIControlEventTouchUpInside];//关注按钮点击
    return cell;
}

- (void)buttonGuanzhuClick:(UIButton*)sender {//关注按钮的点击
    NSLog(@"关注按钮的点击===%ld",sender.tag);
    if ([self.titleNameGuanOrFen isEqualToString:@"关注"]) {
        //粉丝关注按钮点击调用接口 传值粉丝的id
        MXssMyAttentionModel *attentionModels = self.attentionArr[sender.tag];
        if (attentionModels.isAttention.integerValue == 0) {
            [self AddFanData:attentionModels.ownerId opidIsYesOrNo:@"1" withNumberButton:sender];
        }else if (attentionModels.isAttention.integerValue == 1||attentionModels.isAttention.integerValue == 2) {
            [self AddFanData:attentionModels.ownerId opidIsYesOrNo:@"0" withNumberButton:sender];
        }
    }else{
        MXssFansModel *fansModels = self.modelArr[sender.tag];
        if (fansModels.isAttention.integerValue == 1||fansModels.isAttention.integerValue == 2) {
            [self AddFanData:fansModels.fansId opidIsYesOrNo:@"0" withNumberButton:sender];
        }else {
            [self AddFanData:fansModels.fansId opidIsYesOrNo:@"1" withNumberButton:sender];
        }
    }
}
#pragma mark ---AddFanData粉丝关注按钮数据
-(void)AddFanData:(NSString *)numberOwnerId opidIsYesOrNo:(NSString *)isYesOrNoNumber withNumberButton:(UIButton*)numberSender{
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMyAndCancelAtten_PATH;//请求关注\取消关注 接口
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    [paraDic setObject:numberOwnerId forKey:@"ownerId"];//被关注者ID
    [paraDic setObject:isYesOrNoNumber forKey:@"opid"];//操作Flg（0：取消关注，1：关注）
    //    mx_weakify(self);
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"粉丝关注按钮的==%@",personDic);
        NSDictionary *dic = [personDic objectForKey:@"data"];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            
            if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
                MXssFansModel *fansModels = self.modelArr[numberSender.tag];
                fansModels.isAttention = dic[@"isAttention"];
                if (fansModels.isAttention.integerValue == 0){
                    [numberSender setBackgroundImage:[UIImage imageNamed:@"my_guangzhu"] forState:UIControlStateNormal];
                }else if (fansModels.isAttention.integerValue == 1) {
                    
                    [numberSender setBackgroundImage:[UIImage imageNamed:@"my_yiguan"] forState:UIControlStateNormal];
                }else if (fansModels.isAttention.integerValue == 2) {
                    
                    [numberSender setBackgroundImage:[UIImage imageNamed:@"my_huguan"] forState:UIControlStateNormal];
                }
            }else {//我的关注列表isAttention=1
                
                MXssMyAttentionModel *attentionModels = self.attentionArr[numberSender.tag];
                attentionModels.isAttention = dic[@"isAttention"];
                if (attentionModels.isAttention.integerValue == 0) {
                    [numberSender setBackgroundImage:[UIImage imageNamed:@"my_guangzhu"] forState:UIControlStateNormal];
                }else if (attentionModels.isAttention.integerValue == 1) {
                    [numberSender setBackgroundImage:[UIImage imageNamed:@"my_yiguan"] forState:UIControlStateNormal];
                }else {
                    [numberSender setBackgroundImage:[UIImage imageNamed:@"my_huguan"] forState:UIControlStateNormal];
                }
            }
        }else {
            if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
                //请先登录
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                login.isPageNumber = 1;
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
                [self removeFromParentViewController];
            }else {
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
            }
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
// 隐藏多余cell
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//cell点击
    NSLog(@"?????==%ld",indexPath.row);
    
    MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
    if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
        MXssFansModel *fansModels = self.modelArr[indexPath.row];
    vc.ownerId = fansModels.fansId;
    vc.ownerName = fansModels.username;
    }else{
        MXssMyAttentionModel *attentionModels = self.attentionArr[indexPath.row];
        vc.ownerId = attentionModels.ownerId;
        vc.ownerName = attentionModels.username;
    }
    [self.navigationController pushViewController:vc animated:YES];
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
