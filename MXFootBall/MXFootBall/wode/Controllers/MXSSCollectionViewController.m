//
//  MXSSCollectionViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSCollectionViewController.h"
#import "MXSSBallGameCollectionViewController.h"//球赛收藏页面
#import "MXSSArticleCollectionViewController.h"//文章收藏页面
#include "MXSYJPostDetailsController.h"//详情页面
#import "MXBattleDetailsViewController.h"//球赛的详情
@interface MXSSCollectionViewController ()<UIScrollViewDelegate,MXSSArticleCollectionViewControllerDelegate,MXSSBallGameCollectionViewControllerDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) MXSSArticleCollectionViewController *articleCollectionView;//文章收藏页面
@property (nonatomic,strong) MXSSBallGameCollectionViewController *ballGameCollectionView;//球赛收藏页面

@property (nonatomic , strong) NSMutableArray * ballGameDataArrays;
@property (nonatomic , strong) NSMutableArray * collectionDataArrs;

@property (nonatomic , assign) NSInteger gameBsllPage ;//页数加载
@property (nonatomic,copy) NSString *yesWenOrQiuStr;
@property (nonatomic,assign) BOOL ballYesOrNo;//球赛的点击是否显示删除多选的传值
@property (nonatomic,strong) UIButton *confirmBtn;//多选按钮

@property (nonatomic,strong) UISegmentedControl *segmentdControl;

//@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic,strong) NSMutableArray *forumImgsArray;//forumImgs发帖list
@property (nonatomic , assign)BOOL isHeaderRefresh;
@property (nonatomic , assign) NSInteger page ;//页数加载
@property (nonatomic,assign) BOOL yesOrNo;//文章的点击是否显示删除多选的传值

@end

