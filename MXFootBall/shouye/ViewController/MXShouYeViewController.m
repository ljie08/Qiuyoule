//
//  MXShouYeViewController.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXShouYeViewController.h"
#import "LoopView.h"
#import "CircleModel.h"
#import "XWShouYeFirstCell.h"
#import "XWShouYeSecondCell.h"
#import "MXBattleDetailsViewController.h" //赛事详情
#import "MXSYJPostDetailsController.h"
#import "XWShouYeThreeCell.h"//今日赛事cell

#import "MXHomeCountdownCell.h"//倒计时cell
#import "MXHomeBtnCell.h"//快速通道cell
#import "MXHomeContentCell.h"//内容cell
#import "MXHomeScrollCell.h"//滚动内容介绍cell

#import "BannerScrollView.h"//banner

#import "MXLoginViewController.h"//登录
#import "MXNavigationController.h"

#import "MXSSCollectionViewController.h"//收藏
#import "MXSYJCelebrityController.h" //名人堂
#import "MXSYJPostDetailsController.h"//帖子详情
#import "MXSYJCircleDetailController.h"//圈子详情
#import "AppDelegate.h"
#import "MXTabBarController.h"

#import "WKViewController.h"//h5
#import "MXHomeVM.h"

//1.2
#import "MXHomeNewsController.h"//首页资讯page
#import "SliderNavBar.h"

#define XWLine  1           //几行按钮
#define XWNewCount 3        //显示几条新闻

@interface MXShouYeViewController ()<UITableViewDataSource,UITableViewDelegate, BannerScrollViewDelegate, RefreshTableViewDelegate, FastAccessDelegate, HomeContentDelegate, PaomdDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource> {
    MXHomeVM *_homeVM;
    NSTimer *_timer;//定时器
    
    //1.2
    SliderNavBar *_navbar;//类型滑动控件
    UIButton *_upBtn;//返回顶部按钮
    UIView *_navView;//导航栏view
}

@property (weak, nonatomic) IBOutlet JJRefreshTabView *tableView;

@property (nonatomic, strong) BannerScrollView *bannerView;//banner
@property (nonatomic, strong) UIImageView *bannerDefaultImg;//banner默认图片
@property (nonatomic, strong) MXHomeCountdownCell *countdownCell;//倒计时cell
@property (nonatomic, assign) BOOL isRefresh;//重置定时器的时候是否刷新数据，定时结束的时候刷新，进入后台和界面消失的时候不用刷新

//1.2
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSMutableArray *pageArr;//子VC数组
@property (nonatomic, assign) NSInteger currentIndex;//当前页面index
@property (nonatomic, assign) BOOL isRefreshNews;//

@end

@implementation MXShouYeViewController

#pragma mark -- life circle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [_homeVM matchEnd];//根据MXLJShowInfo来确定是否显示，故此方法弃用

//    if (_homeVM.isShow) {
//        [self setTimer];
//    }
    
    //导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"首页界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"首页界面\"}"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.isRefresh = NO;
//    [self resetTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getJpushInfo];
    self.isRefreshNews = NO;

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.isRefresh = NO;
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTimer) name:UIApplicationWillEnterForegroundNotification object:nil];//进入前台，定时器开启
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetTimer) name:UIApplicationDidEnterBackgroundNotification object:nil];//进入后台，定时器停掉
    
    [self initUIView];
    [self initVM];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark - 倒计时
- (void)setTimer {
    [_homeVM getChaTime];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timechange) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

//重置定时器
- (void)resetTimer {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
    if (self.isRefresh) {
        [self loadHomeData];
    }
}

//定时器执行方法
- (void)timechange {
    //    [_homeVM getCountDownTime];
    [_homeVM getChaData];
    if (_homeVM.countdown.showType == 3) {
        self.isRefresh = YES;
        [self resetTimer];
    }
    //    NSLog(@"🍉%@天-%@时-%@分-%@秒", _homeVM.countdown.day, _homeVM.countdown.hour, _homeVM.countdown.minute, _homeVM.countdown.second);
    //之前写的[tableview reloadData]。这样会导致每秒都在刷新整个界面，界面滑动卡，cell点击偶尔不响应，严重影响性能。不应该每秒都刷新整个界面（只刷新分区或单个cell也不行，每秒都刷新cell会导致分区或cell一直在闪），只需要将计算好的时间差赋值给cell即可，每秒都给cell赋值一次数据，达到刷新数据的目的。
    [self.countdownCell setTimeWithCountDown:_homeVM.countdown pic:_homeVM.conduct.advertPic];
}

