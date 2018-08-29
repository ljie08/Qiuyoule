//
//  MXImmediateViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXImmediateViewController.h"

#import "MXEventTableViewCell.h" //赛事
#import "MXDEventModel.h"
#import "MXDEventTableVCell.h" //赛事改
#import "MXDMatchesModel.h"

#import "MXDAdvertsModel.h" //广告
#import "MXADTableViewCell.h"

#import "MXBattleDetailsViewController.h"//对战详情

#import "MXSYJWebViewController.h"//广告

#import "MXDEntranceCollectionViewCell.h"
#import "MXDLinksModel.h"//链接

#import "MXWorldCupViewController.h"//世界杯
#import "MXSYJCircleDetailController.h"//大力神杯

#import "MXDPostersModel.h" //海报


@interface MXImmediateViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
//{
//    BOOL isRefresh ;
//}

@property (nonatomic , strong) UITableView * eventTableview ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@property (nonatomic , assign) NSInteger page ;

@property (nonatomic , strong) UIButton * upDataButton ;

@property (nonatomic , assign) BOOL isRefresh ; //登录后刷新

//广告
@property (nonatomic , strong) NSString * imgURL ;
@property (nonatomic , strong) NSString * webURL ;

@property (nonatomic , strong) NSMutableArray * advertsArray ;

/*
 *世界杯界面，4个入口
 */
@property (nonatomic , strong) NSArray * imgNameArray ;
@property (nonatomic , strong) NSArray * titleArray ;
@property (nonatomic ,strong) UICollectionViewFlowLayout * customLayout ;
@property (nonatomic ,strong) UICollectionView * collectionView ;

@property (nonatomic , strong) NSString * rankingStr ;
@property (nonatomic , strong) NSString * guessStr ;


@property (nonatomic , strong) NSMutableArray * postersArray ;//海报


@end

@implementation MXImmediateViewController

- (NSMutableArray *)postersArray {
    if (!_postersArray) {
        _postersArray = [NSMutableArray array] ;
    }
    return _postersArray ;
}
- (NSMutableArray *)advertsArray {
    if (!_advertsArray) {
        _advertsArray = [NSMutableArray array] ;
    }
    return _advertsArray ;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}
- (UITableView *)eventTableview {
    
    if (!_eventTableview) {
        
        _eventTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - (STATUS_AND_NAVIGATION_HEIGHT) - TABBAR_HEIGHT - 44) style:(UITableViewStylePlain)];
        _eventTableview.delegate = self ;
        _eventTableview.dataSource = self ;
        _eventTableview.backgroundColor = mx_Wode_backgroundColor ;
        
//        [_eventTableview registerNib:[UINib nibWithNibName:@"MXEventTableViewCell" bundle:nil] forCellReuseIdentifier:@"EventTableViewCell"];
        
        [_eventTableview registerClass:[MXDEventTableVCell class] forCellReuseIdentifier:@"MXDEventTableVCell"] ;
        
        [_eventTableview registerClass:[MXADTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MXADTableViewCell class])] ;
        
        _eventTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero] ;
        if (_status == 9) {
            _eventTableview.tableHeaderView = [self createTableViewHeaderView] ;
        }
        /**
         *  将tableview的分割线补满
         */
        if ([_eventTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_eventTableview setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_eventTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_eventTableview setLayoutMargins:UIEdgeInsetsZero];
        }
        
        mx_weakify(self) ;
        _eventTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1 ;
            [weakSelf getNetworkData] ;
        }] ;
        
        _eventTableview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
            weakSelf.page ++  ;
            [weakSelf getNetworkData] ;
        }] ;
        
        
    }
    return _eventTableview ;
    
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated] ;
    if (!self.dataArray.count || self.isRefresh) {
        self.isRefresh = 0 ;
        [self.eventTableview.mj_header beginRefreshing] ;
    } else {

    }
    
    //注册通知 选择好筛选条件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshingData) name:@"selectDefineButton" object:nil];
    //注册通知 选择赔率公司
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshingData) name:@"selectOddsCompanyCell" object:nil];
    
    if (_status == 2) {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"完场赛事界面\"}"] ;
    } else if (_status == 9) {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"世界杯界面\"}"] ;
    } else {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"即时赛事界面\"}"] ;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    
    if (_status == 8) {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"完场赛事界面\"}"] ;
    } else if (_status == 1) {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"世界杯界面\"}"] ;
    } else {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"即时赛事界面\"}"] ;
    }
}

