//
//  MXSSMessageViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSMessageViewController.h"
#import "MXSSMessageTableViewCell.h"
#import "MXssMessageModel.h"//消息model

#import "MXBattleDetailsViewController.h"//赛事
#import "MXSYJWebViewController.h"//活动
#import "MXSYJPostDetailsController.h"//帖子


@interface MXSSMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic, strong) NSMutableArray *modelArr;

@property (nonatomic , assign) NSInteger page ;//页数加载处理
@property (nonatomic , assign)BOOL isHeaderRefresh;//页数加载处理
@end

@implementation MXSSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mx_Wode_backgroundColor;
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableview];
    self.modelArr = [NSMutableArray array];
    self.page = 1;//页数
    [self getMessageCenterMoreData];//消息中心数据请求

    //上拉下拉刷新
    self.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.modelArr = [NSMutableArray array];
        self.page = 1 ;
        self.isHeaderRefresh = YES;
        [self getMessageCenterMoreData];//消息中心数据请求
    }];
    self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.modelArr.count %10 == 0) {
                self.page ++ ;
                self.isHeaderRefresh = NO;
                 [self getMessageCenterMoreData];//消息中心数据请求
            }
            [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
        });
        
    }];
}

#pragma mark-set/get
-(UITableView *)mainTableview{
    if (_mainTableview == nil) {
            _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME) style:UITableViewStylePlain];
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        _mainTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        //        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏整体cell线
        //        _mainTableview.backgroundColor = kWhiteColor;
        _mainTableview.backgroundColor = [UIColor clearColor];
        [_mainTableview registerClass:[MXSSMessageTableViewCell class] forCellReuseIdentifier:@"fansCell"];
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
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"消息中心"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"消息中心界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"消息中心界面\"}"];
    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}

