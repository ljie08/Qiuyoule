//
//  MXSSIntegralViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/12.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSIntegralViewController.h"
#import "MXSSIntegralLVListViewController.h"//等级特权
#import "MXSSIntegralTaskListViewController.h"//积分任务
#import "MXSSIntegralDetailListViewController.h"//积分明细页面
//#import "MXssLevelBouncedView.h"//积分等级弹框显示
//#import "MXssIntegralBouncedView.h"//积分任务弹框显示
#import "MXssFindTaskAndLevelModel.h"//任务积分model
//#import "MXssFindPermissionModel.h"//获取权限列表model


@interface MXSSIntegralViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *lvLabel;//等级名称
@property (nonatomic,strong) UILabel *signatureLabel;//签名
@property (nonatomic,strong) UIButton *giftsButton;//礼物按钮
@property (nonatomic,strong) UILabel *xianLabel1;//下划线
@property (nonatomic,strong) UILabel *xianLabel2;//下划线
@property (nonatomic,strong) UIButton *lvBut;//等级特权按钮
@property (nonatomic,strong) UIButton *integralBut;//积分任务按钮

//@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic,strong) MXSSIntegralLVListViewController *lvViews;//等级特权
@property (nonatomic,strong) MXSSIntegralTaskListViewController *taskView;//积分任务
//@property (nonatomic, strong) MXssFindTaskAndLevelModel *FindtasksModel;
@property (nonatomic, strong) NSMutableArray *modelArr;
@end

@implementation MXSSIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mx_Wode_backgroundColor;
    // Do any additional setup after loading the view.
    self.modelArr = [NSMutableArray array];
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
    [self topHeadView];//头部显示
    [self.view addSubview:self.scrollView];
    self.lvViews =[[MXSSIntegralLVListViewController alloc]init];//等级特权页面
    self.lvViews.view.frame = CGRectMake(0, 0, screen_width, self.scrollView.frame.size.height);
//    self.lvViews.delegate = self;
    [self.scrollView addSubview:self.lvViews.view];

    self.taskView = [[MXSSIntegralTaskListViewController alloc]init];//积分任务页面
    self.taskView.view.frame = CGRectMake(screen_width, 0, screen_width, self.scrollView.frame.size.height);
//    self.taskView.delegate = self;
    [self.scrollView addSubview:self.taskView.view];
    UIButton *confirmBtn = [[UIButton alloc]init];//积分明细按钮
    confirmBtn.frame = CGRectMake(0, 0, 25, 25);
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"saishi_jifenmingxi"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];//积分明细
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmBtn];
//    //当前时间判断
//    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
//    NSDate *  senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYYMMdd"];
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
//    //判断当前时间 一天提醒一次
//    if (![locationString isEqualToString:[NSString stringWithFormat:@"%@",[MXssWodeUtils loadPersonInfo].homeTimeNumber]]) {
//        [self levelBouncedList];//等级弹框显示
//        userModel.homeTimeNumber = locationString;
//        [MXssWodeUtils savePersonInfo:userModel];
//    }
    
//    [self FindPermissionData];//权限列表请求数据
}

#pragma mark ---FindTaskAndLevelData任务积分数据
-(void)FindTaskAndLevelData{
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodemFindTaskAndLevel_PATH;//请求信息中心接口
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    
    mx_weakify(self);
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"任务积分==%@",personDic);
//        NSDictionary *dic = [personDic objectForKey:@"data"];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
//            self.FindtasksModel = [[MXssFindTaskAndLevelModel alloc] initWithDict:[dic objectForKey:@"user"]];
            NSDictionary *quanziDict = personDic[@"data"];
                //任务积分=列表
                weakSelf.modelArr = [MXssFindTaskAndLevelModel mj_objectArrayWithKeyValuesArray:quanziDict];
            if (weakSelf.modelArr.count>0) {
                self.taskView.findTaskLevelArr = weakSelf.modelArr.copy;
            }
            
