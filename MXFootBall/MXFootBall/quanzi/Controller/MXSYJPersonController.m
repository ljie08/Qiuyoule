//
//  MXSYJPersonController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJPersonController.h"
#import "MXSYJPersonCell.h"
//#import "MXSYJQuanziCell.h"
//#import "MXSYJFriendsCell.h"
#import "MXSYJFocusOnModel.h"
#import "MXSYJSaisiModel.h"
#import "MXSYJPostVM.h"
#import "MXSYJPostDetailsController.h"
#import "MXSSMyVoteYESSettledTableViewCell.h"
#import "MXssPersonViewTopTwo.h"//圈子换图tableview
#import "MXReportViewController.h"

static NSString * const personCell = @"personCell";
//static NSString * const QuanziCell = @"QuanziCel";
//static NSString * const FriendsCell = @"MXSYJFriendsCell";

#define kImgWidth (screen_width - 45) / 4


@interface MXSYJPersonController ()<UITableViewDelegate,UITableViewDataSource,MXssPersonViewTopTwoDelegate>{
    
    NSInteger sengmentSecletIndex;
    NSInteger isAttention;
    NSInteger page;
    NSInteger pageTwo;
}

@property (nonatomic, strong) UISegmentedControl *segmented;

/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 帖子数 */
@property (nonatomic, strong) UILabel *postLab;
/** 粉丝数 */
@property (nonatomic, strong) UILabel *fansLab;
/** 等级 */
@property (nonatomic, strong) UILabel *levelLab;
/** 关注 */
@property (nonatomic, strong) UIButton *focusBtn;
/** 地址 */
@property (nonatomic, strong) UILabel *addressLab;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *circleArr;

@property (nonatomic, strong) NSMutableArray *circleArrTwo;
@property (nonatomic , assign)BOOL isHeaderRefresh;


@end

@implementation MXSYJPersonController


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"圈子话题界面\"}"];
    
    [self setBackButton:YES];
    [self initTitleViewWithTitle:@"个人详情"];
}


- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    //    [UBT logTrace:@"residenceTimeOut"; content:@"{\"VC\":\"\u9996\u9875\"}";
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"圈子话题界面\"}"];
    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"?????==%@",self.ownerId);
    self.circleArr = [NSMutableArray array];
    self.circleArrTwo = [NSMutableArray array];
    //加载视图
    [self setUpView];
    //加载tableView
    [self setTableView];
//  self
   
    [self getNetWork];
     page = 1;
    [self cicleNetWork:1 isSwitch:YES];
   
    mx_weakify(self);
