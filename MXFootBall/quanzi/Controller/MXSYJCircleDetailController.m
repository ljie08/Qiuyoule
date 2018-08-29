//
//  MXCircleDetailController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/2.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCircleDetailController.h"
#import "MXSYJCircleHeader.h"
#import "MXSYJTopCell.h"
#import "MXSYJFriendsCell.h"
#import "MXDIYBtn.h"
#import "MXSYJButton.h"
#import "FTPopOverMenu.h"
#import "MXCircleIntroductionVC.h"
#import "MXSYJPostDetailsController.h"
#import "MXSYJChannelModel.h"
#import "MXSYJFocusOnModel.h"
#import "MXSYJPostVM.h"
#import "MXSYJIsTopModel.h"
#import "MXSYJPersonController.h"
#import "MXHomeVM.h"

#import "MXOfficialCell.h"//官方资讯cell

static NSString * const topCell = @"topCell";
static NSString * const friendsCell = @"friendsCell";

#define kImgWidth (screen_width - 45) / 4


@interface MXSYJCircleDetailController ()<UITableViewDelegate,UITableViewDataSource, RefreshTableViewDelegate>{
    
    MXDIYBtn *btn1;
    MXDIYBtn *btn2;
    MXDIYBtn *btn3;
    MXSYJButton *btn4;
    NSInteger isClick;
    
    NSMutableArray *topList;
    NSInteger page;
    
    MXHomeVM *_official;
}

@property (nonatomic, strong) JJRefreshTabView *tableView;
@property (nonatomic, strong) MXSYJCircleHeader *circleHeader;

@property (nonatomic, strong) UIView *sectionView;

@property (nonatomic, strong) NSMutableArray *arrList;

@property (nonatomic, strong) MXSYJChannelModel *channelModel;

@property (nonatomic , strong) UIButton * upDataButton ;


@end

@implementation MXSYJCircleDetailController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //设置标题
    if (self.type == 100) {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"官方资讯界面\"}"];
        [self initTitleViewWithTitle:@"官方资讯"];
    } else {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"论坛专题界面\"}"];
        [self initTitleViewWithTitle:@"圈子详情"];
    }
    
    //设置返回按钮是否显示
    [self setBackButton:YES];
}


- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    //    [UBT logTrace:@"residenceTimeOut"; content:@"{\"VC\":\"\u9996\u9875\"}";
    if (self.type == 100) {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"官方资讯界面\"}"];
    } else {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"论坛专题界面\"}"];
    }
    self.removeUpdataBlock();
    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}