//            NSArray *tasksArr = [personDic objectForKey:@"data"];
//            self.FindtasksModel.tasksListModelArr = [NSMutableArray arrayWithCapacity:0];
//            for (NSDictionary *dictt in tasksArr) {
//                tasksListModel *brokerModel = [tasksListModel modelWithDictionary:dictt];
//                 [self.FindtasksModel.tasksListModelArr addObject:brokerModel];
//            }
//            self.taskView.findTaskLevelArr = self.FindtasksModel.tasksListModelArr.copy;//model传值到积分任务
        }else {
        [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}


//#pragma mark ----等级弹框显示
////任务积分 等级弹框
//- (void)levelBouncedList{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    MXssLevelBouncedView *levelView = [[MXssLevelBouncedView alloc]initWithFrame:window.frame withImage:nil];
////    levelView.numberimg =  numimage;
//    [window addSubview:levelView];
//}

- (void)releaseClick {//积分明细点击
    NSLog(@"积分明细的点击");
    MXSSIntegralDetailListViewController *jifenView = [[MXSSIntegralDetailListViewController alloc] init];
    jifenView.selectIndex = 1;
//    jifenView.title = @"积分明细";
    jifenView.mypostS = [NSString stringWithFormat:@"积分明细"];
    jifenView.menuViewStyle = WMMenuViewStyleLine;
    jifenView.automaticallyCalculatesItemWidths = YES;
//    mypostView.mypostS = [NSString stringWithFormat:@"%@",arr[sender.tag]];
//    mypostView.selectIndex = (int)sender.tag;
    //    [self customizePageController:mypostView];
    jifenView.titleColorSelected = mx_Wode_colorBlue2374e4;
    jifenView.titleColorNormal = [UIColor blackColor];
    jifenView.progressColor = mx_Wode_colorBlue2374e4;
    jifenView.titleSizeNormal=14;
    jifenView.titleSizeSelected=14;
    [self.navigationController pushViewController:jifenView animated:YES];
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scaleWithSize(140), screen_width, screen_height - scaleWithSize(140))];
//        if(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] bounds].size.height == 812.0){//判断机型X
//            _scrollView.frame = CGRectMake(0, scaleWithSize(140), screen_width, screen_height - scaleWithSize(240));
//        }else{
            _scrollView.frame = CGRectMake(0, scaleWithSize(140), screen_width, screen_height - scaleWithSize(205));
//        }
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;//关闭滑动
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(2 * screen_width, scaleWithSize(10));
    }
    return _scrollView;
}
- (void)topHeadView{//头显示
     MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(90))];
    topView.backgroundColor =  mx_Wode_colorBlue2374e4;
    [self.view addSubview:topView];
    
    _lvLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(25.0f), topView.frame.size.height - scaleWithSize(60.0f), scaleWithSize(80), scaleWithSize(20))];
    if (userModel.level) {//签名
        _lvLabel.text = [NSString stringWithFormat:@"LV%@",userModel.level];
    }else{
        _lvLabel.text = @"LV2";
    }
    _lvLabel.textColor = [UIColor whiteColor];
    _lvLabel.font = fontSize(scaleWithSize(19.0f));
    [topView addSubview:_lvLabel];
    
    _giftsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _giftsButton.frame = CGRectMake(screen_width - scaleWithSize(20.0f) - scaleWithSize(40.0f), topView.frame.size.height - scaleWithSize(50.0f), scaleWithSize(40.0f), scaleWithSize(40.0f));
    [_giftsButton setImage:[UIImage imageNamed:@"my_Integral_jifenrenwu-liwu"] forState:UIControlStateNormal];
    [topView addSubview:_giftsButton];
    
    _signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(80), topView.frame.size.height - scaleWithSize(70), screen_width - scaleWithSize(80) - _giftsButton.frame.size.width - scaleWithSize(25.0f), scaleWithSize(35))];
    _signatureLabel.textColor = [UIColor whiteColor];
    _signatureLabel.textAlignment = 2;
    if (userModel.nextMinScore) {//下一等级的最低积分线
        NSInteger sum = userModel.nextMinScore.integerValue - userModel.totalScore.integerValue;
        _signatureLabel.text = [NSString stringWithFormat:@"总积分%@,还需要%ld积分升级",userModel.totalScore,sum];
    }else{
        _signatureLabel.text = @"总积分0，还需要0积分升级";
    }
    _signatureLabel.font = fontSize(scaleWithSize(13.0f));
    _signatureLabel.backgroundColor = [UIColor clearColor];
    _signatureLabel.numberOfLines = 0;
    [topView addSubview:_signatureLabel];
    
    //实例化一个进度条，有两种样式，一种是UIProgressViewStyleBar一种是UIProgressViewStyleDefault，几乎无区别
    UIProgressView *pro1=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    pro1.frame = CGRectMake(scaleWithSize(25.0f), topView.maxY - scaleWithSize(20), screen_width - scaleWithSize(25.0f) * 2 - _giftsButton.frame.size.width - scaleWithSize(10), scaleWithSize(10));
    pro1.backgroundColor = [UIColor grayColor];
    pro1.transform = CGAffineTransformMakeScale(1.0f, 3.0f);    // 设置高度
    pro1.progressTintColor = mx_Wode_colorBlueprogress;  // 已走过的颜色
    pro1.trackTintColor = [UIColor whiteColor];  // 为走过的颜色
    pro1.layer.cornerRadius = 4.0f;
    pro1.layer.masksToBounds = YES;