//    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        page = 1;
//        self.circleArr = [NSMutableArray array];
//            [weakSelf cicleNetWork:1 isSwitch:YES];
//            self.personTwoTableview.hidden = YES;
//    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (sengmentSecletIndex == 0) {
                page ++;
                [weakSelf cicleNetWork:1 isSwitch:NO];
            }
        });
        
    }];
    
    self.personTwoTableview.mainTabelview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (sengmentSecletIndex == 1) {
        self.circleArrTwo = [NSMutableArray array];
        pageTwo = 1;
        self.isHeaderRefresh = YES;
        [weakSelf cicleNetWorkTwo:2 isSwitch:NO];
        }
    }];
    self.personTwoTableview.mainTabelview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (sengmentSecletIndex == 1) {
            if (self.circleArrTwo.count %10 == 0) {
                pageTwo ++ ;
                self.isHeaderRefresh = NO;
                [weakSelf cicleNetWorkTwo:2 isSwitch:NO];
            }
            
            [self.personTwoTableview.mainTabelview.mj_footer endRefreshingWithNoMoreData];
            }
        });
        
    }];
}
#pragma mark - 圈子详情
- (void)cicleNetWorkTwo:(NSInteger)type isSwitch:(BOOL)isSwitchPage{
    
    mx_weakify(self);
    [[MXSYJPostVM sharedInstance] getPersonUserId:[MXssWodeUtils loadPersonInfo].userId ownerId:self.ownerId page:pageTwo limit:10 opid:type success:^(NSDictionary *dic) {
        //加载处理
        [SVProgressHUD dismiss];
        [self.personTwoTableview.mainTabelview.mj_header endRefreshing];
        if (self.isHeaderRefresh == YES) {
            [weakSelf.circleArrTwo removeAllObjects];
        }
//        NSLog(@"圈子详情个人详情🚗=%@",dic);
        NSMutableArray *arr = [MXSYJFocusOnModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        if (arr.count < 10) {
            if (arr.count == 0) {
                weakSelf.personTwoTableview.mainTabelview.mj_footer.hidden = YES;
            }else{
                [weakSelf.personTwoTableview.mainTabelview.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [weakSelf.personTwoTableview.mainTabelview.mj_footer endRefreshing];
        }
        [weakSelf.circleArrTwo addObjectsFromArray:arr];
        
        if (weakSelf.circleArrTwo.count == 0) {
            //            [SVProgressHUD showInfoWithStatus:@"暂无内容!!"];
            [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
            //消除尾部"没有更多数据"的状态
            weakSelf.personTwoTableview.mainTabelview.mj_footer.hidden = YES ;
        }else{
            [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            //消除尾部"没有更多数据"的状态
            weakSelf.personTwoTableview.mainTabelview.mj_footer.hidden = NO ;
        }
        
        [weakSelf.personTwoTableview.mainTabelview reloadData];
        
    } failture:^(NSError *error) {
        
    }];
    
}
- (MXssPersonViewTopTwo *)personTwoTableview {
    if (!_personTwoTableview) {
        self.personTwoTableview = [[MXssPersonViewTopTwo alloc]initWithFrame:CGRectMake(0, 170, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - 170)];
        self.personTwoTableview.backgroundColor = [UIColor yellowColor];
        self.personTwoTableview.hidden = YES;
        self.personTwoTableview.delegate = self;
//        self.personTwoTableview.ownerId = self.ownerId;
        [self.view addSubview:self.personTwoTableview];
    }
    return _personTwoTableview;
}
- (void)PersonViewTopTwocellClickNext:(MXSYJFocusOnModel *)model{
    NSLog(@"%@",model);
    MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
    vc.newsID = model.newsId;
    vc.userId = [NSString stringWithFormat:@"%ld", model.userId];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 加载tableView
- (void)setTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - 120) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    //    self.tableView.backgroundColor = mx_Wode_bordColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    [self.tableView registerClass:[MXSYJPersonCell class] forCellReuseIdentifier:personCell];//MXSSMyVoteYESSettledTableViewCell
    [self.tableView registerClass:[MXSSMyVoteYESSettledTableViewCell class] forCellReuseIdentifier:personCell];
//    [self.tableView registerClass:[MXSYJQuanziCell class] forCellReuseIdentifier:QuanziCell];
//    [self.tableView registerClass:[MXSYJFriendsCell class] forCellReuseIdentifier:FriendsCell];
}

#pragma mark - 加载视图
- (void)setUpView{
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    [reportBtn addTarget:self action:@selector(pushToReportVc) forControlEvents:UIControlEventTouchUpInside];
    reportBtn.titleLabel.font = fontSize(14);
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:reportBtn];
    self.navigationItem.rightBarButtonItem = barBtnItem;
    
    self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"luntan_dashangjifen_touxiang"]];
    [self.view addSubview:self.iconView];
    self.iconView.sd_layout.leftSpaceToView(self.view, 10).topSpaceToView(self.view, 15).heightIs(60).widthIs(60);
    self.iconView.sd_cornerRadius = @30;
    
    self.nameLab = [[UILabel alloc]init];
    [self.view addSubview:self.nameLab];
    self.nameLab.textColor = mx_FontBalckColor;
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.font = fontSize(15);
    self.nameLab.text = @"我是名字";
    self.nameLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.view, 20).heightIs(20);
    [self.nameLab setSingleLineAutoResizeWithMaxWidth:100];
    
    self.levelLab = [[UILabel alloc]init];
    [self.view addSubview:self.levelLab];
    self.levelLab.textColor = mx_FontGreyColor;
    self.levelLab.textAlignment = NSTextAlignmentCenter;
    self.levelLab.font = fontSize(12);
    self.levelLab.text = @"LV5";
    self.levelLab.sd_layout.leftSpaceToView(self.nameLab, 10).topSpaceToView(self.view, 25).heightIs(15).widthIs(30);
    self.levelLab.layer.masksToBounds = YES;
    self.levelLab.layer.cornerRadius = 5;
    self.levelLab.layer.borderColor = mx_FontLightGreyColor.CGColor;
    self.levelLab.layer.borderWidth = 1.0;
    
    self.postLab = [[UILabel alloc]init];
    [self.view addSubview:self.postLab];
    self.postLab.textColor = mx_FontGreyColor;
    self.postLab.textAlignment = NSTextAlignmentLeft;
    self.postLab.font = fontSize(12);
    self.postLab.text = @"帖子 10";
    self.postLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.nameLab, 10).heightIs(15);
    [self.postLab setSingleLineAutoResizeWithMaxWidth:200];
    
    self.fansLab = [[UILabel alloc]init];
    [self.view addSubview:self.fansLab];
    self.fansLab.textColor = mx_FontGreyColor;
    self.fansLab.textAlignment = NSTextAlignmentLeft;
    self.fansLab.font = fontSize(12);
    self.fansLab.text = @"粉丝 9673";
    self.fansLab.sd_layout.leftSpaceToView(self.postLab, 5).topSpaceToView(self.nameLab, 10).heightIs(15);
    [self.fansLab setSingleLineAutoResizeWithMaxWidth:200];
    
    self.focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.focusBtn];
    [self.focusBtn setBackgroundColor:mx_BlueColor];
    [self.focusBtn setTitle:@"+关注" forState:UIControlStateNormal];
    self.focusBtn.titleLabel.font = fontBoldSize(14);
    self.focusBtn.sd_layout.widthIs(80).heightIs(40).centerYEqualToView(self.iconView).rightSpaceToView(self.view, 10);
    self.focusBtn.sd_cornerRadius = @3;
    [self.focusBtn addTarget:self action:@selector(getAttention:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.addressLab = [[UILabel alloc]init];
    [self.view addSubview:self.addressLab];
    self.addressLab.textAlignment = NSTextAlignmentLeft;
    self.addressLab.textColor = mx_FontLightGreyColor;
    self.addressLab.text = @"常驻香港,精通研究!";
    self.addressLab.font = fontSize(13);
    self.addressLab.sd_layout.leftSpaceToView(self.view, 10).topSpaceToView(self.iconView, 10).heightIs(20);
    [self.addressLab setSingleLineAutoResizeWithMaxWidth:240];
    
}

- (void)pushToReportVc{
    
    if ([[MXssWodeUtils loadPersonInfo] userId]) {
        MXReportViewController *reportVC=[[MXReportViewController alloc] init];
        reportVC.ownerId = self.ownerId;
        reportVC.reportUerName = self.ownerName;
        [reportVC setBackButton:YES];
        [self.navigationController pushViewController:reportVC animated:YES];
    }else{
        
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
}

- (void)changedSelectVC:(UISegmentedControl *)segment{
    
    NSLog(@"%ld",segment.selectedSegmentIndex);
    
    sengmentSecletIndex = segment.selectedSegmentIndex;
    
    if (segment.selectedSegmentIndex == 1) {
        pageTwo = 1;
        self.isHeaderRefresh = YES;
        [self cicleNetWorkTwo:2 isSwitch:NO];
         self.personTwoTableview.circleArrTwos = self.circleArrTwo;
        self.personTwoTableview.hidden = NO;
       
    }else{
        [self cicleNetWork:1 isSwitch:YES];
        page = 1;
         self.personTwoTableview.hidden = YES;
    }
    
    
}

#pragma mark - 点击关注
- (void)getAttention:(UIButton *)btn{

    if ([MXssWodeUtils loadPersonInfo].userId) {
        
        NSString *str = [NSString stringWithFormat:@"%@",[MXssWodeUtils loadPersonInfo].userId];
        
        if ([str isEqualToString:self.ownerId]) {
            [SVProgressHUD showInfoWithStatus:@"不能关注自己~~"];
            return;
        }
        
        if (isAttention == 0) {
            isAttention = 1;
        }else if (isAttention == 1) {
            isAttention = 0;
        }else {
            isAttention = 0;
        }
        
        MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
        
        [[MXSYJPostVM sharedInstance] attentionType:isAttention ownerId:self.ownerId userId:userModel.userId success:^(NSDictionary *dic) {
            
            if ([dic[@"code"] isEqualToString:@"0"]) {
                NSLog(@"????关注？=%@",dic[@"data"][@"isAttention"]);
                NSString *str = dic[@"data"][@"isAttention"];
                if (str.intValue == 0) {
                    btn.enabled = YES;
                    [btn setBackgroundColor:mx_BlueColor];
                    [btn setTitle:@"+关注" forState:UIControlStateNormal];
                }else if (str.intValue == 1){
                    btn.enabled = YES;
                    [btn setBackgroundColor:[UIColor grayColor]];
                    [btn setTitle:@"已关注" forState:UIControlStateNormal];
                }else if (str.intValue == 2) {
                     btn.enabled = YES;
                    [btn setBackgroundColor:mx_BlueColor];
                    [btn setTitle:@"⇌互关" forState:UIControlStateNormal];
                }
            }
            
        } failture:^(NSError *error) {
            btn.enabled = YES;
            
        }];
    }else{
        
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}

#pragma mark - 网络请求
- (void)getNetWork{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:self.ownerId forKey:@"ownerId"];
    if ([MXssWodeUtils loadPersonInfo].userId) {
        [parmet setObject:[MXssWodeUtils loadPersonInfo].userId forKey:@"userId"];
    }
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemUserSquarePATH];
    mx_weakify(self);
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            //            NSLog(@"体字数？%@",dic);
            
            [SVProgressHUD dismiss];
            
            [weakSelf.iconView sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"headerPic"]] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
            weakSelf.nameLab.text = dic[@"data"][@"username"];
            //             weakSelf.nameLab.sd_layout.leftSpaceToView(weakSelf.iconView, 5).topSpaceToView(weakSelf.view, 20).heightIs(20);
            weakSelf.addressLab.text = dic[@"data"][@"userSign"];
            weakSelf.levelLab.text = [NSString stringWithFormat:@"LV%@",dic[@"data"][@"level"]];
            weakSelf.postLab.text = [NSString stringWithFormat:@"帖子 %@",dic[@"data"][@"articleNum"]];//帖子数
            weakSelf.postLab.sd_layout.leftSpaceToView(weakSelf.iconView, 5).topSpaceToView(weakSelf.nameLab, 10).heightIs(15);
            weakSelf.fansLab.text = [NSString stringWithFormat:@"粉丝 %@",dic[@"data"][@"fansNum"]];//粉丝数
            weakSelf.fansLab.sd_layout.leftSpaceToView(weakSelf.postLab, 5).topSpaceToView(weakSelf.nameLab, 10).heightIs(15);
            NSString *str = dic[@"data"][@"isAttention"];
            isAttention = [str integerValue];
            if (isAttention == 0) {
                [weakSelf.focusBtn setBackgroundColor:mx_BlueColor];
                [weakSelf.focusBtn setTitle:@"+关注" forState:UIControlStateNormal];
            }else if (isAttention == 1) {
                [weakSelf.focusBtn setBackgroundColor:mx_FontGreyColor];
                [weakSelf.focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }else if (isAttention == 2) {
                [weakSelf.focusBtn setBackgroundColor:mx_BlueColor];
                [weakSelf.focusBtn setTitle:@"⇌互关" forState:UIControlStateNormal];
            }
            
        }else{
            
            [SVProgressHUD showInfoWithStatus:dic[@"msg"]];
            
        }
        
        
    } WithFailureBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求错误!!!"];
    }];
}

