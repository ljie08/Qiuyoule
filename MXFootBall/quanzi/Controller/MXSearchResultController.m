//
//  MXSearchResultController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSearchResultController.h"
#import "MXSYJFriendsCell.h"
#import "MXSYJPostDetailsController.h"
#import "MXSYJFocusOnModel.h"

#define kImgWidth (screen_width - 45) / 4

static NSString *friendsID  = @"friendsID";

@interface MXSearchResultController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSInteger page;
    BOOL isHeaderRefresh;
    
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MXSYJFocusOnModel *model;

@property (nonatomic, strong) NSMutableArray *modelnewsLsit;


@end

@implementation MXSearchResultController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initTitleViewWithTitle:@"搜索结果"];
    [self setBackButton:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tableView
    [self setTableView];
    self.modelnewsLsit = [NSMutableArray array];
    
    if ([MXssWodeUtils loadPersonInfo].userId) {
        mx_weakify(self);
        //加载网络数据
        [self getNetWork];
        //上拉下拉刷新
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            page = 1;
            isHeaderRefresh = YES;
            [weakSelf getNetWork];
            
        }];
        [self.tableView.mj_header beginRefreshing];
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
}


- (void)setTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME) style:UITableViewStylePlain];
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
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:@"10" forKey:@"limit"];
    if (self.strTitle) {
        [parmet setObject:self.strTitle forKey:@"title"];
    }
    [parmet setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    if ([MXssWodeUtils loadPersonInfo].userId) {
        [parmet setObject:[MXssWodeUtils loadPersonInfo].userId forKey:@"userId"];
    }
    
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemFindPointTypeList_PATH];
    mx_weakify(self);
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            
            if (isHeaderRefresh == YES) {
                [weakSelf.modelnewsLsit removeAllObjects];
            }

            NSDictionary *newsDict = dic[@"data"][@"newsList"];
            
            NSMutableArray *arr = [MXSYJFocusOnModel mj_objectArrayWithKeyValuesArray:newsDict];
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
            [weakSelf.modelnewsLsit addObjectsFromArray:arr];
            
            [weakSelf.tableView reloadData];
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        
        NSLog(@"%@",dic);
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}

#pragma mark - table view dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MXSYJFocusOnModel *mdoel = self.modelnewsLsit[indexPath.row];
    
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
    return self.modelnewsLsit.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MXSYJFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:friendsID];
    if (self.modelnewsLsit.count > 0) {
        MXSYJFocusOnModel *model = self.modelnewsLsit[indexPath.row];
        cell.model = model;
    }

    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.modelnewsLsit.count > 0) {
        MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
        MXSYJFocusOnModel *mdoel = self.modelnewsLsit[indexPath.row];
        vc.newsID = mdoel.newsId;
        vc.userId = [NSString stringWithFormat:@"%d", mdoel.userId];
        [self.navigationController pushViewController:vc animated:YES];
        
        mdoel.view = mdoel.view + 1 ;
        [self.modelnewsLsit replaceObjectAtIndex:indexPath.row withObject:mdoel] ;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
    }
    
}

@end
