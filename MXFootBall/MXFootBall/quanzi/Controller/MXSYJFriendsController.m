//
//  MXSYJFriendsController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJFriendsController.h"
#import "MXSYJFriendsCell.h"
#import "MXSYJPostDetailsController.h"
#import "MXSYJFocusOnModel.h"
#import "MXSYJPersonController.h"

#define kImgWidth (screen_width - 45) / 4

static NSString *friendsID  = @"friendsID";


@interface MXSYJFriendsController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger page;
    BOOL isHeaderRefresh;
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MXSYJFocusOnModel *model;

@property (nonatomic, strong) NSMutableArray * arrList;

@property (nonatomic , strong) UIButton * upDataButton ;


@end

@implementation MXSYJFriendsController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([MXssWodeUtils loadPersonInfo].userId) {
        mx_weakify(self);
        //加载网络数据
        //上拉下拉刷新
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            isHeaderRefresh = YES;
            [weakSelf getNetWork];
            
        }];
        if (!self.arrList.count) {
            [self.tableView.mj_header beginRefreshing];
        }
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            page ++;
            isHeaderRefresh = NO;
            [weakSelf getNetWork];
        }];
        
    }else{
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        login.isPageNumber = 3;
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"论坛关注界面\"}"];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tableView
    [self setTableView];
    self.arrList = [NSMutableArray array];
    
    if (!self.arrList.count) {
        self.upDataButton = [self addUpDataBtnWithTitle:@"" superView:self.tableView];
        self.upDataButton.titleLabel.font = fontBoldSize(20);
    }
    
    mx_weakify(self);
    self.updataBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateDatas) name:@"NOTI_LOGOUT" object:nil];
}
- (void)setTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = mx_Wode_bordColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[MXSYJFriendsCell class] forCellReuseIdentifier:friendsID];
}

#pragma mark - network
- (void)getNetWork{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];

    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    //    [parmet setObject:userModel.userSign forKey:@"sign"];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:userModel.userId forKey:@"userId"];
    [parmet setObject:userModel.token forKey:@"token"];
    [parmet setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [parmet setObject:@"10" forKey:@"limit"];

    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemFindListOfOnePeoplesPATH];
    mx_weakify(self);
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        [self.tableView.mj_header endRefreshing];

        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            NSLog(@"%@",dic);
            [SVProgressHUD dismiss];
            
            
            [weakSelf.tableView.mj_header endRefreshing];
            
            if (isHeaderRefresh == YES) {
                [weakSelf.arrList removeAllObjects];
            }
            
            NSMutableArray *arr = [MXSYJFocusOnModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
            if (arr.count < 10) {
                
                if (arr.count == 0) {
                    weakSelf.tableView.mj_footer.hidden = YES;
                }else{
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            //新闻列表
            [weakSelf.arrList addObjectsFromArray:arr];
            
            if (weakSelf.arrList.count == 0) {
                [weakSelf.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
                [weakSelf.view addSubview:weakSelf.upDataButton];
                
            }else{
                weakSelf.removeUpdataBlock() ;
            }
            [weakSelf.tableView reloadData];
            
            
        }else{
            
            [weakSelf.upDataButton setTitle:dic[@"msg"] forState:(UIControlStateNormal)] ;
            [weakSelf.view addSubview:weakSelf.upDataButton];
        }
        
        NSLog(@"%@",dic);
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"网络好像不太好呀~~"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    
    
}

#pragma mark - table view dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MXSYJFocusOnModel *mdoel = self.arrList[indexPath.row];
    
    if (mdoel.forumImgs.count > 0) {
        return [self.tableView cellHeightForIndexPath:indexPath model:mdoel keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width] + kImgWidth;
        
    }else{
        return [self.tableView cellHeightForIndexPath:indexPath model:mdoel keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width];
        
    }
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MXSYJFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:friendsID];
    if (self.arrList.count > 0) {
        MXSYJFocusOnModel *model = self.arrList[indexPath.row];
        cell.model = model;
    }
    //推荐
    mx_weakify(self);
    cell.tapClick = ^{
        
        MXSYJFocusOnModel *model = weakSelf.arrList[indexPath.row];
        MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
        vc.ownerId = [NSString stringWithFormat:@"%d", model.userId];
        vc.ownerName = model.username;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (self.arrList.count > 0) {
        MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
        MXSYJFocusOnModel *mdoel = self.arrList[indexPath.row];
        vc.newsID = mdoel.newsId;
        vc.userId = [NSString stringWithFormat:@"%d", mdoel.userId];;
        [self.navigationController pushViewController:vc animated:YES];
        
        mdoel.view = mdoel.view + 1 ;
        [self.arrList replaceObjectAtIndex:indexPath.row withObject:mdoel] ;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
    }
    
}



- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    //    [UBT logTrace:@"residenceTimeOut"; content:@"{\"VC\":\"\u9996\u9875\"}";
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"广场界面\"}"];
}




@end
