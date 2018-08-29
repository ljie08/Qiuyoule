//
//  MXSituationViewController.m
//  MXFootBall
//
//  Created by YY on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//
#import "UIControl+category.h"
#import "MXSYJWebViewController.h"//广告
#import "MXChatModel.h"
#import "MXTextLiveCell.h"
#import <BarrageRenderer/BarrageRenderer.h>
#import "MXChatRoomViewController.h"
#import "MXSituationViewController.h"
#import "MXEventViewController.h"
#import "MXGoalViewController.h"
#import "MXNewTextLiveCell.h"
@interface MXSituationViewController ()
<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>

@property (nonatomic,strong)BarrageRenderer *renderer;

@property (nonatomic,strong)dispatch_source_t timer;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong)NSMutableArray *historyChatInfo;

@property (nonatomic,strong)UIWebView *webView;

@property (nonatomic,strong)NSMutableArray *barrageArr;

@property (nonatomic,strong)UISegmentedControl *segmentControl;

@property (nonatomic,strong)UIScrollView *contentScrollView;


@property (nonatomic, assign) NSInteger adHeight ;

@end

@implementation MXSituationViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor=mx_Wode_colorBlue2374e4;
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName :[UIFont systemFontOfSize:18]}];
    self.view.backgroundColor=[UIColor whiteColor];
    self.delegate=self;
    self.dataSource=self;
    self.titleSizeNormal=15;
    self.titleSizeSelected=15;
    self.titleColorNormal=[UIColor grayColor];
    self.titleColorSelected=mx_Wode_colorBlue2374e4;
    self.menuViewLayoutMode=WMMenuViewLayoutModeCenter;

    mx_weakify(self);
    [self.segmentControl addActionHandler:^(UISegmentedControl *control) {
        if (control.selectedSegmentIndex==0) {
            if (self.flag==YES) {
                weakSelf.contentScrollView.contentOffset=CGPointMake(0, 0);
            }
        }else if (control.selectedSegmentIndex==1){
            weakSelf.contentScrollView.contentOffset=CGPointMake(screen_width, 0);
        }
    }];
    
    self.adHeight = 50 ;
    
    [self reloadData] ;
    
}
-(UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width,scaleWithSize(260))];
        _contentScrollView.pagingEnabled=YES;
        _contentScrollView.scrollEnabled=NO;
        _contentScrollView.contentSize=CGSizeMake(screen_width*2, scaleWithSize(260));
        _contentScrollView.backgroundColor = [UIColor blueColor] ;
    }
   return _contentScrollView;
}
-(UISegmentedControl *)segmentControl{
    if (!_segmentControl) {
        _segmentControl=[[UISegmentedControl alloc] initWithItems:@[@"动画直播",@"文字直播"]];
        _segmentControl.frame=CGRectMake((screen_width-120)/2, 5, 120, 30);
        _segmentControl.selectedSegmentIndex=self.selectedIndex;
    }
    return _segmentControl;
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screen_width, self.contentScrollView.height)];
        _webView.delegate=self;
        NSString *url=[NSString stringWithFormat:@"http://www.lstasports.com/mlive/qiuyoule.html?id=%@",self.matchID];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    return _webView;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)historyChatInfo{
    if (!_historyChatInfo) {
        _historyChatInfo=[NSMutableArray array];
    }
    return _historyChatInfo;
}
-(NSMutableArray *)barrageArr{
    if (!_barrageArr) {
        _barrageArr=[NSMutableArray array];
    }
    return _barrageArr;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(screen_width, 0, screen_width, self.contentScrollView.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[MXLJUtil hexStringToColor:@"0x342828"];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MXNewTextLiveCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MXNewTextLiveCell class])];
    if (!cell) {
        cell=[[MXNewTextLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MXNewTextLiveCell class])];
    }
    cell.model=self.dataArr[indexPath.row];
    return cell;
}
- (void)scrollsToBottomAnimated:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];//这里一定要设置为NO，动画可能会影响到scrollerView，导致增加数据源之后，tableView到处乱跳
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView cellHeightForIndexPath:indexPath model:self.dataArr[indexPath.row] keyPath:@"model" cellClass:[MXNewTextLiveCell class] contentViewWidth:screen_width];
}
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction side:(BarrageWalkSide)side andTexts:(NSString *)texts
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"bizMsgId"] = [NSString stringWithFormat:@"0"];
    //    descriptor.params[@"text"] = texts;
    descriptor.params[@"textColor"] = [[UIColor blueColor] colorWithAlphaComponent:0.6];
    descriptor.params[@"speed"] = @50;
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
    descriptor.params[@"backgroundColor"]= [UIColor whiteColor];
    //    descriptor.params[@"borderColor"]=[UIColor grayColor];
