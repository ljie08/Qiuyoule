//
//  MXAllScreeningViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXAllScreeningViewController.h"

#import "MXScreeningCollectionViewCell.h"

#import "MXScreeningHeaderCollectionReusableView.h"//A～Z组头视图

#import "MJRefresh.h"

#import "MXDAllEventsModel.h"
//#import "MXFilterModel.h"
#import "NSString+PinYing.h"

@interface MXAllScreeningViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
    BOOL isUnselectAll ;
    
    BOOL isRefresh ;
}

@property (nonatomic ,strong) UICollectionViewFlowLayout * customLayout ;

@property (nonatomic ,strong) UICollectionView * collectionView ;
@property (nonatomic ,strong) UILabel * headerLabel ;

//为使用索引创建 空白tableView
@property (nonatomic ,strong) UITableView * mainTableView ;
//A～Z 索引
@property (nonatomic ,strong) NSMutableArray * zimuMutableArray ;

//存collectionCell的状态
@property (nonatomic ,strong) NSMutableDictionary * selectMutDic ;

//存放选中赛事的ID
@property (nonatomic , strong) NSString * allScreeningIDsString ;


@property (nonatomic , strong) NSMutableArray * dataArray ;

@end

@implementation MXAllScreeningViewController


static NSString *const cellId = @"MXScreeningCollectionViewCell";
static NSString *const headerId = @"MXScreeningHeaderCollectionReusableView";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithRGBF(0xebf0f4) ;
    
//    isRefresh = NO ;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.mainTableView] ;
    
    mx_weakify(self) ;
    if (self.dataArray.count == 0) {
        self.refreshButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.collectionView] ;
    }
    self.updataBlock = ^{
        
        [weakSelf getNetworkData] ;
//        [weakSelf.collectionView.mj_header beginRefreshing] ;
    } ;
    
//    [self getNetworkData] ;
//    for (char c = 'A'; c <= 'Z'; c ++) {
//
//        [self.zimuMutableArray addObject:[NSString stringWithFormat:@"%c",c]] ;
//    }
    
}

#pragma mark - network
- (void)getNetworkData {
    
//    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
//    if (userModel.userId) {
//
//        NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
//        NSString *token = userModel.token;
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        [parameters setObject:userId forKey:@"userId"];
//        [parameters setObject:token forKey:@"token"];
    
    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
    NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
    if (userModel.userId) {
        [parameters setObject:userId forKey:@"userId"] ;
    }
    
    
//       NSLog(@"---%@",self.optType) ;
//    NSString * opid ;
//    if ([self.optType isEqualToString:@"0"]) {
//        opid = @"0" ;
//    } else if ([self.optType isEqualToString:@"1"]) {
//        opid = @"2" ;
//    } else {
//        opid = @"1" ;
//    }
    [parameters setObject:self.optType forKey:@"opid"];
    
        [parameters setObject:@"1" forKey:@"operationType"] ;
        [parameters setObject:timeStr forKey:@"time"];
        NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXApiCommonEventList2];
        
        [SVProgressHUD showWithStatus:@"正在加载..."];
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            [weakSelf.collectionView.mj_header endRefreshing];
            if ([dic[@"code"] isEqualToString:@"0"]) {
                
                
                if ([dic[@"data"] count]) {
                    
                    weakSelf.dataArray = [MXDAllEventsModel mj_objectArrayWithKeyValuesArray:dic[@"data"]] ;
                    
                    [weakSelf arraySorting:weakSelf.dataArray];
                    
//                    MXDAllEventsModel * eventsModel = self.dataArray[index] ;
                    [weakSelf.zimuMutableArray removeAllObjects] ;
                    for (MXDAllEventsModel * eventsModel in weakSelf.dataArray) {
                        
                        if (eventsModel.events.count) {
                            [weakSelf.zimuMutableArray addObject:[NSString stringWithFormat:@"%@",eventsModel.letter]] ;
                        }
                        
                        
                    }
                    
                    weakSelf.removeUpdataBlock() ;
                    
                } else {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    if (weakSelf.dataArray.count == 0) {
                        [weakSelf.refreshButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
                        [weakSelf.view addSubview:weakSelf.refreshButton];
                    }
                }
                
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.collectionView.mj_header endRefreshing] ;
                    
                    [weakSelf.collectionView reloadData];
                    [weakSelf.mainTableView reloadData] ;
                    
                });
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                if (self.dataArray.count == 0) {
                    [weakSelf.refreshButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
                    [weakSelf.view addSubview:weakSelf.refreshButton];
                }
                
            }
            
        } WithFailureBlock:^(NSError *error) {
            [weakSelf.collectionView.mj_header endRefreshing];
            if (weakSelf.dataArray.count == 0) {
                [weakSelf.refreshButton setTitle:@"网络错误" forState:(UIControlStateNormal)] ;
                [weakSelf.view addSubview:weakSelf.refreshButton];
            }
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }] ;
}

