//
//  MXSSArticleCollectionViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSArticleCollectionViewController.h"
#import "MXSSArticleCollectionTableViewCell.h"
//#import "MXssMyPostTableViewCell.h"//cell
#import "MXssCollectionModel.h"//
//#import "MXSYJPostDetailsController.h"

@interface MXSSArticleCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic, strong) NSMutableArray *modelArr;
//@property (nonatomic,strong) NSMutableArray *forumImgsArray;//forumImgs发帖list
@property (nonatomic,strong)UIView *deleViews;

//@property (strong, nonatomic) NSMutableArray *selectIndexs;//多选选中的行
@property (nonatomic,assign) BOOL yesCellOrNo;
//@property (nonatomic , assign) NSInteger page ;//页数加载
//@property (nonatomic , assign)BOOL isHeaderRefresh;
@property (nonatomic , strong)UIButton *delButList;//删除 垃圾桶按钮
@property (nonatomic,strong) NSMutableArray *forumImgsArray;//forumImgs发帖list
@property (nonatomic , assign)BOOL isHeaderRefresh;
@property (nonatomic , assign) NSInteger page ;//页数加载
@end

@implementation MXSSArticleCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.yesCellOrNo = NO;
    self.dataArray = [NSMutableArray array];//多选数组
    //    _selectIndexs = [NSMutableArray new];//多行选中
    //    self.modelArr = [NSMutableArray array];
        self.forumImgsArray = [NSMutableArray array];
    [self.view addSubview:self.mainTableview];
    [self.view addSubview:self.deleViews];
    //    //页数
        self.page = 1;
    //    [self CollectForumListData:@"文章"];//收藏文章数据
    ////    //消除尾部"没有更多数据"的状态
    //        self.mainTableview.mj_footer.hidden = YES ;
    //    //上拉下拉刷新
    //    mx_weakify(self) ;
    //    self.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        self.modelArr = [NSMutableArray array];
    //        self.forumImgsArray = [NSMutableArray array];
    //        weakSelf.page = 1 ;
    //        self.isHeaderRefresh = YES;
    //        [self CollectForumListData:@"文章"];//收藏文章数据
    //    }];
//        self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if (self.collectDataArr.count %10 == 0) {
//                    self.page ++ ;
//                     self.forumImgsArray = [NSMutableArray array];
//                    self.isHeaderRefresh = NO;
//                    [self CollectForumListData:@"文章"];//收藏文章数据
//                }
//                [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
//            });
//    
//        }];
    
