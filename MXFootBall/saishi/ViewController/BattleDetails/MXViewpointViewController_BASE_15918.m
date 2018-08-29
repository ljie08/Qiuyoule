//
//  MXViewpointViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXViewpointViewController.h"

#import "MXSSMyOpinionYESSettledTableViewCell.h"//观点Cell
#import "MXDViewpointModel.h"

#import "MXOpinionDetailViewController.h"//观点详情

@interface MXViewpointViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView * mainTableView ;

@property (nonatomic , assign) NSInteger page ;

@property (nonatomic , strong) NSMutableArray * dataArray ;

@property (nonatomic , strong) NSString * matchStatus ;
@property (nonatomic , strong) NSString * freeCount ;


@property (nonatomic , strong) UIButton * upDataButton ;

@end

@implementation MXViewpointViewController

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
        
        [_mainTableView registerClass:[MXSSMyOpinionYESSettledTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@",[MXSSMyOpinionYESSettledTableViewCell class]]];
        
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
            self.page = 1 ;
            [weakSelf getNetworkData] ;
            [SVProgressHUD showWithStatus:@"正在加载..."];
        }];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.page ++ ;
            [weakSelf getNetworkData] ;
            [SVProgressHUD showWithStatus:@"正在加载..."];
        }] ;
    }
    
    return _mainTableView ;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    if (self.dataArray.count == 0) {
        [self.mainTableView.mj_header beginRefreshing] ;
    } else {
        [self getNetworkData] ;
    }
        
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"观点界面\"}"] ;
}
//观点界面
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"观点界面\"}"] ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor;
    
    [self.view addSubview:self.mainTableView];
    
    mx_weakify(self) ;
    if (self.dataArray.count == 0) {
        self.upDataButton = [weakSelf addUpDataBtnWithTitle:@"" superView:weakSelf.mainTableView] ;
    }
    self.updataBlock = ^{
        //        [weakSelf getNetworkData] ;
        [weakSelf.mainTableView.mj_header beginRefreshing] ;
    } ;
    
}

#pragma mark - network
- (void)getNetworkData {
    
    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
    if (userModel.userId) {
        
        NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
        NSString *token = userModel.token;
        
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
        
        NSString * matchID = [NSString stringWithFormat:@"%ld",(long)_matchId] ;
//        NSString * matchID =@"2460754" ;
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        [parameters setObject:matchID forKey:@"matchId"] ;
        [parameters setObject:userId forKey:@"userId"] ;
        [parameters setObject:token forKey:@"token"] ;
        [parameters setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];
        [parameters setObject:@"10" forKey:@"limit"];
        [parameters setObject:timeStr forKey:@"time"];
        
        NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
        NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXEventFindAppEventViewsPATH];
        
        
        
        mx_weakify(self);
        [[WebManager sharedManager]requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
            YYLog(@"=====%@=====",dic);
            [weakSelf.mainTableView.mj_header endRefreshing] ;
            [weakSelf.mainTableView.mj_footer endRefreshing] ;
            if ([dic[@"code"] isEqualToString:@"0"]) {
                
                
//                NSLog(@"%@" , dic[@"data"]) ;
                if ([dic[@"data"][@"viewList"] count]) {
                    
                    if (weakSelf.page == 1) {
                        weakSelf.dataArray = [MXDViewpointModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"viewList"]] ;
                    } else {
                        NSMutableArray * array = [MXDViewpointModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"viewList"]] ;
                        
                        [weakSelf.dataArray addObjectsFromArray:array];
                    }
                    weakSelf.matchStatus = [dic[@"data"][@"matchInfo"][@"matchStatus"] stringValue] ;
                    weakSelf.freeCount = [dic[@"data"][@"count"] stringValue] ;
                    
                    weakSelf.removeUpdataBlock() ;
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
                    
                    [weakSelf.mainTableView reloadData];
                });
                
                
            } else {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                if (weakSelf.page > 1) {
                    weakSelf.page -- ;
                }
                if (!weakSelf.dataArray.count) {
                    [self.upDataButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
                    [weakSelf.mainTableView addSubview:weakSelf.upDataButton];
                }
            }
            
        } WithFailureBlock:^(NSError *error) {
            [weakSelf.mainTableView.mj_header endRefreshing] ;
            [weakSelf.mainTableView.mj_footer endRefreshing] ;
            if (weakSelf.page > 1) {
                weakSelf.page -- ;
            }
            [SVProgressHUD showErrorWithStatus:@"请求错误"];
            if (!weakSelf.dataArray.count) {
                [self.upDataButton setTitle:@"请求错误" forState:(UIControlStateNormal)] ;
                [weakSelf.mainTableView addSubview:weakSelf.upDataButton];
            }
        }] ;
        
    } else {
        
    }
    
}



#pragma mark TableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
//    return 10 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return scaleWithSize(100);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MXLineupTableViewCell";//cell重用问题
    MXSSMyOpinionYESSettledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXSSMyOpinionYESSettledTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.matchStatus = self.matchStatus ;
    cell.eventViewpointModel = self.dataArray[indexPath.row] ;
    MXDViewpointModel *model=self.dataArray[indexPath.row];
    YYLog(@"=====%li=====",model.ID);
    
    cell.selectionStyle = 0;
    return cell ;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001 ;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return scaleWithSize(35);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(35))] ;
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, scaleWithSize(10), screen_width, scaleWithSize(25))];
    whiteView.backgroundColor = mx_Wode_colorf2f2f2 ;
    [headerView addSubview:whiteView];
    
    UILabel * nameL = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(25))];
    [whiteView addSubview:nameL];
    nameL.font = fontSize(scaleWithSize(11));
    nameL.text = @"球友观点";

    UILabel * numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - scaleWithSize(50), 0, scaleWithSize(50), scaleWithSize(25))] ;
    [whiteView addSubview:numberLabel] ;
    UIImageView * freeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(numberLabel.frame) - scaleWithSize(20), scaleWithSize(5), scaleWithSize(14), scaleWithSize(14))] ;
    [whiteView addSubview:freeImgView] ;
    if (self.freeCount) {
        numberLabel.text = [NSString stringWithFormat:@"X%@",self.freeCount] ;
        freeImgView.image = Image(@"saishi_suo") ;
    }
    
    return headerView ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MXDViewpointModel *model=self.dataArray[indexPath.row];
//    model.ID
    
    MXOpinionDetailViewController * opinionDetail = [[MXOpinionDetailViewController alloc]init] ;
    opinionDetail.eventID = [NSString stringWithFormat:@"%li",model.ID];
    [self.navigationController pushViewController:opinionDetail animated:YES];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
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
