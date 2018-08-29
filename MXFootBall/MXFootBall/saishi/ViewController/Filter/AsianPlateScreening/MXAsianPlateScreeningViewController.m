//
//  MXAsianPlateScreeningViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXAsianPlateScreeningViewController.h"

#import "MXScreeningCollectionViewCell.h"

#import "MXAsianPlateScreeningModel.h"

@interface MXAsianPlateScreeningViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic ,strong) UICollectionViewFlowLayout * customLayout ;

@property (nonatomic ,strong) UICollectionView * collectionView ;

@property (nonatomic , strong) NSMutableArray * allScreeningArray ;

@property (nonatomic , strong) NSString * allScreeningIDsString ;
//所有的赔率
@property (nonatomic , strong) NSString * allAsianPlateNameString ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@end

@implementation MXAsianPlateScreeningViewController

static NSString *const cellId = @"MXScreeningCollectionViewCell";
static NSString *const headerId = @"headerId";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor ;
    
    [self.view addSubview:self.collectionView];
    
    mx_weakify(self) ;
    if (self.dataArray.count == 0) {
        self.refreshButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.collectionView] ;
    }
    self.updataBlock = ^{
        
        [weakSelf.collectionView.mj_header beginRefreshing] ;
    } ;
    
//    self.allScreeningIDsString = @"" ;
    
//    [self GCDQueueSerial] ;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
//    if (!self.dataArray.count) {
//        [self getNetworkAllScreeningData] ;
//    }
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([self.optType isEqualToString:@"1"]) {
        self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyEnd1"] ;
    } else if ([self.optType isEqualToString:@"2"]) {
        self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyWorldCup1"] ;
    } else{
        self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyImm1"] ;
    }
//    if (![self.optType isEqualToString:@"0"]) {
//        self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyEnd1"] ;
//    } else {
//        self.allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyImm1"] ;
//    }
    
    
    NSLog(@"%@",self.allScreeningIDsString) ;
    
    [self getNetworkData] ;
    
}

#pragma mark - network

- (void)GCDQueueSerial {
    
    dispatch_queue_t queue = dispatch_queue_create("com.MXFootBall", DISPATCH_QUEUE_SERIAL) ;
    mx_weakify(self) ;
    dispatch_async(queue, ^{
        [weakSelf getNetworkAllScreeningData];
    }) ;
    
    dispatch_async(queue, ^{
        [weakSelf getNetworkData] ;
    });
    
}



- (void)getNetworkAllScreeningData {

    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"1" forKey:@"operationType"] ;
    [parameters setObject:timeStr forKey:@"time"];
    NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventFilterPATH];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    mx_weakify(self);
    [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            
            weakSelf.allScreeningArray = [MXFilterModel mj_objectArrayWithKeyValuesArray:dic[@"data"]] ;
            
            if (weakSelf.allScreeningArray.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
            } else {
                
            }
            
            
            
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                
        
                [weakSelf getNetworkData] ;
            });
            
            
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }] ;
    
    
    //    } else {
    //        [SVProgressHUD showErrorWithStatus:@"请先登入"];
    //    }
    
    
}