- (NSMutableArray *)arraySorting:(NSMutableArray *) mutableArray {
    
//    NSMutableArray * filterArray = [NSMutableArray array];
//
//    for (int i = 'A'; i <= 'Z'; i++) {
//        NSMutableArray * arr = [NSMutableArray array] ;
//        [filterArray addObject:arr];
//
//    }
    
    self.allScreeningIDsString = @"" ;
    for (MXDAllEventsModel * model in mutableArray) {
        for (MXFilterModel * filterModel in model.events) {
            //存 所有的ID
            if (filterModel.ID) {
                if (![self.allScreeningIDsString isEqualToString:@""]) {
                    self.allScreeningIDsString = [NSString stringWithFormat:@"%@|%ld",self.allScreeningIDsString,(long)filterModel.ID] ;
                } else {
                    self.allScreeningIDsString = [NSString stringWithFormat:@"%ld",(long)filterModel.ID] ;
                }
            }
        }
        
        
//        [filterModel.initials getFirstLetter] ;
//        int i = [[filterModel.initials getFirstLetter] characterAtIndex:0] - 'A' ;
//        if ( 0< i <filterArray.count ) {
//            [filterArray[i] addObject:filterModel] ;
//        }
    }
    
    NSLog(@"%@", self.allScreeningIDsString) ;
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//    [defaults synchronize];
    [self setAllScreeningKey] ;
    
    
    return mutableArray ;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    if (!self.dataArray.count) {
        [self getNetworkData] ;
    }
//    if (self.allScreeningIDsString.length) {
    
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey] ;
//    }
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi1:) name:@"tongzhi1" object:nil];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi2:) name:@"tongzhi2" object:nil];
}
#pragma mark - 通知
- (void)tongzhi:(NSNotification *)notification{
    
    if ([notification.userInfo[@"selectIndex"] isEqualToString:@"0"]) {
//        isUnselectAll = YES ;
        self.allScreeningIDsString = @"" ;
        if (self.dataArray.count > 0) {
            for (int i = 0; i< self.dataArray.count; i ++) {
                MXDAllEventsModel * eventsModel = self.dataArray[i] ;
                for (int j = 0; j < [eventsModel.events count]; j ++) {
                    MXFilterModel * model = eventsModel.events[j] ;
                    if ([model.shortNameZh isEqualToString:@"英超"]||
                        [model.shortNameZh isEqualToString:@"意甲"]||
                        [model.shortNameZh isEqualToString:@"德甲"]||
                        [model.shortNameZh isEqualToString:@"西甲"]||
                        [model.shortNameZh isEqualToString:@"法甲"]) {
                        model.isSelect = 0;
                        
                        if (model.ID) {
                            if ([self.allScreeningIDsString isEqualToString:@""]) {
                                self.allScreeningIDsString = [NSString stringWithFormat:@"%ld",(long)model.ID] ;
                            } else {
                                self.allScreeningIDsString = [NSString stringWithFormat:@"%@|%ld",self.allScreeningIDsString,(long)model.ID] ;
                            }
                        }
                        
                    } else {
                        model.isSelect = 1;
                    }
                    [eventsModel.events replaceObjectAtIndex:j withObject:model];
                    [self.dataArray replaceObjectAtIndex:i withObject:eventsModel];
//                    [self.dataArray[i] replaceObjectAtIndex:j withObject:model];
                }
            }
        }
        
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey] ;
        
        [self.collectionView reloadData];
    }
}
- (void)tongzhi1:(NSNotification *)notification{
    
    if ([notification.userInfo[@"selectIndex"] isEqualToString:@"0"]) {
        
        self.allScreeningIDsString = @"" ;
        if (self.dataArray.count > 0) {
            for (int i = 0; i< self.dataArray.count; i ++) {
                MXDAllEventsModel * eventsModel = self.dataArray[i] ;
                for (int j = 0; j < [eventsModel.events count]; j ++) {
                    MXFilterModel * model = eventsModel.events[j] ;
                    model.isSelect = 0 ;
                    [eventsModel.events replaceObjectAtIndex:j withObject:model];
                    [self.dataArray replaceObjectAtIndex:i withObject:eventsModel];
//                    [self.dataArray[i] replaceObjectAtIndex:j withObject:model];
                    
                    if (model.ID) {
                        if ([self.allScreeningIDsString isEqualToString:@""]) {
                            self.allScreeningIDsString = [NSString stringWithFormat:@"%ld",(long)model.ID] ;
                        } else {
                            self.allScreeningIDsString = [NSString stringWithFormat:@"%@|%ld",self.allScreeningIDsString,(long)model.ID] ;
                        }
                    }
                    
                    
                }
            }
        }
        
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey] ;
        
        [self.collectionView reloadData];
        
//        [self.selectMutDic removeAllObjects] ;
        [self delegateSelectNameMutDic];
    }
}
- (void)tongzhi2:(NSNotification *)notification{
    
    if ([notification.userInfo[@"selectIndex"] isEqualToString:@"0"]) {
//        isUnselectAll = YES ;
        
        
        if (self.dataArray.count > 0) {
            for (int i = 0; i< self.dataArray.count; i ++) {
                MXDAllEventsModel * eventsModel = self.dataArray[i] ;
                for (int j = 0; j < [eventsModel.events count]; j ++) {
                    MXFilterModel * model = eventsModel.events[j] ;
                    model.isSelect = 1 ;
                    [eventsModel.events replaceObjectAtIndex:j withObject:model];
                    [self.dataArray replaceObjectAtIndex:i withObject:eventsModel];
//                    [self.dataArray[i] replaceObjectAtIndex:j withObject:model];
                }
            }
        }
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        self.allScreeningIDsString = @"" ;
//        [defaults setValue:@"" forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey] ;
        
        [self.collectionView reloadData];
    }
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 加载
- (NSMutableDictionary *)selectMutDic {
    if (!_selectMutDic) {
        _selectMutDic = [NSMutableDictionary dictionary] ;
    }
    return _selectMutDic ;
}
- (NSMutableArray *)zimuMutableArray {
    
    if (!_zimuMutableArray) {
        _zimuMutableArray = [NSMutableArray array];
    }
    return _zimuMutableArray ;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - scaleWithSize(114) - 44 - TABBAR_FRAME) style:(UITableViewStyleGrouped)] ;
        _mainTableView.backgroundColor = [UIColor clearColor] ;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine ;
        _mainTableView.delegate = self ;
        _mainTableView.dataSource = self ;
        _mainTableView.allowsSelection = YES ;
        
        _mainTableView.userInteractionEnabled = NO ;
        _mainTableView.showsVerticalScrollIndicator = NO ;
        _mainTableView.showsHorizontalScrollIndicator = NO ;
        
        _mainTableView.sectionIndexColor = mx_Wode_colorBlue2374e4 ;
        _mainTableView.sectionIndexBackgroundColor = [UIColor clearColor] ;
        
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    return _mainTableView ;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _customLayout = [[UICollectionViewFlowLayout alloc]init] ;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - scaleWithSize(114) - 44 - TABBAR_FRAME - STATUS_HEIGHT) collectionViewLayout:_customLayout] ;
        _collectionView.backgroundColor = [UIColor clearColor] ;
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
//        _collectionView.allowsMultipleSelection = YES ;//多选
        
        [_collectionView registerClass:[MXScreeningCollectionViewCell class] forCellWithReuseIdentifier:cellId] ;
        
        [_collectionView registerClass:[MXScreeningHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId] ;
        
        __weak typeof(self) weakSelf = self ;
//        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//            [weakSelf getNetworkData] ;
//        }];
//        [_collectionView.mj_header beginRefreshing];
        
    }
    return _collectionView ;
}


