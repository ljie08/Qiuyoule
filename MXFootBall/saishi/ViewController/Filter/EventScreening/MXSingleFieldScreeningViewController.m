//
//  MXSingleFieldScreeningViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSingleFieldScreeningViewController.h"

#import "MXScreeningCollectionViewCell.h"

#import "MXFilterModel.h"
#import "NSString+PinYing.h"

@interface MXSingleFieldScreeningViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

{
    BOOL isUnselectAll ;
}

@property (nonatomic ,strong) UICollectionViewFlowLayout * customLayout ;

@property (nonatomic ,strong) UICollectionView * collectionView ;

//存collectionCell的状态
@property (nonatomic ,strong) NSMutableDictionary * selectMutDic ;
//存放选中赛事的ID
@property (nonatomic , strong) NSString * allScreeningIDsString ;


@property (nonatomic , strong) NSMutableArray * dataArray ;


@end

@implementation MXSingleFieldScreeningViewController


static NSString *const cellId = @"MXScreeningCollectionViewCell";
static NSString *const headerId = @"headerId";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorWithRGBF(0xebf0f4) ;
    
    [self.view addSubview:self.collectionView];
    
    mx_weakify(self) ;
    if (self.dataArray.count == 0) {
        self.refreshButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.collectionView] ;
    }
    self.updataBlock = ^{
        
        [weakSelf getNetworkData] ;
        //        [weakSelf.collectionView.mj_header beginRefreshing] ;
    } ;
    
//    [self getNetworkData] ;
    
}

#pragma mark - network
- (void)getNetworkData {
    
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
    NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
    if (userModel.userId) {
        [parameters setObject:userId forKey:@"userId"] ;
    }
    
    [parameters setObject:self.optType forKey:@"opid"];
        [parameters setObject:@"3" forKey:@"operationType"] ;
        [parameters setObject:timeStr forKey:@"time"];
        NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXApiCommonEventList2];
        
        [SVProgressHUD showWithStatus:@"正在加载..."];
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            [weakSelf.collectionView.mj_header endRefreshing] ;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                
                if ([dic[@"data"] count]) {
                    
                    weakSelf.dataArray = [MXFilterModel mj_objectArrayWithKeyValuesArray:dic[@"data"]] ;
                    for (MXFilterModel * filterModel in weakSelf.dataArray) {
                        //存 所有的ID
                        if (filterModel.ID) {
                            if (self.allScreeningIDsString) {
                                self.allScreeningIDsString = [NSString stringWithFormat:@"%@|%ld",self.allScreeningIDsString,(long)filterModel.ID] ;
                            } else {
                                self.allScreeningIDsString = [NSString stringWithFormat:@"%ld",(long)filterModel.ID] ;
                            }
                        }
                    }
                    
//                    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//                    [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//                    [defaults synchronize];
                    [self setAllScreeningKey];
                    
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
            [weakSelf.collectionView.mj_header endRefreshing] ;
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


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated] ;
    if (!self.dataArray.count) {
        [self getNetworkData] ;
    }
//    if (self.allScreeningIDsString.length) {
    
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey];
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
    
    if ([notification.userInfo[@"selectIndex"] isEqualToString:@"2"]) {
        //        isUnselectAll = YES ;
        self.allScreeningIDsString = @"" ;
        if (self.dataArray.count > 0) {
            for (int i = 0; i< self.dataArray.count; i ++) {
                    MXFilterModel * model = self.dataArray[i] ;
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
                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                
            }
        }
        
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey];
        
        [self.collectionView reloadData];
    }
}
- (void)tongzhi1:(NSNotification *)notification{
    
    if ([notification.userInfo[@"selectIndex"] isEqualToString:@"2"]) {
        //        isUnselectAll = NO ;
        self.allScreeningIDsString = @"" ;
        if (self.dataArray.count > 0) {
            for (int i = 0; i< self.dataArray.count; i ++) {
                    MXFilterModel * model = self.dataArray[i] ;
                    model.isSelect = 0 ;
                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                
                if (model.ID) {
                    if ([self.allScreeningIDsString isEqualToString:@""]) {
                        self.allScreeningIDsString = [NSString stringWithFormat:@"%ld",(long)model.ID] ;
                    } else {
                        self.allScreeningIDsString = [NSString stringWithFormat:@"%@|%ld",self.allScreeningIDsString,(long)model.ID] ;
                    }
                }
                
                
            }
        }
        
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey];
        
        
        [self.collectionView reloadData];
        
        //        [self.selectMutDic removeAllObjects] ;
//        [self delegateSelectNameMutDic];
    }
}
- (void)tongzhi2:(NSNotification *)notification{
    
    if ([notification.userInfo[@"selectIndex"] isEqualToString:@"2"]) {
        //        isUnselectAll = YES ;
        
        if (self.dataArray.count > 0) {
            for (int i = 0; i< self.dataArray.count; i ++) {
                    MXFilterModel * model = self.dataArray[i] ;
                    model.isSelect = 1 ;
                    [self.dataArray replaceObjectAtIndex:i withObject:model];
                
            }
        }
        
//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        self.allScreeningIDsString = @"" ;
//        [defaults setValue:@"" forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey];
        
        
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _customLayout = [[UICollectionViewFlowLayout alloc]init] ;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - scaleWithSize(114) - 44 - TABBAR_FRAME - STATUS_HEIGHT) collectionViewLayout:_customLayout] ;
        _collectionView.backgroundColor = mx_Wode_backgroundColor ;
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
//        _collectionView.allowsMultipleSelection = YES ;
        
        [_collectionView registerClass:[MXScreeningCollectionViewCell class] forCellWithReuseIdentifier:cellId] ;
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId] ;
        
//        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self getNetworkData] ;
//        }] ;
    }
    return _collectionView ;
}


#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray.count > 0) {
        return [self.dataArray count] ;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXScreeningCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath] ;
    
    cell.layer.cornerRadius = 5 ;
    cell.layer.masksToBounds = YES ;
    cell.backgroundColor = mx_Wode_colorBlue2374e4 ;
    cell.nameLabel.textColor = [UIColor whiteColor] ;
    cell.numberLabel.textColor = [UIColor whiteColor] ;
    
    if (self.dataArray.count > 0) {
        
        MXFilterModel * model = self.dataArray[indexPath.row] ;
        
        cell.model = model ;
        
        if (model.isSelect == 1) {
            cell.backgroundColor = [UIColor whiteColor] ;
            cell.nameLabel.textColor = [UIColor darkGrayColor] ;
            cell.numberLabel.textColor = [UIColor darkGrayColor] ;
        }
        
    }
    
    
    
    
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
        
        MXFilterModel * model = self.dataArray[indexPath.row] ;
//
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
        
//        [defaults setValue:self.allScreeningIDsString forKey:@"AllScreeningKey1"] ;
//        [defaults synchronize];
        [self setAllScreeningKey];
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
    }
    
    
    [self.collectionView reloadData] ;
    
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
//    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = mx_Wode_colorBlue2374e4 ;
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