- (void)getNetworkData {
    
//    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
//    if (userModel.userId) {
    
//        NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
//        NSString *token = userModel.token;
//    for (MXFilterModel * model in self.allScreeningArray) {
//
//        self.allScreeningIDsString = [NSString stringWithFormat:@"%@|%ld",self.allScreeningIDsString,(long)model.ID] ;
//    }
    
//    NSLog(@"------%@",self.allScreeningIDsString) ;
    
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[self.optType isEqualToString:@"0"]?@"0":@"1" forKey:@"opid"] ;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * companyId = @"1";
    if ([userDefaults valueForKey:@"CompanyIdKey"]!=nil) {
        companyId = [userDefaults objectForKey:@"CompanyIdKey"];
//        [parameters setObject:companyId forKey:@"companyId"] ;
    }
    if ([self.optType isEqualToString:@"1"]) {
        if ([userDefaults valueForKey:@"AllScreeningKeyEnd1"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[userDefaults valueForKey:@"AllScreeningKeyEnd1"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllScreeningKeyString = [array componentsJoinedByString:@"#"];
            [parameters setValue:AllScreeningKeyString forKey:@"eventIdStr"] ;
        }
    } else if ([self.optType isEqualToString:@"2"]) {
        if ([userDefaults valueForKey:@"AllScreeningKeyWorldCup1"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[userDefaults valueForKey:@"AllScreeningKeyWorldCup1"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllScreeningKeyString = [array componentsJoinedByString:@"#"];
            [parameters setValue:AllScreeningKeyString forKey:@"eventIdStr"] ;
        }
    } else {
        if ([userDefaults valueForKey:@"AllScreeningKeyImm1"] != nil) {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[[userDefaults valueForKey:@"AllScreeningKeyImm1"] componentsSeparatedByString:@"|"]]  ;
            NSString * AllScreeningKeyString = [array componentsJoinedByString:@"#"];
            [parameters setValue:AllScreeningKeyString forKey:@"eventIdStr"] ;
        }
    }
    
    
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXApiCommonOddList2];
        
    [SVProgressHUD showWithStatus:@"正在加载..."];
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            [weakSelf.collectionView.mj_header endRefreshing
             ];
            if ([dic[@"code"] isEqualToString:@"0"]) {
                
                if ([dic[@"data"] count]) {
                    
                    weakSelf.dataArray = [MXAsianPlateScreeningModel mj_objectArrayWithKeyValuesArray:dic[@"data"]] ;
                    for (MXAsianPlateScreeningModel * filterModel in weakSelf.dataArray) {
                        //存 所有的ID
                        if (filterModel.odd) {
                            if (self.allAsianPlateNameString) {
                                self.allAsianPlateNameString = [NSString stringWithFormat:@"%@|%@",self.allAsianPlateNameString,filterModel.odd] ;
                            } else {
                                self.allAsianPlateNameString = [NSString stringWithFormat:@"%@",filterModel.odd] ;
                            }
                        }
                    }
                    
                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];

                    if ([self.optType isEqualToString:@"1"]) {
                        [defaults setValue:self.allAsianPlateNameString forKey:@"AllAsianPlateKeyEnd1"] ;
                    } else if ([self.optType isEqualToString:@"2"]) {
                        [defaults setValue:self.allAsianPlateNameString forKey:@"AllAsianPlateKeyWorldCup1"] ;
                    } else {
                        [defaults setValue:self.allAsianPlateNameString forKey:@"AllAsianPlateKeyImm1"] ;
                    }
//                    [defaults setValue:self.allAsianPlateNameString forKey:@"AllAsianPlateKey1"] ;
                    [defaults synchronize];
                    
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
                    
                    [weakSelf.collectionView reloadData];
                });
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                if (self.dataArray.count == 0) {
                    [weakSelf.refreshButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
                    [weakSelf.view addSubview:weakSelf.refreshButton];
                }
            }
            
        } WithFailureBlock:^(NSError *error) {
            
            [weakSelf.collectionView.mj_header endRefreshing
             ];
            if (weakSelf.dataArray.count == 0) {
                [weakSelf.refreshButton setTitle:@"网络错误" forState:(UIControlStateNormal)] ;
                [weakSelf.view addSubview:weakSelf.refreshButton];
            }
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }] ;
        
        
//    } else {
//        [SVProgressHUD showErrorWithStatus:@"请先登入"];
//    }
    
    
}

- (NSMutableArray *)allScreeningArray {
    
    if (!_allScreeningArray) {
        _allScreeningArray = [NSMutableArray array] ;
    }
    return _allScreeningArray ;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _customLayout = [[UICollectionViewFlowLayout alloc]init] ;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - scaleWithSize(60) - TABBAR_FRAME) collectionViewLayout:_customLayout] ;
        _collectionView.backgroundColor = mx_Wode_backgroundColor ;
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
//        _collectionView.allowsMultipleSelection = YES ;
        
        [_collectionView registerClass:[MXScreeningCollectionViewCell class] forCellWithReuseIdentifier:cellId] ;
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId] ;
        
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getNetworkData] ;
        }] ;
        
    }
    return _collectionView ;
}


