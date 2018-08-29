//
//  MXSSBallGameCollectionViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSBallGameCollectionViewController.h"
//#import "MXSSBallGameCollectionTableViewCell.h"
#import "MXEventTableViewCell.h"//球赛cell
#import "MXssMyCollectGameModel.h"//我的收藏球赛的model
#import "MXDEventTableVCell.h"

@interface MXSSBallGameCollectionViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int indexRow;
    
}
@property (nonatomic , assign) NSInteger page ;//页数加载
@property (nonatomic , assign)BOOL isHeaderRefresh;
//多选删除
@property (nonatomic,strong)UIView *deleViews;

@property (nonatomic,assign) BOOL yesCellOrNo;
@property (nonatomic , strong)UIButton *delButList;//删除 垃圾桶按钮

@end

@implementation MXSSBallGameCollectionViewController


#pragma mark ---CollectForum Data 个人收藏球赛数据
-(void)CollectForumListData:(NSString*)numberStrPage{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMyFindCollectMatches_PATH;//请求个人收藏列表数据接口
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    [paraDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    [paraDic setObject:@"10" forKey:@"limit"];//分页起始位置
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"收藏球赛数据==%@",personDic);
        [weakSelf.mainTableview.mj_header endRefreshing];
        
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
            [SVProgressHUD dismiss];
            [self.mainTableview.mj_header endRefreshing];
            if (self.isHeaderRefresh == YES) {
                [weakSelf.ballGameDataArray removeAllObjects];
            }
            if ([personDic[@"data"] count]) {
                if (weakSelf.page == 1) {
//                    MXssMyCollectGameModel *postModel = [MXssMyCollectGameModel modelWithDictionary:personDic[@"data"]];
//                    [weakSelf.ballGameDataArray addObject:postModel];
                    weakSelf.ballGameDataArray = [MXssMyCollectGameModel mj_objectArrayWithKeyValuesArray:personDic[@"data"]] ;
                } else {
                    NSMutableArray * array = [MXssMyCollectGameModel mj_objectArrayWithKeyValuesArray:personDic[@"data"]] ;
                    [weakSelf.ballGameDataArray addObjectsFromArray:array];
                }
            }
            if (weakSelf.ballGameDataArray.count == 0) {
                [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
                //消除尾部"没有更多数据"的状态
                weakSelf.mainTableview.mj_footer.hidden = YES ;
            }else{
                [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            }
            if (self.ballGameDataArray.count < 10) {
                [weakSelf.mainTableview.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.mainTableview.mj_footer endRefreshing];
            }
            [weakSelf.mainTableview reloadData];
            
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
        if (weakSelf.ballGameDataArray.count == 0) {
            [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
            //消除尾部"没有更多数据"的状态
            weakSelf.mainTableview.mj_footer.hidden = YES ;
        }else{
            [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
        }
    }];
}

- (void)setBallGameDataArray:(NSMutableArray *)ballGameDataArray {
    _ballGameDataArray =ballGameDataArray;
    //消除尾部"没有更多数据"的状态
//    self.mainTableview.mj_footer.hidden = YES ;
    [self.mainTableview reloadData];
}

- (UIView *)deleViews {//收藏的球赛页面的 删除处理
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
    if (self.dataArraySum.count>0) {
////         103 删除收藏球赛---多选删除
//        extern NSString *const MXWodeMyDeleteCollMatchesById_PATH;
        NSLog(@"收藏球赛删除的点击");
        
        MXssMyCollectGameModel *postmodels = self.dataArraySum[0];
        NSString *strId = postmodels.collectId;
        for (int i = 1; i < self.dataArraySum.count; i++) {
            MXssMyCollectGameModel *postmodels = self.dataArraySum[i];
            NSLog(@"%@",postmodels.collectId);
            strId = [NSString stringWithFormat:@"%@,%@",strId,postmodels.collectId];
        }
        NSLog(@"总？=%@",strId);
        [self deleteCollestNewByIdListData:strId];
        _mainTableview.frame = CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(13) - scaleWithSize(0));
        self.deleViews.hidden = YES;
        self.yesCellOrNo = NO;
        
    }else{
        NSLog(@"收藏球赛删除的不可以点击");
    }
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
    NSString *url = MXWodeMyDeleteCollMatchesById_PATH;//多选删除收藏球赛
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    [paraDic setObject:numberStrPage forKey:@"collectId"];//eg（1，2）逗号分隔（收藏球赛的collectId）
    //    [paraDic setObject:[NSString stringWithFormat:@"%ld",self.page] forKey:@"page"];//分页起始位置  例如：page=1&limit=10（第一页取十条）
    //    [paraDic setObject:@"10" forKey:@"limit"];//分页起始位置
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"收藏球赛⚽️多选删除的数据==%@",personDic);
        
        [weakSelf.mainTableview.mj_header endRefreshing];
        //        NSArray *arrayList = [personDic objectForKey:@"data"];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
            [self.delegate BallGameCollectionNewDeleUpdateViewController];//删除后刷新页面传值
            self.ballGameDataArray = [NSMutableArray array];
            weakSelf.page = 1 ;
            self.isHeaderRefresh = YES;
            [self CollectForumListData:@"球赛"];//收藏球赛数据
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
    }];
}
- (void)setYesCell:(BOOL)yesCell {//收藏的球赛页面的 删除处理
    _yesCell = yesCell;
    if (self.yesCell) {
        _mainTableview.frame = CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(13) - scaleWithSize(90));
        self.deleViews.hidden = NO;
       
        self.yesCellOrNo = YES;
        
    }else{
        _mainTableview.frame = CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - scaleWithSize(13) - scaleWithSize(0));
        self.deleViews.hidden = YES;
        self.yesCellOrNo = NO;
         [self.dataArraySum removeAllObjects];
        
        for (int i = 0; i < self.ballGameDataArray.count; i++) {
             MXssMyCollectGameModel *postmodels =self.ballGameDataArray[i];
            postmodels.yesOrNo = 0;
        }
    }
    [self.mainTableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //多选删除
    self.yesCellOrNo = NO;
    self.dataArraySum = [NSMutableArray array];//多选数组
    [self.view addSubview:self.deleViews];
    
    self.ballGameDataArray = [NSMutableArray array];
    [self.view addSubview:self.mainTableview];
    mx_weakify(self) ;
    
    weakSelf.page = 1 ;
    //    [self CollectForumListData:@"球赛"];//收藏球赛数据
    //消除尾部"没有更多数据"的状态
//    self.mainTableview.mj_footer.hidden = YES ;
    //上拉下拉刷新
    self.mainTableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.ballGameDataArray = [NSMutableArray array];
        [self.dataArraySum removeAllObjects];//多选的数组存放
        for (int i = 0; i < self.ballGameDataArray.count; i++) {
            MXssMyCollectGameModel *postmodels =self.ballGameDataArray[i];
            postmodels.yesOrNo = 0;
        }
        weakSelf.page = 1 ;
        self.isHeaderRefresh = YES;
        [self CollectForumListData:@"球赛"];//收藏球赛数据
    }];
    self.mainTableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.ballGameDataArray.count %10 == 0) {
                weakSelf.page ++ ;
                self.isHeaderRefresh = NO;
                [self CollectForumListData:@"球赛"];//收藏球赛数据
            }
            [self.mainTableview.mj_footer endRefreshingWithNoMoreData];
        });
        
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
        //        [_mainTableview registerClass:[MXEventTableViewCell class] forCellReuseIdentifier:@"collectionCell"];
        [_mainTableview registerNib:[UINib nibWithNibName:@"MXEventTableViewCell" bundle:nil] forCellReuseIdentifier:@"collectionCell"];
        _mainTableview.showsVerticalScrollIndicator = false;//上下滑动关闭滚动的显示
        //消除尾部"没有更多数据"的状态
        _mainTableview.mj_footer.hidden = YES ;
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
    if (self.ballGameDataArray.count) {
        return self.ballGameDataArray.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return scaleWithSize(84);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 0) {
    static NSString *CellIdentifier = @"collectionCell";//cell重用问题
    MXEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXEventTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
    
    if (self.ballGameDataArray.count>0) {
        MXssMyCollectGameModel *MyevenListModel =self.ballGameDataArray[indexPath.row];
        //     cell.MyevenListModel = self.ballGameDataArray[indexPath.row];//我的收藏球赛的model
        cell.NumberOfPeriods.text = [NSString stringWithFormat:@"%@  %@",MyevenListModel.eventNm, [MXLJUtil timeInterverlToDateStr:MyevenListModel.matchStartTime]];

        cell.numberL1.text = [NSString stringWithFormat:@"%@",MyevenListModel.homeScore] ;
        cell.numberL2.text = [NSString stringWithFormat:@"%@",MyevenListModel.awayScore] ;
        cell.imgView.hidden = YES;
//        if (MyevenListModel.isCollect) {
//            cell.imgView.image = Image(@"saishi_naozhong_hong") ;
//        } else {
//            cell.imgView.image = Image(@"saishi_naozhong") ;
//        }

        cell.TeamNameL1.text = MyevenListModel.homeNm ;
        cell.TeamNameL2.text = MyevenListModel.awayNm ;
        cell.ExpertName.hidden = YES;//xxx专家解读隐藏
        cell.numberL1.textColor = mx_Wode_color16a635;
        cell.numberL2.textColor = mx_Wode_color16a635;

        switch (MyevenListModel.matchStatus.intValue) {
            case 0:
                cell.timeLabel.text = @"异" ;
                break;
            case 1:
                cell.timeLabel.text = @"未" ;
                break;
            case 8:
                cell.timeLabel.text = @"完" ;
                cell.imgView.hidden = YES ;
                break;
            case 9:
                cell.timeLabel.text = @"推迟" ;
                break;
            case 10:
                cell.timeLabel.text = @"中断" ;
                break;
            case 11:
                cell.timeLabel.text = @"腰斩" ;
                break;
            case 12:
                cell.timeLabel.text = @"取消" ;
                break;
            case 13:
                cell.timeLabel.text = @"待定" ;
                break;

            default://当前时间-开始的时间 matchStartTime
            { NSDate *senddate = [NSDate date];
                //            NSLog(@"date1时间戳 = %ld",time(NULL));
                NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
                //            NSLog(@"date2时间戳 = %@",date2);
                cell.timeLabel.text = [NSString stringWithFormat:@"%d'",(int)(date2.doubleValue - MyevenListModel.matchStartTime.doubleValue)/60];
            }
                break;
        }
        cell.eventCollectMatcheBlock = ^{
            NSLog(@"🚗🚫==%ld",indexPath.row) ;
        };
        if (self.yesCellOrNo) {
            NSLog(@"点击多选按钮显示");
            cell.selctButton.hidden = NO ;//显示多选按钮
             [cell.selctButton setImage:[UIImage imageNamed:@"my_duoxuan_weixuanzhong"] forState:UIControlStateNormal];
            if (self.dataArraySum.count>0) {
                 [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_xuanzhong"] forState:UIControlStateNormal];//垃圾桶删除不可点击
            }else {
                [self.delButList setImage:[UIImage imageNamed:@"my_lajixiang_weixuanzhong"] forState:UIControlStateNormal];//垃圾桶删除不可点击
            }
        }else {
            cell.selctButton.hidden = YES;//
        }
        if (MyevenListModel.yesOrNo) {
             [cell.selctButton setImage:[UIImage imageNamed:@"my_duoxuan_xuanzhong"] forState:UIControlStateNormal];
        }else {
             [cell.selctButton setImage:[UIImage imageNamed:@"my_duoxuan_weixuanzhong"] forState:UIControlStateNormal];
        }
    }
    cell.selctButton.tag = indexPath.row;
   
    [cell.selctButton addTarget:self action:@selector(duoxuanButtonClick:) forControlEvents:UIControlEventTouchUpInside];//多选的按钮点击
    return cell;
}

- (void)duoxuanButtonClick:(UIButton*)sender {
    MXssMyCollectGameModel *postmodels =self.ballGameDataArray[sender.tag];
    if (postmodels.yesOrNo == 0) { //改行在选择的数组里面有记录
        [sender setImage:[UIImage imageNamed:@"my_duoxuan_xuanzhong"] forState:UIControlStateNormal];
        postmodels.yesOrNo = 1;
        [self.dataArraySum addObject:postmodels];
    }else {
        [sender setImage:[UIImage imageNamed:@"my_duoxuan_weixuanzhong"] forState:UIControlStateNormal];
        postmodels.yesOrNo = 0;
        [self.dataArraySum removeObject:postmodels];
    }
    NSLog(@"多选的数组存储🍐=%@",self.dataArraySum);
    if (self.dataArraySum.count>0) {
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
    NSLog(@"球赛收藏点击cell?????==%ld",indexPath.row);
    //    [SVProgressHUD showInfoWithStatus:@"暂无数据接口"];
    MXssMyCollectGameModel * model = self.ballGameDataArray[indexPath.row] ;
    [self.delegate buyBallGameCollectionViewController:nil withResult:nil andBallGameModel:model];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)buyBallGameCollectionViewController:(MXSSBallGameCollectionViewController *)VC withResult:(NSDictionary *)result andBallGameModel:(MXssMyCollectGameModel *)model {
    NSLog(@"球赛收藏——可爱😊🐶🐱");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