- (void)refreshingData {

    [self.eventTableview.mj_header beginRefreshing] ;
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isRefresh = 0 ;
    
    if (_status == 9) {
        self.imgNameArray = @[@"shijiebei_saicheng",
                              @"shijiebei_jifenbang",
                              @"shijiebei_dacaixiang",
                              @"shijiebei_luntan"] ;
        self.titleArray = @[@"赛程",@"积分榜",@"大猜想",@"论坛"] ;
    }
    
    if (@available(iOS 11.0, *)) {
        self.eventTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.eventTableview];
    
    mx_weakify(self) ;
    if (self.dataArray.count == 0) {
        self.upDataButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.eventTableview] ;
    }
    self.updataBlock = ^{

        [weakSelf.eventTableview.mj_header beginRefreshing] ;
    } ;
    

}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _customLayout = [[UICollectionViewFlowLayout alloc]init] ;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(98)) collectionViewLayout:_customLayout] ;
        _collectionView.backgroundColor = [UIColor whiteColor] ;
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
        //        _collectionView.allowsMultipleSelection = YES ;
        
        [_collectionView registerClass:[MXDEntranceCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MXDEntranceCollectionViewCell class])] ;
        
        //        mx_weakify(self) ;
        //        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            [weakSelf getNetworkData] ;
        //        }] ;
        
    }
    return _collectionView ;
}


#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4 ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXDEntranceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MXDEntranceCollectionViewCell class]) forIndexPath:indexPath] ;
    
    //    cell.backgroundColor = [UIColor redColor] ;
    cell.imgView.image = Image(self.imgNameArray[indexPath.row]) ;
    cell.titleLabel.text = self.titleArray[indexPath.row] ;
    
    return cell  ;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(scaleWithSize(55), scaleWithSize(98)) ;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(scaleWithSize(0), scaleWithSize(19), 0, scaleWithSize(19)) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return scaleWithSize(0) ;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return scaleWithSize(30) ;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[MXWorldCupViewController new] animated:YES] ;
    } else if (indexPath.row == 1) {
        if (!self.rankingStr) {
            return ;
        }
        MXSYJWebViewController * webVC = [[MXSYJWebViewController alloc]init] ;
        webVC.url = self.rankingStr ;
        [self.navigationController pushViewController:webVC animated:YES] ;
    } else if (indexPath.row == 2) {
        if (!self.guessStr) {
            return ;
        }
        MXSYJWebViewController * webVC = [[MXSYJWebViewController alloc]init] ;
        webVC.url = self.guessStr ;
        webVC.guessBool = YES ;
        [self.navigationController pushViewController:webVC animated:YES] ;
    } else {
        MXSYJCircleDetailController *vc = [[MXSYJCircleDetailController alloc]init];
        MXSYJChannelModel * model = [MXSYJChannelModel new];
        model.channelId = @"7" ;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark - createTableViewHeaderView
- (UIView *)createTableViewHeaderView {
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(98))];
    view.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:self.collectionView] ;
    
    if (self.postersArray.count == 2) {
        MXDPostersModel * imgModel = self.postersArray[0] ;
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, scaleWithSize(98), screen_width, 0.5 * screen_width)] ;
        [imgView sd_setImageWithURL:[NSURL URLWithString:imgModel.posterPic]] ;
        imgView.userInteractionEnabled = YES ;
        UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)] ;
        [imgView addGestureRecognizer:imgTap] ;
        [view addSubview:imgView] ;
        
        MXDPostersModel * imageModel = self.postersArray[1] ;
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), screen_width, screen_width)] ;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.posterPic]] ;
        imageView.userInteractionEnabled = YES ;
        UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImageView)] ;
        [imageView addGestureRecognizer:imageTap] ;
        [view addSubview:imageView] ;
        
        view.frame = CGRectMake(0, 0, screen_width, CGRectGetMaxY(imageView.frame)) ;
    }
    
    if (self.postersArray.count == 1) {
        MXDPostersModel * imgModel = self.postersArray[0] ;
        if (imgModel.posterPic) {
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, scaleWithSize(98), screen_width, 1.5 * screen_width)] ;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgModel.posterPic]] ;
            imageView.userInteractionEnabled = YES ;
            UITapGestureRecognizer * imgTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage)] ;
            [imageView addGestureRecognizer:imgTap] ;
            
            [view addSubview:imageView] ;
            
            view.frame = CGRectMake(0, 0, screen_width, CGRectGetMaxY(imageView.frame)) ;
            
        }
    }
    

    return view ;
}

