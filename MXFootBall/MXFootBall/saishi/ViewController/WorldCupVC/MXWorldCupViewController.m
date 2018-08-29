//
//  MXWorldCupViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXWorldCupViewController.h"

#import "MXWorldCupModel.h"
#import "MXWorldCupTableViewCell.h"

#import "MXBattleDetailsViewController.h"


@interface MXWorldCupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong ) UITableView * worldCupTableView ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@end

@implementation MXWorldCupViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}

- (UITableView *)worldCupTableView {
    
    if (! _worldCupTableView) {
//        - TABBAR_HEIGHT - 44   TABBAR_FRAME
        _worldCupTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - (STATUS_AND_NAVIGATION_HEIGHT) - TABBAR_FRAME) style:(UITableViewStyleGrouped)] ;
        _worldCupTableView.delegate = self ;
        _worldCupTableView.dataSource = self ;
        _worldCupTableView.backgroundColor = mx_Wode_backgroundColor ;
        
        [_worldCupTableView registerNib:[UINib nibWithNibName:@"MXWorldCupTableViewCell" bundle:nil] forCellReuseIdentifier:@"WorldCupTableViewCell"];
        
        
        /**
         *  将tableview的分割线补满
         */
        if ([_worldCupTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_worldCupTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_worldCupTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_worldCupTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        _worldCupTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           
            [self getNetworkData] ;
        }];
        
    }
    return _worldCupTableView ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"赛程" ;
    [self.view addSubview:self.worldCupTableView];
    
    
    mx_weakify(self) ;
    if (self.dataArray.count == 0) {
        self.refreshButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.worldCupTableView] ;
    }
    self.updataBlock = ^{
        
        [weakSelf.worldCupTableView.mj_header beginRefreshing] ;
    } ;
    
    [self getNetworkData] ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"世界杯界面\"}"] ;
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"世界杯界面\"}"];
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
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventFindWorldCupPATH];
        
        [SVProgressHUD showWithStatus:@"正在加载..."];
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            [weakSelf.worldCupTableView.mj_header endRefreshing] ;
            
//            NSLog(@"世界杯 %@",dic) ;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                
                if ([dic[@"data"] count]) {
                    for (NSArray * array in dic[@"data"]) {
                        NSMutableArray * mutableArr = [MXWorldCupModel mj_objectArrayWithKeyValuesArray:array] ;
                        [weakSelf.dataArray addObject:mutableArr] ;
                    }
                    weakSelf.removeUpdataBlock() ;
                } else {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    if (weakSelf.dataArray.count == 0) {
                        [weakSelf.refreshButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
                        [weakSelf.view addSubview:weakSelf.refreshButton];
                    }
                }
                
//                weakSelf.dataArray = [MXWorldCupModel mj_objectArrayWithKeyValuesArray:dic[@"data"]] ;
//                weakSelf.dataArray = [weakSelf arraySorting:weakSelf.dataArray];
//                NSLog(@"%@",weakSelf.dataArray[0]) ;
//                NSLog(@"%@",weakSelf.dataArray) ;
               
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.worldCupTableView reloadData];
                });
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                if (self.dataArray.count == 0) {
                    [weakSelf.refreshButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
                    [weakSelf.view addSubview:weakSelf.refreshButton];
                }
            }
            
        } WithFailureBlock:^(NSError *error) {
            [weakSelf.worldCupTableView.mj_header endRefreshing] ;
            if (weakSelf.dataArray.count == 0) {
                [weakSelf.refreshButton setTitle:@"网络错误" forState:(UIControlStateNormal)] ;
                [weakSelf.view addSubview:weakSelf.refreshButton];
            }
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }] ;
        
        
//    } else {
//
//    }
    
    
}

- (NSMutableArray *)arraySorting:(NSMutableArray *) mutableArray {
    
    NSMutableArray * filterArray = [NSMutableArray array];
    
    for (int i = 'A'; i <= 'Z'; i++) {
        NSMutableArray * arr = [NSMutableArray array] ;
        [filterArray addObject:arr];
        
    }
    
    for (MXWorldCupModel * filterModel in mutableArray) {
        
        //        [filterModel.initials getFirstLetter] ;
        int i = [filterModel.groupType  characterAtIndex:0] - 'A' ;
        if ( 0 < i < filterArray.count ) {
            [filterArray[i] addObject:filterModel] ;
        }
    }
    
    for (int i = filterArray.count - 1; i >= 0; i --) {
        
        if ([filterArray[i] count] == 0) {
            
            [filterArray removeObjectAtIndex:i];
        }
        
    }
    
    return filterArray ;
}




#pragma mark mainTableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
//    if (self.dataArray.count > 0) {
        return self.dataArray.count ;
//    }
//    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count > 0) {
        return [self.dataArray[section] count] ;
    }
    return 0 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return scaleWithSize(44);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"WorldCupTableViewCell";//cell复用
    MXWorldCupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXWorldCupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
    cell.backgroundColor = kColorWithRGBF(0x564242);
    
    if (self.dataArray.count > 0) {
        
        cell.worldCupModel = self.dataArray[indexPath.section][indexPath.row] ;
    }
    
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return scaleWithSize(30);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(30))];
    headerView.backgroundColor = kColorWithRGBF(0x453535) ;
    
    UILabel * sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, 50, scaleWithSize(30))];
//    sectionLabel.text = @"A组" ;
    sectionLabel.textColor = [UIColor whiteColor] ;
    sectionLabel.font = fontSize(scaleWithSize(11)) ;
    [headerView addSubview:sectionLabel];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 200 - scaleWithSize(15), 0, 200, scaleWithSize(30))];
    nameLabel.textAlignment = 2 ;
//    nameLabel.text = @"xxx观点" ;
    nameLabel.textColor = [UIColor whiteColor] ;
    nameLabel.font = fontSize(scaleWithSize(11)) ;
    [headerView addSubview:nameLabel];
    
    if (self.dataArray.count > 0) {
        MXWorldCupModel * model = self.dataArray[section][0] ;
        
        sectionLabel.text = [NSString stringWithFormat:@"%@",model.groupType] ;
    }
    
    
    return headerView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MXWorldCupModel * model = self.dataArray[indexPath.section][indexPath.row] ;
    
    MXBattleDetailsViewController * battleDetails = [[MXBattleDetailsViewController alloc]init];
//    battleDetails.selectIndex = 0 ;
    battleDetails.matchId = model.matchId ;
    battleDetails.titleString = @"世界杯" ;
    
    battleDetails.homeNm = model.homeTeam ;
    battleDetails.homeLogo = model.homeLogo ;
    battleDetails.awayNm = model.awayTeam ;
    battleDetails.awayLogo = model.awayLogo ;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init] ;
//    NSTimeZone * tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"] ;
//    [dateFormatter setTimeZone:tz] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"] ;
    NSDate * date = [dateFormatter dateFromString:model.matchTime] ;
    
    battleDetails.matchStartTime = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]] ;
    
    
//    battleDetails.homeScore = model.homeScore ;
//    battleDetails.awayScore = model.awayScore ;
//    battleDetails.status = model.matchStatus ;
//    battleDetails.flashFlg = model.flashFlg ;
    
    
    [self.navigationController pushViewController:battleDetails animated:YES];
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
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