@implementation MXSSCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.yesWenOrQiuStr = @"文章";
    self.page = 1;
    self.gameBsllPage = 1;
    self.yesOrNo = YES;//文章的点击是否显示删除多选的传值
    self.ballYesOrNo = YES;//球赛的点击是否显示删除多选的传值
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    self.articleCollectionView =[[MXSSArticleCollectionViewController alloc]init];//文章收藏页面
    self.articleCollectionView.view.frame = CGRectMake(0, 0, screen_width, self.scrollView.frame.size.height);
    self.articleCollectionView.delegate = self;
    [self.scrollView addSubview:self.articleCollectionView.view];

    //页数
    self.page = 1;
    self.collectionDataArrs = [NSMutableArray array];
    [self CollectForumListData:@"文章"];//收藏文章数据
    //    //消除尾部"没有更多数据"的状态
    //    self.articleCollectionView.mainTableview.mj_footer.hidden = YES ;
    //上拉下拉刷新
    mx_weakify(self) ;
    self.articleCollectionView.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.collectionDataArrs = [NSMutableArray array];
        self.forumImgsArray = [NSMutableArray array];
        [self.articleCollectionView.dataArray removeAllObjects];//多选的数组存放
        for (int i = 0; i < self.collectionDataArrs.count; i++) {
            MXssMyCollectGameModel *postmodels =self.collectionDataArrs[i];
            postmodels.yesOrNo = 0;
        }
        weakSelf.page = 1 ;
        self.isHeaderRefresh = YES;
        [self CollectForumListData:@"文章"];//收藏文章数据
    }];
    self.articleCollectionView.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.collectionDataArrs.count %10 == 0) {
                weakSelf.page ++ ;
                self.forumImgsArray = [NSMutableArray array];
                self.isHeaderRefresh = NO;
                [self CollectForumListData:@"文章"];//收藏文章数据
            }
            [self.articleCollectionView.mainTableview.mj_footer endRefreshingWithNoMoreData];
        });
    }];
    
    self.ballGameCollectionView = [[MXSSBallGameCollectionViewController alloc]init];//球赛收藏页面
    self.ballGameCollectionView.view.frame = CGRectMake(screen_width, 0, screen_width, self.scrollView.frame.size.height);
    self.ballGameCollectionView.delegate = self;
    self.ballGameCollectionView.dataArraySum = [NSMutableArray array];
    [self.scrollView addSubview:self.ballGameCollectionView.view];
    //    [self.view addSubview:self.mainTableview];
    [self segmentedControl];
    
    self.confirmBtn = [[UIButton alloc]init];
    self.confirmBtn.frame = CGRectMake(0, 0, 25, 25);
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_weixuanzhong"] forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.confirmBtn];
}
- (void)releaseClick {//分享按钮点击
    NSLog(@"管理按钮的点击");
    if ([self.yesWenOrQiuStr isEqualToString:@"文章"]) {
        if (self.yesOrNo) {
            self.articleCollectionView.yesCell = YES;
            self.yesOrNo = NO;//文章的点击是否显示删除多选的传值
            [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_xuanzhong"] forState:UIControlStateNormal];
        }else {
            self.articleCollectionView.yesCell = NO;
            self.yesOrNo = YES;//文章的点击是否显示删除多选的传值
            [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_weixuanzhong"] forState:UIControlStateNormal];
        }
    }else{
        if (self.ballYesOrNo) {
            self.ballGameCollectionView.yesCell = YES;
            self.ballYesOrNo = NO;//球赛的点击是否显示删除多选的传值
            [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_xuanzhong"] forState:UIControlStateNormal];
        }else {
            self.ballGameCollectionView.yesCell = NO;
            self.ballYesOrNo = YES;//球赛的点击是否显示删除多选的传值
            [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_weixuanzhong"] forState:UIControlStateNormal];
        }
        
    }
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scaleWithSize(50), screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(50))];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;//关闭滑动
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(2 * screen_width, 10);
    }
    return _scrollView;
}

-(void)segmentedControl{
    //    1. 创建对象 */
    self.segmentdControl = [[UISegmentedControl alloc] initWithItems:@[@"文章",@"球赛"]];
    //    字面量生产的是不可变对象，通过mutableCopy变为可变 */
    self.segmentdControl.frame = CGRectMake(screen_width / 2 - scaleWithSize(180/2), scaleWithSize(10), scaleWithSize(180), scaleWithSize(30));
    [self.view addSubview:self.segmentdControl];
    self.segmentdControl.selectedSegmentIndex = 0;
    [self.segmentdControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.segmentdControl.tintColor = mx_Wode_colorBlue2374e4;
}
#pragma mark - segment方法
-(void)change:(UISegmentedControl *)segmentControl{
    switch ((long)segmentControl.selectedSegmentIndex) {
        case 0:
            self.collectionDataArrs = [NSMutableArray array];
            self.page = 1;
            [self CollectForumListData:@"文章"];//个人收藏列表请求
            self.yesWenOrQiuStr = @"文章";
            self.articleCollectionView.yesCell = NO;
            self.yesOrNo = YES;//文章的点击是否显示删除多选的传值
            [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_weixuanzhong"] forState:UIControlStateNormal];
            // 能否滚动
            _scrollView.scrollEnabled = NO;
            self.segmentdControl.selectedSegmentIndex = 0;
            self.ballGameCollectionView.dataArraySum = [NSMutableArray array];//球赛的删除数组存放清空
            break;
        case 1:
            if (self.ballGameDataArrays.count == 0) {
                [self CollectForumListData:@"球赛"];//个人收藏列表请求
            }else{
                [self CollectForumListData:@"球赛"];//个人收藏列表请求
                [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            }
            self.ballGameCollectionView.yesCell = NO;
            self.ballYesOrNo = YES;//球赛的点击是否显示删除多选的传值
            [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_weixuanzhong"] forState:UIControlStateNormal];
            
            _scrollView.scrollEnabled = NO;
            self.yesWenOrQiuStr = @"球赛";
            self.segmentdControl.selectedSegmentIndex = 1;
            break;
            
        default:
            break;
    }
    self.scrollView.contentOffset = CGPointMake(segmentControl.selectedSegmentIndex*screen_width, 0);
}
/**
 文章收藏页面delegate
 */
-(void)buyArticleCollectionViewController:(MXSSArticleCollectionViewController*)VC withResult:(NSDictionary*)result andArticleModel:(MXssCollectionModel*)model{
    NSLog(@"文章收藏delegate处理？？？=%@",model);
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
    vc.newsID = model.newsId;
    vc.userId = userModel.userId;
    //        vc.title = @"帖子详情";
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 球赛收藏页面delegate
 */
- (void)buyBallGameCollectionViewController:(MXSSBallGameCollectionViewController *)VC withResult:(NSDictionary *)result andBallGameModel:(MXssMyCollectGameModel *)model {
    NSLog(@"球赛收藏delegate处理点击？？？");
    //        MXBattleDetailsViewController * battleDetails = [[MXBattleDetailsViewController alloc]init];
    //        battleDetails.selectIndex = 0 ;
    //        battleDetails.matchId = model.matchId.intValue ;
    //        battleDetails.titleString = model.eventNm ;
    //    battleDetails.yesOrNoButton = @"个人收藏球赛";
    
    MXBattleDetailsViewController * battleDetails = [[MXBattleDetailsViewController alloc]init];
//    battleDetails.selectIndex = 0 ;
    battleDetails.matchId = model.matchId.intValue ;
    battleDetails.titleString = model.eventNm ;
    battleDetails.yesOrNoButton = @"个人收藏球赛";
    
    battleDetails.homeNm = model.homeNm;
    battleDetails.homeScore = [NSString stringWithFormat:@"%@",model.homeScore] ;
    battleDetails.homeLogo = model.homeLogo;
    
    battleDetails.awayNm = model.awayNm;
    battleDetails.awayScore = [NSString stringWithFormat:@"%@",model.awayScore] ;
    battleDetails.awayLogo = model.awayLogo;
    
    battleDetails.status = model.matchStatus.intValue ;
    battleDetails.matchStartTime = model.matchStartTime ;
    [self.navigationController pushViewController:battleDetails animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"收藏"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"收藏界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"收藏界面\"}"];
    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)ArticleCollectionNewDeleUpdateViewController:(MXSSArticleCollectionViewController *)VC {//收藏文章的多选删除后返回的值 重新刷星文章的页面、
    NSLog(@"删除文章后多选 刷新页面");
    self.collectionDataArrs = [NSMutableArray array];
    self.page = 1;
    [self CollectForumListData:@"文章"];//个人收藏列表请求
    self.articleCollectionView.yesCell = NO;
    self.yesOrNo = YES;//文章的点击是否显示删除多选的传值
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_weixuanzhong"] forState:UIControlStateNormal];
    
    self.yesWenOrQiuStr = @"文章";
}
-(void)BallGameCollectionNewDeleUpdateViewController{
    
     NSLog(@"删除球赛后多选 刷新页面");
    [self CollectForumListData:@"球赛"];//个人收藏列表请求
    self.yesWenOrQiuStr = @"球赛";
    self.ballGameCollectionView.yesCell = NO;
    self.ballYesOrNo = YES;//球赛的点击是否显示删除多选的传值
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_CollectionDuoxuan_weixuanzhong"] forState:UIControlStateNormal];
}
#pragma mark ---CollectForum Data 个人收藏球赛数据
-(void)CollectForumListData:(NSString*)numberStrPage{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url =@"";
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    if ([numberStrPage isEqualToString:@"文章"]) {
        url=MXWodeMyCollectForum_PATH;//请求个人收藏文章列表数据接口
        [paraDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    }else {
        url=MXWodeMyFindCollectMatches_PATH;//请求个人收藏球赛列表数据接口
        [paraDic setObject:[NSString stringWithFormat:@"%ld",self.gameBsllPage] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    }
    
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    
    [paraDic setObject:@"10" forKey:@"limit"];//分页起始位置
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"收藏球赛？文章数据🍎=%% %@",personDic);
        //        [weakSelf.mainTableview.mj_header endRefreshing];
        
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
            [SVProgressHUD dismiss];
            [self.articleCollectionView.mainTableview.mj_header endRefreshing];
            if (self.isHeaderRefresh == YES) {
                [self.collectionDataArrs removeAllObjects];
            }
            if ([numberStrPage isEqualToString:@"文章"]) {
                NSArray *arrayList = [personDic objectForKey:@"data"];
                for (NSDictionary *dictt in arrayList) {
                    MXssCollectionModel *postModel = [MXssCollectionModel modelWithDictionary:dictt];
                    NSArray *forumImgsarr = dictt[@"forumImgs"];
                    NSMutableArray *forumImgsArray = [NSMutableArray array];
//                    NSLog(@"????==%@",forumImgsarr);
                    for (NSDictionary *dicttImage in forumImgsarr) {
                        imageUrlModelColl *brokerModel = [imageUrlModelColl modelWithDictionary:dicttImage];
                        [forumImgsArray addObject:brokerModel];
                    }
                    postModel.forumImgs = forumImgsArray.copy;
                    [self.collectionDataArrs addObject:postModel];
                    
                }
                self.articleCollectionView.collectDataArr = self.collectionDataArrs;//传值
                // [self.articleCollectionView.mainTableview reloadData];//刷新
                
                if (self.collectionDataArrs.count == 0) {
                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                    //消除尾部"没有更多数据"的状态
                    self.articleCollectionView.mainTableview.mj_footer.hidden = YES ;
                }else{
                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                }
                //消除尾部"没有更多数据"的状态
                //                self.articleCollectionView.mainTableview.mj_footer.hidden = YES ;
                if (self.collectionDataArrs.count < 10) {
                    [self.articleCollectionView.mainTableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.articleCollectionView.mainTableview.mj_footer endRefreshing];
                }
                [self.articleCollectionView.mainTableview reloadData];
                
            }else {
                if ([personDic[@"data"] count]) {
                    if (weakSelf.gameBsllPage == 1) {
                        
                        weakSelf.ballGameDataArrays = [MXssMyCollectGameModel mj_objectArrayWithKeyValuesArray:personDic[@"data"]] ;
                    } else {
                        NSMutableArray * array = [MXssMyCollectGameModel mj_objectArrayWithKeyValuesArray:personDic[@"data"]] ;
                        
                        [weakSelf.ballGameDataArrays addObjectsFromArray:array];
                    }
                }
                self.ballGameCollectionView.ballGameDataArray = weakSelf.ballGameDataArrays;//传值
                [self.ballGameCollectionView.mainTableview reloadData];
                if (weakSelf.ballGameDataArrays.count == 0) {
                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                    //消除尾部"没有更多数据"的状态
                    self.ballGameCollectionView.mainTableview.mj_footer.hidden = YES ;
                }else{
                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                }
                //            if (self.ballGameDataArray.count < 10) {
                //                [weakSelf.mainTableview.mj_footer endRefreshingWithNoMoreData];
                //            }else{
                //                [weakSelf.mainTableview.mj_footer endRefreshing];
                //            }
                //            [weakSelf.mainTableview reloadData];
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
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
@end