//        descriptor.params[@"borderWidth"]=@1;
    descriptor.params[@"cornerRadius"]=@12;
    descriptor.params[@"fontSize"]=@17;
    NSTextAttachment * attachment = [[NSTextAttachment alloc]init];
    attachment.image = [UIImage imageNamed:@"saishi_zhibo_lanqiu_lan"];
    attachment.bounds=CGRectMake(10, -5, 25, 25);
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:
                                              [NSString stringWithFormat:@"   %@  ",texts]];
    [attributed insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
    descriptor.params[@"attributedText"] = attributed;
    return descriptor;
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.renderer stop];
    [[MXSocketManager manager] disConnect];
}
-(BarrageRenderer *)renderer{
    if (!_renderer) {
        _renderer=[[BarrageRenderer alloc] init];
        _renderer.smoothness=.3;
        _renderer.speed=0.5;
        _renderer.canvasMargin=UIEdgeInsetsMake(50, 0, 50, 0);
    }
    return _renderer;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.titleView=self.segmentControl;
    [self.view addSubview:self.contentScrollView];
    [self.renderer start];
    [self.contentScrollView addSubview:self.webView];
    [self.contentScrollView addSubview:self.tableView];
    YYTableViewNoDataView *noDateView=[[YYTableViewNoDataView alloc] initWithFrame:self.contentScrollView.frame titleInfo:@"大家好,欢迎收看球友乐直播,球员们正在热身,比赛即将开始" viewClick:^{
        
    }andTitleColor:[UIColor whiteColor]];
    self.tableView.placeHolderView=noDateView;
    noDateView.backgroundColor=[MXLJUtil hexStringToColor:@"0x342828"];
    [self.view addSubview:self.renderer.view];
    [self.view bringSubviewToFront:self.renderer.view];
    if (self.segmentControl.selectedSegmentIndex==0) {
        if (self.flag==YES) {
            self.contentScrollView.contentOffset=CGPointMake(0, 0);
        }
    }else{
        self.contentScrollView.contentOffset=CGPointMake(screen_width, 0);
    }
    NSMutableDictionary *paras=[NSMutableDictionary dictionaryWithDictionary:@{@"locationId":@"2",@"time":[MXLJUtil getNowDateTimeString]}];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:@"api/ad/findAds"] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {
        NSArray *advertsArr=[[dic objectForKey:@"data"] objectForKey:@"adverts"];
        YANGLog(@"-----%@-----",advertsArr);
        if (advertsArr.count!=0) {
            UIImageView *imageView=[[UIImageView alloc] init];
            [self.view addSubview:imageView];
            [self.view bringSubviewToFront:imageView];
            imageView.sd_layout
//            .bottomEqualToView(self.webView)
            .topSpaceToView(self.view, scaleWithSize(250))
            .leftEqualToView(self.webView)
            .rightEqualToView(self.webView)
            .heightIs(50);
            UILabel *advertLabel=[UILabel new];
            [imageView addSubview:advertLabel];
            advertLabel.sd_layout
            .rightSpaceToView(imageView, 3)
            .bottomSpaceToView(imageView, 3)
            .widthIs(30)
            .heightIs(15);
            advertLabel.font=[UIFont systemFontOfSize:13];
            advertLabel.text=@"广告";
            advertLabel.textColor=[UIColor whiteColor];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[[advertsArr firstObject] objectForKey:@"advertPic"]]];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled=YES;
            [tap addActionBlock:^(UITapGestureRecognizer *tap) {
                MXSYJWebViewController *webViewCon=[[MXSYJWebViewController alloc] init];
                webViewCon.url=[[advertsArr firstObject] objectForKey:@"targetUrl"];
                webViewCon.adID = [[advertsArr firstObject] objectForKey:@"advertId"];
                [self.navigationController pushViewController:webViewCon animated:YES];
            }];
            UIImageView *removeAdvertView=[[UIImageView alloc] init];
            [imageView addSubview:removeAdvertView];
            removeAdvertView.sd_layout
            .rightSpaceToView(imageView, 5)
            .topSpaceToView(imageView, 5)
            .widthIs(15)
            .heightIs(15);
            removeAdvertView.image=[UIImage imageNamed:@"close"];
            removeAdvertView.userInteractionEnabled=YES;
            UITapGestureRecognizer *removeTap=[[UITapGestureRecognizer alloc] init];
            [removeAdvertView addGestureRecognizer:removeTap];
            [removeTap addActionBlock:^(UITapGestureRecognizer *tap) {
                [imageView removeFromSuperview];
                self.adHeight = 0 ;
                [self reloadData];
                MXSocketManager * manager= [MXSocketManager manager];
                [manager disConnect] ;
                [self socketManager] ;
                
            }];
        }
    } WithFailureBlock:^(NSError *error) {
        
    }];
    
    [self socketManager] ;
    
}
#pragma mark SocketManager
- (void)socketManager {
    MXSocketManager * manager= [MXSocketManager manager];
    manager.currentStatusType = ^(ConnectStatusType statusType) {
        switch (statusType) {
            case 0:
                //                [SVProgressHUD showWithStatus:@"聊天室断开连接"];
                break;
            case 1:
                [SVProgressHUD showWithStatus:@"正在连接聊天室"];
                break;
            case 2:
                [SVProgressHUD dismiss];
                break;
            case 3:
                [SVProgressHUD showWithStatus:@"正在重连聊天室"];
                break;
            case 4:
                [SVProgressHUD showErrorWithStatus:@"连接失败"];
                break;
            default:
                break;
        }
    };
    
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    __weak typeof(self) WeakSelf=self;
    
    if (config.userId) {
        [manager connectWithUserInfo:@{@"matchId":self.matchID,@"startTime":[MXLJUtil getNowDateTimeString],@"userId":config.userId,@"username":config.username,@"headerPic":config.headerPic,@"level":config.level,@"matchStatus":self.matchStatus} andUserType:MXLoginInUser];
    }else{
        [manager connectWithUserInfo:@{@"matchId":self.matchID,@"startTime":[MXLJUtil getNowDateTimeString],@"matchStatus":self.matchStatus} andUserType:MXTourist];
    }
    manager.message = ^(id message) {
        if ([[message objectForKey:@"matchId"]isEqualToString:self.matchID]) {

            [MXNotificationDefaultCenter postNotificationName:@"chatInfoNotification" object:self userInfo:message];
            
            if ([[message objectForKey:@"msgType"] isEqualToString:@"repmsg"]) {
                [SVProgressHUD showErrorWithStatus:@"重复登录"];
            }
            if (message[@"messageModel"]!=[NSNull null]) {
                if ([[message objectForKey:@"msgType"] isEqualToString:@"allmsg"]) {
                    if ( message[@"messageModel"][@"matchInfoList"]!=[NSNull null]) {
                        NSArray *matchInfoList= message[@"messageModel"][@"matchInfoList"];
                        WeakSelf.dataArr= [MXTextLiveModel mj_objectArrayWithKeyValuesArray:matchInfoList];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [WeakSelf.tableView reloadData];
                        });
                    }
                }
                if ([[message objectForKey:@"msgType"] isEqualToString:@"barmsg"]) {
                    if (message[@"messageModel"][@"chatInfo"]!=[NSNull null]) {
                        NSDictionary *chatInfoDict= message[@"messageModel"][@"chatInfo"];
                        int i=arc4random()/2;
                        [self.renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L side:i=(0)?BarrageWalkSideLeft:BarrageWalkSideRight andTexts:[chatInfoDict objectForKey:@"chatMsg"]]];
                    }
                }
                if ([[message objectForKey:@"msgType"] isEqualToString:@"chatmsg"]) {
                    if (message[@"messageModel"][@"chatInfoList"]!=[NSNull null]) {
                        NSArray *chatInfoList= message[@"messageModel"][@"chatInfoList"];
                        self.historyChatInfo=[MXChatModel mj_objectArrayWithKeyValuesArray:chatInfoList];
                    }
                }
                if (message[@"messageModel"]!=[NSNull null]&& message[@"messageModel"][@"matchInfo"]!=[NSNull null]) {
                    NSDictionary *matchInfo=message[@"messageModel"][@"matchInfo"];
                    MXTextLiveModel *model=[MXTextLiveModel mj_objectWithKeyValues:matchInfo];
                    [WeakSelf.dataArr addObject:model];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [WeakSelf.tableView reloadData];
                    });
                }
            }
        }
        
    };
}

