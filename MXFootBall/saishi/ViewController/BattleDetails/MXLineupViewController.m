//
//  MXLineupViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXLineupViewController.h"

#import "MXLineupTableViewCell.h"

#import "MXDLineupModel.h"

#import "MXDSoccerPlayerModel.h"
#import "MXDInjuredPlayerModel.h"

@interface MXLineupViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * mainTableView ;

@property (nonatomic , strong) UIImageView * headerImg ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@property (nonatomic , strong) MXDLineupModel * lineupMoel ;

@property (nonatomic , strong) UIButton * upDataButton ;

@property (nonatomic , strong) UIImageView * imgView ;

@end

@implementation MXLineupViewController


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - (STATUS_AND_NAVIGATION_HEIGHT)  - scaleWithSize(110 + 44) - TABBAR_FRAME) style:(UITableViewStyleGrouped)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = mx_Wode_backgroundColor;
        
        [_mainTableView registerClass:[MXLineupTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@",[MXLineupTableViewCell class]]];
        
        /**
         *  将tableview的分割线补满
         */
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        mx_weakify(self) ;
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakSelf getNetworkData] ;
        }];
        
    }
    
    return _mainTableView ;
}

- (UIImageView *)headerImg {
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(200))];
    }
    return _headerImg ;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    if (!self.dataArray.count) {
        [self.mainTableView.mj_header beginRefreshing] ;
    }
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"阵容界面\"}"] ;
}
//阵容界面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"阵容界面\"}"] ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor;
    
    [self.view addSubview:self.mainTableView];
    
//    self.mainTableView.tableHeaderView = self.headerImg ;
    
    self.mainTableView.tableHeaderView = [self createTableViewHearderView] ;
    
    mx_weakify(self) ;
    if (!self.dataArray.count) {
        self.upDataButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.mainTableView] ;
    }
    self.updataBlock = ^{
        //        [weakSelf getNetworkData] ;
        [weakSelf.mainTableView.mj_header beginRefreshing] ;
    } ;
    
}

- (UIView *) createTableViewHearderView {
    
    UIView * tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_width / 2 + scaleWithSize(40))] ;
    
    UILabel * homelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, scaleWithSize(10), screen_width/2, scaleWithSize(30))] ;
    homelabel.text = @"上一场首发" ;
    homelabel.textAlignment = 1;
    homelabel.textColor = mx_Wode_colorBlue2374e4 ;
    [tableViewHeaderView addSubview:homelabel] ;
    UIView * redView = [[UIView alloc]initWithFrame:CGRectMake(0, scaleWithSize(28), screen_width/2, scaleWithSize(2))] ;
    redView.backgroundColor = mx_Wode_colorBlue2374e4 ;
    [homelabel addSubview:redView] ;
    
    UILabel * awaylabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/2, scaleWithSize(10), screen_width/2, scaleWithSize(30))] ;
    awaylabel.text = @"上一场首发" ;
    awaylabel.textAlignment = 1 ;
    awaylabel.textColor = kColorWithRGBF(0x497cc8) ;
    [tableViewHeaderView addSubview:awaylabel] ;
    UIView * blueView = [[UIView alloc]initWithFrame:CGRectMake(0, scaleWithSize(28), screen_width/2, scaleWithSize(2))] ;
    blueView.backgroundColor = kColorWithRGBF(0x497cc8) ;
    [awaylabel addSubview:blueView] ;
    
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, scaleWithSize(40), screen_width, screen_width/2)] ;
    if (self.lineupMoel.homeList.count||self.lineupMoel.awayList.count) {
        imgView.image = Image(@"saishi_tutututu") ;
    } else {
        imgView.image = Image(@"saishi_tutututu") ;
    }
    
    [tableViewHeaderView addSubview:imgView] ;
