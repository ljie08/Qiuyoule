//
//  MXSSMyVoteViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//投票

#import "MXSSMyVoteViewController.h"
#import "MXSSMyVoteNOSettledViewController.h"//投票待结算
#import "MXSSMyVoteYESSettledViewController.h"//投票已结算
#import "MXssSupotOrPostModel.h"//个人投票/观点model
@interface MXSSMyVoteViewController ()<UIScrollViewDelegate,MXSSMyVoteNOSettledViewControllerDelegate,MXSSMyVoteYESSettledViewControllerDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) MXSSMyVoteNOSettledViewController *voteNOSettledView;//投票待结算页面
@property (nonatomic,strong) MXSSMyVoteYESSettledViewController *voteYESSettledView;//投票已结算页面
@property (nonatomic, strong) NSMutableArray *modelArr;//待结算
@property (nonatomic, strong) NSMutableArray *modelArrYes;//已结算
@property (nonatomic , assign) NSInteger pageNo ;//页数待结算
@property (nonatomic , assign) NSInteger pageYes;//页数已结算
@property (nonatomic , assign)BOOL isHeaderRefresh;

@end

@implementation MXSSMyVoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //页数
    self.pageNo = 1;//页数待结算
    self.pageYes = 1;//页数已结算
    self.modelArr = [NSMutableArray array];
    self.modelArrYes = [NSMutableArray array];
    [self MyEventViewsMoreData:@"0" withYesOrNo:@"待结算"];//个人投票/观点列表数据 :@"supot"
    [self.view addSubview:self.scrollView];
    self.view.backgroundColor =mx_Wode_backgroundColor;
    self.voteNOSettledView =[[MXSSMyVoteNOSettledViewController alloc]init];//投票待结算页面
    self.voteNOSettledView.view.frame = CGRectMake(0, 0, screen_width, self.scrollView.frame.size.height);
    self.voteNOSettledView.delegate = self;
    [self.scrollView addSubview:self.voteNOSettledView.view];
    
    self.voteYESSettledView = [[MXSSMyVoteYESSettledViewController alloc]init];//投票已结算页面
    self.voteYESSettledView.view.frame = CGRectMake(screen_width, 0, screen_width, self.scrollView.frame.size.height);
    self.voteYESSettledView.delegate = self;
    [self.scrollView addSubview:self.voteYESSettledView.view];
    
#pragma mark - 按钮隐藏
//    [self segmentedControl];
    
    //    上拉下拉刷新
    self.voteNOSettledView.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.modelArr = [NSMutableArray array];
        self.pageNo = 1 ;
        self.isHeaderRefresh = YES;
        [self MyEventViewsMoreData:@"0" withYesOrNo:@"待结算"];
    }];
    self.voteNOSettledView.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.modelArr.count %10 == 0) {
                self.pageNo ++ ;
                self.isHeaderRefresh = NO;
                [self MyEventViewsMoreData:@"0" withYesOrNo:@"待结算"];
            }
            [self.voteNOSettledView.mainTableview.mj_footer endRefreshingWithNoMoreData];
        });
    }];
    
    //    上拉下拉刷新
    self.voteYESSettledView.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.modelArrYes = [NSMutableArray array];
        self.pageYes = 1 ;
        self.isHeaderRefresh = YES;
        [self MyEventViewsMoreData:@"1" withYesOrNo:@"已结算"];
    }];
    self.voteYESSettledView.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.modelArrYes.count %10 == 0) {
                self.pageYes ++ ;
                self.isHeaderRefresh = NO;
                [self MyEventViewsMoreData:@"1" withYesOrNo:@"已结算"];
            }
            [self.voteYESSettledView.mainTableview.mj_footer endRefreshingWithNoMoreData];
        });
    }];
    
    
}