#pragma mark -- 极光推送接收推送跳转对应页面
-(void)getJpushInfo{
    if ([MXwodeUnitObject shareManager].JpushUserInfo) {
        [self JpushJumpViewControllerWithUserInfo:[MXwodeUnitObject shareManager].JpushUserInfo];
    }
}

-(void)pushNotification:(NSNotification *)notification{
    [self JpushJumpViewControllerWithUserInfo:notification.userInfo];
}
- (void)JpushJumpViewControllerWithUserInfo:(NSDictionary *)dict
{
    switch ([[dict objectForKey:@"action"]intValue]) {
        case 1:
        {//资讯
            
            MXSYJPostDetailsController *postDetailVC  = [[MXSYJPostDetailsController alloc]init];
            postDetailVC.newsID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            [self.navigationController pushViewController:postDetailVC animated:YES];
            
        }
            
            break;
        case 2:
        {//赛事
            NSLog(@"赛事 +++++++++++++");
            MXBattleDetailsViewController *BattleDetails  = [[MXBattleDetailsViewController alloc]init];
            BattleDetails.matchId = [[dict objectForKey:@"id"] integerValue];
            [self.navigationController pushViewController:BattleDetails animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark -- data
- (void)initVM {
    _homeVM = [[MXHomeVM alloc] init];
    [self loadHomeData];
}

//首页数据
- (void)loadHomeData {
    [SVProgressHUD showWithStatus:@"正在加载"];
    @weakSelf(self);
    [_homeVM getHomeDataWithSuccess:^(BOOL result) {
        [SVProgressHUD dismiss];
        [weakSelf setBannerData];
        [weakSelf.tableView reloadData];
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

//资讯
- (void)loadNewsDataWithRefresh:(BOOL)isRefresh {
    @weakSelf(self);
    [_homeVM getHomeNewsWithRefresh:isRefresh type:1 success:^(BOOL result) {
        [SVProgressHUD dismiss];
        weakSelf.isRefreshNews = YES;
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:3];
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
//        [weakSelf.tableView reloadData];
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

#pragma mark -- 以下数据已弃用
//获取banner数据
- (void)loadBannerData {
    [SVProgressHUD showWithStatus:@"正在加载..."];
    @weakSelf(self);
    [_homeVM getBannerWithSuccess:^(BOOL result) {
//        [SVProgressHUD dismiss];
        [weakSelf setBannerData];
        [weakSelf.tableView reloadData];
        
        [weakSelf loadAccessData];
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
        return;
    }];
    
}

//获取快速通道数据
- (void)loadAccessData {
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    @weakSelf(self);
    
    [_homeVM getAccessWithSuccess:^(BOOL result) {
//        [SVProgressHUD dismiss];
        [weakSelf.tableView reloadData];
        
        [weakSelf loadTopNews];
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
        return;
    }];
}

/**
 获取置顶两篇文章
 */
- (void)loadTopNews {
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    @weakSelf(self);
    
    [_homeVM getTopNewsWithSuccess:^(BOOL result) {
//        [SVProgressHUD dismiss];
        [weakSelf.tableView reloadData];
        
        [weakSelf loadRollNews];
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
        return;
    }];
}

/**
 获取滚动资讯
 */
- (void)loadRollNews {
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    @weakSelf(self);
    
    [_homeVM getRollNewsWithSuccess:^(BOOL result) {
//        [SVProgressHUD dismiss];
        [weakSelf.tableView reloadData];
        
        [weakSelf loadSaishiWithRefresh:YES];
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
        
        return;
    }];
}

//今日赛事
- (void)loadSaishiWithRefresh:(BOOL)isRefresh {
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    @weakSelf(self);
    
    [_homeVM getSaishiWithRefresh:isRefresh success:^(BOOL result) {
        [SVProgressHUD dismiss];
        [weakSelf.tableView reloadData];
        NSLog(@"ahhh");
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
#pragma mark --- 弃用截至此上


//1.2
#pragma mark -- action
- (void)gotoTop {
    self.isRefreshNews = NO;
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    _upBtn.hidden = YES;
}

#pragma mark -- tableview滑动距离
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        int section = _homeVM.isShow ? 3 :2;
        
        CGFloat height = 175*Height_Scale + 100 + 44+160 + 44+125*_homeVM.saishiList.count + 10*section - STATUS_AND_NAVIGATION_HEIGHT;
        
        if (self.isRefreshNews) {
            [self scrollDisableScroll];
            return;
        }
        if (offset.y < height) {
            [self scrollCanScroll];
        } else {
            [self scrollDisableScroll];
        }
        
    }
}

- (void)scrollCanScroll {
    self.tableView.scrollEnabled = YES;
    _upBtn.hidden = YES;
    _navView.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)scrollDisableScroll {
    self.tableView.scrollEnabled = NO;
    _upBtn.hidden = NO;
    _navView.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - UIPageViewControllerDelegate & UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageArr indexOfObject:viewController];
    index --;
    if ((index < 0) || (index == NSNotFound)) {
        return nil;
    }
    return self.pageArr[index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self.pageArr indexOfObject:viewController];
    index ++;
    if (index >= self.pageArr.count) {
        return nil;
    }
    return self.pageArr[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        MXHomeNewsController *vc = pageViewController.viewControllers.firstObject;
        NSInteger index = [self.pageArr indexOfObject:vc];
        [_navbar moveToIndex:index];
        
        self.currentIndex = index;
    }
}

#pragma mark - BannerScrollViewDelegate
- (void)bannerTappedIndex:(NSInteger)index tap:(UITapGestureRecognizer *)tap {
//    NSLog(@"%ld", index);
    MXLJBanner *banner = _homeVM.bannerList[index];
    
    if (banner.targetUrl.length) {
        NSString *idStr = [NSString stringWithFormat:@"%ld", banner.advertId];
        NSDictionary *jsondic = [NSDictionary dictionaryWithObjectsAndKeys:idStr, @"id", nil];
        NSString *content = [MXLJUtil dictionaryToJson:jsondic];
        [UBT logCode:@"ad" content:content];
        
        WKViewController *wk = [[WKViewController alloc] init];
        NSString *str = [banner.targetUrl stringByReplacingOccurrencesOfString:@"https:" withString:@"http:"];
        //不知道为嘛https打不开
        wk.url = str;
        wk.wktitle = banner.title;
        [self.navigationController pushViewController:wk animated:YES];
    }
}

#pragma mark -- refresh
- (void)refreshTableViewHeader {
//    [_homeVM getChaTime];
    [self loadHomeData];
}

- (void)refreshTableViewFooter {
    
}

#pragma mark -- 刷新资讯
- (void)refreshNewsData {
    [self loadNewsDataWithRefresh:YES];
}

- (void)loadMoreNewsData {
    [self loadNewsDataWithRefresh:NO];
}

#pragma mark -- cell delegate
//快速通道跳转
- (void)fastAccessWithTag:(NSInteger)tag {
    if (!_homeVM.accessList.count) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        return;
    }
    MXLJAccess *access = _homeVM.accessList[tag];
    //1:即时赛事，2：官方发布，3：名人堂，4：个人收藏
    switch (access.accessId) {
        case 1: {
            NSLog(@"🐷即时赛事");
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            MXTabBarController *tab = (MXTabBarController *)delegate.window.rootViewController;
            
            tab.selectedIndex = 1;
        }
            break;
        case 2: {
            NSLog(@"🐷官方发布");
            [self gotoOfficial];
//            [SVProgressHUD showSuccessWithStatus:@"官方发布"];
        }
            break;
        case 3: {
            NSLog(@"🐷名人堂");
            MXSYJCelebrityController *celevc = [[MXSYJCelebrityController alloc] init];
            [self.navigationController pushViewController:celevc animated:YES];
        }
            break;
        case 4: {
            NSLog(@"🐷个人收藏");
            MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
            if (userModel.userId) {
                MXSSCollectionViewController *mxCollectionView = [[MXSSCollectionViewController alloc] init];
                mxCollectionView.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mxCollectionView animated:YES];
            } else {
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
            break;
            
        default:
            break;
    }
}

//内容详情跳转
- (void)lookContentWithTag:(NSInteger)tag {
    if (!_homeVM.topList.count) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        return;
    }
    MXLJArticle *top = _homeVM.topList[tag];
    
    MXSYJPostDetailsController *detailvc = [[MXSYJPostDetailsController alloc] init];
    detailvc.newsID = top.newsId;
    detailvc.type = 200;
    detailvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailvc animated:YES];
}

//跑马灯跳转
- (void)clickLabelWithTag:(NSInteger)tag {
    [self gotoOfficial];
}

//官方资讯页
- (void)gotoOfficial {
    MXSYJCircleDetailController *official = [[MXSYJCircleDetailController alloc] init];
    official.hidesBottomBarWhenPushed = YES;
    
    official.type = 100;
    [self.navigationController pushViewController:official animated:YES];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _homeVM.isShow ? 5 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_homeVM.isShow) {
        if (section == 2) {//内容
            return 2;
        }
        if (section == 3) {//今日赛事
            return _homeVM.saishiList.count+1;
        }
        if (section == 4) {
            return 1;//新闻资讯
        }
        return 1;//快速通道
    } else {
        if (section == 1) {//内容
            return 2;
        }
        if (section == 2) {//今日赛事
            return _homeVM.saishiList.count+1;
        }
        if (section == 3) {
            return 1;//新闻资讯
        }
        return 1;//快速通道
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_homeVM.isShow) {
        if (indexPath.section == 0) {//倒计时
            MXHomeCountdownCell *cell = [MXHomeCountdownCell myCellWithTableview:tableView];
            [cell setTimeWithCountDown:_homeVM.countdown pic:_homeVM.conduct.advertPic];
            self.countdownCell = cell;
            
            return cell;
            
        } else if (indexPath.section == 1) {//快速通道cell
            MXHomeBtnCell *cell = [MXHomeBtnCell myCellWithTableview:tableView withBtnArr:_homeVM.accessList];
            cell.delegate = self;
            [cell.btnsCollectionview reloadData];
            
            return cell;
            
        } else if(indexPath.section == 2) {//内容cell
            if (indexPath.row) {//滚动内容cell
                MXHomeScrollCell *cell = [MXHomeScrollCell myCellWithTableview:tableView];
                cell.delegate = self;
                if (_homeVM.rollList.count) {
                    [cell setDataWithArray:_homeVM.rollList];
                }
                
                return cell;
            }
            //内容介绍cell
            MXHomeContentCell *cell = [MXHomeContentCell myCellWithTableview:tableView withContentsArr:_homeVM.topList];
            cell.delegate = self;
            [cell.contentsCollectionview reloadData];
            
            return cell;
            
        } else if (indexPath.section == 3) {
            if (!indexPath.row) {//赛事cell
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
                    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_width - 30, 44)];
                    headerLab.text = @"精彩推荐";
                    headerLab.font = fontSize(14);
                    headerLab.textColor = mx_Wode_color333333;
                    [cell addSubview:headerLab];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                return cell;
            }
            //赛事内容cell
            XWShouYeThreeCell *threeCell = [XWShouYeThreeCell myCellWithTableview:tableView];
            if (_homeVM.saishiList.count) {
                [threeCell setDataWithModel:_homeVM.saishiList[indexPath.row-1]];
            }
            
            return threeCell;
        } else {
            //赛事内容cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            if (_homeVM.tagArr.count) {
                [self setupSliderWithView:cell.contentView];
            }
            return cell;
        }
    } else {
        if (indexPath.section == 0) {//快速通道cell
            
            MXHomeBtnCell *cell = [MXHomeBtnCell myCellWithTableview:tableView withBtnArr:_homeVM.accessList];
            cell.delegate = self;
            [cell.btnsCollectionview reloadData];
            
            return cell;
        } else if(indexPath.section == 1) {//内容cell
            if (indexPath.row) {//滚动内容cell
                MXHomeScrollCell *cell = [MXHomeScrollCell myCellWithTableview:tableView];
                cell.delegate = self;
                if (_homeVM.rollList.count) {
                    [cell setDataWithArray:_homeVM.rollList];
                }
                
                return cell;
            }
            //内容介绍cell
            MXHomeContentCell *cell = [MXHomeContentCell myCellWithTableview:tableView withContentsArr:_homeVM.topList];
            cell.delegate = self;
            [cell.contentsCollectionview reloadData];
            
            return cell;
            
        } else if (indexPath.section == 2) {
            if (!indexPath.row) {//赛事cell
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headerCell"];
                    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_width - 30, 44)];
                    headerLab.text = @"精彩推荐";
                    headerLab.font = fontSize(14);
                    headerLab.textColor = mx_Wode_color333333;
                    [cell addSubview:headerLab];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                return cell;
            }
            //赛事内容cell
            XWShouYeThreeCell *threeCell = [XWShouYeThreeCell myCellWithTableview:tableView];
            if (_homeVM.saishiList.count) {
                [threeCell setDataWithModel:_homeVM.saishiList[indexPath.row-1]];
            }
            
            return threeCell;
        } else {//新闻资讯cell
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            
            [self setupSliderWithView:cell.contentView];
            return cell;
        }
    }
    
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_homeVM.isShow) {
        
        if (indexPath.section == 0) {
            return 110*Height_Scale;
        } else if (indexPath.section == 1) {
            return 100;
        } else if(indexPath.section == 2){
            if (indexPath.row) {
                return 44;
            }
            return 160;
        } else if(indexPath.section == 3){
            if (!indexPath.row) {
                return 44;
            }
            return 125;
        }
        return screen_height-TABBAR_HEIGHT-STATUS_AND_NAVIGATION_HEIGHT;
    } else {
        if (indexPath.section == 0) {
            return 100;
        } else if(indexPath.section == 1){
            if (indexPath.row) {
                return 44;
            }
            return 160;
        } else if(indexPath.section == 2){
            if (!indexPath.row) {
                return 44;
            }
            return 125;
        }
        return screen_height-TABBAR_HEIGHT-STATUS_AND_NAVIGATION_HEIGHT;
    }
    
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = _homeVM.isShow ? 3 : 2;
    
    //赛事
    if (indexPath.section == section && indexPath.row) {
        MXHomeSaishi *model = _homeVM.saishiList[indexPath.row - 1];
        MXBattleDetailsViewController * battleDetails = [[MXBattleDetailsViewController alloc]init];
//        battleDetails.selectIndex = 0 ;
        battleDetails.matchId = model.matchId ;
        battleDetails.titleString = model.eventNm ;
        
        battleDetails.homeNm = model.homeNm ;
        battleDetails.homeScore = [NSString stringWithFormat:@"%ld",model.homeScore] ;
        battleDetails.homeLogo = model.homeLogo ;
        
        battleDetails.awayNm = model.awayNm ;
        battleDetails.awayScore = [NSString stringWithFormat:@"%ld",model.awayScore] ;
        battleDetails.awayLogo = model.awayLogo ;
        
        NSString *status = [NSString stringWithFormat:@"%ld", model.matchStatus];
        battleDetails.status = [status intValue];
        battleDetails.matchStartTime = model.matchStartTime ;
        
        battleDetails.hidesBottomBarWhenPushed = YES;
        battleDetails.yesOrNoButton = @"首页赛事";
        
        [self.navigationController pushViewController:battleDetails animated:YES];
    }
}

