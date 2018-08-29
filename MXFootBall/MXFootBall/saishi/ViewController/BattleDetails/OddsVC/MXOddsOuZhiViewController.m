//
//  MXOddsOuZhiViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOddsOuZhiViewController.h"

#import "MXOuZhiTitleTableViewCell.h"

#import "MXDEuModels.h"

@interface MXOddsOuZhiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * mainTableView ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@property (nonatomic , strong) UIButton * upDataButton ;

@end

@implementation MXOddsOuZhiViewController

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array] ;
    }
    return _dataArray ;
}
- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, scaleWithSize(30), screen_width, screen_height -(STATUS_AND_NAVIGATION_HEIGHT)  - scaleWithSize(110 + 44 + 30) - TABBAR_FRAME) style:(UITableViewStylePlain)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = mx_Wode_backgroundColor;
        
        _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero] ;
        
        [_mainTableView registerClass:[MXOuZhiTitleTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@",[MXOuZhiTitleTableViewCell class]]];
        
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
            [self getNetworkData] ;
        }] ;
        
    }
    
    return _mainTableView ;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.dataArray.count) {
        [self.mainTableView.mj_header beginRefreshing];
    }
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"赔率欧指界面\"}"] ;
}
//赔率欧指界面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"赔率欧指界面\"}"] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor;
    
    [self.view addSubview:self.mainTableView];
    
    
    mx_weakify(self) ;
    if (!self.dataArray.count) {
        self.upDataButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.mainTableView] ;
    }
    self.updataBlock = ^{
        //        [weakSelf getNetworkData] ;
        [weakSelf.mainTableView.mj_header beginRefreshing] ;
    } ;
    
}

#pragma mark - network
- (void)getNetworkData {
    
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

//    NSString * matchIDString = @"2442832" ;
    NSString * matchIDString = [NSString stringWithFormat:@"%ld",_matchId] ;
    [parameters setObject:matchIDString forKey:@"matchId"] ;
    [parameters setObject:@"eu" forKey:@"oddsType"];
    [parameters setObject:timeStr forKey:@"time"];
    NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventOddsPanelPATH];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    mx_weakify(self);
    [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        [weakSelf.mainTableView.mj_header endRefreshing];
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            NSLog(@"%@" ,dic[@"data"]) ;
            
            if ([dic[@"data"][@"odds"] count]) {
                weakSelf.dataArray = [MXDEuModels mj_objectArrayWithKeyValuesArray:dic[@"data"][@"odds"]] ;
                weakSelf.removeUpdataBlock() ;
            } else {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                [self.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
//                if (!weakSelf.dataArray.count) {
                    [weakSelf.mainTableView addSubview:self.upDataButton];
//                }
            }
            
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.mainTableView reloadData];
            });
            
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            if (!weakSelf.dataArray.count) {
                [self.upDataButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
                [weakSelf.mainTableView addSubview:self.upDataButton];
            }
        }
    } WithFailureBlock:^(NSError *error) {
        [weakSelf.mainTableView.mj_header endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        if (!weakSelf.dataArray.count) {
            [self.upDataButton setTitle:@"网络错误" forState:(UIControlStateNormal)] ;
            [weakSelf.mainTableView addSubview:self.upDataButton];
        }
    }] ;
}


#pragma mark TableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count) {
        return self.dataArray.count + 1 ;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return scaleWithSize(30);
    }
    
    return scaleWithSize(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MXOuZhiTitleTableViewCell";//cell重用问题
    MXOuZhiTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXOuZhiTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    CGFloat labelText = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"99.99  99.99  99.99" font:fontSize(scaleWithSize(13))] ;
    CGFloat labelText1 = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"999.99%" font:fontSize(scaleWithSize(13))] ;
    
    if (indexPath.row == 0) {
        
        cell.companyLabel.frame = CGRectMake(0, 0, scaleWithSize(80), scaleWithSize(30));
        cell.companyLabel.textColor = kColorWithRGBF(0xb2b2b2) ;
        cell.oddsLabel.frame = CGRectMake(CGRectGetMaxX(cell.companyLabel.frame), 0, labelText, scaleWithSize(30));
        cell.oddsLabel.textColor = kColorWithRGBF(0xb2b2b2) ;
        
        cell.kellyLabel.frame = CGRectMake(screen_width - labelText , 0, labelText, scaleWithSize(30));
        cell.kellyLabel.textColor = kColorWithRGBF(0xb2b2b2) ;
        cell.returnRateLabel.frame = CGRectMake(CGRectGetMaxX(cell.oddsLabel.frame) + (CGRectGetMinX(cell.kellyLabel.frame) - CGRectGetMaxX(cell.oddsLabel.frame) - labelText1)/2, 0, labelText1, scaleWithSize(30));
        cell.returnRateLabel.textColor = kColorWithRGBF(0xb2b2b2) ;
        
        cell.companyLabel.text = @"公司" ;
        cell.oddsLabel.text = @"欧赔" ;
        cell.returnRateLabel.text = @"返还率" ;
        cell.kellyLabel.text = @"凯利" ;
        
    } else {
        
        cell.companyLabel.frame = CGRectMake(0, 0, scaleWithSize(80), scaleWithSize(60));
        cell.companyLabel.textColor = kColorWithRGBF(0x000000) ;
        cell.oddsLabel.frame = CGRectMake(CGRectGetMaxX(cell.companyLabel.frame), 0, labelText, scaleWithSize(60));
        cell.oddsLabel.textColor = kColorWithRGBF(0x000000) ;
//        cell.returnRateLabel.frame = CGRectMake(screen_width/2, 0, labelText1, scaleWithSize(60));
//        cell.returnRateLabel.textColor = kColorWithRGBF(0x000000) ;

        cell.kellyLabel.frame = CGRectMake(screen_width - labelText , 0, labelText, scaleWithSize(60));
        cell.kellyLabel.textColor = kColorWithRGBF(0x000000) ;
        
        cell.returnRateLabel.frame = CGRectMake(CGRectGetMaxX(cell.oddsLabel.frame) + (CGRectGetMinX(cell.kellyLabel.frame) - CGRectGetMaxX(cell.oddsLabel.frame) - labelText1)/2, 0, labelText1, scaleWithSize(60));
        cell.returnRateLabel.textColor = kColorWithRGBF(0x000000) ;
        
        cell.euModel = self.dataArray[indexPath.row - 1] ;
        
    }
    
    cell.selectionStyle = 0 ;
    return cell ;
}

- (NSMutableAttributedString *)attributedStringWihtTextString:(NSString *)textString lineSpacing:(CGFloat)lineSpacing {
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    
    return attributedString ;
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
