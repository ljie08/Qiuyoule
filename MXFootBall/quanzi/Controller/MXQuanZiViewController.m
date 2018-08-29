//
//  MXQuanZiViewController.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXQuanZiViewController.h"
#import "MXSYJCustomNavitagionView.h"
#import "MXTableCollectionCell.h"
#import "MXSYJFriendsCell.h"
#import "MXSYJCelebrityController.h"
#import "MXSYJPostDetailsController.h"
#import "MXSYJPersonController.h"
#import "MXSYJCircleDetailController.h"
#import "MXSYJFocusOnModel.h"
#import "MXSYJChannelModel.h"
#import "MXSYJScrollerView.h"
#import <UIImage+GIF.h>
#import "MXSYJAdCell.h"
#import "MXSYJWebViewController.h"

static NSString *hallOfFameID  = @"hallOfFameID";
static NSString *tableCollectionID  = @"tableCollectionID";
static NSString *friendsID  = @"friendsID";
static NSString *adCell = @"adCell";

#define kImgWidth (screen_width - 45) / 4



@interface MXQuanZiViewController ()<UITableViewDelegate,UITableViewDataSource,btnClickDelegte>{
    
    NSInteger page;
    BOOL isHeaderRefresh;
}

/** 自定义导航栏 */
@property (nonatomic, strong) MXSYJCustomNavitagionView *customNavigation;

@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, strong) NSMutableArray *modelnewsLsit;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MXSYJScrollerView *scrollView;

@property (nonatomic, strong) NSString *fileName;

@end

@implementation MXQuanZiViewController

- (MXSYJScrollerView *)scrollView{
    
    if (_scrollView == nil) {
        _scrollView = [[MXSYJScrollerView alloc]initWithFrame:CGRectMake(0, -100, screen_width, 60)];
        UIImage *icon = [UIImage imageNamed:@"bannerPlace"];
        _scrollView.arrImg = [NSMutableArray arrayWithObjects:icon,icon,icon,icon,icon,icon, nil];
    }
    return _scrollView;
}

#pragma mark - scrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 向下的话 为负数
    CGFloat off_y = scrollView.contentOffset.y;
    
    // 下拉超过照片的高度的时候
    if (off_y > 280)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.frame =CGRectMake(0,0, screen_width, 60);
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.frame =CGRectMake(0,-100, screen_width, 60);
        }];
        
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelArr = [NSMutableArray array];
    self.modelnewsLsit = [NSMutableArray array];
    //页数
    page = 1;
    
    //设置自定义导航栏
//    [self setNavigation];
    //加载tableview
    [self setTableView];
    
    [self getNetWork];

    mx_weakify(self);
    self.scrollView.pushAction = ^(NSInteger tag) {
       
        MXSYJCircleDetailController *vc = [[MXSYJCircleDetailController alloc]init];
        MXSYJChannelModel *model = weakSelf.modelArr[tag];
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    
    //上拉下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        page = 1;
        isHeaderRefresh = YES;
        [weakSelf getNetWork];

    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        isHeaderRefresh = NO;
        [weakSelf getNetWork];
        
    }];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *fileName = [path stringByAppendingPathComponent:@"articles.plist"];
    self.fileName = fileName;
}

#pragma mark - tableView

- (void)setTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = mx_Wode_bordColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[MXTableCollectionCell class] forCellReuseIdentifier:tableCollectionID];
    [self.tableView registerClass:[MXSYJFriendsCell class] forCellReuseIdentifier:friendsID];
    [self.tableView registerClass:[MXSYJAdCell class] forCellReuseIdentifier:adCell];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 120)];
    imgView.image = [UIImage imageNamed:@"luntan_qiuqiumingrentang"];
    self.tableView.tableHeaderView = imgView;
    imgView.userInteractionEnabled = YES;
#pragma mark - 去掉mingrt点击事件
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
//    [imgView addGestureRecognizer:tap];
    
    UIButton *stickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    stickBtn.imageView.image = [UIImage imageNamed:@"置顶"];
    stickBtn.backgroundColor = [UIColor whiteColor];
    stickBtn.layer.cornerRadius = scaleWithSize(20);
    [stickBtn addTarget:self action:@selector(stickClick) forControlEvents:UIControlEventTouchUpInside];
    [stickBtn setBackgroundImage:[UIImage imageNamed:@"置顶"] forState:UIControlStateNormal];
    [self.view addSubview:stickBtn];
    
    [stickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(scaleWithSize(-20));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(scaleWithSize(-TABBAR_HEIGHT));
        make.size.mas_equalTo(CGSizeMake(scaleWithSize(40), scaleWithSize(40)));
    }];
    
}

- (void)stickClick{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)tapClick{
    //不跳转到个人详情
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        return;
    }

    [self.navigationController pushViewController:[MXSYJCelebrityController new] animated:YES];
    
}