//    NSLog(@"-----%f", imgView.frame.size.height) ;
    
    for (MXDSoccerPlayerModel * model in self.lineupMoel.homeList) {
        
        if (model.x) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scaleWithSize(16), scaleWithSize(16))] ;
            label.text = model.shirtNumber ;
            label.textAlignment = 1 ;
            label.font = fontSize(scaleWithSize(8)) ;
            label.textColor = mx_Wode_colorBlue2374e4 ;
            label.layer.masksToBounds = YES ;
            label.layer.cornerRadius = scaleWithSize(8) ;
            label.layer.borderWidth = 1 ;
            label.layer.borderColor = [mx_Wode_colorBlue2374e4 CGColor] ;
            [imgView addSubview:label] ;
            label.center = CGPointMake(CGRectGetMidX(imgView.frame)*model.y/100.f, imgView.frame.size.height*model.x/100.f) ;
//            NSLog(@"-----%f----%f----%ld", label.center.y,imgView.frame.size.height,model.y) ;
            
            UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(16))] ;
            nameLabel.center = CGPointMake(model.y/200.f*screen_width, model.x/200.f*screen_width + scaleWithSize(16)) ;
            NSString * nameString = [[[model.name stringByReplacingOccurrencesOfString:@"." withString:@"·"] componentsSeparatedByString:@"·"] firstObject] ;
            if (nameString.length == 1) {
                nameString = [[[model.name stringByReplacingOccurrencesOfString:@"." withString:@"·"] componentsSeparatedByString:@"·"] lastObject] ;
            }
            nameLabel.text = nameString ;
            nameLabel.textAlignment = 1 ;
            nameLabel.textColor = Color(191, 53, 54, 0.5) ;
            nameLabel.font = fontSize(scaleWithSize(8)) ;
            [imgView addSubview:nameLabel] ;
            
        }
    }
    
    
    for (MXDSoccerPlayerModel * model in self.lineupMoel.awayList) {
        
        if (model.x) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scaleWithSize(16), scaleWithSize(16))] ;
            label.center = CGPointMake(screen_width - model.y/200.f*screen_width, model.x/200.f*screen_width) ;
            label.text = model.shirtNumber ;
            label.textAlignment = 1 ;
            label.font = fontSize(scaleWithSize(8)) ;
            label.textColor = kColorWithRGBF(0x497cc8) ;
            label.layer.masksToBounds = YES ;
            label.layer.cornerRadius = scaleWithSize(8) ;
            label.layer.borderWidth = 1 ;
            label.layer.borderColor = [kColorWithRGBF(0x497cc8) CGColor] ;
            [imgView addSubview:label] ;
            
            UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(16))] ;
            nameLabel.center = CGPointMake(screen_width - model.y/200.f*screen_width, model.x/200.f*screen_width + scaleWithSize(16)) ;
//            nameLabel.text = [model.name componentsSeparatedByString:@"·"].firstObject ;
            NSString * nameString = [[[model.name stringByReplacingOccurrencesOfString:@"." withString:@"·"] componentsSeparatedByString:@"·"] firstObject] ;
            if (nameString.length == 1) {
                nameString = [[[model.name stringByReplacingOccurrencesOfString:@"." withString:@"·"] componentsSeparatedByString:@"·"] lastObject] ;
            }
            nameLabel.text = nameString ;
            nameLabel.textAlignment = 1 ;
            nameLabel.textColor = kColorWithRGBF(0x89a0c0) ;
            nameLabel.font = fontSize(scaleWithSize(8)) ;
            [imgView addSubview:nameLabel] ;
            
        }
    }
    
    
    
    return tableViewHeaderView ;
}


