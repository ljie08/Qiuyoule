//
//  MXSSMyPostViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSMyPostViewController.h"
#import "MXssMyPostTableViewCell.h"//我的发帖cell
#import "MXssPostModel.h"
#import "MXSYJPostDetailsController.h"//帖子详情页面

@interface MXSSMyPostViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *postArray;//post发帖list
@property (nonatomic,strong) NSMutableArray *gentieArray;//跟帖list
@property (nonatomic,strong) NSMutableArray *forumImgsArray;//forumImgs发帖list
@property (nonatomic,strong) NSMutableArray *gentieImageArrays;//跟帖forumImgs
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic,strong) MXssPostModel *postListImageModel;

@property (nonatomic , assign) NSInteger page ;//页数加载
@property (nonatomic , assign) NSInteger pageAtte;//
@property (nonatomic , assign)BOOL isHeaderRefresh;

@end

@implementation MXSSMyPostViewController{
    UITableView *_tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mainTableview];
    //页数
    self.page = 1;
    self.pageAtte = 1;
    self.postArray = [NSMutableArray array];//发帖list数组
    self.forumImgsArray = [NSMutableArray array];//发帖图片存储
    self.gentieArray = [NSMutableArray array];//跟帖list数组
    self.gentieImageArrays = [NSMutableArray array];//跟帖图片存储
     [self getFindMyPostingData:self.yesOrOnString];//发帖数据请求
    //上拉下拉刷新
    self.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.yesOrOnString isEqualToString:@"发帖"]) {
            self.page = 1 ;
            self.postArray = [NSMutableArray array];//发帖list数组
            self.forumImgsArray = [NSMutableArray array];//发帖图片存储
        }else{
            self.pageAtte = 1;
        self.gentieArray = [NSMutableArray array];//跟帖list数组
        self.gentieImageArrays = [NSMutableArray array];//跟帖图片存储
        }
        self.isHeaderRefresh = YES;
        [self getFindMyPostingData:self.yesOrOnString];//发帖数据请求
    }];
    self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self.yesOrOnString isEqualToString:@"发帖"]) {
                if (self.postArray.count %10 == 0) {
                    self.page ++ ;
                    self.isHeaderRefresh = NO;
                    [self getFindMyPostingData:self.yesOrOnString];
                }
            }else {
                if (self.gentieArray.count %10 == 0) {
                    self.pageAtte ++ ;
                    self.isHeaderRefresh = NO;
                    [self getFindMyPostingData:self.yesOrOnString];
                }
            }
            [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
        });
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.yesOrOnString isEqualToString:@"发帖"]) {
        if (self.postArray.count == 0) {
            [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
            //消除尾部"没有更多数据"的状态
            self.mainTableview.mj_footer.hidden = YES ;
        }else{
            [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
        }
    }else{
        if (self.gentieArray.count == 0) {
            [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
            //消除尾部"没有更多数据"的状态
            self.mainTableview.mj_footer.hidden = YES ;
        }else{
            [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
        }
    }
}
#pragma mark ---Posting comments Data 发帖、跟帖数据
-(void)getFindMyPostingData:(NSString*)stringNameTitle{
    
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = @"";

    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    if ([stringNameTitle isEqualToString:@"发帖"]) {
        url = MXWodemFindMyPosting_PATH;//请求发帖数据接口
        [paraDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    }else {
         url = MXWodemFindMycomments_PATH;//请求跟帖数据接口
        [paraDic setObject:[NSString stringWithFormat:@"%ld",self.pageAtte] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    }
    
    [paraDic setObject:@"10" forKey:@"limit"];//分页起始位置
     [SVProgressHUD showWithStatus:@"正在加载..."];
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"发帖、跟帖数据==%@",personDic);
        [weakSelf.mainTableview.mj_header endRefreshing];
        NSArray *arrayList = [personDic objectForKey:@"data"];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
            [SVProgressHUD dismiss];
            [self.mainTableview.mj_header endRefreshing];
            if (self.isHeaderRefresh == YES) {
                if ([stringNameTitle isEqualToString:@"发帖"]) {
                    [weakSelf.postArray removeAllObjects];
                }else {
                    [weakSelf.gentieArray removeAllObjects];
                }
            }
            if ([stringNameTitle isEqualToString:@"发帖"]) {
                for (NSDictionary *dictt in arrayList) {
                    MXssPostModel *postModel = [MXssPostModel modelWithDictionary:dictt];
                    self.forumImgsArray = [NSMutableArray array];
                    NSArray *forumImgsarr = dictt[@"forumImgs"];
                    for (NSDictionary *dicttImage in forumImgsarr) {
                        imageUrlModel *brokerModel = [imageUrlModel modelWithDictionary:dicttImage];
                        [self.forumImgsArray addObject:brokerModel];
                    }
                    postModel.forumImgs = self.forumImgsArray.copy;
                    [self.postArray addObject:postModel];
                }
                if (self.postArray.count == 0) {
                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                    //消除尾部"没有更多数据"的状态
                    weakSelf.mainTableview.mj_footer.hidden = YES ;
                }else{
                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                    
                }
                if (self.postArray.count < 10) {
                    [weakSelf.mainTableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelf.mainTableview.mj_footer endRefreshing];
                    //消除尾部"没有更多数据"的状态
                    weakSelf.mainTableview.mj_footer.hidden = NO ;
                }
                [weakSelf.mainTableview reloadData];
            }else {
                for (NSDictionary *dictt in arrayList) {
                    MXssPostModel *postModel = [MXssPostModel modelWithDictionary:dictt];
                    self.gentieImageArrays = [NSMutableArray array];
                    NSArray *forumImgsarr = dictt[@"forumImgs"];
                    for (NSDictionary *dicttImage in forumImgsarr) {
                        imageUrlModel *brokerModel = [imageUrlModel modelWithDictionary:dicttImage];
                        [self.gentieImageArrays addObject:brokerModel];
                    }
                    postModel.forumImgs = self.gentieImageArrays.copy;
                    [self.gentieArray addObject:postModel];
                }
                if (self.gentieArray.count == 0) {
                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
//                    //消除尾部"没有更多数据"的状态
                    weakSelf.mainTableview.mj_footer.hidden = YES ;
                }else{
                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
                }
                
                if (self.gentieArray.count < 10) {
                    [weakSelf.mainTableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [weakSelf.mainTableview.mj_footer endRefreshing];
                    //消除尾部"没有更多数据"的状态
                    weakSelf.mainTableview.mj_footer.hidden = NO ;
                }
                [weakSelf.mainTableview reloadData];
            }
            
        }else if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
            //请先登录
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            login.isPageNumber = 1;
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:nil];
        }else {
            [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
//        [self.mainTableview.mj_header endRefreshing];
//        [self.mainTableview.mj_footer endRefreshing];
    }];
}

#pragma mark-set/get
-(UITableView *)mainTableview{
    if (_mainTableview == nil) {
        _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(44)) style:UITableViewStylePlain];
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        //        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏整体cell线
        _mainTableview.backgroundColor = mx_Wode_backgroundColor;
        [_mainTableview registerClass:[MXssMyPostTableViewCell class] forCellReuseIdentifier:@"collectionCell"];
        _mainTableview.showsVerticalScrollIndicator = false;//上下滑动关闭滚动的显示
        _mainTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        /**
         *  将tableview的分割线补满
         */
        if ([_mainTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableview setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_mainTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableview setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _mainTableview;
}
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return scaleWithSize(1.0f);//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark mainTableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.yesOrOnString isEqualToString:@"发帖"]) {
    if (self.postArray.count>0) {
        return self.postArray.count;
    }else {
        return 0;
    }
    }else {
        if (self.gentieArray.count>0) {
            return self.gentieArray.count;
        }else {
            return 0;
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return scaleWithSize(105);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"collectionCell";//cell重用问题
    MXssMyPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXssMyPostTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //            cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
    cell.backgroundColor = [UIColor whiteColor];

    if ([self.yesOrOnString isEqualToString:@"发帖"]) {
        if (self.postArray.count>0) {
        
        MXssPostModel *postmodels = self.postArray[indexPath.row];
        //        NSLog(@"????🚗骑车=%ld",postmodels.forumImgs.count);
        if (postmodels.forumImgs.count > 0||([postmodels.channelName isEqualToString:@"官方发布"]&&(![postmodels.imgUrl isEqualToString:@""]))) {
            cell.myPostImage.hidden = NO;
            cell.zongViewl.frame = CGRectMake(cell.myPostImage.frame.size.width + scaleWithSize(20), scaleWithSize(10), screen_width - cell.myPostImage.frame.size.width - scaleWithSize(30), scaleWithSize(80));
            cell.numberSumView.frame = CGRectMake(cell.zongViewl.frame.size.width - scaleWithSize(190),cell.zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10));
            cell.myPostTitleNameLabel.frame = CGRectMake(0, 0, cell.zongViewl.frame.size.width, 20);
            cell.myPostContentLabel.frame = CGRectMake(0, 22, cell.zongViewl.frame.size.width, 45);
//            imageUrlModel *imPomodel = postmodels.forumImgs[0];
            cell.myPostImage.contentMode = UIViewContentModeScaleAspectFill;//图片自适应UIViewContentModeScaleAspectFill
            cell.myPostImage.clipsToBounds = true;
            [cell.myPostImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", postmodels.imgUrl]]placeholderImage:[UIImage imageNamed:@"topPlace"]];
        }else {
            cell.myPostImage.hidden = YES;
            cell.zongViewl.frame = CGRectMake(scaleWithSize(10), scaleWithSize(10), screen_width - scaleWithSize(20), scaleWithSize(80));
            cell.numberSumView.frame = CGRectMake(screen_width - scaleWithSize(210), scaleWithSize(77), scaleWithSize(190), 10);
//            cell.numberSumView.frame = CGRectMake(cell.zongViewl.frame.size.width - scaleWithSize(190),cell.zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10));
            cell.myPostTitleNameLabel.frame = CGRectMake(0, 0, cell.zongViewl.frame.size.width, 20);
            cell.myPostContentLabel.frame = CGRectMake(0, 22, cell.zongViewl.frame.size.width, 45);
        }
        cell.myPostTimeLabel.text = postmodels.createTime;
        NSString *string3 = [cell.myPostTimeLabel.text substringToIndex:11];//从字符串的开头截取到指定位置，但是切记标记是从0开始，不包括5位置的字符
            cell.myPostTimeLabel.text = string3;
            cell.myPostTitleNameLabel.text = postmodels.title;//被关注者论坛标题
        cell.myPostContentLabel.text = postmodels.subContent;//被关注者论坛主题内容（内容的概述）
        cell.myPostZanLabel.text = postmodels.comments;//评论数
        cell.myPostSeeLabel.text = postmodels.view;//阅读数
        }
    }else {
        if (self.gentieArray.count>0) {
            
        MXssPostModel *postmodels = self.gentieArray[indexPath.row];
            NSLog(@"??🚗🚴=%ld",postmodels.forumImgs.count);
        if (postmodels.forumImgs.count > 0||([postmodels.channelName isEqualToString:@"官方发布"]&&(![postmodels.imgUrl isEqualToString:@""]))) {
            cell.myPostImage.hidden = NO;
//            cell.zongViewl.frame = CGRectMake(cell.myPostImage.frame.size.width + 20, 10, screen_width - cell.myPostImage.frame.size.width - 30, 80);
            cell.zongViewl.frame = CGRectMake(cell.myPostImage.frame.size.width + scaleWithSize(20), scaleWithSize(10), screen_width - cell.myPostImage.frame.size.width - scaleWithSize(30), scaleWithSize(80));
            cell.numberSumView.frame = CGRectMake(cell.zongViewl.frame.size.width - scaleWithSize(190),cell.zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10));
            cell.myPostTitleNameLabel.frame = CGRectMake(0, 0, cell.zongViewl.frame.size.width, 20);
            cell.myPostContentLabel.frame = CGRectMake(0, 22, cell.zongViewl.frame.size.width, 45);
//            imageUrlModel *imPomodel = postmodels.forumImgs[0];
            cell.myPostImage.contentMode = UIViewContentModeScaleAspectFill;//图片自适应UIViewContentModeScaleAspectFill
            cell.myPostImage.clipsToBounds = true;
            [cell.myPostImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", postmodels.imgUrl]]placeholderImage:[UIImage imageNamed:@"topPlace"]];
        }else {
            cell.myPostImage.hidden = YES;
//            cell.zongViewl.frame = CGRectMake(10, 10, screen_width - 20, 80);
             cell.zongViewl.frame = CGRectMake(scaleWithSize(10), scaleWithSize(10), screen_width - scaleWithSize(20), scaleWithSize(80));
            cell.numberSumView.frame = CGRectMake(screen_width - scaleWithSize(210), scaleWithSize(77), scaleWithSize(190), 10);
            //            cell.numberSumView.frame = CGRectMake(cell.zongViewl.frame.size.width - scaleWithSize(190),cell.zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10));
            cell.myPostTitleNameLabel.frame = CGRectMake(0, 0, cell.zongViewl.frame.size.width, 20);
            cell.myPostContentLabel.frame = CGRectMake(0, 22, cell.zongViewl.frame.size.width, 40);
        }
        cell.myPostTimeLabel.text = postmodels.createTime;
        NSString *string3 = [cell.myPostTimeLabel.text substringToIndex:11];//从字符串的开头截取到指定位置，但是切记标记是从0开始，不包括5位置的字符
        cell.myPostTimeLabel.text = string3;
        cell.myPostTitleNameLabel.text = postmodels.title;
        cell.myPostContentLabel.text = postmodels.subContent;
        cell.myPostZanLabel.text = postmodels.comments;//评论数
        cell.myPostSeeLabel.text = postmodels.view;
        }
    }
    return cell;
}
// 隐藏多余cell
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//cell点击
    NSLog(@"我的帖子点击cell?????==%ld",indexPath.row);
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
     if ([self.yesOrOnString isEqualToString:@"发帖"]) {
    MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
    MXssPostModel *mdoel = self.postArray[indexPath.row];
    vc.newsID = mdoel.newsId;
    vc.userId = userModel.userId;
    [self.navigationController pushViewController:vc animated:YES];
         
         mdoel.view = [NSString stringWithFormat:@"%d",mdoel.view.intValue + 1];
         [self.postArray replaceObjectAtIndex:indexPath.row withObject:mdoel] ;
         [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
         
     }else {
//    [SVProgressHUD showInfoWithStatus:@"暂无接口数据,不可点击!!!"];
         MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
         MXssPostModel *mdoel = self.gentieArray[indexPath.row];
         vc.newsID = mdoel.newsId;
         vc.userId = userModel.userId;
         [self.navigationController pushViewController:vc animated:YES];
         
         mdoel.view = [NSString stringWithFormat:@"%d",mdoel.view.intValue + 1];
         [self.gentieArray replaceObjectAtIndex:indexPath.row withObject:mdoel] ;
         [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
     }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    //    [self initTitleViewWithTitle:@"发帖"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    if ([self.yesOrOnString isEqualToString:@"发帖"]) {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"发帖界面\"}"];
    }else {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"跟帖界面\"}"];
    }
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    if ([self.yesOrOnString isEqualToString:@"发帖"]) {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"发帖界面\"}"];
        if (self.postArray.count > 0) {
            [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
        }
    }else {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"跟帖界面\"}"];
        if (self.gentieArray.count > 0) {
            [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
        }
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