#pragma mark - 圈子详情
- (void)cicleNetWork:(NSInteger)type isSwitch:(BOOL)isSwitchPage{
    
    mx_weakify(self);
    [[MXSYJPostVM sharedInstance] getPersonUserId:[MXssWodeUtils loadPersonInfo].userId ownerId:self.ownerId page:page limit:10 opid:type success:^(NSDictionary *dic) {
        //加载处理
        [SVProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        if (isSwitchPage == YES) {
            [weakSelf.circleArr removeAllObjects];
        }
//        NSLog(@"圈子详情个人详情=%@",dic);
            NSMutableArray *arr = [MXSYJSaisiModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            if (arr.count < 10) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            [weakSelf.circleArr addObjectsFromArray:arr];
        
        if (weakSelf.circleArr.count == 0) {
//            [SVProgressHUD showInfoWithStatus:@"暂无内容!!"];
            [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
            //消除尾部"没有更多数据"的状态
            weakSelf.tableView.mj_footer.hidden = YES ;
        }else{
                [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            //消除尾部"没有更多数据"的状态
            weakSelf.tableView.mj_footer.hidden = NO ;
        }
        
        [weakSelf.tableView reloadData];
        
    } failture:^(NSError *error) {
        
    }];
    
}


#pragma mark - table view dataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = mx_Wode_bordColor;
    
    self.segmented=[[UISegmentedControl alloc] initWithItems:@[@"赛事观点",@"圈子话题"]];
    [view addSubview:self.segmented];
    self.segmented.sd_layout.centerYEqualToView(view).centerXEqualToView(view).heightIs(40).widthIs(200);
    self.segmented.selectedSegmentIndex=sengmentSecletIndex;
    self.segmented.tintColor=mx_Wode_colorBlue2374e4;
    [self.segmented addTarget:self action:@selector(changedSelectVC:) forControlEvents:UIControlEventValueChanged];
    self.segmented.layer.masksToBounds = YES;
    self.segmented.layer.cornerRadius = 3;
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (self.segmented.selectedSegmentIndex == 0) {
        //        return [self.tableView cellHeightForIndexPath:indexPath model:self.circleArr[indexPath.row] keyPath:@"model" cellClass:[MXSYJPersonCell class] contentViewWidth:screen_width] + 10;
        return scaleWithSize(90);
//    }else{
//
//        if (self.circleArr.count > 0) {
//            MXSYJFocusOnModel *model = self.circleArr[indexPath.row];
//
//            if (model.forumImgs.count > 0) {
//                return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width] + kImgWidth;
//            }else{
//                return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width] + 10;
//            }
//
//        }else{
//            return 0;
//        }
//
//    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.circleArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.segmented.selectedSegmentIndex == 0) {
        //        MXSYJPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:personCell];
        //        if (self.circleArr.count > 0) {
        //            cell.model = self.circleArr[indexPath.row];
        //        }
        MXSSMyVoteYESSettledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:personCell];
        cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
        if (self.circleArr.count>0) {
            MXSYJSaisiModel *model = self.circleArr[indexPath.row]; //个人投票/观点model
            cell.myVoteYESSettledNameLabel.text = [NSString stringWithFormat:@"%@ vs %@",model.homeNm,model.awayNm];
            cell.myVoteYESSettledContentLabel.text = model.reason;//推荐理由
            cell.myVoteYESSettledTitleNameLabel.text = [NSString stringWithFormat:@"%@ - %d%%",model.username,(int)(model.hitRate.doubleValue*100)];
            [cell.myVoteYESSettledTouImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.headerPic]] placeholderImage:[UIImage imageNamed:@"saishi_morentouxiang"]];
            cell.myVoteYESSettledNumberLabel.text = model.suportCount;
            if (model.hit.intValue == 1) {//是否命中
                cell.myVoteYESSettledOrNoBigImage.image = [UIImage imageNamed:@"my_mingzhong"];
            }else  if (model.hit.intValue == 0){//是否命中
                cell.myVoteYESSettledOrNoBigImage.image = [UIImage imageNamed:@"my_weizhong"];
            }else  if (model.hit.intValue == 2){//是否命中
                cell.myVoteYESSettledOrNoBigImage.image = [UIImage imageNamed:@"my_fengpan"];
            }else{//是否命中
                cell.myVoteYESSettledOrNoBigImage.image = [UIImage imageNamed:@""];
            }
            //是否解锁🔐 isNotLock
            if (model.isNotLock.intValue == 1) {
                cell.myVoteYESSettledOrNoSuoImage.image = [UIImage imageNamed:@""];
            }else {
                cell.myVoteYESSettledOrNoSuoImage.image = [UIImage imageNamed:@"saishi_suo"];
            }
        }
        return cell;
        
//    }else{
//
//        MXSYJFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendsCell];
//        if (self.circleArr.count > 0) {
//            cell.model = self.circleArr[indexPath.row];
//        }
//        return cell;
//    }
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (sengmentSecletIndex == 0) {
        if ([MXssWodeUtils loadPersonInfo].userId) {//判断是否登录
            MXOpinionDetailViewController * opinionDetail = [[MXOpinionDetailViewController alloc]init] ;
            MXSYJSaisiModel *model = self.circleArr[indexPath.row];
            opinionDetail.eventID = [NSString stringWithFormat:@"%@",model.ID];
            [self.navigationController pushViewController:opinionDetail animated:YES];
            self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
        }else {
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:nil];
            [MXssWodeUtils removePersonInfo];
//        }
    }
//    if (sengmentSecletIndex == 1) {
//        MXSYJFocusOnModel *model = self.circleArr[indexPath.row];
//        MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
//        vc.newsID = model.newsId;
//        vc.userId = [NSString stringWithFormat:@"%d", model.userId];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
}



@end