//    self.articleCollectionView.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if (self.collectionDataArrs.count %10 == 0) {
//                weakSelf.page ++ ;
//                self.forumImgsArray = [NSMutableArray array];
//                self.isHeaderRefresh = NO;
//
//                [self CollectForumListData:@"文章"];//收藏文章数据
//
//            }
//            [self.articleCollectionView.mainTableview.mj_footer endRefreshingWithNoMoreData];
//        });
//
//    }];
}
#pragma mark ---CollectForum Data 个人收藏球赛数据
//-(void)CollectForumListData:(NSString*)numberStrPage{
//
//    [SVProgressHUD showWithStatus:@"正在加载..."];
//    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
//    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
//    NSString *token = userModel.token;
//    NSString *timeStr = [MXLJUtil getNowDateTimeString];
//    NSString *url =@"";
//    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//        url=MXWodeMyCollectForum_PATH;//请求个人收藏文章列表数据接口
//        [paraDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
//    [paraDic setObject:userid forKey:@"userId"];//用户ID
//    [paraDic setObject:token forKey:@"token"];//用户token
//    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
//
//    [paraDic setObject:@"10" forKey:@"limit"];//分页起始位置
//
//    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
////    mx_weakify(self);
//    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
//        NSLog(@"收藏球赛？文章数据🍎=%% %@",personDic);
//        //        [weakSelf.mainTableview.mj_header endRefreshing];
//
//        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
//            //加载处理
//            [SVProgressHUD dismiss];
//            [self.mainTableview.mj_header endRefreshing];
//            if (self.isHeaderRefresh == YES) {
//                [self.collectDataArr removeAllObjects];
//            }
//
//                NSArray *arrayList = [personDic objectForKey:@"data"];
//                for (NSDictionary *dictt in arrayList) {
//                    MXssCollectionModel *postModel = [MXssCollectionModel modelWithDictionary:dictt];
//                    NSArray *forumImgsarr = dictt[@"forumImgs"];
//                    NSMutableArray *forumImgsArray = [NSMutableArray array];
//                    //                    NSLog(@"????==%@",forumImgsarr);
//                    for (NSDictionary *dicttImage in forumImgsarr) {
//                        imageUrlModelColl *brokerModel = [imageUrlModelColl modelWithDictionary:dicttImage];
//                        [forumImgsArray addObject:brokerModel];
//                    }
//                    postModel.forumImgs = forumImgsArray.copy;
//                    [self.collectDataArr addObject:postModel];
//
//                }
////                self.collectDataArr = self.collectDataArr;//传值
//                // [self.articleCollectionView.mainTableview reloadData];//刷新
//
//                if (self.collectDataArr.count == 0) {
//                    [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
//                    //消除尾部"没有更多数据"的状态
//                    self.mainTableview.mj_footer.hidden = YES ;
//                }else{
//                    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
//                }
//                //消除尾部"没有更多数据"的状态
//                //                self.articleCollectionView.mainTableview.mj_footer.hidden = YES ;
//                if (self.collectDataArr.count < 10) {
//                    [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
//                }else{
//                    [self.mainTableview.mj_footer endRefreshing];
//                }
//                [self.mainTableview reloadData];
//
//        }else {
//
//            if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
//                //请先登录
//                MXLoginViewController *login = [[MXLoginViewController alloc] init];
//                login.isPageNumber = 1;
//                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
//                [self presentViewController:nav animated:YES completion:nil];
//            }else {
//                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
//            }
//        }
//
//    } failure:^(NSString *error) {
//        [SVProgressHUD showErrorWithStatus:error];
//    }];
//}
- (void)setCollectDataArr:(NSMutableArray *)collectDataArr{
    _collectDataArr = collectDataArr;
    //消除尾部"没有更多数据"的状态
    //    self.mainTableview.mj_footer.hidden = YES ;
    
    [_mainTableview reloadData];
}
- (UIView *)deleViews {//收藏的文章页面的 删除处理
    if (_deleViews==nil) {
        _deleViews = [[UIView alloc] initWithFrame:CGRectMake(0, screen_height - STATUS_AND_NAVIGATION_HEIGHT - scaleWithSize(100) - TABBAR_FRAME, screen_width, scaleWithSize(60))];
        _deleViews.backgroundColor = mx_Wode_colorBlue2374e4;
        _deleViews.hidden = YES;
        self.delButList = [UIButton buttonWithType:UIButtonTypeCustom];
        self.delButList.frame = CGRectMake(screen_width - scaleWithSize(100), scaleWithSize(5), scaleWithSize(80), scaleWithSize(40));
        [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_weixuanzhong"] forState:UIControlStateNormal];
        [self.delButList addTarget:self action:@selector(deleButClick:) forControlEvents:UIControlEventTouchUpInside];
        [_deleViews addSubview:self.delButList];
    }
    return _deleViews;
}
- (void)deleButClick:(UIButton *)sender {
    if (self.dataArray.count>0) {
        //        // 104 删除收藏文章---多选删除
        //        extern NSString *const MXWodeMyDeleteCollestNewById_PATH;
        NSLog(@"收藏文章删除的点击");
        //        [SVProgressHUD showErrorWithStatus:@"暂无后台数据接口"];
        MXssCollectionModel *postmodels = self.dataArray[0];
        NSString *strId = postmodels.collectId;
        for (int i = 1; i < _dataArray.count; i++) {
            MXssCollectionModel *postmodels = self.dataArray[i];
            NSLog(@"%@",postmodels.collectId);
            strId = [NSString stringWithFormat:@"%@,%@",strId,postmodels.collectId];
        }
        NSLog(@"总？=%@",strId);
        [self deleteCollestNewByIdListData:strId];
        _mainTableview.frame = CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(13) - scaleWithSize(0));
        self.deleViews.hidden = YES;
        self.yesCellOrNo = NO;
    }else{
        NSLog(@"收藏文章删除的不可以点击");
    }
}

