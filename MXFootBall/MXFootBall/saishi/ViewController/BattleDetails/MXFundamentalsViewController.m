//
//  MXFundamentalsViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXFundamentalsViewController.h"

#import "MXTeamTitleTableViewCell.h"
#import "MXLeagueTitleTableViewCell.h"

#import "MXEventBasicPanelModel.h"
#import "MXBattleModel.h"

@interface MXFundamentalsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * situationTableView ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@property (nonatomic , strong) MXEventBasicPanelModel * basicPanelModel ;

@property (nonatomic , strong) MXBattleModel * battleModel ;


@property (nonatomic , strong) UIButton * upDataButton ;

@end

@implementation MXFundamentalsViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}

- (UITableView *)situationTableView {
    
    if ( ! _situationTableView ) {
        
        _situationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - (STATUS_AND_NAVIGATION_HEIGHT)  - scaleWithSize(110 + 44) - TABBAR_FRAME) style:(UITableViewStyleGrouped)];
        _situationTableView.delegate = self;
        _situationTableView.dataSource = self;
        _situationTableView.backgroundColor = mx_Wode_backgroundColor;
        
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(10))];
//        view.backgroundColor = [UIColor redColor];
//
//        _situationTableView.tableHeaderView = view ;
        
        [_situationTableView registerClass:[MXTeamTitleTableViewCell class] forCellReuseIdentifier:@"TeamTitleTableViewCell"];
        [_situationTableView registerClass:[MXLeagueTitleTableViewCell class] forCellReuseIdentifier:@"LeagueTitleTableViewCell"];
        
        /**
         *  将tableview的分割线补满
         */
        if ([_situationTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_situationTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_situationTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_situationTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        _situationTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self getNetworkData] ;
        }] ;
        
        
    }
    
    return _situationTableView ;
}

- (void)viewWillAppear:(BOOL)animated {
    if (!self.dataArray.count) {
        [self.situationTableView.mj_header beginRefreshing];
    }
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"基本面界面\"}"] ;
}
//基本面界面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"基本面界面\"}"] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.situationTableView];
    
    mx_weakify(self) ;
    if (self.dataArray.count == 0) {
        self.upDataButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.situationTableView] ;
    }
    self.updataBlock = ^{
        //        [weakSelf getNetworkData] ;
        [weakSelf.situationTableView.mj_header beginRefreshing] ;
    } ;
    
}

#pragma mark - network
- (void)getNetworkData {
    
//    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
//    if (userModel.userId) {
    
//        NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
//        NSString *token = userModel.token;
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
        
        NSString * matchID = [NSString stringWithFormat:@"%ld",(long)_matchId] ;
    
//    NSString * matchID = @"2215827" ;
    
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//        [parameters setObject:userId forKey:@"userId"];
//        [parameters setObject:token forKey:@"token"];
        [parameters setObject:matchID forKey:@"matchId"] ;
        [parameters setObject:timeStr forKey:@"time"];
        NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventBasicPanelPATH];
        
        [SVProgressHUD showWithStatus:@"正在加载..."];
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            [weakSelf.situationTableView.mj_header endRefreshing] ;
            
            if ([dic[@"code"] isEqualToString:@"0"]) {
                
//                NSLog(@" --- %@",dic[@"data"]) ;
                weakSelf.basicPanelModel = [MXEventBasicPanelModel mj_objectWithKeyValues:dic[@"data"]] ;
                
//                NSLog(@"%@",weakSelf.basicPanelModel) ;
                if (!weakSelf.basicPanelModel.matchId) {
                    [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                    [weakSelf.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
                    [weakSelf.situationTableView addSubview:weakSelf.upDataButton];
                } else {
                    weakSelf.removeUpdataBlock() ;
                    weakSelf.dataRefreshing(weakSelf.basicPanelModel) ;
                }
                
                
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.situationTableView reloadData];
                });
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                if (!weakSelf.basicPanelModel.matchId) {
                    
                    [weakSelf.upDataButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
                    [weakSelf.situationTableView addSubview:weakSelf.upDataButton];
                }
            }
            
        } WithFailureBlock:^(NSError *error) {
            [weakSelf.situationTableView.mj_header endRefreshing] ;
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            if (!weakSelf.basicPanelModel.matchId) {
                [weakSelf.upDataButton setTitle:@"网络错误" forState:(UIControlStateNormal)] ;
                [weakSelf.situationTableView addSubview:self.upDataButton];
            }
        }] ;
        
        
//    } else {
//
//    }

    
}