#pragma mark ---MessageCenterMoreData 消息中心数据
-(void)getMessageCenterMoreData{
 
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodemModifyMessageCenter_PATH;//请求信息中心接口
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
//        NSLog(@"消息中心==%@",personDic);
        [weakSelf.mainTableview.mj_header endRefreshing];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
            [SVProgressHUD dismiss];
            [self.mainTableview.mj_header endRefreshing];
            if (self.isHeaderRefresh == YES) {
                [weakSelf.modelArr removeAllObjects];
            }
            //消息列表
            NSDictionary *quanziDict = personDic[@"data"];
            NSMutableArray * array = [MXssMessageModel mj_objectArrayWithKeyValuesArray:quanziDict] ;
            
            [weakSelf.modelArr addObjectsFromArray:array];
//            weakSelf.modelArr = [MXssMessageModel mj_objectArrayWithKeyValuesArray:quanziDict];
            
            if (weakSelf.modelArr.count == 0) {
                [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无消息信息"];
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
//        [self.mainTableview.mj_header endRefreshing];
//        [self.mainTableview.mj_footer endRefreshing];
    }];
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
//    if (indexPath.row == 0) {
//        return 210;
//    }else   {
    if (self.modelArr.count>0) {
        MXssMessageModel *model = self.modelArr[indexPath.row];
        UILabel *messageContentLabel = [[UILabel alloc]init];
        messageContentLabel.text = model.content;
        messageContentLabel.numberOfLines = 0 ;
        messageContentLabel.frame = CGRectMake(scaleWithSize(10), 0, screen_width - scaleWithSize(50), 40) ;
        messageContentLabel.font = fontSize(scaleWithSize(14.0f));
        
        if (messageContentLabel.text.length) {
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:messageContentLabel.text];
            NSMutableParagraphStyle *style2 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style2.paragraphSpacing = 4;//段落后面的间距
            [attrString2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, [messageContentLabel.text length])];
            messageContentLabel.attributedText = attrString2;
        }
        CGSize size = [messageContentLabel sizeThatFits:CGSizeMake(screen_width - scaleWithSize(50), MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度

        return scaleWithSize(95) + size.height + scaleWithSize(5);
    }else{
        return 150;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"fansCell";//cell重用问题
    MXSSMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXSSMessageTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
    cell.backgroundColor = [UIColor clearColor];
//    if (indexPath.row == 0) {
//        cell.messageImage.hidden = NO;//是否显示图片的处理
//        cell.messageTitleNameLabel.hidden = YES;
//        cell.topView.frame = CGRectMake(scaleWithSize(15), cell.messageImage.frame.size.height + cell.messageTimeLabel.frame.size.height + scaleWithSize(20), screen_width - scaleWithSize(30), scaleWithSize(60));
//        cell.messageTitleNameLabel.frame = CGRectMake(scaleWithSize(10), scaleWithSize(10), screen_width - scaleWithSize(40), scaleWithSize(0));
//        cell.messageContentLabel.frame = CGRectMake(scaleWithSize(10), cell.messageTitleNameLabel.frame.size.height + scaleWithSize(10), screen_width - scaleWithSize(50), 40);
//    }else{
    if (self.modelArr.count>0) {
        MXssMessageModel *model = self.modelArr[indexPath.row];
//        cell.messageImage.hidden = YES;
        cell.messageTitleNameLabel.hidden = NO;
        cell.messageTimeLabel.text = model.createTime;
        cell.messageTitleNameLabel.text = model.msgType;
        cell.messageContentLabel.text = model.content;
#pragma mark ----段落的处理---间距问题
        if (cell.messageContentLabel.text.length) {
            NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:cell.messageContentLabel.text];
            NSMutableParagraphStyle *style2 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style2.paragraphSpacing = 4;//段落后面的间距
            [attrString2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, [cell.messageContentLabel.text length])];
            cell.messageContentLabel.attributedText = attrString2;
        }
        
        
        CGSize size = [cell.messageContentLabel sizeThatFits:CGSizeMake(screen_width - scaleWithSize(50), MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
        
        cell.messageContentLabel.frame = CGRectMake(scaleWithSize(10), cell.messageTitleNameLabel.frame.size.height + scaleWithSize(12),screen_width - scaleWithSize(50), size.height+scaleWithSize(5));////<span style="font-family:Menlo;">假如是自适应高度的话，就把宽度确定</span>
//        cell.messageContentLabel.backgroundColor = [UIColor redColor];
        
        cell.topView.frame = CGRectMake(scaleWithSize(15), cell.messageTimeLabel.frame.size.height + scaleWithSize(20), screen_width - scaleWithSize(30), scaleWithSize(45) + size.height+scaleWithSize(3));
        cell.messageTitleNameLabel.frame = CGRectMake(scaleWithSize(10), scaleWithSize(10), screen_width - scaleWithSize(40), scaleWithSize(20));
        
//    }
    cell.messageTimeLabel.hidden = NO;//时间显示
    }
    return cell;
    
}

- (void)buttonGuanzhuClick:(UIButton*)sender {//关注按钮的点击
//    NSLog(@"关注按钮的点击===%ld",sender.tag);
    
}
// 隐藏多余cell
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//cell点击
//    NSLog(@"?????==%ld",indexPath.row);
//    [SVProgressHUD showInfoWithStatus:@"暂无数据接口"];
    
    
    MXssMessageModel * model = self.modelArr[indexPath.row];
    
    
    if (model.msgTypeId == 3) { //赛事
        
        MXBattleDetailsViewController * vc = [[MXBattleDetailsViewController alloc]init] ;
        vc.matchId = model.matchId ;
        [self.navigationController pushViewController:vc animated:YES] ;
        
    } else if (model.msgTypeId == 2) { //活动
        
        MXSYJWebViewController * vc = [[MXSYJWebViewController alloc]init] ;
        vc.adID = [NSString stringWithFormat:@"%ld",model.msgId] ;
        vc.url = model.targetUrl ;
        [self.navigationController pushViewController:vc animated:YES] ;
        
    } else if (model.msgTypeId == 4) { //帖子
        
        MXSYJPostDetailsController * vc = [[MXSYJPostDetailsController alloc]init] ;
        vc.newsID = [NSString stringWithFormat:@"%ld",model.newsId] ;
        [self.navigationController pushViewController:vc animated:YES] ;
        
    } else {
        
    }
    
    
    
    
    
    
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