- (void)getNetWork{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];

    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:@"10" forKey:@"limit"];
    if (self.titleStr) {
    [parmet setObject:self.titleStr forKey:@"title"];
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

            NSDictionary *quanziDict = dic[@"data"][@"channelList"];
            //圈子分类
            weakSelf.modelArr = [MXSYJChannelModel mj_objectArrayWithKeyValuesArray:quanziDict];
            
            //滑动scroll
            weakSelf.scrollView.arrImg = weakSelf.modelArr;
            [weakSelf.view addSubview:weakSelf.scrollView];
            
            if (weakSelf.modelArr.count == 0) {
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            }
            //存储数据
            NSMutableArray *arrName = [NSMutableArray array];
            NSMutableArray *arrID = [NSMutableArray array];
            
            for (MXSYJChannelModel *model in weakSelf.modelArr) {
                [arrName addObject:model.channelName];
                [arrID addObject:model.channelId];
            }
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:arrName forKey:@"arrName"];
            
            
            [userDefaults setObject:arrID forKey:@"arrID"];
            [userDefaults synchronize];
            
            
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
            
            NSMutableArray *adArr = [MXSYJFocusOnModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"adverts"]];
            if (adArr.count > 0) {
                [arr addObjectsFromArray:adArr];
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

    }];
    
    
}

#pragma mark - delegate

- (void)index:(NSInteger)index{
    
    if (self.modelArr.count > 0) {
        MXSYJCircleDetailController *vc = [[MXSYJCircleDetailController alloc]init];
        vc.model = self.modelArr[index];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - table view dataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
            //名人
            MXTableCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCollectionID];
            cell.arrModle = self.modelArr;
            cell.delegate = self;
            return cell;
    }else{
            mx_weakify(self);


            MXSYJFocusOnModel *model = self.modelnewsLsit[indexPath.row];
            
            if (model.advertPic) {
                MXSYJAdCell *cell = [tableView dequeueReusableCellWithIdentifier:adCell];
                if (self.modelnewsLsit.count > 0) {
                    MXSYJFocusOnModel *adModel = self.modelnewsLsit[indexPath.row];
                    cell.model = adModel;
                    cell.imgClick = ^{
                        MXSYJWebViewController *vc = [[MXSYJWebViewController alloc]init];
                        vc.url = adModel.targetUrl;
                        vc.adID = adModel.advertId ;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    };
                }
               
                return cell;
            }else{
                //推荐
                MXSYJFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:friendsID];
                if (self.modelnewsLsit.count > 0) {
                    cell.model = self.modelnewsLsit[indexPath.row];
                }
                mx_weakify(self);
                cell.tapClick = ^{
                    
                    MXSYJFocusOnModel *model = weakSelf.modelnewsLsit[indexPath.row];
                    MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
                    vc.ownerName = model.username;
                    vc.ownerId = [NSString stringWithFormat:@"%ld", model.userId];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
                return cell;
            }
        }
}


#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 1){
        
        MXSYJFocusOnModel *model = self.modelnewsLsit[indexPath.row];
    
        if (model.advertPic) {
            MXSYJWebViewController *vc = [[MXSYJWebViewController alloc]init];
            MXSYJFocusOnModel *adModel = self.modelnewsLsit[indexPath.row];
            vc.url = adModel.targetUrl;
            vc.adID = adModel.advertId ;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
            MXSYJFocusOnModel *mdoel = self.modelnewsLsit[indexPath.row];
            vc.fileName = self.fileName;
            vc.articleType = model.articleType;
            vc.model = model;
            vc.newsID = mdoel.newsId;
            vc.userId = [NSString stringWithFormat:@"%ld", (long)model.userId];
            [self.navigationController pushViewController:vc animated:YES];
            
            mdoel.view = mdoel.view + 1;
            [self.modelnewsLsit replaceObjectAtIndex:indexPath.row withObject:mdoel] ;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
            
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 30)];
        view.backgroundColor = mx_Wode_backgroundColor;
        UILabel *label = [[UILabel alloc]init];
        [view addSubview:label];
        label.font = fontBoldSize(12);
        label.textColor = mx_Wode_colorBlueprogress;
        label.text = @"精彩推荐";
        label.textAlignment = NSTextAlignmentLeft;
        label.sd_layout.leftSpaceToView(view, 20).centerYEqualToView(view).heightIs(15);
        [label setSingleLineAutoResizeWithMaxWidth:160];
        
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return 30;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 240;
    }else if (indexPath.section == 1){
        MXSYJFocusOnModel *model = self.modelnewsLsit[indexPath.row];

           
            if (model.advertPic) {
                
                return screen_width * 5 / 32 + 10;
                
            }else{
                MXSYJFocusOnModel *mdoel = self.modelnewsLsit[indexPath.row];
                
                if (mdoel.forumImgs.count > 0) {
                    return [self.tableView cellHeightForIndexPath:indexPath model:mdoel keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width] + kImgWidth;
                    
                }else{
                    return [self.tableView cellHeightForIndexPath:indexPath model:mdoel keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width];
                }
            }
        }
    
    return 80;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else{
        return self.modelnewsLsit.count;
    }
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"广场界面\"}"];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isResfure"]) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}


- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    //    [UBT logTrace:@"residenceTimeOut"; content:@"{\"VC\":\"\u9996\u9875\"}";
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"广场界面\"}"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isResfure"];

    
}

@end