//    pro1.progress = 0.7; // 进度 默认为0.0∈[0.0,1.0]
    float onenum = userModel.totalScore.integerValue;
    float twonum = userModel.nextMinScore.integerValue;
    float num = onenum/twonum;
//    NSLog(@"?????==%f",num);
    pro1.progress = num;
    [topView addSubview:pro1];
    
    UIView *butClickV = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height + scaleWithSize(10), screen_width, scaleWithSize(40))];
    butClickV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:butClickV];
    
    _lvBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _lvBut.frame = CGRectMake(screen_width/2 - scaleWithSize(100), 0, scaleWithSize(100), scaleWithSize(40));
    [_lvBut setTitle:@"等级特权" forState:UIControlStateNormal];
    [_lvBut setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateNormal];
    [_lvBut addTarget:self action:@selector(LVButClick:) forControlEvents:UIControlEventTouchUpInside];
    _lvBut.titleLabel.font = fontSize(scaleWithSize(14.0f));
    [butClickV addSubview:_lvBut];
    
    _xianLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2- scaleWithSize(90), _lvBut.frame.size.height-1, scaleWithSize(80), 1)];
    _xianLabel1.backgroundColor = mx_Wode_colorBlue2374e4;
    _xianLabel1.hidden = NO;
    [butClickV addSubview:_xianLabel1];
    
     _integralBut= [UIButton buttonWithType:UIButtonTypeCustom];
    _integralBut.frame = CGRectMake(screen_width/2, 0, scaleWithSize(100), scaleWithSize(40));
    [_integralBut setTitle:@"积分任务" forState:UIControlStateNormal];
    [_integralBut setTitleColor:mx_Wode_color666666 forState:UIControlStateNormal];
    [_integralBut addTarget:self action:@selector(integralButClick:) forControlEvents:UIControlEventTouchUpInside];
    _integralBut.titleLabel.font = fontSize(scaleWithSize(14.0f));
    [butClickV addSubview:_integralBut];
    
    _xianLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2 + scaleWithSize(10), _integralBut.frame.size.height-1, scaleWithSize(80), 1)];
    _xianLabel2.backgroundColor = mx_Wode_colorBlue2374e4;
    _xianLabel2.hidden = YES;
    [butClickV addSubview:_xianLabel2];
    
}
-(void)LVButClick:(UIButton*)sender {//等级特权点击NSLog(@"等级特权点击");
    [_lvBut setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateNormal];
    [_integralBut setTitleColor:mx_Wode_color666666 forState:UIControlStateNormal];
    _xianLabel2.hidden = YES;
    _xianLabel1.hidden = NO;
    self.scrollView.contentOffset = CGPointMake(0*screen_width, 0);
}
-(void)integralButClick:(UIButton*)sender {//积分任务点击NSLog(@"积分任务点击");
    [_integralBut setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateNormal];
    [_lvBut setTitleColor:mx_Wode_color666666 forState:UIControlStateNormal];
    _xianLabel1.hidden = YES;
    _xianLabel2.hidden = NO;
     self.scrollView.contentOffset = CGPointMake(1*screen_width, 0);
    
    [self FindTaskAndLevelData];//任务积分数据请求
//    //当前时间判断
//    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
//    NSDate *  senddate=[NSDate date];
//    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//    [dateformatter setDateFormat:@"YYYYMMdd"];
//    NSString *  locationString=[dateformatter stringFromDate:senddate];
//    //判断当前时间 一天提醒一次
//    if (![locationString isEqualToString:[NSString stringWithFormat:@"%@",[MXssWodeUtils loadPersonInfo].homeTimeNumber]]) {
        //积分任务弹框
//        [self integralBouncedList];
//        userModel.homeTimeNumber = locationString;
//        [MXssWodeUtils savePersonInfo:userModel];
//    }
}
//#pragma mark --- 积分任务弹框显示
//- (void)integralBouncedList {
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    MXssIntegralBouncedView *levelView = [[MXssIntegralBouncedView alloc]initWithFrame:window.frame withImage:nil];
//    //    levelView.numberimg =  numimage;
//    [window addSubview:levelView];
//}
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"任务积分"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"任务积分界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"任务积分界面\"}"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