#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXScreeningCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath] ;
    cell.backgroundColor = mx_Wode_colorBlue2374e4 ;
    cell.layer.cornerRadius = 5 ;
    cell.layer.masksToBounds = YES ;
    cell.nameLabel.textColor = [UIColor whiteColor] ;
    cell.numberLabel.textColor = [UIColor whiteColor] ;
//    cell.selected = YES ;
    
    if (self.dataArray.count > 0) {
        
        MXAsianPlateScreeningModel * model = self.dataArray[indexPath.row] ;
        
        cell.asianPlateModel = model ;
        
        if (model.isSelect == 1) {
            cell.backgroundColor = [UIColor whiteColor] ;
            cell.nameLabel.textColor = [UIColor darkGrayColor] ;
            cell.numberLabel.textColor = [UIColor darkGrayColor] ;
        }
        
    }
    
//    cell.asianPlateModel = self.dataArray[indexPath.row] ;
    
    return cell ;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
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
    
//    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor] ;
    
    
    if (self.dataArray.count > 0) {
        
        MXAsianPlateScreeningModel * model = self.dataArray[indexPath.row] ;
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        if ([self.optType isEqualToString:@"1"]) {
            self.allAsianPlateNameString = [defaults valueForKey:@"AllScreeningKeyEnd1"] ;
        } else if ([self.optType isEqualToString:@"2"]) {
            self.allAsianPlateNameString = [defaults valueForKey:@"AllScreeningKeyWorldCup1"] ;
        } else{
            self.allAsianPlateNameString = [defaults valueForKey:@"AllScreeningKeyImm1"] ;
        }
//        if (![self.optType isEqualToString:@"0"]) {
//            self.allAsianPlateNameString = [defaults valueForKey:@"AllAsianPlateKeyEnd1"] ;
//        } else {
//            self.allAsianPlateNameString = [defaults valueForKey:@"AllAsianPlateKeyImm1"] ;
//        }
//        self.allAsianPlateNameString = [defaults valueForKey:@"AllAsianPlateKey1"] ;
        
        if (model.isSelect == 1) {
            model.isSelect = 0;
            if ([self.allAsianPlateNameString isEqualToString:@""]) {
                self.allAsianPlateNameString = [NSString stringWithFormat:@"%@",model.odd] ;
            } else {
                self.allAsianPlateNameString = [NSString stringWithFormat:@"%@|%@",self.allAsianPlateNameString,model.odd] ;
            }
            
        } else {
            NSMutableArray * array =[NSMutableArray arrayWithArray:[self.allAsianPlateNameString componentsSeparatedByString:@"|"]]  ;
            [array removeObject:[NSString stringWithFormat:@"%@",model.odd]];
            self.allAsianPlateNameString = @"" ;
            for (NSString * string in array) {
                if (string.length) {
                    if ([self.allAsianPlateNameString isEqualToString:@""]) {
                        self.allAsianPlateNameString = string ;
                    } else {
                        self.allAsianPlateNameString = [NSString stringWithFormat:@"%@|%@",self.allAsianPlateNameString,string] ;
                    }
                }
            }
            
            model.isSelect = 1;
        }
        
        if ([self.optType isEqualToString:@"1"]) {
            [defaults setValue:self.allAsianPlateNameString forKey:@"AllAsianPlateKeyEnd1"] ;
        } else if ([self.optType isEqualToString:@"2"]) {
            [defaults setValue:self.allAsianPlateNameString forKey:@"AllAsianPlateKeyWorldCup1"] ;
        } else {
            [defaults setValue:self.allAsianPlateNameString forKey:@"AllAsianPlateKeyImm1"] ;
        }
//        [defaults setValue:self.allAsianPlateNameString forKey:@"AllAsianPlateKey1"] ;
        [defaults synchronize];
        NSLog(@"%@",self.allAsianPlateNameString) ;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    }
    
    
    [self.collectionView reloadData] ;
    
    
}
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = mx_Wode_colorBlue2374e4 ;
//    
//}


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