#pragma mark TableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.basicPanelModel.matchId) {
        return 4 ;
    }
    return 0 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.basicPanelModel.matchId) {
        switch (section) {
            case 0:
                if (self.basicPanelModel.score.count) {
                    return self.basicPanelModel.score.count + 1 ;
                }
                break;
            case 1:
                if (self.basicPanelModel.vs.battle.count) {
                    return self.basicPanelModel.vs.battle.count +1 ;
                }
                break;
            case 2:
                if (self.basicPanelModel.homeVs.battle.count) {
                    return self.basicPanelModel.homeVs.battle.count + 1 ;
                }
                break;
            case 3:
                if (self.basicPanelModel.awayVs.battle.count) {
                    return self.basicPanelModel.awayVs.battle.count  + 1 ;
                }
                break;
                
            default:
                break;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return scaleWithSize(30);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"TeamTitleTableViewCell";//cell重用问题
        MXTeamTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell) {
            cell = [[MXTeamTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row == 0) {
            
            cell.rankLabel.textColor = kColorWithRGBF(0xb2b2b2);
            cell.teamLabel.textColor = kColorWithRGBF(0xb2b2b2);
            cell.winFlatNegativeLabel.textColor = kColorWithRGBF(0xb2b2b2);
            cell.inOutLabel.textColor = kColorWithRGBF(0xb2b2b2);
            cell.integralLabel.textColor = kColorWithRGBF(0xb2b2b2);
            
        } else {
            cell.rankLabel.textColor = kColorWithRGBF(0x000000);
            cell.teamLabel.textColor = kColorWithRGBF(0x000000);
            cell.winFlatNegativeLabel.textColor = kColorWithRGBF(0x000000);
            cell.inOutLabel.textColor = kColorWithRGBF(0x000000);
            cell.integralLabel.textColor = kColorWithRGBF(0x000000);
            
//            cell.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//            cell.teamLabel.text = @"亚特兰";
//            cell.winFlatNegativeLabel.text = @"0/0/0";
//            cell.inOutLabel.text = @"0/0";
//            cell.integralLabel.text = @"0";
            cell.scoreModel = self.basicPanelModel.score[indexPath.row - 1] ;
        }
        
        cell.selectionStyle = 0 ;
        return cell;
    }
    
    static NSString *CellIdentifier1 = @"LeagueTitleTableViewCell";//cell重用问题
    MXLeagueTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXLeagueTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
    }
    
    if (indexPath.row == 0) {
        cell.resultsLabel.hidden = NO;
        cell.resultsContentLabel.hidden = YES;
        cell.homeNameLabel.hidden = YES ;
        cell.awayNameLabel.hidden = YES ;
        cell.timeLabel.text = @"时间";
        cell.leagueLabel.text = @"联赛";
        cell.gameLabel.text = @"比赛";
        
        cell.resultsLabel.textColor = kColorWithRGBF(0xb2b2b2);
        cell.timeLabel.textColor = kColorWithRGBF(0xb2b2b2);
        cell.leagueLabel.textColor = kColorWithRGBF(0xb2b2b2);
        cell.gameLabel.textColor = kColorWithRGBF(0xb2b2b2);
        
    } else {
        cell.resultsLabel.hidden = YES;
        cell.resultsContentLabel.hidden = NO;
        cell.homeNameLabel.hidden = NO ;
        cell.awayNameLabel.hidden = NO ;
        
        cell.timeLabel.textColor = kColorWithRGBF(0x000000);
        cell.leagueLabel.textColor = kColorWithRGBF(0x000000);
        cell.gameLabel.textColor = kColorWithRGBF(0x000000);
        
        if (self.basicPanelModel.matchId) {
            switch (indexPath.section) {
                case 1:
                    self.battleModel = self.basicPanelModel.vs.battle[indexPath.row - 1];
                    break;
                case 2:
                    self.battleModel = self.basicPanelModel.homeVs.battle[indexPath.row - 1] ;
                    break;
                case 3:
                    self.battleModel = self.basicPanelModel.awayVs.battle[indexPath.row - 1] ;
                    break;
                    
                default:
                    break;
            }
 
            cell.battleModel = self.battleModel ;
            
        }
        
    }
    
    cell.selectionStyle = 0 ;
    return cell;
    
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.basicPanelModel.matchId) {
        switch (section) {
            case 0:
                if (!self.basicPanelModel.score.count) {
                    return scaleWithSize(50) ;
                }
                break;
            case 1:
                if (!self.basicPanelModel.vs.battle.count) {
                    return  scaleWithSize(50);
                }
                break;
            case 2:
                if (!self.basicPanelModel.homeVs.battle.count) {
                    return scaleWithSize(50) ;
                }
                break;
            case 3:
                if (!self.basicPanelModel.awayVs.battle.count) {
                    return scaleWithSize(50) ;
                }
                break;
                
            default:
                break;
        }
    }
    
    return scaleWithSize(30);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return scaleWithSize(40);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(30))];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(screen_width/2, 0, screen_width/2 - scaleWithSize(15), scaleWithSize(30));
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn setTitle:@"完整积分榜" forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    
    [view addSubview:btn];
    
    if (!self.basicPanelModel.score.count||
        !self.basicPanelModel.vs.battle.count||
        !self.basicPanelModel.homeVs.battle.count||
        !self.basicPanelModel.awayVs.battle.count) {
        
        [btn setTitle:@"暂无数据" forState:(UIControlStateNormal)];
        btn.center = CGPointMake(screen_width/2, scaleWithSize(25)) ;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    
    
    if (self.basicPanelModel.matchId) {
        switch (section) {
            case 0:
                if (self.basicPanelModel.score.count) {
                    btn.frame = CGRectMake(screen_width/2, 0, screen_width/2 - scaleWithSize(15), scaleWithSize(30));
                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    [btn setTitle:@"完整积分榜" forState:(UIControlStateNormal)];
                    return  view;
                }
                break;
            case 1:
                if (self.basicPanelModel.vs.battle.count) {
                    btn.frame = CGRectMake(screen_width/2, 0, screen_width/2 - scaleWithSize(15), scaleWithSize(30));
                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    [btn setTitle:@"完整积分榜" forState:(UIControlStateNormal)];
                    return  view;
                }
                break;
            case 2:
                if (self.basicPanelModel.homeVs.battle.count) {
                    btn.frame = CGRectMake(screen_width/2, 0, screen_width/2 - scaleWithSize(15), scaleWithSize(30));
                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    [btn setTitle:@"完整积分榜" forState:(UIControlStateNormal)];
                    return view ;
                }
                break;
            case 3:
                if (self.basicPanelModel.awayVs.battle.count) {btn.frame = CGRectMake(screen_width/2, 0, screen_width/2 - scaleWithSize(15), scaleWithSize(30));
                    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    [btn setTitle:@"完整积分榜" forState:(UIControlStateNormal)];
                    
                    return view ;
                }
                break;
                
            default:
                break;
        }
    }
    
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(30))] ;
    headView.backgroundColor = Color(250, 250, 250, 1);
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screen_width, scaleWithSize(30))];
    view.backgroundColor = Color(242, 242, 242, 1);
    [headView addSubview:view] ;
    
    UILabel * titleLable = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(10), 0, screen_width, scaleWithSize(30))];
    titleLable.font = fontSize(scaleWithSize(11)) ;
    [view addSubview:titleLable];
    
    UILabel * results = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/2, 0, screen_width/2 - scaleWithSize(10), scaleWithSize(30))];
    results.textAlignment = 2;
