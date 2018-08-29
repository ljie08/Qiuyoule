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

#import "MXDAdvertsModel.h" //广告
#import "MXADTableViewCell.h"

#import "MXBattleDetailsViewController.h"//对战详情

#import "MXSYJWebViewController.h"//广告


@interface MXImmediateViewController ()<UITableViewDelegate,UITableViewDataSource>
//{
//    BOOL isRefresh ;
//}

@property (nonatomic , strong) UITableView * eventTableview ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@property (nonatomic , assign) NSInteger page ;

@property (nonatomic , assign) UIButton * upDataButton ;

@property (nonatomic , assign) BOOL isRefresh ; //登录后刷新

//广告
@property (nonatomic , strong) NSString * imgURL ;
@property (nonatomic , strong) NSString * webURL ;

@property (nonatomic , strong) NSMutableArray * advertsArray ;

@end

@implementation MXImmediateViewController


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
        
//        _eventTableview.tableFooterView =  ;
        
//        [_eventTableview registerNib:[UINib nibWithNibName:@"MXEventTableViewCell" bundle:nil] forCellReuseIdentifier:@"EventTableViewCell"];
        
        [_eventTableview registerClass:[MXDEventTableVCell class] forCellReuseIdentifier:@"MXDEventTableVCell"] ;
        
        [_eventTableview registerClass:[MXADTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MXADTableViewCell class])] ;
        
        _eventTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero] ;
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
    
    if (_status == 8) {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"完场赛事界面\"}"] ;
    } else {
        
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"即时赛事界面\"}"] ;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    
    if (_status == 8) {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"完场赛事界面\"}"] ;
    } else {
        
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"即时赛事界面\"}"] ;
    }
}

- (void)refreshingData {
//    [self.dataArray removeAllObjects] ;

    [self.eventTableview.mj_header beginRefreshing] ;
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isRefresh = 0 ;
    
    [self.view addSubview:self.eventTableview];
    
    mx_weakify(self) ;
    if (self.dataArray.count == 0) {
        self.upDataButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.eventTableview] ;
    }
    self.updataBlock = ^{

        [weakSelf.eventTableview.mj_header beginRefreshing] ;
    } ;
    

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
                    
                    MXDEventModel * model = self.dataArray[indexPath.row] ;
                    model.isCollect = [optType intValue] ;
                    [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
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
                    MXDEventModel * model = self.dataArray[indexPath.row] ;
                    model.isCollect =  i;
                    [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
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
                MXDEventModel * model = self.dataArray[indexPath.row] ;
                model.isCollect =  i;
                [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
                [weakSelf.eventTableview reloadData];
                
                
            });
        }] ;
        
        
    } else {
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
//        login.isPageNumber = 1;
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        self.isRefresh = 1 ;
        [self presentViewController:nav animated:YES completion:^{
            
                MXDEventModel * model = self.dataArray[indexPath.row] ;
                model.isCollect =  0;
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
                [self.eventTableview reloadData];
            
        }] ;

//        [SVProgressHUD showErrorWithStatus:@"请先登入"];
    }
}

#pragma mark - getNetworkData
- (void)getNetworkData {
    
    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
//    if (userModel.userId) {
    
//        isRefresh = YES ;
    
        NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
        NSString *token = userModel.token;
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
        
    
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userModel.userId) {
        [parameters setObject:userId forKey:@"userId"] ;
        [parameters setObject:token forKey:@"token"] ;
    }
        [parameters setObject:timeStr forKey:@"time"];
        
//        [parameters setObject:@"0/0.5|0.5/1|1" forKey:@"dishStr"];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * companyId = @"1";
    if ([defaults valueForKey:@"CompanyIdKey"]!=nil) {
        companyId = [defaults objectForKey:@"CompanyIdKey"];
        [parameters setObject:companyId forKey:@"companyId"];
    }
    
