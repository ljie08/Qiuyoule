//
//  MXDiskViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXDiskViewController.h"

#import "MXDiskTableViewCell.h"

@interface MXDiskViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * mainTableView ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@property (nonatomic , strong) UIButton * upDataButton ;

@end

@implementation MXDiskViewController

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
        
        
        [_mainTableView registerClass:[MXDiskTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@",[MXDiskTableViewCell class]]];
        
//        NSLog(@"%@",[NSString stringWithFormat:@"%@",[MXDiskTableViewCell class]]);
        
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    if (!self.dataArray.count) {
        [self.mainTableView.mj_header beginRefreshing] ;
    }
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"盘面界面\"}"] ;
}
//盘面界面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"盘面界面\"}"] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    
    NSString * matchID = [NSString stringWithFormat:@"%ld",(long)_matchId] ;
//    NSString * matchID =@"2247260" ;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:matchID forKey:@"matchId"] ;
    [parameters setObject:timeStr forKey:@"time"];
    NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventGetdiskPATH];
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    mx_weakify(self);
    [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        [weakSelf.mainTableView.mj_header endRefreshing] ;
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            
            //            weakSelf.basicPanelModel = [MXEventBasicPanelModel mj_objectWithKeyValues:dic[@"data"]] ;
            
            
            if (weakSelf.dataArray.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂无数据"];
                [weakSelf.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
                [weakSelf.mainTableView addSubview:weakSelf.upDataButton];
            } else {
                
                weakSelf.removeUpdataBlock() ;
            }
            
            
            [SVProgressHUD dismiss];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.mainTableView reloadData];
            });
            
            
        } else {
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            if (!weakSelf.dataArray.count) {
                
                [weakSelf.upDataButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
                [weakSelf.mainTableView addSubview:weakSelf.upDataButton];
            }
        }
        
    } WithFailureBlock:^(NSError *error) {
        [weakSelf.mainTableView.mj_header endRefreshing] ;
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
        if (!weakSelf.dataArray.count) {
            
            [weakSelf.upDataButton setTitle:@"网络错误" forState:(UIControlStateNormal)] ;
            [weakSelf.mainTableView addSubview:weakSelf.upDataButton];
        }
    }] ;
    
    
}


#pragma mark TableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return scaleWithSize(130);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MXDiskTableViewCell";//cell重用问题
    MXDiskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXDiskTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = mx_Wode_colorBlue2374e4 ;
    
    cell.selectionStyle = 0 ;
    return cell ;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return scaleWithSize(40);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(40))] ;
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, scaleWithSize(10), screen_width, scaleWithSize(30))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:whiteView];
    
    UILabel * nameL = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(30))];
    [whiteView addSubview:nameL];
    nameL.text = @"欧盘赔率";
    
    UILabel * numberL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width - scaleWithSize(64), scaleWithSize(30))];
    numberL.textAlignment = 2 ;
    [whiteView addSubview:numberL];
    numberL.text = @"2.4 7.8 3.4";
    
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