#pragma mark - network
- (void)getNetworkData {
    
    
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSString * matchID = [NSString stringWithFormat:@"%ld",(long)_matchId] ;
//    NSString * matchID = @"2247260" ;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:matchID forKey:@"matchId"] ;
    [parameters setObject:timeStr forKey:@"time"];
    NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventGetSquadPATH];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    mx_weakify(self);
    [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        [weakSelf.mainTableView.mj_header endRefreshing] ;
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            
            //            weakSelf.basicPanelModel = [MXEventBasicPanelModel mj_objectWithKeyValues:dic[@"data"]] ;
            weakSelf.lineupMoel = [MXDLineupModel mj_objectWithKeyValues:dic[@"data"]] ;
            
            if (!(weakSelf.lineupMoel.homeList.count||
                  weakSelf.lineupMoel.awayList.count||
                  weakSelf.lineupMoel.homeInjuryList.count||
                  weakSelf.lineupMoel.awayInjuryList.count)) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
//                [self.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
//                [weakSelf.mainTableView addSubview:self.upDataButton];
            } else {
                
                weakSelf.removeUpdataBlock() ;
            }
            
            
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.mainTableView reloadData];
                self.mainTableView.tableHeaderView = [self createTableViewHearderView] ;
            });
            
            
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            if (!(weakSelf.lineupMoel.homeList.count||
                  weakSelf.lineupMoel.awayList.count||
                  weakSelf.lineupMoel.homeInjuryList.count||
                  weakSelf.lineupMoel.awayInjuryList.count)) {
//                [self.upDataButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
//                [weakSelf.mainTableView addSubview:self.upDataButton];
            }
        }
        
    } WithFailureBlock:^(NSError *error) {
        [weakSelf.mainTableView.mj_header endRefreshing] ;
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        if (!(weakSelf.lineupMoel.homeList.count||
              weakSelf.lineupMoel.awayList.count||
              weakSelf.lineupMoel.homeInjuryList.count||
              weakSelf.lineupMoel.awayInjuryList.count)) {
//            [self.upDataButton setTitle:@"网络错误" forState:(UIControlStateNormal)] ;
//            [weakSelf.mainTableView addSubview:self.upDataButton];
        }
    }] ;
    
    
}


#pragma mark TableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.lineupMoel.homeInjuryList.count) {
            return self.lineupMoel.homeInjuryList.count + 1 ;
        }
        
    } else {
        if (self.lineupMoel.awayInjuryList.count) {
            return self.lineupMoel.awayInjuryList.count + 1 ;
        }
        
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return scaleWithSize(30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MXLineupTableViewCell";//cell重用问题
    MXLineupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXLineupTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        
        cell.playerLabel.text = @"球员";
        cell.positionLabel.text = @"位置";
        cell.reasonLabel.text = @"原因";
        cell.frequencyLabel.text = @"归队时间";
        
        for (UILabel * label in cell.contentView.subviews) {
            label.font = fontSize(scaleWithSize(11));
            label.textColor = kColorWithRGBF(0xb2b2b2) ;
        }
        
        
    } else {
        
        if (indexPath.section == 0) {
            cell.injuredModel = self.lineupMoel.homeInjuryList[indexPath.row - 1] ;
        } else {
            cell.injuredModel = self.lineupMoel.awayInjuryList[indexPath.row - 1] ;
        }
        
//        cell.playerLabel.text = @"李代尔";
//        cell.positionLabel.text = @"后卫";
//        cell.reasonLabel.text = @"亚特兰";
//        cell.frequencyLabel.text = @"";
        
        for (UILabel * label in cell.contentView.subviews) {
            label.font = fontSize(scaleWithSize(13));
            label.textColor = [UIColor blackColor] ;
        }
        
    }
    
    
    cell.selectionStyle = 0 ;
    return cell ;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (!self.lineupMoel.homeInjuryList.count) {
            return scaleWithSize(70) ;
        }
    } else {
        if (!self.lineupMoel.awayInjuryList.count) {
            return scaleWithSize(70) ;
        }
    }
    return 0.001 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(70))] ;
    label.backgroundColor = [UIColor whiteColor] ;
    label.text = @"暂无数据" ;
    label.textColor = mx_FontLightGreyColor ;
    label.textAlignment = 1 ;
    if (section == 0) {
        if (!self.lineupMoel.homeInjuryList.count) {
            return label ;
        }
    } else {
        if (!self.lineupMoel.awayInjuryList.count) {
            return label ;
        }
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return scaleWithSize(35);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(35))] ;
    headerView.backgroundColor = Color(250, 250, 250, 1);;
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, scaleWithSize(10), screen_width, scaleWithSize(25))];
    whiteView.backgroundColor = Color(242, 242, 242, 1);;
    [headerView addSubview:whiteView];
    
    UILabel * nameL = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(25))];
    [whiteView addSubview:nameL];
    nameL.font = fontSize(scaleWithSize(11));
    
    if (section == 0) {
        nameL.text = @"主队伤停";
    } else {
        nameL.text = @"客队伤停";
    }
    
    return headerView ;
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