//    results.text = @"1胜1平1负";
    results.font = fontSize(scaleWithSize(11)) ;
    [view addSubview:results];
    
    
    switch (section) {
            case 0:
            titleLable.text = @"赛前积分排名";//春季分组-A组-赛前积分排名
            results.hidden = YES;
            break;
            case 1:
            titleLable.text = @"历史交战";
            results.hidden = NO;
            if (self.basicPanelModel.vs.battle.count) {
                results.text = [NSString stringWithFormat:@"%ld胜%ld平%ld负",
                                self.basicPanelModel.vs.tolWon,
                                self.basicPanelModel.vs.tolDrawn,
                                self.basicPanelModel.vs.tolLost] ;
            }
            break;
            case 2:
            titleLable.text = @"队A";
            results.hidden = NO;
            if (self.basicPanelModel.homeVs.battle.count) {
                results.text = [NSString stringWithFormat:@"%ld胜%ld平%ld负",
                                self.basicPanelModel.homeVs.tolWon,
                                self.basicPanelModel.homeVs.tolDrawn,
                                self.basicPanelModel.homeVs.tolLost] ;
            }
            break;
            case 3:
            if (self.basicPanelModel.awayVs.battle.count) {
                results.text = [NSString stringWithFormat:@"%ld胜%ld平%ld负",
                                self.basicPanelModel.awayVs.tolWon,
                                self.basicPanelModel.awayVs.tolDrawn,
                                self.basicPanelModel.awayVs.tolLost] ;
            }
            titleLable.text = @"队B";
            results.hidden = NO;
            break;
            
        default:
            break;
    }
    
    
    
    return headView;
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