#pragma mark -- secontion试图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section == 3) {
//        UIView *view = [[UIView alloc] init];
//        UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_width - 30, 44)];
//        headerLab.text = @"今日赛事";
//        headerLab.font = fontSize(14);
//        headerLab.textColor = mx_Wode_color333333;
//        [view addSubview:headerLab];
//    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!section) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

#pragma mark -- UI
- (void)initUIView {
    [self setUpBannerView];
    [self setTableView];
    
    [self initNavbar];
    [self initUpBtn];
}

//设置刷新tableview
- (void)setTableView{
    self.tableView.refreshDelegate = self;
    self.tableView.CanRefresh = YES;
    self.tableView.lastUpdateKey = NSStringFromClass([self class]);
    self.tableView.isShowMore = NO;
}

//设置头试图
- (void)setUpBannerView {
    self.bannerView = [[BannerScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 175*Height_Scale)];
    self.bannerView.bannerHeight = 175*Height_Scale;
    self.bannerView.delegate = self;
    
    self.tableView.tableHeaderView = self.bannerView;
    
    self.bannerDefaultImg = [[UIImageView alloc] init];
    self.bannerDefaultImg.frame = CGRectMake(0, 0, screen_width, 175*Height_Scale);
    self.bannerDefaultImg.image = Image(@"bannerPlace");
//    self.bannerDefaultImg.contentMode = UIViewContentModeScaleAspectFill;
    self.bannerDefaultImg.clipsToBounds = YES;
    
    [self.bannerView addSubview:self.bannerDefaultImg];
}