#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        MXDAllEventsModel * model = self.dataArray[section] ;
        return [model.events count] ;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXScreeningCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath] ;
    
    
//    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    
    cell.layer.cornerRadius = 5 ;
    cell.layer.masksToBounds = YES ;
    cell.backgroundColor = mx_Wode_colorBlue2374e4 ;
    cell.nameLabel.textColor = [UIColor whiteColor] ;
    cell.numberLabel.textColor = [UIColor whiteColor] ;
    
    if (self.dataArray.count > 0) {
        MXDAllEventsModel * model = self.dataArray[indexPath.section] ;
//
        if (model.events.count) {
            MXFilterModel * eventsModel = model.events[indexPath.row] ;
            cell.model = eventsModel;
            
            if (eventsModel.isSelect == 1) {
                cell.backgroundColor = [UIColor whiteColor] ;
                cell.nameLabel.textColor = [UIColor darkGrayColor] ;
                cell.numberLabel.textColor = [UIColor darkGrayColor] ;
            }
        }
        
    }
    
    
    
    
//    if (!isUnselectAll) {
//        cell.backgroundColor = mx_Wode_colorBlue2374e4 ;
//    } else {
//        cell.backgroundColor = [UIColor whiteColor] ;
//        cell.nameLabel.textColor = [UIColor darkGrayColor] ;
//        cell.numberLabel.textColor = [UIColor darkGrayColor] ;
//    }
//    if ([[self.selectMutDic objectForKey:[NSString stringWithFormat:@"%@_%ld",self.zimuMutableArray[indexPath.section], (long)indexPath.row]] isEqualToString:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]) {
//        cell.backgroundColor = [UIColor whiteColor] ;
//        cell.nameLabel.textColor = [UIColor darkGrayColor] ;
//        cell.numberLabel.textColor = [UIColor darkGrayColor] ;
//    }
    
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (self.dataArray.count > 0) {
        MXDAllEventsModel * model = self.dataArray[section] ;
        if ([model.events count] == 0) {
            return (CGSize){screen_width,scaleWithSize(0)};
        }
    }
    
    
    return (CGSize){screen_width,scaleWithSize(30)};
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        MXScreeningHeaderCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath] ;
        
        MXDAllEventsModel * model = self.dataArray[indexPath.section] ;
        
        headerView.label.text = model.letter;
       
        return headerView ;
    }
    
    return nil ;
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(scaleWithSize(108), scaleWithSize(32)) ;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, scaleWithSize(15), 5, scaleWithSize(15)) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return scaleWithSize(7) ;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return scaleWithSize(7) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

    if (self.dataArray.count > 0) {
        
        MXDAllEventsModel * eventsModel = self.dataArray[indexPath.section] ;
        MXFilterModel * model = eventsModel.events[indexPath.row] ;
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if ([self.optType isEqualToString:@"1"]) {
            self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyEnd1"] ;
        } else if ([self.optType isEqualToString:@"2"]) {
            self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyWorldCup1"] ;
        } else{
            self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyImm1"] ;
        }
//        self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKey1"] ;
        
        if (model.isSelect == 1) {
            model.isSelect = 0;
            if ([self.allScreeningIDsString isEqualToString:@""]) {
                self.allScreeningIDsString = [NSString stringWithFormat:@"%ld",(long)model.ID] ;
            } else {
                self.allScreeningIDsString = [NSString stringWithFormat:@"%@|%ld",self.allScreeningIDsString,(long)model.ID] ;
            }
            
        } else {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[self.allScreeningIDsString componentsSeparatedByString:@"|"]]  ;
            [array removeObject:[NSString stringWithFormat:@"%ld",model.ID]];
            self.allScreeningIDsString = @"" ;
            for (NSString * string in array) {
                if (string.length) {
                    if ([self.allScreeningIDsString isEqualToString:@""]) {
                        self.allScreeningIDsString = string ;
                    } else {
                        self.allScreeningIDsString = [NSString stringWithFormat:@"%@|%@",self.allScreeningIDsString,string] ;
                    }
                }
            }
            
            model.isSelect = 1;
        }
        
        NSLog(@"%@",self.allScreeningIDsString) ;
        