//懒加载
- (UIView *)sectionView{
    
    if (_sectionView == nil) {
        _sectionView = [[UIView alloc]init];
        _sectionView.backgroundColor = [UIColor whiteColor];
        btn1 = [[MXDIYBtn alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
        [_sectionView addSubview:btn1];
        btn1.nameLab.text = @"全部";
        btn1.nameLab.textColor = mx_redColor;
        btn1.line.backgroundColor = mx_redColor;
        btn1.tag = 11;
        btn1.selected = YES;
        mx_weakify(self);
        btn1.click = ^(UIControl *control) {
            [weakSelf clcikSlider:control];
        };
        
        btn2 = [[MXDIYBtn alloc]initWithFrame:CGRectMake(80, 0, 70, 40)];
        [_sectionView addSubview:btn2];
        btn2.selected = NO;
        btn2.nameLab.text = @"最新热帖";
        btn2.nameLab.textColor = mx_FontLightGreyColor;
        btn2.line.backgroundColor = [UIColor clearColor];
        btn2.tag = 12;
        btn2.click = ^(UIControl *control) {
            [weakSelf clcikSlider:control];
        };
        
        btn3 = [[MXDIYBtn alloc]initWithFrame:CGRectMake(160, 0, 70, 40)];
        [_sectionView addSubview:btn3];
        btn3.selected = NO;
        btn3.nameLab.text = @"历史置顶";
        btn3.nameLab.textColor = mx_FontLightGreyColor;
        btn3.line.backgroundColor = [UIColor clearColor];
        btn3.tag = 13;
        btn3.click = ^(UIControl *control) {
            [weakSelf clcikSlider:control];
        };
        
            btn4 = [[MXSYJButton alloc]initWithFrame:CGRectMake(screen_width - 100, 0,80,40)];
            btn4.hidden = YES;
            [_sectionView addSubview:btn4];
            btn4.ysl_buttonType = SYJCustomButtonImageRight;
            btn4.titleLabel.font = fontSize(14);
            btn4.ysl_spacing = 0;
            [btn4 setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
            [btn4 setTitle:@"最新回复" forState:UIControlStateNormal];
            [btn4 setTitleColor:mx_FontLightGreyColor forState:UIControlStateNormal];
            btn4.tag = 14;
//            [btn4 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _sectionView;
    
}

- (void)clcikSlider:(UIControl *)control{
    
    NSLog(@"%ld",control.tag);
    if (control.tag == 11) {
        
        isClick = control.tag;
        btn1.selected = YES;
        [self.tableView reloadData];
        btn1.nameLab.textColor = mx_redColor;
        btn1.line.backgroundColor = mx_redColor;
        btn2.nameLab.textColor = mx_FontLightGreyColor;
        btn2.line.backgroundColor = [UIColor clearColor];
        btn2.selected = NO;
        btn3.nameLab.textColor = mx_FontLightGreyColor;
        btn3.line.backgroundColor = [UIColor clearColor];
        btn3.selected = NO;
        if (self.type == 100) {
            [self getOfficialDataIsRefresh:YES type:isClick - 10];
        } else {
            [self getListNetWork:isClick - 10 isSwitch:YES];
        }
        page = 1;
        
    }else if(control.tag == 12){
        
        isClick = control.tag;
        btn2.selected = YES;
        btn1.selected = NO;
        [self.tableView reloadData];
        btn2.nameLab.textColor = mx_redColor;
        btn2.line.backgroundColor = mx_redColor;
        btn1.nameLab.textColor = mx_FontLightGreyColor;
        btn1.line.backgroundColor = [UIColor clearColor];
        btn3.nameLab.textColor = mx_FontLightGreyColor;
        btn3.line.backgroundColor = [UIColor clearColor];
        btn3.selected = NO;
        if (self.type == 100) {
            [self getOfficialDataIsRefresh:YES type:isClick - 10];
        } else {
            [self getListNetWork:isClick - 10 isSwitch:YES];
        }
        page = 1;
        
    }else{
        isClick = control.tag;
        btn2.selected = NO;
        btn1.selected = NO;
        [self.tableView reloadData];
        btn2.nameLab.textColor = mx_FontLightGreyColor;
        btn2.line.backgroundColor = [UIColor clearColor];
        btn1.nameLab.textColor = mx_FontLightGreyColor;
        btn1.line.backgroundColor = [UIColor clearColor];
        btn3.nameLab.textColor = mx_redColor;
        btn3.line.backgroundColor = mx_redColor;
        btn3.selected = YES;
        if (self.type == 100) {
            [self getOfficialDataIsRefresh:YES type:isClick - 10];
        } else {
            [self getListNetWork:isClick - 10 isSwitch:YES];
        }
        page = 1;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrList = [NSMutableArray array];
    topList = [NSMutableArray array];
    
    [self setTableView];
    
    isClick = 11;
    
    if (self.type == 100) {
        [self initOfficial];
    } else {
        page = 1;
        [self getListNetWork:1 isSwitch:NO];
    }
    if (!self.arrList.count) {
        self.upDataButton = [self addUpDataBtnWithTitle:@"" superView:self.tableView];
        NSLog(@"==🍎%f",[UIScreen mainScreen].bounds.size.height);
        if ([UIScreen mainScreen].bounds.size.height <=568) {
             self.upDataButton.frame = CGRectMake(0, screen_height/2 + scaleWithSize(50), screen_width, 40);
        }else {
            self.upDataButton.frame = CGRectMake(0, screen_height/2 , screen_width, 40);
        }
        self.upDataButton.titleLabel.font = fontBoldSize(18);
    }
    
    mx_weakify(self);
    self.updataBlock = ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    // Do any additional setup after loading the view.
}

#pragma mark -- 官方资讯
- (void)initOfficial {
    _official = [[MXHomeVM alloc] init];
    [self getOfficialDataIsRefresh:YES type:1];
}

// type 1:全部，2：最新热帖，3：历史置顶
- (void)getOfficialDataIsRefresh:(BOOL)isRefresh type:(NSInteger)type {
    @weakSelf(self);
    [SVProgressHUD showWithStatus:@"加载中"];
    [_official getNewsWithRefresh:isRefresh type:type success:^(BOOL result) {
        [SVProgressHUD dismiss];
//        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        
        weakSelf.circleHeader.nameLab.text =  _official.info.channelName;
        [weakSelf.circleHeader.iconImg sd_setImageWithURL:[NSURL URLWithString: _official.info.imgUrl] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
        weakSelf.circleHeader.descLab.text = _official.info.title;
        weakSelf.circleHeader.postLab.text = [NSString stringWithFormat:@"帖子数 %@",_official.info.forumCount];
        
        //新请求到的数据条数大于0 显示加载更多
        if (_official.channelList.count) {
            weakSelf.tableView.isShowMore = YES;
            if ([UIScreen mainScreen].bounds.size.height <=568) {
                 weakSelf.removeUpdataBlock() ;
            }else {
            [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            //消除尾部"没有更多数据"的状态
            weakSelf.tableView.mj_footer.hidden = NO ;
            }
        } else {
            if ([UIScreen mainScreen].bounds.size.height <=568) {
                self.upDataButton.frame = CGRectMake(0, screen_height/2 - scaleWithSize(10), screen_width, 40);
                [weakSelf.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
                [weakSelf.view addSubview:weakSelf.upDataButton];
            }else {
            [[MXNotDataAlertView shareInstance] showNotDataAlertViewWithAlertText:@"暂无数据"];
            //消除尾部"没有更多数据"的状态
            weakSelf.tableView.mj_footer.hidden = YES ;
            }
        }
        
        //加载更多的时候，新请求到的数据和之前的数据条数一样且不为0或者没有数据，则是没有更多数据了，不显示加载更多
        if ((!isRefresh && _official.channelList.count%10 != 0) || !_official.channelList.count) {
            weakSelf.tableView.isShowMore = NO;
        }
        
        topList = _official.officialTopList;
        weakSelf.arrList = _official.channelList;
        
        [weakSelf.tableView reloadData];
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark - network
- (void)getListNetWork:(NSInteger)type isSwitch:(BOOL)isSwitchPage{

    mx_weakify(self);
    [[MXSYJPostVM sharedInstance] getCircleDetail:[MXssWodeUtils loadPersonInfo].userId channleId:self.model.channelId page:page limit:10 opid:type success:^(NSDictionary *dic) {
        
        if (isSwitchPage == YES || page == 1) {
            [weakSelf.arrList removeAllObjects];
            [topList removeAllObjects];
        }

        //频道信息
        weakSelf.channelModel  = [MXSYJChannelModel mj_objectWithKeyValues:dic[@"data"][@"channelInfo"]];
        weakSelf.circleHeader.nameLab.text =  weakSelf.channelModel.channelName;
        [weakSelf.circleHeader.iconImg sd_setImageWithURL:[NSURL URLWithString: weakSelf.channelModel.imgUrl] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
        weakSelf.circleHeader.descLab.text = weakSelf.channelModel.title;
        weakSelf.circleHeader.postLab.text = [NSString stringWithFormat:@"帖子数 %@",weakSelf.channelModel.forumCount];

        
        NSMutableArray *arr = [MXSYJFocusOnModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"channelForumList"]];
        
        if (arr.count < 10) {
            if (arr.count == 0) {
                weakSelf.tableView.mj_footer.hidden = YES;
            }else{
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
        if (arr.count) {
            weakSelf.tableView.isShowMore = YES;
        }

        //文章列表
        [weakSelf.arrList addObjectsFromArray:arr];
        //置顶列表
        topList = [MXSYJIsTopModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"topForumList"]];

        if (weakSelf.arrList.count == 0) {
            [weakSelf.upDataButton setTitle:@"暂无数据" forState:(UIControlStateNormal)] ;
            [weakSelf.view addSubview:weakSelf.upDataButton];
            
        }else{
            weakSelf.removeUpdataBlock() ;
        }

        [weakSelf.tableView reloadData];
        
    } failture:^(NSError *error) {
        
    }];
}


#pragma mark - 加载tableView
- (void)setTableView{
    
    self.tableView = [[JJRefreshTabView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height- STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = mx_Wode_bordColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//分割线从最左边开始
    
    self.tableView.refreshDelegate = self;
    self.tableView.CanRefresh = YES;
    self.tableView.lastUpdateKey = NSStringFromClass([self class]);
    self.tableView.isShowMore = NO;
    
    self.circleHeader = [[MXSYJCircleHeader alloc]initWithFrame:CGRectMake(0, 0, screen_width, 80)];
    
    if (self.type != 100) {
        self.tableView.tableHeaderView = self.circleHeader;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
    [self.circleHeader addGestureRecognizer:tap];
    
    [self.tableView registerClass:[MXSYJTopCell class] forCellReuseIdentifier:topCell];
    [self.tableView registerClass:[MXSYJFriendsCell class] forCellReuseIdentifier:friendsCell];
    
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

- (void)viewTap{
    MXCircleIntroductionVC *vc = [[MXCircleIntroductionVC alloc]init];
    if (self.type == 100) {
        self.model = _official.info;
    }
    vc.ID = self.model.channelId;
    if (!vc.ID) {
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -- refresh
- (void)refreshTableViewHeader {
    //默认是全部的时候，isClick为0，传的type应为1，如果不处理的话，此时type为-10，则会请求出错，刷新的时候是最新或最热，isClick是12或13，传的type是2或3
    NSInteger dataType = isClick == 0 ? 1 : isClick - 10;
    
    if (self.type == 100) {
        [self getOfficialDataIsRefresh:YES type:dataType];
    } else {
        [self getListNetWork:dataType isSwitch:NO];
    }
}

- (void)refreshTableViewFooter {
    //默认是全部的时候，isClick为0，传的type应为1，如果不处理的话，此时type为-10，则会请求出错，刷新的时候是最新或最热，isClick是12或13，传的type是2或3
    NSInteger dataType = isClick == 0 ? 1 : isClick - 10;
    if (self.type == 100) {
        [self getOfficialDataIsRefresh:NO type:dataType];
    } else {
        page ++;
        [self getListNetWork:dataType isSwitch:NO];
    }
}

#pragma mark - table view dataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else{
        return 40;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 50;
    }else{
        MXSYJFocusOnModel *model = self.arrList[indexPath.row];
        if (self.type == 100) {
//            if (model.imgUrl) {
//                CGFloat height = [MXOfficialCell cellHeightWithString:model.subContent];
//                return height+65;
//            }
            return 100;
        }
        
        if (model.forumImgs.count > 0) {
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width] + kImgWidth;
            
        }else{
            return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width];
            
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return topList.count;
    }
    
    return self.arrList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
#pragma mark -- 置顶
        MXSYJTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCell];
        cell.model = topList[indexPath.row];
        return cell;
    }else{
#pragma mark -- 帖子列表
        if (self.type == 100) {//官方资讯
            MXOfficialCell *cell = [MXOfficialCell myCellWithTableview:tableView];
            [cell setDataWithModel:self.arrList[indexPath.row]];
            
            return cell;
        }
        //圈子
        MXSYJFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:friendsCell];
        if (self.arrList.count) {
            mx_weakify(self);
            cell.model = self.arrList[indexPath.row];
            cell.tapClick = ^{
                MXSYJFocusOnModel *model = weakSelf.arrList[indexPath.row];
                MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
                vc.ownerId = [NSString stringWithFormat:@"%ld", model.userId];;
                vc.ownerName = model.username;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
                model.view = model.view + 1 ;
                [weakSelf.arrList replaceObjectAtIndex:indexPath.row withObject:model] ;
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
            };
            cell.btnAction = ^(UIButton *btn) {
              
                MXSYJFocusOnModel *model = weakSelf.arrList[indexPath.row];
                MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
                vc.newsID = model.newsId;
                vc.userId = [NSString stringWithFormat:@"%ld", model.userId];;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
                model.view = model.view + 1 ;
                [weakSelf.arrList replaceObjectAtIndex:indexPath.row withObject:model] ;
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
                
            };
        }
        [cell updateLayout];
        return cell;
    }
    

}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
        if (self.type == 100) {
            vc.type = 200;
        }
        MXSYJIsTopModel *model = topList[indexPath.row];
        vc.articleType = model.articleType;
        vc.newsID = model.newsId;
//        vc.userId = model.userId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
        if (self.type == 100) {
            vc.type = 200;
        }
        MXSYJFocusOnModel *model = self.arrList[indexPath.row];
        vc.articleType = model.articleType;
        vc.newsID = model.newsId;
        vc.userId = [NSString stringWithFormat:@"%d", model.userId];;
        [self.navigationController pushViewController:vc animated:YES];
        
        model.view = model.view + 1 ;
        [self.arrList replaceObjectAtIndex:indexPath.row withObject:model] ;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
    }
    
}

@end
