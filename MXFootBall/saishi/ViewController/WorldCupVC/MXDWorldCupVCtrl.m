//
//  MXDWorldCupVCtrl.m
//  MXFootBall
//
//  Created by dai on 2018/5/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXDWorldCupVCtrl.h"

#import "MXDEventTableVCell.h"

#import "MXDEntranceCollectionViewCell.h"

#import "MXWorldCupViewController.h"//世界杯

@interface MXDWorldCupVCtrl ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) NSArray * imgNameArray ;
@property (nonatomic , strong) NSArray * titleArray ;

@property (nonatomic , strong) UITableView * mainTableView ;

@property (nonatomic ,strong) UICollectionViewFlowLayout * customLayout ;
@property (nonatomic ,strong) UICollectionView * collectionView ;

@end

@implementation MXDWorldCupVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imgNameArray = @[@"shijiebei_saicheng",
                          @"shijiebei_jifenbang",
                          @"shijiebei_dacaixiang",
                          @"shijiebei_luntan"] ;
    self.titleArray = @[@"赛程",@"积分榜",@"大猜想",@"论坛"] ;
    
    [self.view addSubview:self.mainTableView] ;
    
}

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - (STATUS_AND_NAVIGATION_HEIGHT) - TABBAR_HEIGHT - 44) style:(UITableViewStylePlain)];
        _mainTableView.delegate = self ;
        _mainTableView.dataSource = self ;
        _mainTableView.backgroundColor = mx_Wode_backgroundColor ;
        
        [_mainTableView registerClass:[MXDEventTableVCell class] forCellReuseIdentifier:@"MXDEventTableVCell"] ;
        
//        [_mainTableView registerClass:[MXADTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MXADTableViewCell class])] ;
        
        _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero] ;
        _mainTableView.tableHeaderView = [self createTableViewHeaderView] ;
        
        
//        mx_weakify(self) ;
//        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////            weakSelf.page = 1 ;
////            [weakSelf getNetworkData] ;
//        }] ;
//
//        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
////            weakSelf.page ++  ;
////            [weakSelf getNetworkData] ;
//        }] ;
    }
    return _mainTableView ;
    
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
    return scaleWithSize(39) ;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[MXWorldCupViewController new] animated:YES] ;
    } if (indexPath.row == 1) {
        
    } if (indexPath.row == 2) {
        
    } else {
        
    }
    
    
}

#pragma mark - createTableViewHeaderView
- (UIView *)createTableViewHeaderView {
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(98))];
    view.backgroundColor = [UIColor whiteColor];
    
    [view addSubview:self.collectionView] ;
    
    return view ;
}


#pragma mark - TableView delegate/dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return scaleWithSize(98) ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MXDEventTableVCell";//cell复用
    MXDEventTableVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXDEventTableVCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //            cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = 0;//禁止选中
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