//        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey] ;
        
//        eventsModel.events[indexPath.row] = 0;
        [eventsModel.events replaceObjectAtIndex:indexPath.row withObject:model];
        
        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:eventsModel];
    }
    
    
    [self.collectionView reloadData] ;
    [self delegateSelectNameMutDic];
}
- (void)setAllScreeningKey {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([self.optType isEqualToString:@"1"]) {
        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKeyEnd1"] ;
    } else if ([self.optType isEqualToString:@"2"]) {
        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKeyWorldCup1"] ;
    } else {
        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKeyImm1"] ;
    }
    
    [defaults synchronize];
    
}


//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//
////    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
////    MXScreeningCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath] ;
////    cell.backgroundColor = mx_Wode_colorBlue2374e4 ;
//
//    [self.selectMutDic removeObjectForKey:[NSString stringWithFormat:@"%@_%ld",self.zimuMutableArray[indexPath.section], (long)indexPath.row]] ;
//    [self.collectionView reloadData] ;
//    [self delegateSelectNameMutDic];
//}

#pragma mark - self Delegate
- (void)delegateSelectNameMutDic {
    if ([self.delegate respondsToSelector:@selector(selectNameMutDic:)]) {
        
        [self.delegate selectNameMutDic:self.selectMutDic] ;
    }
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  0 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:NSStringFromClass([UITableViewCell class])] ;
    }
    return cell ;
}


#pragma mark -  索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.zimuMutableArray ;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
//    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index ] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    if ([self.dataArray count] > 0) {
        
        int i = [self.zimuMutableArray[index] characterAtIndex:0] - 'A' ;
        MXDAllEventsModel * eventsModel = self.dataArray[i] ;
//        MXFilterModel * model = eventsModel.events[indexPath.row] ;
        if (!eventsModel.events.count) {
            
        } else {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
            
        }
        
        
    }
    
    
    
    return index  ;
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