//banner data
- (void)setBannerData {
    if (_homeVM.bannerList.count > 0) {
    //把图片地址数组赋值给banner的地址数组
        NSMutableArray *banners = [NSMutableArray array];
        for (MXLJBanner *banner in _homeVM.bannerList) {
            [banners addObject:banner.bannerPic];
        }
        self.bannerView.imageUrls = banners;
        if (self.bannerDefaultImg) {
            [self.bannerDefaultImg removeFromSuperview];
            self.bannerDefaultImg = nil;
        }
    }
}

//1.2
- (void)initNavbar {
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, STATUS_AND_NAVIGATION_HEIGHT)];
    _navView.backgroundColor = mx_redColor;
    _navView.hidden = YES;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screen_width, STATUS_AND_NAVIGATION_HEIGHT - 20)];
    title.text = @"首页";
    title.font = [UIFont boldSystemFontOfSize:18];
    title.textColor = [ UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    [_navView addSubview:title];
    
    [self.view addSubview:_navView];
}

- (void)initUpBtn {
    _upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _upBtn.frame = CGRectMake(screen_width - 50, screen_height - 20, 40, 40);
    _upBtn.layer.masksToBounds = YES;
    _upBtn.layer.cornerRadius = 20;
    _upBtn.backgroundColor = [UIColor whiteColor];
    _upBtn.hidden = YES;
    [_upBtn setBackgroundImage:Image(@"置顶") forState:UIControlStateNormal];
    [_upBtn addTarget:self action:@selector(gotoTop) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_upBtn];
    
    [_upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(scaleWithSize(-20));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(scaleWithSize(-TABBAR_HEIGHT-20));
        make.size.mas_equalTo(CGSizeMake(scaleWithSize(40), scaleWithSize(40)));
    }];
}