- (void)selectImage {
    MXDPostersModel * model = self.postersArray[0] ;
    MXBattleDetailsViewController * viewCtrl = [[MXBattleDetailsViewController alloc]init] ;
    viewCtrl.matchId = model.matchId ;
    [self.navigationController pushViewController:viewCtrl animated:YES] ;
}
- (void)selectImageView {
    MXDPostersModel * model = self.postersArray[1] ;
    MXBattleDetailsViewController * viewCtrl = [[MXBattleDetailsViewController alloc]init] ;
    viewCtrl.matchId = model.matchId ;
    [self.navigationController pushViewController:viewCtrl animated:YES] ;
    
}

#pragma mark - 收藏球赛
- (void)collectMatcheWithMatchId:(NSString *)matchId IndexPath:(NSIndexPath *)indexPath optType:(NSString *)optType {
    
    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
    
    if (userModel.userId) {
        
        NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:userId forKey:@"userId"] ;
        [parameters setObject:optType forKey:@"optType"] ;
        [parameters setObject:matchId forKey:@"matchId"] ;
        [parameters setObject:timeStr forKey:@"time"];
        
        NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventCollectMatchePATH];
        
//        [SVProgressHUD showWithStatus:@"正在加载..."];
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            
            if ([dic[@"code"] isEqualToString:@"0"]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([self EventType]) {
                        MXDEventModel * model = [self.dataArray[indexPath.section]match][indexPath.row] ;
                        model.isCollect = [optType intValue] ;
                        [[weakSelf.dataArray[indexPath.section] match] replaceObjectAtIndex:indexPath.row withObject:model];
                    } else {
                        MXDEventModel * model = self.dataArray[indexPath.row] ;
                        model.isCollect = [optType intValue] ;
                        [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
                    }
                    
                    [weakSelf.eventTableview reloadData];
                    
                    
                });
                
            } else {
                
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]] ;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    int i = 0 ;
                    if ([optType intValue] == 0) {
                        i = 1 ;
                    } else {
                        i = 0 ;
                    }
                    if ([self EventType]) {
                        MXDEventModel * model = [self.dataArray[indexPath.section]match][indexPath.row] ;
                        model.isCollect = i ;
                        [[weakSelf.dataArray[indexPath.section] match] replaceObjectAtIndex:indexPath.row withObject:model];
                    } else {
                        MXDEventModel * model = self.dataArray[indexPath.row] ;
                        model.isCollect = i ;
                        [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
                    }
                    [weakSelf.eventTableview reloadData];
                    
                    
                });
            }
            
            
        } WithFailureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"收藏失败"] ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                int i = 0 ;
                if ([optType intValue] == 0) {
                    i = 1 ;
                } else {
                    i = 0 ;
                }
                if ([self EventType]) {
                    MXDEventModel * model = [self.dataArray[indexPath.section]match][indexPath.row] ;
                    model.isCollect = i ;
                    [[weakSelf.dataArray[indexPath.section]match] replaceObjectAtIndex:indexPath.row withObject:model];
                } else {
                    MXDEventModel * model = self.dataArray[indexPath.row] ;
                    model.isCollect = i ;
                    [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
                }
                [weakSelf.eventTableview reloadData];
                
                
            });
        }] ;
        
        
    } else {
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
//        login.isPageNumber = 1;
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        self.isRefresh = 1 ;
        [self presentViewController:nav animated:YES completion:^{
            
            if ([self EventType]) {
                MXDEventModel * model = [self.dataArray[indexPath.section]match][indexPath.row] ;
                model.isCollect = 0 ;
                [[self.dataArray[indexPath.section]match] replaceObjectAtIndex:indexPath.row withObject:model];
            } else {
                MXDEventModel * model = self.dataArray[indexPath.row] ;
                model.isCollect = 0 ;
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            }
                [self.eventTableview reloadData];
            
        }] ;

//        [SVProgressHUD showErrorWithStatus:@"请先登入"];
    }
}