//        [parameters setObject:@"220|144" forKey:@"eventIdStr"];
        [parameters setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
        [parameters setObject:@"10" forKey:@"limit"];
    
    
    if ([defaults valueForKey:@"AllAsianPlateKey"] != nil) {
        [parameters setObject:[defaults valueForKey:@"AllAsianPlateKey"] forKey:@"dishStr"];
    }
    if ([defaults valueForKey:@"AllScreeningKey"] != nil) {
        [parameters setObject:[defaults valueForKey:@"AllScreeningKey"] forKey:@"eventIdStr"];
    }
    
    
        NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, ((self.status == 8) ? MXEventFindAfterGamePATH : MXEventInstantPATH)];
        
        [SVProgressHUD showWithStatus:@"正在加载..."];
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            
//            [weakSelf.eventTableview.mj_header endRefreshing] ;
//            [weakSelf.eventTableview.mj_footer endRefreshing] ;
            if ([dic[@"code"] isEqualToString:@"0"]) {
//                NSLog(@"赛事🚗==%@",dic[@"data"]);
//                self.webURL = @"cvbjnop" ;
                if ([dic[@"data"][@"matches"] count]) {
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
                    weakSelf.removeUpdataBlock();
                } else {
                    if (weakSelf.page == 1) {
                        [self.dataArray removeAllObjects];
                    }
                    if (weakSelf.page > 1) {
                        weakSelf.page -- ;
                    }
                    
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    if (self.dataArray.count == 0) {
                        [weakSelf.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
                        [weakSelf.view addSubview:weakSelf.upDataButton];
                    }
                    
                }
                
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.eventTableview reloadData];
                    [self endRefreshing] ;
                    
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
                [self endRefreshing] ;
            }
            
        } WithFailureBlock:^(NSError *error) {
            if (weakSelf.page > 1) {
                weakSelf.page -- ;
            }
            if (self.dataArray.count == 0) {
                [weakSelf.upDataButton setTitle:@"请求错误" forState:(UIControlStateNormal)] ;
                [weakSelf.view addSubview:weakSelf.upDataButton];
            }
            [SVProgressHUD showErrorWithStatus:@"请求错误"];
//            [weakSelf.eventTableview.mj_header endRefreshing] ;
//            [weakSelf.eventTableview.mj_footer endRefreshing] ;
            [self endRefreshing] ;
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
    if (self.dataArray.count) {
        weakSelf.eventTableview.mj_footer.hidden = NO ;
    } else {
        weakSelf.eventTableview.mj_footer.hidden = YES ;
    }
    
    [weakSelf.eventTableview.mj_header endRefreshing] ;
    [weakSelf.eventTableview.mj_footer endRefreshing] ;
    
}



#pragma mark mainTableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.numDataArr.count;
//    if (self.advertsArray.count) {
//        MXDAdvertsModel *adModel = self.advertsArray[0] ;
//        if (adModel.targetUrl) {
//            return self.dataArray.count + self.advertsArray.count ;
//        }
//    }
    return self.dataArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (self.advertsArray.count) {
//        MXDAdvertsModel *adModel = self.advertsArray[0] ;
//        if (adModel.targetUrl&&(indexPath.row%11== 0||indexPath.row == self.dataArray.count)) {
//            return screen_width * 5 / 32 ;
//        }
//    }
    
    if (self.dataArray.count >= indexPath.row) {
        
        MXDEventModel * model = self.dataArray[indexPath.row] ;
        if (model.targetUrl) {
            return screen_width * 5 / 32 ;
        }
    }

    
//    if (model.odds) {
//        return scaleWithSize(143) ;
//    }
    return scaleWithSize(98);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    //            cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = 0;//禁止选中
    cell.backgroundColor = [UIColor whiteColor];
    
//    MXDEventModel * model = self.dataArray[indexPath.row] ;
    
    cell.eventModel = model ;
    
//    cell.selctButton.hidden = NO ;
    
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
    
    MXDEventModel * model = self.dataArray[indexPath.row] ;
    if (model.targetUrl) {
        
        MXSYJWebViewController * webVC = [[MXSYJWebViewController alloc]init] ;
        webVC.url = model.targetUrl ;
//        NSLog(@"广告") ;
        [self.navigationController pushViewController:webVC animated:YES] ;
        return ;
    }
    
    MXBattleDetailsViewController *battleDetails = [[MXBattleDetailsViewController alloc]init];
    
    battleDetails.matchId = model.matchId ;
    battleDetails.titleString = model.event.shortNameZh ;
//    battleDetails.childViewControllers
    
    battleDetails.homeNm = model.homeTeam.nameZh ;
    battleDetails.homeScore = [NSString stringWithFormat:@"%@",model.homeTeamData[2]] ;
    battleDetails.homeLogo = model.homeTeam.logo ;

    battleDetails.awayNm = model.visitingTeam.nameZh ;
    battleDetails.awayScore = [NSString stringWithFormat:@"%@",model.visitingTeamData[2]] ;
    battleDetails.awayLogo = model.visitingTeam.logo ;

    battleDetails.status = model.matchStatus ;
    battleDetails.matchStartTime = model.TeeTime ;
    battleDetails.flashFlg = model.flashFlg ;
    
//    battleDetails.selectIndex = 0 ;
    
    
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
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screen_width - 10 , scaleWithSize(30))];
//    label.text = @"2018/05/23 周五";
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
//    paragraphStyle.headIndent = scaleWithSize(15) ;
    paragraphStyle.firstLineHeadIndent = scaleWithSize(15) ;
    
    NSAttributedString * attrStr = [[NSAttributedString alloc]initWithString:@"2018/05/23 周五" attributes:@{
            NSFontAttributeName:[UIFont systemFontOfSize:scaleWithSize(15)],
            NSParagraphStyleAttributeName:paragraphStyle,}];
    
    label.attributedText = attrStr;
    return label;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return scaleWithSize(30);
    }
    
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