-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 3;
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            return @"事件统计";
            break;
        case 1:
            return @"进球分布";
            break;
        case 2:
            return @"聊天室";
            break;
        default:
            break;
    }
    return @"";
}
- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}
-(UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {
            MXEventViewController *eventVC= [[MXEventViewController alloc] init];
            eventVC.matchID=[NSString stringWithFormat:@"%@",self.matchID];
            eventVC.adHeight = self.adHeight ;
            return eventVC;
            break;
        }
        case 1:{
            MXGoalViewController*goalVC= [[MXGoalViewController alloc] init];
            goalVC.matchID=[NSString stringWithFormat:@"%@",self.matchID];
            goalVC.adHeight = self.adHeight ;
            return goalVC;
            break;
        }
        case 2:{
            MXChatRoomViewController *chatVC =[[MXChatRoomViewController alloc] init];
            chatVC.chaInfo=self.historyChatInfo;
            chatVC.matchID=[NSString stringWithFormat:@"%@",self.matchID];
            chatVC.bulletCsmScore=self.bulletCsmScore;
            chatVC.chatMinLv=self.chatMinLv;
            chatVC.bulletMinLv=self.bulletMinLv;
            chatVC.adHeight = self.adHeight ;
            return chatVC;
            break;}
        default:
            break;
    }
    return nil;
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : self.contentScrollView.frame.size.height + self.adHeight;
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