#pragma mark - getNetworkData
- (void)getNetworkData {
    
    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;

    NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userModel.userId) {
        [parameters setObject:userId forKey:@"userId"] ;
    }
    [parameters setObject:timeStr forKey:@"time"];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * companyId = @"1";
    if ([defaults valueForKey:@"CompanyIdKey"]!=nil) {
        companyId = [defaults objectForKey:@"CompanyIdKey"];
//        [parameters setObject:companyId forKey:@"comid"];
    }
    
    if (self.status == 2||
        self.status == 1||
        self.status == 9) {
        [parameters setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
        [parameters setObject:@"10" forKey:@"limit"];
    } else {
        
        
    }
    
    
    
    if (self.status == 2) {
        if ([defaults valueForKey:@"AllAsianPlateKeyEnd"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[defaults valueForKey:@"AllAsianPlateKeyEnd"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllAsianPlateKeyString = [array componentsJoinedByString:@"#"];
            [parameters setObject:AllAsianPlateKeyString forKey:@"dishStr"];
        }
        if ([defaults valueForKey:@"AllScreeningKeyEnd"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[defaults valueForKey:@"AllScreeningKeyEnd"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllScreeningKeyString = [array componentsJoinedByString:@"#"];
            [parameters setObject:AllScreeningKeyString forKey:@"eventIdStr"];
        }
    } else if (self.status == 9) {
        if ([defaults valueForKey:@"AllAsianPlateKeyWorldCup"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[defaults valueForKey:@"AllAsianPlateKeyWorldCup"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllAsianPlateKeyString = [array componentsJoinedByString:@"#"];
            [parameters setObject:AllAsianPlateKeyString forKey:@"dishStr"];
        }
        if ([defaults valueForKey:@"AllScreeningKeyWorldCup"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[defaults valueForKey:@"AllScreeningKeyWorldCup"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllScreeningKeyString = [array componentsJoinedByString:@"#"];
            [parameters setObject:AllScreeningKeyString forKey:@"eventIdStr"];
        }
    } else if (self.status == 1) {
        if ([defaults valueForKey:@"AllAsianPlateKeyImm"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[defaults valueForKey:@"AllAsianPlateKeyImm"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllAsianPlateKeyString = [array componentsJoinedByString:@"#"];
            [parameters setObject:AllAsianPlateKeyString forKey:@"dishStr"];
        }
        if ([defaults valueForKey:@"AllScreeningKeyImm"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[defaults valueForKey:@"AllScreeningKeyImm"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllScreeningKeyString = [array componentsJoinedByString:@"#"];
            [parameters setObject:AllScreeningKeyString forKey:@"eventIdStr"];
        }
    } else if (self.status == 0) {
        if ([defaults valueForKey:@"AllAsianPlateKeyCollect"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[defaults valueForKey:@"AllAsianPlateKeyCollect"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllAsianPlateKeyString = [array componentsJoinedByString:@"#"];
            [parameters setObject:AllAsianPlateKeyString forKey:@"dishStr"];
        }
        if ([defaults valueForKey:@"AllScreeningKeyCollect"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[defaults valueForKey:@"AllScreeningKeyCollect"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllScreeningKeyString = [array componentsJoinedByString:@"#"];
            [parameters setObject:AllScreeningKeyString forKey:@"eventIdStr"];
        }
    }
    
    
    
    
    NSString * opid ;
    if (_status == 1) {
        opid = @"0" ;
    } else if (_status == 2) {
        opid = @"1" ;
    } else if (_status == 9) {
        opid = @"2" ;
    } else if (_status == 0){
        opid = @"3" ;
    } else {
        opid = [NSString stringWithFormat:@"%d",_status + 1] ;
    }
//    ((self.status == 8) ? @"1":@"0")
    [parameters setObject:opid forKey:@"opid"] ;
    
    NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
//    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, ((self.status == 8) ? MXEventFindAfterGamePATH : MXEventInstantPATH)];
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXApiCommonInstant2];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            [weakSelf endRefreshing] ;
            
            if ([dic[@"code"] isEqualToString:@"0"]) {
//                NSLog(@"赛事🚗==%@",dic[@"data"]);
//                self.webURL = @"cvbjnop" ;
                if ([dic[@"data"][@"matches"] count]||[dic[@"data"][@"posters"] count]) {
                    
                    if ([self EventType]) {
                        weakSelf.dataArray = [MXDMatchesModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"matches"]] ;
                    } else {
                        if (_status == 9) {
                            MXDLinksModel * rankingStrModel = [[MXDLinksModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"links"]] firstObject] ;
                            weakSelf.rankingStr = rankingStrModel.targetUrl ;
                            MXDLinksModel * guessStrModel = [[MXDLinksModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"links"]] lastObject] ;
                            weakSelf.guessStr = guessStrModel.targetUrl ;
                            
                            weakSelf.postersArray = [MXDPostersModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"posters"]] ;
                            
                        }
                        
                        if (weakSelf.page == 1) {
                            weakSelf.dataArray = [MXDEventModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"matches"]] ;
                            if ([dic[@"data"][@"adverts"] count]) {
                                weakSelf.advertsArray = [MXDEventModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"adverts"]] ;
                                [weakSelf.dataArray addObjectsFromArray:weakSelf.advertsArray];
                            }
                            
                        } else {
                            NSMutableArray * array = [MXDEventModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"matches"]] ;
                            [weakSelf.dataArray addObjectsFromArray:array];
                            
                            if ([dic[@"data"][@"adverts"] count]) {
                                weakSelf.advertsArray = [MXDEventModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"adverts"]] ;
                                [weakSelf.dataArray addObjectsFromArray:weakSelf.advertsArray];
                            }
                        }
                    }
                    
                    
                    weakSelf.removeUpdataBlock();
                } else {
                    if (weakSelf.page == 1) {
                        [weakSelf.dataArray removeAllObjects];
                    }
                    if (weakSelf.page > 1) {
                        weakSelf.page -- ;
                    }
                    
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    if (weakSelf.dataArray.count == 0) {
                        [weakSelf.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
                        [weakSelf.view addSubview:weakSelf.upDataButton];
                    }
                    
                }
                
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.eventTableview reloadData];
                    [weakSelf endRefreshing] ;
                    if (weakSelf.status == 9) {
                        weakSelf.eventTableview.tableHeaderView = [self createTableViewHeaderView] ;
                    }
                    
                });
                
                
            } else {
                if (weakSelf.page > 1) {
                    weakSelf.page -- ;
                }
                if (self.dataArray.count == 0) {
                    [weakSelf.upDataButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
                    [weakSelf.view addSubview:weakSelf.upDataButton];
                }
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                [weakSelf endRefreshing] ;
            }
            
        } WithFailureBlock:^(NSError *error) {
            if (weakSelf.page > 1) {
                weakSelf.page -- ;
            }
            if (weakSelf.dataArray.count == 0) {
                [weakSelf.upDataButton setTitle:@"网络错误" forState:(UIControlStateNormal)] ;
                [weakSelf.view addSubview:weakSelf.upDataButton];
            }
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
//            [weakSelf.eventTableview.mj_header endRefreshing] ;
//            [weakSelf.eventTableview.mj_footer endRefreshing] ;
            [weakSelf endRefreshing] ;
        }] ;
        
        
//    } else {
//
//
//        MXLoginViewController *login = [[MXLoginViewController alloc] init];
//        login.isPageNumber = 1;
//        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
////        [self presentViewController:nav animated:YES completion:nil];
//        [self presentViewController:nav animated:YES completion:^{
//            [self.eventTableview.mj_header beginRefreshing] ;
//        }] ;
//
////        [SVProgressHUD showErrorWithStatus:@"请先登入"];
//    }
    
    
}

- (void)endRefreshing {
    
    mx_weakify(self) ;
    if (self.dataArray.count&&![self EventType]) {
        weakSelf.eventTableview.mj_footer.hidden = NO ;
    } else {
        weakSelf.eventTableview.mj_footer.hidden = YES ;
    }
    
    [weakSelf.eventTableview.mj_header endRefreshing] ;
    [weakSelf.eventTableview.mj_footer endRefreshing] ;
    
}



#pragma mark - mainTableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([self EventType]) {
        return self.dataArray.count ;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self EventType]) {
        return [[self.dataArray[section] match] count] ;
    }
    
    return self.dataArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self EventType]) {
        return scaleWithSize(98);
    }
    
    if (self.dataArray.count >= indexPath.row) {
        
        MXDEventModel * model = self.dataArray[indexPath.row] ;
        if (model.targetUrl) {
            return screen_width * 5 / 32 ;
        }
    }
    
    return scaleWithSize(98);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self EventType]) {
        MXDEventModel * model = [self.dataArray[indexPath.section] match][indexPath.row] ;
        
        static NSString *CellIdentifier = @"MXDEventTableVCell";//cell复用
        MXDEventTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell) {
            cell = [[MXDEventTableVCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
        cell.selectionStyle = 0;//禁止选中
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.eventModel = model ;
        
        mx_weakify(self) ;
        cell.eventCollectMatcheBlock = ^{
            
            if (model.isCollect == 0) {
                model.isCollect = 1 ;
            } else {
                model.isCollect = 0 ;
            }
            [[weakSelf.dataArray[indexPath.section]match] replaceObjectAtIndex:indexPath.row withObject:model];
            [weakSelf.eventTableview reloadData] ;
            
            [weakSelf collectMatcheWithMatchId:[NSString stringWithFormat:@"%ld",(long)model.matchId] IndexPath:indexPath optType:[NSString stringWithFormat:@"%ld",(long)model.isCollect]];
           
        } ;
        
        return cell;
        
    } else {
        MXDEventModel * model = self.dataArray[indexPath.row] ;
        
        if (model.targetUrl) {
            static NSString *CellIdentifierString = @"MXADTableViewCell";//cell复用
            MXADTableViewCell * imgCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierString forIndexPath:indexPath] ;
            if (!imgCell) {
                imgCell = [[MXADTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifierString] ;
            }
            imgCell.selectionStyle = 0;//禁止选中
            //        imgCell.imageView.image = Image(@"163") ;
            //            UIImageView * imgView = [[UIImageView alloc]init] ;
            [imgCell.ADPicImgView sd_setImageWithURL:[NSURL URLWithString:model.advertPic] placeholderImage:Image(@"adPlace")] ;
            //            imgCell.backgroundView = imgView ;
            
            return imgCell ;
        }
        
        
        static NSString *CellIdentifier = @"MXDEventTableVCell";//cell复用
        MXDEventTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell) {
            cell = [[MXDEventTableVCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
        cell.selectionStyle = 0;//禁止选中
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.eventModel = model ;
        
        mx_weakify(self) ;
        cell.eventCollectMatcheBlock = ^{
            
            //        NSLog(@"%ld",(long)indexPath.row) ;
            //        model.isCollect = !model.isCollect ;
            //        MXDEventModel * model = self.dataArray[indexPath.row] ;
            if (model.isCollect == 0) {
                model.isCollect = 1 ;
            } else {
                model.isCollect = 0 ;
            }
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            [weakSelf.eventTableview reloadData] ;
            
            [weakSelf collectMatcheWithMatchId:[NSString stringWithFormat:@"%ld",(long)model.matchId] IndexPath:indexPath optType:[NSString stringWithFormat:@"%ld",(long)model.isCollect]];
            //        NSLog(@"-----------%ld",model.isCollect) ;
            //
            
            //        for (MXDEventModel * model in weakSelf.dataArray) {
            //            NSLog(@"-----------%ld",model.isCollect) ;
            //        }
            
        } ;
        
        return cell;
    }
    
}
// 隐藏多余cell
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.advertsArray.count) {
//
//        MXDAdvertsModel *adModel = self.advertsArray[0] ;
//        if (adModel.targetUrl&&(indexPath.row%11== 0||indexPath.row == self.dataArray.count)) {
//            NSLog(@"广告") ;
//            return ;
//        }
//    }
    
    MXDEventModel * model ;
    
    if ([self EventType]) {
        model = [self.dataArray[indexPath.section]match][indexPath.row] ;
    } else {
        model = self.dataArray[indexPath.row] ;
    }
    
    
    
    if (model.targetUrl) {
        
        MXSYJWebViewController * webVC = [[MXSYJWebViewController alloc]init] ;
        webVC.url = model.targetUrl ;
        webVC.adID = model.advertId ;
//        NSLog(@"广告") ;
        [self.navigationController pushViewController:webVC animated:YES] ;
        return ;
    }
    
    MXBattleDetailsViewController *battleDetails = [[MXBattleDetailsViewController alloc]init];
    
    battleDetails.matchId = model.matchId ;
    battleDetails.titleString = model.eventShortName ;

    
    battleDetails.homeNm = model.homeTeamName ;
    battleDetails.homeScore = [NSString stringWithFormat:@"%ld",model.homeTeamScore] ;
    battleDetails.homeLogo = model.homeTeamLogo ;

    battleDetails.awayNm = model.visitTeamName ;
    battleDetails.awayScore = [NSString stringWithFormat:@"%ld",model.visitTeamScore] ;
    battleDetails.awayLogo = model.visitTeamLogo ;

    battleDetails.status = (int)model.matchStatus ;
    battleDetails.matchStartTime = model.startGameTime ;
    battleDetails.flashFlg = model.flashFlg ;
    
    
    [self.navigationController pushViewController:battleDetails animated:YES];
    
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width  , scaleWithSize(30))];
//    label.text = @"2018/05/23 周五";
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
//    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init] ;
    paragraphStyle.alignment = NSTextAlignmentCenter ;
//    paragraphStyle.headIndent = scaleWithSize(15) ;
//    paragraphStyle.firstLineHeadIndent = scaleWithSize(15) ;
    
    if ([[self.dataArray[section]groupType]length]) {
        NSAttributedString * attrStr = [[NSAttributedString alloc]initWithString:[self.dataArray[section]groupType] attributes:@{
                                                                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:scaleWithSize(15)],
                                                                                                                                 NSParagraphStyleAttributeName:paragraphStyle,}];
        label.attributedText = attrStr;
    }
    
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self EventType]) {
        return scaleWithSize(30);
    }else {
        return 0 ;
    }
    
//    if (section == 0) {
//        return 0;
//    } else {
//        return scaleWithSize(30);
//    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = scaleWithSize(30);
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


- (BOOL)EventType {

    /* 0:  赛事类型（0：即时赛事，1：完场赛事 2：世界杯即时赛事）
     * 1:  赛事类型（3：收藏 4：中超 5：西甲6：德甲 7：英超8：意甲9：中甲）
     */
    if (_status == 1||
        _status == 2||
        _status == 9) {
        return 0 ;
    } else {
        return 1;
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