- (void)setYesCell:(BOOL)yesCell {//收藏的文章页面的 删除处理
    _yesCell = yesCell;
//    [self.dataArray removeAllObjects];
    if (self.yesCell) {
        _mainTableview.frame = CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(13) - scaleWithSize(90));
        self.deleViews.hidden = NO;
        self.yesCellOrNo = YES;
        
    }else{
        _mainTableview.frame = CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(13) - scaleWithSize(0));
        self.deleViews.hidden = YES;
        self.yesCellOrNo = NO;
        [self.dataArray removeAllObjects];
        for (int i = 0; i < self.collectDataArr.count; i++) {
            MXssCollectionModel *postmodels = self.collectDataArr[i];
            postmodels.yesOrNo = 0;
        }
    }
    [_mainTableview reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    if (self.modelArr.count == 0) {
    //        [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
    //        //消除尾部"没有更多数据"的状态
    //        self.mainTableview.mj_footer.hidden = YES ;
    //    }else{
    //        [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
    //    }
}
#pragma mark ---deleteCollestNewById Data 个人收藏文章数据多选删除
-(void)deleteCollestNewByIdListData:(NSString*)numberStrPage{
    //    bigCaiPiaoArrHome= [NSMutableArray array];
    [SVProgressHUD showWithStatus:@"正在加载..."];
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    //    NSString *url = MXWodeMyCollectForum_PATH;//请求个人收藏列表数据接口
    NSString *url = MXWodeMyDeleteCollestNewById_PATH;//多选删除收藏文章
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    [paraDic setObject:numberStrPage forKey:@"collectId"];//eg（1，2）逗号分隔（收藏球赛的collectId）
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"收藏文章多选删除的数据==%@",personDic);
        
        [weakSelf.mainTableview.mj_header endRefreshing];
        //        NSArray *arrayList = [personDic objectForKey:@"data"];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            [self.delegate ArticleCollectionNewDeleUpdateViewController:nil];//删除后刷新页面传值
        }else {
            
            if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
                //请先登录
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                login.isPageNumber = 1;
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
            }else {
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        //        if (self.modelArr.count == 0) {
        //            [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
        //            //消除尾部"没有更多数据"的状态
        //            self.mainTableview.mj_footer.hidden = YES ;
        //        }else{
        //            [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
        //        }
    }];
}
#pragma mark-set/get
-(UITableView *)mainTableview{
    if (_mainTableview == nil) {
        _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(13)) style:UITableViewStyleGrouped];
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        //        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏整体cell线
        _mainTableview.backgroundColor = mx_Wode_backgroundColor;
        [_mainTableview registerClass:[MXSSArticleCollectionTableViewCell class] forCellReuseIdentifier:@"collectionCell"];
        _mainTableview.showsVerticalScrollIndicator = false;//上下滑动关闭滚动的显示
        //        _mainTableview.showsVerticalScrollIndicator = false;
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
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark mainTableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return self.numDataArr.count;
    if (self.collectDataArr.count > 0) {
        return self.collectDataArr.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return scaleWithSize(105);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"collectionCell";//cell重用问题
    
    MXSSArticleCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXSSArticleCollectionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //            cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
    cell.backgroundColor = [UIColor whiteColor];
    //   cell.selectedBackgroundView = [[UIView alloc] init];//灰色
    if (self.collectDataArr.count > 0) {
        MXssCollectionModel *postmodels = self.collectDataArr[indexPath.row];
        if (self.yesCellOrNo) {
//            cell.duoBut.hidden = NO;//多选按钮显示
            cell.duoBut.frame = CGRectMake(scaleWithSize(0), scaleWithSize(100)/2-scaleWithSize(20), scaleWithSize(50), scaleWithSize(40));
//            [cell.duoBut setImage:[UIImage imageNamed:@"my_duoxuan_weixuanzhong"] forState:UIControlStateNormal];
            if (self.dataArray.count>0) {
                [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_xuanzhong"] forState:UIControlStateNormal];//垃圾桶删除不可点击
            }else {
                [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_weixuanzhong"] forState:UIControlStateNormal];//垃圾桶删除不可点击
            }
            if (postmodels.forumImgs.count > 0 ||([postmodels.channelName isEqualToString:@"官方发布"]&&(![postmodels.imgUrl isEqualToString:@""]))) {
                cell.collectionArticlesImage.hidden = NO;
                
                cell.collectionArticlesImage.frame = CGRectMake(cell.duoBut.maxX + scaleWithSize(-10), scaleWithSize(10), scaleWithSize(80), scaleWithSize(80));
                cell.zongViewl.frame = CGRectMake(cell.collectionArticlesImage.maxX+ scaleWithSize(10), scaleWithSize(10), screen_width - cell.collectionArticlesImage.frame.size.width -cell.duoBut.frame.size.width - scaleWithSize(30), scaleWithSize(80));
                cell.numberSumView.frame = CGRectMake(cell.zongViewl.frame.size.width - scaleWithSize(190),cell.zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10));
                cell.collectionArticlesTitleNameLabel.frame = CGRectMake(0, 0, cell.zongViewl.frame.size.width, 20);
                cell.collectionArticlesContentLabel.frame = CGRectMake(0, 22, cell.zongViewl.frame.size.width, 45);
//                imageUrlModelColl *imPomodel = postmodels.forumImgs[0];
                [cell.collectionArticlesImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", postmodels.imgUrl]]placeholderImage:[UIImage imageNamed:@"topPlace"]];
                cell.collectionArticlesImage.contentMode = UIViewContentModeScaleAspectFill;//图片自适应UIViewContentModeScaleAspectFill
                cell.collectionArticlesImage.clipsToBounds = true;
            }else {
                cell.collectionArticlesImage.hidden = YES;
                cell.zongViewl.frame = CGRectMake(scaleWithSize(-10)+ cell.duoBut.maxX, scaleWithSize(10), screen_width - scaleWithSize(10) - cell.duoBut.maxX, scaleWithSize(80));
                cell.numberSumView.frame = CGRectMake(cell.zongViewl.frame.size.width - scaleWithSize(190),cell.zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10));
                cell.collectionArticlesTitleNameLabel.frame = CGRectMake(0, 0, cell.zongViewl.frame.size.width, 20);
                cell.collectionArticlesContentLabel.frame = CGRectMake(0, 22, cell.zongViewl.frame.size.width, 45);
            }
        }else {
            cell.duoBut.hidden = YES;//多选钮不显示
            if (postmodels.forumImgs.count > 0||([postmodels.channelName isEqualToString:@"官方发布"]&&(![postmodels.imgUrl isEqualToString:@""]))) {
                cell.collectionArticlesImage.hidden = NO;
                cell.collectionArticlesImage.frame = CGRectMake(scaleWithSize(10), scaleWithSize(10), scaleWithSize(80), scaleWithSize(80));
                cell.zongViewl.frame = CGRectMake(cell.collectionArticlesImage.frame.size.width + 20, 10, screen_width - cell.collectionArticlesImage.frame.size.width - 30, 80);
                cell.numberSumView.frame = CGRectMake(cell.zongViewl.frame.size.width - scaleWithSize(190),cell.zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10));
                cell.collectionArticlesTitleNameLabel.frame = CGRectMake(0, 0, cell.zongViewl.frame.size.width, 20);
                cell.collectionArticlesContentLabel.frame = CGRectMake(0, 22, cell.zongViewl.frame.size.width, 45);
//                imageUrlModelColl *imPomodel = postmodels.forumImgs[0];
                [cell.collectionArticlesImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", postmodels.imgUrl]]placeholderImage:[UIImage imageNamed:@"topPlace"]];
                cell.collectionArticlesImage.contentMode = UIViewContentModeScaleAspectFill;//图片自适应UIViewContentModeScaleAspectFill
                cell.collectionArticlesImage.clipsToBounds = true;
                //                NSLog(@"=%ld",cell.collectionArticlesImage.contentScaleFactor);
            }else {
                cell.collectionArticlesImage.hidden = YES;
                //                cell.numberSumView.frame = CGRectMake(cell.zongViewl.frame.size.width - scaleWithSize(190),cell.zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10));
                cell.numberSumView.frame = CGRectMake(screen_width - scaleWithSize(210), scaleWithSize(77), scaleWithSize(190), 10);
                cell.zongViewl.frame = CGRectMake(10, 10, screen_width - 20, 80);
                cell.collectionArticlesTitleNameLabel.frame = CGRectMake(0, 0, cell.zongViewl.frame.size.width, 20);
                cell.collectionArticlesContentLabel.frame = CGRectMake(0, 22, cell.zongViewl.frame.size.width, 45);
            }
            //        }
        }
        cell.collectionArticlesTimeLabel.text = postmodels.createTime;
        NSString *string3 = [cell.collectionArticlesTimeLabel.text substringToIndex:11];//从字符串的开头截取到指定位置，但是切记标记是从0开始，不包括5位置的字符
        cell.collectionArticlesTimeLabel.text = string3;
        cell.collectionArticlesTitleNameLabel.text = postmodels.title;//被关注者论坛标题
        cell.collectionArticlesContentLabel.text = postmodels.subContent;//被关注者论坛主题内容（内容的概述）
        cell.collectionArticlesZanLabel.text = postmodels.comments;//被关注者论坛收藏数comments collects
        cell.collectionArticlesSeeLabel.text = postmodels.view;//被关注者论坛阅读数

        if (self.yesCellOrNo) {
            NSLog(@"点击多选按钮显示");
            cell.duoBut.hidden = NO ;//显示多选按钮
            [cell.duoBut setImage:[UIImage imageNamed:@"my_duoxuan_weixuanzhong"] forState:UIControlStateNormal];
            if (self.dataArray.count>0) {
                [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_xuanzhong"] forState:UIControlStateNormal];//垃圾桶删除不可点击
            }else {
                [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_weixuanzhong"] forState:UIControlStateNormal];//垃圾桶删除不可点击
            }
        }else {
            cell.duoBut.hidden = YES;//
        }
        if (postmodels.yesOrNo) {
            [cell.duoBut setImage:[UIImage imageNamed:@"my_duoxuan_xuanzhong"] forState:UIControlStateNormal];
        }else {
            [cell.duoBut setImage:[UIImage imageNamed:@"my_duoxuan_weixuanzhong"] forState:UIControlStateNormal];
        }
    }
     cell.duoBut.tag = indexPath.row;
    [cell.duoBut addTarget:self action:@selector(duoxuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];//多选的按钮点击
//    }
    return cell;
}
- (void)duoxuanButtonClick:(UIButton*)sender {
    MXssCollectionModel *postmodels = self.collectDataArr[sender.tag];
    if (postmodels.yesOrNo == 0) { //改行在选择的数组里面有记录
        [sender setImage:[UIImage imageNamed:@"my_duoxuan_xuanzhong"] forState:UIControlStateNormal];
        postmodels.yesOrNo = 1;
        [self.dataArray addObject:postmodels];
    }else {
        [sender setImage:[UIImage imageNamed:@"my_duoxuan_weixuanzhong"] forState:UIControlStateNormal];
        postmodels.yesOrNo = 0;
        [self.dataArray removeObject:postmodels];
    }
    NSLog(@"多选的数组存储🍐=%@",self.dataArray);
    if (self.dataArray.count>0) {
        [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_xuanzhong"] forState:UIControlStateNormal];//可以点击垃圾桶
    }else {
        [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_weixuanzhong"] forState:UIControlStateNormal];//垃圾桶删除不可点击
    }
}
// 隐藏多余cell
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//cell点击
    NSLog(@"文章收藏点击cell?????==%ld",indexPath.row);
    
    MXssCollectionModel * mdoel = self.collectDataArr[indexPath.row];
    [self.delegate buyArticleCollectionViewController:nil withResult:nil andArticleModel:mdoel];
    
    mdoel.view = [NSString stringWithFormat:@"%d",mdoel.view.intValue + 1];
    [self.collectDataArr replaceObjectAtIndex:indexPath.row withObject:mdoel] ;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)buyArticleCollectionViewController:(MXSSArticleCollectionViewController*)VC withResult:(NSDictionary*)result andArticleModel:(MXssCollectionModel*)model{
    NSLog(@"可爱😊🐶🐱");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
