//
//  MXOddsCompanyViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOddsCompanyViewController.h"

#import "MXOddsCpyModel.h"

#import "MXDOddsCompanyCollectionViewCell.h"


@interface MXOddsCompanyViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic , strong) UITableView * mainTableView ;

@property (nonatomic , strong) NSMutableArray * companyNameArray ;


@property (nonatomic ,strong) UICollectionViewFlowLayout * customLayout ;

@property (nonatomic ,strong) UICollectionView * collectionView ;

@end

@implementation MXOddsCompanyViewController

- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - (STATUS_AND_NAVIGATION_HEIGHT) - TABBAR_FRAME) style:(UITableViewStylePlain)];
        _mainTableView.delegate = self ;
        _mainTableView.dataSource = self ;
        
        _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero] ;
        
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getNetworkData] ;
        }] ;
        
    }
    return _mainTableView ;
}
- (NSMutableArray *)companyNameArray {
    if (!_companyNameArray) {
        _companyNameArray = [NSMutableArray array] ;
        
//        [NSMutableArray arrayWithObjects:
//                             @"ManbetX",@"BET365",@"SB",@"10BET",@"立博",
//                             @"明陞",@"澳彩",@"SNAI",@"威廉",@"易胜博",
//                             @"韦德",@"EuroBet",@"Inter wetten",@"12bet",@"利记",
//                             @"盈禾",@"18Bet",@"Fun88",@"竞彩官方", nil];
    }
    return _companyNameArray ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO ;
    self.view.backgroundColor = mx_Wode_backgroundColor ;
    self.title = @"赔率公司" ;
    
//    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.collectionView] ;
    
    [self getNetworkData] ;
}
//赔率公司界面
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"赔率公司界面\"}"] ;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"赔率公司界面\"}"] ;
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _customLayout = [[UICollectionViewFlowLayout alloc]init] ;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - scaleWithSize(60) - TABBAR_FRAME) collectionViewLayout:_customLayout] ;
        _collectionView.backgroundColor = mx_Wode_backgroundColor ;
        _collectionView.delegate = self ;
        _collectionView.dataSource = self ;
        //        _collectionView.allowsMultipleSelection = YES ;
        
        [_collectionView registerClass:[MXDOddsCompanyCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([MXDOddsCompanyCollectionViewCell class])] ;
        
        mx_weakify(self) ;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getNetworkData] ;
        }] ;
        
    }
    return _collectionView ;
}


#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.companyNameArray.count ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXDOddsCompanyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MXDOddsCompanyCollectionViewCell class]) forIndexPath:indexPath] ;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults objectForKey:@"CompanyIdKey"] ;
    int i = 0 ;
    if ([defaults objectForKey:@"CompanyIdKey"]) {
        i = [[defaults objectForKey:@"CompanyIdKey"] intValue] - 1 ;
    }
    if (indexPath.row == i) {
        cell.titleNameLabel.backgroundColor = mx_redColor ;
        cell.titleNameLabel.textColor = [UIColor whiteColor] ;
    } else {
        cell.titleNameLabel.backgroundColor = [UIColor whiteColor] ;
        cell.titleNameLabel.textColor = [UIColor blackColor] ;
    }
    
    MXOddsCpyModel * model = [[MXOddsCpyModel alloc] init] ;
    model = self.companyNameArray[indexPath.row] ;
    
    cell.titleNameLabel.text =  model.companyNm ;
    
    return cell  ;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(scaleWithSize(100), scaleWithSize(32)) ;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(scaleWithSize(15), scaleWithSize(15), 0, scaleWithSize(15)) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return scaleWithSize(15) ;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return scaleWithSize(7) ;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MXOddsCpyModel * model = [[MXOddsCpyModel alloc] init] ;
    model = self.companyNameArray[indexPath.row] ;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%ld",(long)model.companyId] forKey:@"CompanyIdKey"];
    [defaults synchronize];
    
    //创建通知
    NSNotification * notification =[NSNotification notificationWithName:@"selectOddsCompanyCell" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES] ;
}
    


#pragma mark - network
- (void)getNetworkData {
    
//    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
//    if (userModel.userId) {
    
//        NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
//        NSString *token = userModel.token;
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        [parameters setObject:userId forKey:@"userId"];
//        [parameters setObject:token forKey:@"token"];
        [parameters setObject:timeStr forKey:@"time"];
        NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventFindAllLottCpyPATH];
        
        [SVProgressHUD showWithStatus:@"正在加载..."];
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
//            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_header endRefreshing] ;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                
                
//                NSLog(@"%@",dic[@"data"]) ;
//                if (weakSelf.companyNameArray.count == 0) {
//
//                }
                if ([dic[@"data"] count]) {
                    weakSelf.companyNameArray = [MXOddsCpyModel mj_objectArrayWithKeyValuesArray:dic[@"data"]] ;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                }
                
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
//                    [weakSelf.mainTableView reloadData];
                    [weakSelf.collectionView reloadData] ;
                });
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            }
            
        } WithFailureBlock:^(NSError *error) {
//            [weakSelf.mainTableView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_header endRefreshing] ;
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }] ;
        
        
//    } else {
//
//    }
    
    
}



#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.companyNameArray.count ;
    }
    return 12 ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[NSString stringWithFormat:@"%ld",(long)model.companyId] forKey:@"CompanyIdKey"];
    [defaults objectForKey:@"CompanyIdKey"] ;
    int i = 0 ;
    if ([defaults objectForKey:@"CompanyIdKey"]) {
        i = [[defaults objectForKey:@"CompanyIdKey"] intValue] - 1 ;
    }
    
    if (indexPath.row == i) {
//        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scaleWithSize(10), scaleWithSize(10))] ;
//        imgView.image = Image(@"saishi_zhibo_hongpai") ;
//        imgView.center = CGPointMake(screen_width - scaleWithSize(15 + 10), cell.center.y) ;
//
//        [cell addSubview:imgView] ;
    }
    
    cell.selectionStyle = 0 ;
    
    MXOddsCpyModel * model = [[MXOddsCpyModel alloc] init] ;
    model = self.companyNameArray[indexPath.row] ;
    
    cell.textLabel.text =  model.companyNm ;
    
    return cell ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MXOddsCpyModel * model = [[MXOddsCpyModel alloc] init] ;
    model = self.companyNameArray[indexPath.row] ;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%ld",(long)model.companyId] forKey:@"CompanyIdKey"];
    [defaults synchronize];
    
    //创建通知
    NSNotification * notification =[NSNotification notificationWithName:@"selectOddsCompanyCell" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES] ;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
////    return scaleWithSize(30) ;
//    return 0 ;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(30))] ;
//    
//    UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(30))];
//    
//    if (section == 0) {
//        headerLabel.text = @"默认(6家)";
//    } else {
//        headerLabel.text = @"包月专享(12家)";
//    }
//    [headerView addSubview:headerLabel];
//    
//    
////    return headerView ;
//    return nil ;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil ;
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