//滑动导航栏
- (void)setupSliderWithView:(UIView *)view {
    if (!_navbar) {
        _navbar = [[SliderNavBar alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
        _navbar.buttonTitleArr = _homeVM.nameArr;
        _navbar.mode = BottomLineModeEqualBtn;
        _navbar.fontSize = 14;
        _navbar.backgroundColor = [UIColor whiteColor];
        _navbar.selectedColor = mx_redColor;
        _navbar.unSelectedColor = mx_FontLightGreyColor;
        _navbar.bottomLineColor = mx_redColor;
        _navbar.canScrollOrTap = YES;
        [view addSubview:_navbar];
        if (_homeVM.nameArr.count) {
            [self initPageWithView:view];
        }
    }
}

- (void)initPageWithView:(UIView *)view {
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    _pageArr = [NSMutableArray array];
    for (int i = 0; i < _navbar.buttonTitleArr.count; i++) {
        MXHomeNewsController *news = [[MXHomeNewsController alloc] init];
//        news.delegate = self;
//        news.newsArr = _homeVM.newsArr;
        news.type = i+1;
        [_pageArr addObject:news];
    }
    
    [_pageViewController setViewControllers:[NSArray arrayWithObject:_pageArr[self.currentIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    _pageViewController.view.frame = CGRectMake(0, 40, screen_width, screen_height-STATUS_TABBAR_NAVIGATION_HEIGHT-40);
    
    __weak typeof (_pageViewController)weakPageViewController = _pageViewController;
    __weak typeof (_pageArr)weakPageArr = _pageArr;
    @weakSelf(self);
    [_navbar setNavBarTapBlock:^(NSInteger index, UIPageViewControllerNavigationDirection direction) {
        [weakPageViewController setViewControllers:[NSArray arrayWithObject:weakPageArr[index]] direction:direction animated:YES completion:nil];
        weakSelf.currentIndex = index;
    }];
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [view addSubview:_pageViewController.view];
    [_navbar moveToIndex:self.currentIndex];
}

///**
// 画圆环
// */
//- (void)makeLoop{
//
//    NSMutableArray *mArray = [NSMutableArray new];
//    for (int i = 0; i < 4; i ++) {
//        CircleModel *model = [[CircleModel alloc]init];
//        model.proportion = 0.25;
//        model.circleColor = [self randomColor];
//        [mArray addObject:model];
//    }
//
//    LoopView *loop = [[LoopView alloc]initWithFrame: CGRectMake(0, 60, 200, 200)withRadius:80 withModelArray:mArray];
//
//    loop.backgroundColor = [UIColor redColor];
//
//    [self.view addSubview:loop];
//}
//
////随机颜色
//- (UIColor *)randomColor{
//
//    CGFloat r = arc4random_uniform(256) / 255.0;
//    CGFloat g = arc4random_uniform(256) / 255.0;
//    CGFloat b = arc4random_uniform(256) / 255.0;
//    return [UIColor colorWithRed:r green:g blue:b alpha:1];
//
//}

#pragma mark - - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