#pragma mark ---findFansData个人投票/观点列表数据
-(void)MyEventViewsMoreData:(NSString *)accntType withYesOrNo:(NSString *)strYesOrNo{
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMyEventViews_PATH;//个人投票/观点
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    if ([strYesOrNo isEqualToString:@"待结算"]) {
        [paraDic setObject:[NSString stringWithFormat:@"%ld", _pageNo] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    }else {
        [paraDic setObject:[NSString stringWithFormat:@"%ld",_pageYes] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    }
    
    [paraDic setObject:@"10" forKey:@"limit"];//分页起始位置
    
    [paraDic setObject:@"supot" forKey:@"optType"];//查询类型（supot：投票 post：观点）
    [paraDic setObject:accntType forKey:@"accntType"];//状态（0：待结算 1：已结算）
    
    //    [SVProgressHUD showWithStatus:@"正在加载..."];
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"个人投票/观点列表数据列表==%@",personDic);
        //        [weakSelf.mainTableview.mj_header endRefreshing];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
            [SVProgressHUD dismiss];
            if ([strYesOrNo isEqualToString:@"待结算"]) {
                [self.voteNOSettledView.mainTableview.mj_header endRefreshing];
            }else {
                [self.voteYESSettledView.mainTableview.mj_header endRefreshing];
            }
            if (self.isHeaderRefresh == YES) {
                if ([strYesOrNo isEqualToString:@"待结算"]) {
                    [weakSelf.modelArr removeAllObjects];
                }else {
                    [weakSelf.modelArrYes removeAllObjects];
                }
            }
            NSDictionary *quanziDict = personDic[@"data"];
            if ([accntType isEqualToString:@"0"]) {//待结算数据
                //个人投票/观点列表
                weakSelf.modelArr = [MXssSupotOrPostModel mj_objectArrayWithKeyValuesArray:quanziDict];
                self.voteNOSettledView.voteNoArr = weakSelf.modelArr.copy;
                if (weakSelf.modelArr.count == 0) {
                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                    //消除尾部"没有更多数据"的状态
                    weakSelf.voteNOSettledView.mainTableview.mj_footer.hidden = YES ;
                }else{
                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                }
                if (self.modelArr.count < 10) {
                    [weakSelf.voteNOSettledView.mainTableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelf.voteNOSettledView.mainTableview.mj_footer endRefreshing];
                }
                [weakSelf.voteNOSettledView.mainTableview reloadData];
            }else {//已结算数据
                weakSelf.modelArrYes = [MXssSupotOrPostModel mj_objectArrayWithKeyValuesArray:quanziDict];
                self.voteYESSettledView.voteYesArr = weakSelf.modelArrYes.copy;
                if (weakSelf.modelArrYes.count == 0) {
                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                    //消除尾部"没有更多数据"的状态
                    weakSelf.voteYESSettledView.mainTableview.mj_footer.hidden = YES ;
                }else{
                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                }
            }
            if (self.modelArrYes.count < 10) {
                [weakSelf.voteYESSettledView.mainTableview.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.voteYESSettledView.mainTableview.mj_footer endRefreshing];
            }
            [weakSelf.voteYESSettledView.mainTableview reloadData];
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
        //        [self.mainTableview.mj_header endRefreshing];
        //        [self.mainTableview.mj_footer endRefreshing];
    }];
}


- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scaleWithSize(50), screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(94))];
        _scrollView.pagingEnabled = NO;
        _scrollView.scrollEnabled = NO;//关闭滑动
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = mx_Wode_backgroundColor;
        _scrollView.contentSize = CGSizeMake(2 * screen_width, 10);
    }
    return _scrollView;
}

-(void)segmentedControl{
    //    1. 创建对象 */
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"待结算",@"已结算"]];
    //    字面量生产的是不可变对象，通过mutableCopy变为可变 */
    
    //    if(UI_IS_IPHONEX){//判断机型
    //        segment.frame = CGRectMake(screen_width / 2 - scaleWithSize(90), scaleWithSize(20), scaleWithSize(180), scaleWithSize(30));
    //    }else{
    segment.frame = CGRectMake(screen_width / 2 - scaleWithSize(90), scaleWithSize(10), scaleWithSize(180), scaleWithSize(30));
    //    }
    [self.view addSubview:segment];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segment.tintColor = mx_Wode_colorBlue2374e4;
}
#pragma mark - segment方法
-(void)change:(UISegmentedControl *)segmentControl{
    switch ((long)segmentControl.selectedSegmentIndex) {
        case 0:
            if (self.modelArr.count == 0) {
                [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
            }else{
                [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            }
            // 能否滚动
            [self MyEventViewsMoreData:@"0" withYesOrNo:@"待结算"];//个人投票/观点列表数据 :@"supot"
            _scrollView.scrollEnabled = NO;
            break;
        case 1:
            if (self.modelArrYes.count == 0) {
                [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
            }else{
                [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            }
            // 能否滚动
            [self MyEventViewsMoreData:@"1" withYesOrNo:@"已结算"];//个人投票/观点列表数据 :@"supot" @"post"
            _scrollView.scrollEnabled = NO;
            break;
            
        default:
            break;
    }
    self.scrollView.contentOffset = CGPointMake(segmentControl.selectedSegmentIndex*screen_width, 0);
}

- (void)goMyVoteNOSettledViewController:(MXSSMyVoteNOSettledViewController *)VC withResult:(NSDictionary *)result andArticleModel:(MXssSupotOrPostModel *)model {
    NSLog(@"🍑跳转投票待结算cell点击【观点的id=%@",model.viewId);
    MXOpinionDetailViewController * opinionDetail = [[MXOpinionDetailViewController alloc]init] ;
    opinionDetail.eventID = [NSString stringWithFormat:@"%@",model.viewId];
    [self.navigationController pushViewController:opinionDetail animated:YES];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
}
- (void)goMyVoteYESSettledViewController:(MXSSMyVoteYESSettledViewController *)VC withResult:(NSDictionary *)result andArticleModel:(MXssSupotOrPostModel *)model{
    NSLog(@"🍎跳转投票已结算cell点击【观点的id=%@",model.viewId);
    
    MXOpinionDetailViewController * opinionDetail = [[MXOpinionDetailViewController alloc]init] ;
    opinionDetail.eventID = [NSString stringWithFormat:@"%@",model.viewId];
    [self.navigationController pushViewController:opinionDetail animated:YES];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
    //    [self.navigationController pushViewController:[MXOpinionDetailViewController new] animated:YES] ;
}
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    //[self initTitleViewWithTitle:@"投票"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"投票界面\"}"];
    
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"投票界面\"}"];
    if (self.modelArr.count > 0 ||self.modelArrYes.count > 0) {
        [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
