//
//  MXBattleDetailsViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//
#import "MXMainPublishViewsVC.h"
#import "MXSituationViewController.h"
#import "MXBattleDetailsViewController.h"

#import "MXFundamentalsViewController.h"//基本面
#import "MXDiskViewController.h"//盘面
#import "MXLineupViewController.h"//阵容
#import "MXOddsViewController.h"//赔率
#import "MXViewpointViewController.h"//观点

#import "MXPublishOpinionViewController.h" //发布观点

//赔率
#import "MXOddsOuZhiViewController.h"//欧指
#import "MXOddsAsianPlateViewController.h"//亚盘
#import "MXOddsSizeViewController.h"//大小
#import "MXOddsLetTheBallViewController.h"//让球
#import "MXOddsHotAndColdViewController.h"//冷热


#import "MXTeamDetailViewController.h"//球队资料


#define ButtonTag 100      //按钮标签

//#define OddsButtonTag 200   //各种赔率

//#define Timestamps 1528340962 //2018-06-7 11:09:22 1528340962


@interface MXBattleDetailsViewController ()

//底部五个按钮
@property (nonatomic, strong) UIButton * fundamentalsBtn ;//基本面
@property (nonatomic, strong) UIButton * diskBtn ;//盘面
@property (nonatomic, strong) UIButton * lineupBtn ;//阵容
@property (nonatomic, strong) UIButton * oddsBtn ;//赔率
@property (nonatomic, strong) UIButton * viewpointBtn ;//观点


@property (nonatomic, strong) UIView * oddsView ; //赔率（欧指，亚盘，大小）
@property (nonatomic, strong) NSArray * oddsNameArray ;


@property (nonatomic, strong) UIView * blueView ; //头部蓝色视图
@property (nonatomic , strong) UIImageView * backImgView ; //

@property (nonatomic , strong) UILabel * timeLabel ;//比赛开始时间
@property (nonatomic , strong) UILabel * statusLabel ;//比赛状态

@property (nonatomic , strong) UILabel * aTeamNameL ;//主队名
@property (nonatomic , strong) UILabel * aNumberL ;//主队得分
@property (nonatomic , strong) UIImageView * homeLogoView ;//主队logo

@property (nonatomic , strong) UILabel * bTeamNameL ;//客队名
@property (nonatomic , strong) UILabel * bNumberL ;//客队得分
@property (nonatomic , strong) UIImageView * awayLogoView ;//客队logo

@property (nonatomic , assign) BOOL isGetData ;//获取基本面数据成功


@property (nonatomic , strong) UISegmentedControl * segmentedControl ;//动画直播/文字直播


@end

@implementation MXBattleDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor ;
    self.automaticallyAdjustsScrollViewInsets = NO ;
    self.title = _titleString ;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self setUpUI];
    
    [self.view addSubview:self.oddsView];
    
    UIButton * rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    [rightButton setImage:[UIImage imageNamed:@"saishi_fabuguangdian"] forState:(UIControlStateNormal)];
    [rightButton addTarget:self action:@selector(selectorRightBarButtonItemWithOpinionBtn:) forControlEvents:(UIControlEventTouchDown)];
    rightButton.timeInterval=5;
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        rightButton.hidden = YES ;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton] ;
    if ([self.yesOrNoButton isEqualToString:@"个人收藏球赛"] || [self.yesOrNoButton isEqualToString:@"首页赛事"]) {
        [self CreateleftBarButtonItem];//返回按钮
    }
}
-(void)CreateleftBarButtonItem{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //避免iOS 11上导航栏按钮frame小，点不到区域。将按钮设置大点，居左显示
    [backBtn setImage:[UIImage imageNamed:@"mxWodeBackbtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}
// 左上角按钮点击事件
-(void)backEvent{
    [self.navigationController popViewControllerAnimated:YES];
    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}
#pragma mark - 发布观点
- (void)selectorRightBarButtonItemWithOpinionBtn:(UIButton *)button {
    button.enabled=NO;
    [SVProgressHUD showWithStatus:@"正在处理中"];
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
//    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    if (!config.userId) {
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        button.enabled=YES;
    }else{
        
        NSMutableDictionary *paras=[NSMutableDictionary dictionaryWithDictionary:@{@"userId":config.userId,@"token":config.token,@"matchId":[NSString stringWithFormat:@"%li",self.matchId],@"time":[MXLJUtil getNowDateTimeString]}];
        [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:@"api/event/postViewAbility"] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {
            button.enabled=YES;
            if ([[dic objectForKey:@"code"] integerValue]==0) {
                if ([[[dic objectForKey:@"data"] objectForKey:@"canPost"] integerValue]==1) {
                    MXMainPublishViewsVC * publishOpinion = [[MXMainPublishViewsVC alloc]init] ;
                    publishOpinion.matchID = [NSString stringWithFormat:@"%li",self.matchId];
                    publishOpinion.infoDict=[dic objectForKey:@"data"];
                    publishOpinion.startTime=_matchStartTime;
                    publishOpinion.automaticallyCalculatesItemWidths=YES;
                    publishOpinion.menuViewStyle=WMMenuViewStyleLine;
                    publishOpinion.progressColor=[UIColor whiteColor];
                    publishOpinion.tabs=[[dic objectForKey:@"data"] objectForKey:@"tabs"];
                    
                    [self.navigationController pushViewController:publishOpinion animated:YES];
                    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
                    [SVProgressHUD dismiss];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            }
        } WithFailureBlock:^(NSError *error) {
            YANGLog(@"======%@========",error);
            button.enabled=YES;
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }];
//        [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:MXPublishOpinionInitPATH] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {
//            if ([[dic objectForKey:@"code"] integerValue]==1005){
//                [MXssWodeUtils removePersonInfo];
//                UIAlertController *alertCon=[UIAlertController alertControllerWithTitle:@"提示" message:[dic objectForKey:@"msg"] preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    MXLoginViewController *login = [[MXLoginViewController alloc] init];
//                    MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
//                    [self presentViewController:nav animated:YES completion:nil];
//                }];
//                [alertCon addAction:action];
//                [self presentViewController:alertCon animated:YES completion:nil];
//            }else if([[dic objectForKey:@"code"] integerValue]==0){
//                MXMainPublishViewsVC * publishOpinion = [[MXMainPublishViewsVC alloc]init] ;
//                publishOpinion.matchID = [NSString stringWithFormat:@"%li",self.matchId];
//                publishOpinion.infoDict=[dic objectForKey:@"data"];
//                publishOpinion.startTime=_matchStartTime;
//                [self.navigationController pushViewController:publishOpinion animated:YES];
//                self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
//            }else{
////                [[MXAlertView new] showErrorInfo:[dic objectForKey:@"msg"]];
//                MXMainPublishViewsVC * publishOpinion = [[MXMainPublishViewsVC alloc]init] ;
//                publishOpinion.matchID = [NSString stringWithFormat:@"%li",self.matchId];
//                publishOpinion.infoDict=[dic objectForKey:@"data"];
//                publishOpinion.startTime=_matchStartTime;
//                publishOpinion.automaticallyCalculatesItemWidths=YES;
//                publishOpinion.menuViewStyle=WMMenuViewStyleLine;
//                publishOpinion.progressColor=[UIColor whiteColor];
//                publishOpinion.tag=1;
//                [self.navigationController pushViewController:publishOpinion animated:YES];
//                self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
//            }
//            [SVProgressHUD dismiss];
//        } WithFailureBlock:^(NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"处理失败"];
//        }];
//
    }
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (NSArray *)oddsNameArray {
    if (!_oddsNameArray) {
        _oddsNameArray = @[@"欧指",@"亚盘",@"大小",@"让球"];//,@"冷热"
    }
    return _oddsNameArray ;
}
#pragma mark - 赔率
- (UIView *)oddsView {
    
    if (!_oddsView) {
        _oddsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.blueView.frame), screen_width, scaleWithSize(30))];
        _oddsView.hidden = YES ;
        
        for (int i = 0; i < 3; i ++) {
            
            UIButton * btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            btn.frame = CGRectMake(screen_width/3 * (i), 0, screen_width/3, scaleWithSize(30));
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:self.oddsNameArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateSelected];
            btn.tag = ButtonTag + i + 4;
            [btn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
            [_oddsView addSubview:btn];
            
        }
        
        
    }
    
    return _oddsView ;
}
- (UISegmentedControl *)segmentedControl {
    
    if (!_segmentedControl) {
        NSArray *items = @[@"动画直播", @"文字直播"];
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:items] ;
        _segmentedControl.frame = CGRectMake(0, 0, scaleWithSize(132), scaleWithSize(22));
        _segmentedControl.center = CGPointMake(screen_width/2, scaleWithSize(78 + 11 + 5));
        _segmentedControl.backgroundColor = [UIColor whiteColor] ;
        [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName:fontSize(scaleWithSize(10)),NSForegroundColorAttributeName:mx_Wode_colorBlue2374e4} forState:(UIControlStateNormal)] ;
        [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:mx_Wode_colorBlue2374e4} forState:(UIControlStateSelected)] ;
        _segmentedControl.layer.masksToBounds = YES;
        _segmentedControl.layer.cornerRadius = scaleWithSize(11) ;
        _segmentedControl.tintColor = [UIColor whiteColor] ;
        _segmentedControl.momentary = YES ;
        
        //监听点击
        [_segmentedControl addTarget:self action:@selector(clickedSituationBtn) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl ;
}


#pragma mark - 赛况信息
- (UIView *)blueView {
    
    if (!_blueView) {
        _blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(110))];
        _blueView.backgroundColor = mx_Wode_colorBlue2374e4;
        
        self.backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scaleWithSize(345), scaleWithSize(78))] ;
        self.backImgView.center = CGPointMake(screen_width/2, scaleWithSize(39)) ;
        [_blueView addSubview:self.backImgView] ;
        
        
        
        //比赛开始时间
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, scaleWithSize(17), screen_width, scaleWithSize(10))];
//        timeLabel.text = @"2018-03-08 11:30";
        
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = fontSize(scaleWithSize(10));
        self.timeLabel.textAlignment = 1;
        [_blueView addSubview:self.timeLabel];
        
        //比赛状态
        self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame) + scaleWithSize(7), screen_width, scaleWithSize(10))];
//        statusLabel.text = @"完场";
        self.statusLabel.textColor = [UIColor whiteColor];
        self.statusLabel.font = fontSize(scaleWithSize(10));
        self.statusLabel.textAlignment = 1;
        [_blueView addSubview:self.statusLabel];
        
        //按钮@“赛况”
        UIButton * situationBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        situationBtn.frame = CGRectMake(0, 0, scaleWithSize(66), scaleWithSize(22));
        situationBtn.center = CGPointMake(screen_width/2, scaleWithSize(78 + 11 + 5));
        situationBtn.layer.masksToBounds = YES;
        situationBtn.layer.cornerRadius = scaleWithSize(11) ;
        [situationBtn setTitle:@"赛况" forState:(UIControlStateNormal)];
        situationBtn.titleLabel.font = fontSize(scaleWithSize(10)) ;
        [situationBtn setTitleColor:mx_Wode_colorBlue2374e4 forState:(UIControlStateNormal)];
        [situationBtn setBackgroundColor:[UIColor whiteColor]];
        [situationBtn addTarget:self action:@selector(clickedSituationBtn) forControlEvents:UIControlEventTouchUpInside];
//        [_blueView addSubview:situationBtn];
        [_blueView addSubview:self.segmentedControl] ;
        
        
        
        self.aTeamNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width / 2 , scaleWithSize(10))];
        self.aTeamNameL.center = CGPointMake(screen_width/4, scaleWithSize(50));
//        aTeamNameL.text = @"莱昂";
        
        self.aTeamNameL.textColor = [UIColor whiteColor];
        self.aTeamNameL.font = fontSize(scaleWithSize(10));
        self.aTeamNameL.textAlignment = 1;
        [_blueView addSubview:self.aTeamNameL];
        
        self.aNumberL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width / 2 , scaleWithSize(31))];
        self.aNumberL.center = CGPointMake(screen_width/4, CGRectGetMidY(self.aTeamNameL.frame) -  scaleWithSize(22));
//        aNumberL.text = @"4";
        self.aNumberL.textColor = [UIColor whiteColor];
        self.aNumberL.font = fontSize(scaleWithSize(31));
        self.aNumberL.textAlignment = 1;
        [_blueView addSubview:self.aNumberL];
        
        self.homeLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, scaleWithSize(11), scaleWithSize(115), scaleWithSize(41))] ;
        self.homeLogoView.contentMode = UIViewContentModeScaleAspectFit ;
//        homeLogo.backgroundColor = [UIColor redColor] ;
        [self.backImgView addSubview:self.homeLogoView] ;
        
        
        
        
        self.bTeamNameL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width / 2 , scaleWithSize(10))];
        self.bTeamNameL.center = CGPointMake(screen_width * 3.f/4, scaleWithSize(50));
//        bTeamNameL.text = @"塞拉娅";
        
        self.bTeamNameL.textColor = [UIColor whiteColor];
        self.bTeamNameL.font = fontSize(scaleWithSize(10));
        self.bTeamNameL.textAlignment = 1;
        [_blueView addSubview:self.bTeamNameL];
        
        self.bNumberL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width / 2 , scaleWithSize(31))];
        self.bNumberL.center = CGPointMake(screen_width * 3.f/4, CGRectGetMidY(self.bTeamNameL.frame) -  scaleWithSize(22));
//        bNumberL.text = @"4";
        self.bNumberL.textColor = [UIColor whiteColor];
        self.bNumberL.font = fontSize(scaleWithSize(31));
        self.bNumberL.textAlignment = 1;
        [_blueView addSubview:self.bNumberL];
        
        self.awayLogoView = [[UIImageView alloc]initWithFrame:CGRectMake(scaleWithSize(230), scaleWithSize(11), scaleWithSize(115), scaleWithSize(41))] ;
        self.awayLogoView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.backImgView addSubview:self.awayLogoView] ;
        
        UITapGestureRecognizer * tapA = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectATeamDetail)] ;
        self.aNumberL.userInteractionEnabled = YES ;
        [self.aNumberL addGestureRecognizer:tapA] ;
        
        UITapGestureRecognizer * tapB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectBTeamDetail)] ;
        self.bNumberL.userInteractionEnabled = YES ;
        [self.bNumberL addGestureRecognizer:tapB] ;
        
        
//        [self setEventInfo] ;
        
        
    }
    return _blueView;
}
- (void)setEventInfo {
    
    if (![_matchStartTime isEqualToString:@""]) {
        self.timeLabel.text = [self timeInterverlToDateStr:_matchStartTime] ;
    }
    
    self.aTeamNameL.text = _homeNm ;
    self.bTeamNameL.text = _awayNm ;
    
    switch (_status) {
        case 0:
            self.statusLabel.text = @"比赛异常";
            break;
        case 1:
            self.statusLabel.text = @"未开赛";
            break;
        case 2:
            self.statusLabel.text = @"上半场";
            break;
        case 3:
            self.statusLabel.text = @"中场";
            break;
        case 4:
            self.statusLabel.text = @"下半场";
            break;
        case 5:
            self.statusLabel.text = @"加时赛上半场";
            break;
        case 6:
            self.statusLabel.text = @"加时赛下半场";
            break;
        case 7:
            self.statusLabel.text = @"点球决战";
            break;
        case 8:
            self.statusLabel.text = @"完场";
            break;
        case 9:
            self.statusLabel.text = @"推迟";
            break;
        case 10:
            self.statusLabel.text = @"中断";
            break;
        case 11:
            self.statusLabel.text = @"腰斩";
            break;
        case 12:
            self.statusLabel.text = @"取消";
            break;
        case 13:
            self.statusLabel.text = @"待定";
            break;
            
        default:
            break;
    }
    
    if (_status == 8) {
        
        self.aNumberL.text = _homeScore ;
        self.bNumberL.text = _awayScore ;
        self.aTeamNameL.textColor = [UIColor whiteColor] ;
        self.bTeamNameL.textColor = [UIColor whiteColor] ;
        
        self.backImgView.image = Image(@"") ;
        self.homeLogoView.image = Image(@"") ;
        self.awayLogoView.image = Image(@"") ;
        self.timeLabel.center = CGPointMake(screen_width/2, scaleWithSize(22)) ;
        self.aTeamNameL.center = CGPointMake(screen_width/4, scaleWithSize(50));
        self.bTeamNameL.center = CGPointMake(screen_width * 3.f/4, scaleWithSize(50));
        
    } else {
        self.aNumberL.text = @"" ;
        self.bNumberL.text = @"" ;
        self.backImgView.image = Image(@"saishi_vs_beijing") ;
        self.aTeamNameL.textColor = mx_Wode_colorBlue2374e4 ;
        self.bTeamNameL.textColor = mx_Wode_colorBlue2374e4 ;
        self.timeLabel.center = CGPointMake(screen_width/2, scaleWithSize(50)) ;
//        [self.homeLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_homeLogo]]];
//        [self.awayLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_awayLogo]]] ;
        [self.homeLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_homeLogo]] placeholderImage:Image(@"saishi_huilogo")] ;
        [self.awayLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_awayLogo]] placeholderImage:Image(@"saishi_huilogo")] ;
        
        self.aTeamNameL.center = CGPointMake(self.homeLogoView.center.x + self.backImgView.frame.origin.x, CGRectGetMaxY(self.homeLogoView.frame) + scaleWithSize(10)) ;
        self.bTeamNameL.center = CGPointMake(self.awayLogoView.center.x + self.backImgView.frame.origin.x, CGRectGetMaxY(self.awayLogoView.frame) + scaleWithSize(10)) ;
    }
    
    self.statusLabel.frame = CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame) + scaleWithSize(7), screen_width, scaleWithSize(10)) ;
    
}

#pragma mark - 时间戳转为时间字符串
- (NSString *)timeInterverlToDateStr:(NSString *)timeStr {
    //timeStr时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式yyyy.MM.dd HH:mm
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

#pragma mark - 手势
- (void)selectATeamDetail {
    
//    MXTeamDetailViewController * viewContro = [[MXTeamDetailViewController alloc]init] ;
    
//    [self.navigationController pushViewController:viewContro animated:YES] ;
}
- (void)selectBTeamDetail {
    
//    MXTeamDetailViewController * viewContro = [[MXTeamDetailViewController alloc]init] ;
    
//    [self.navigationController pushViewController:viewContro animated:YES] ;
}

#pragma mark - 赛事信息
- (UIButton *)fundamentalsBtn {
    if (!_fundamentalsBtn) {
        _fundamentalsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fundamentalsBtn.backgroundColor = [UIColor whiteColor];
        [_fundamentalsBtn setTitle:@"基本面" forState:UIControlStateNormal];
        [_fundamentalsBtn setSelected:YES];
        [_fundamentalsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_fundamentalsBtn setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateSelected];
        _fundamentalsBtn.tag = ButtonTag + 1;
        [_fundamentalsBtn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fundamentalsBtn;
}
- (UIButton *)diskBtn {
    if (!_diskBtn) {
        _diskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _diskBtn.backgroundColor = [UIColor whiteColor];
        [_diskBtn setTitle:@"盘面" forState:UIControlStateNormal];
        [_diskBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_diskBtn setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateSelected];
        _diskBtn.tag = ButtonTag + 2;
        [_diskBtn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _diskBtn;
}
- (UIButton *)lineupBtn {
    if (!_lineupBtn) {
        _lineupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lineupBtn.backgroundColor = [UIColor whiteColor];
        [_lineupBtn setTitle:@"阵容" forState:UIControlStateNormal];
        [_lineupBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_lineupBtn setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateSelected];
        _lineupBtn.tag = ButtonTag + 3;
        [_lineupBtn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lineupBtn;
}
- (UIButton *)oddsBtn {
    if (!_oddsBtn) {
        _oddsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _oddsBtn.backgroundColor = [UIColor whiteColor];
        [_oddsBtn setTitle:@"赔率" forState:UIControlStateNormal];
        [_oddsBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_oddsBtn setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateSelected];
        _oddsBtn.tag = ButtonTag + 10;
        [_oddsBtn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oddsBtn;
}
- (UIButton *)viewpointBtn {
    if (!_viewpointBtn) {
        _viewpointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _viewpointBtn.backgroundColor = [UIColor whiteColor];
        [_viewpointBtn setTitle:@"观点" forState:UIControlStateNormal];
        [_viewpointBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_viewpointBtn setTitleColor:mx_Wode_colorBlue2374e4 forState:UIControlStateSelected];
        _viewpointBtn.tag = ButtonTag + 7 ;
        [_viewpointBtn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _viewpointBtn;
}
#pragma mark - 赛况
-(void)clickedSituationBtn {
    
    
    if (!self.isGetData) {
        return ;
    }
    
        MXSituationViewController *situationVC=[[MXSituationViewController alloc] init];
//        situationVC.title=[NSString stringWithFormat:@"%@ %@-%@ %@",_homeNm,_homeScore,_awayScore,_awayNm];
        situationVC.matchID=[NSString stringWithFormat:@"%li",self.matchId];
        situationVC.matchStatus=[NSString stringWithFormat:@"%i",self.status];
        situationVC.bulletCsmScore = [NSString stringWithFormat:@"%ld",self.bulletCsmScore] ;
        situationVC.automaticallyCalculatesItemWidths=YES;
        situationVC.menuViewStyle=WMMenuViewStyleLine;//跳转前设置有效
        situationVC.progressColor=mx_Wode_colorBlue2374e4;//跳转前设置有效
        situationVC.flag = _flashFlg ;
    
    situationVC.bulletMinLv = self.bulletMinLv ;
    situationVC.chatMinLv = self.chatMinLv ;
    
        situationVC.selectedIndex=self.segmentedControl.selectedSegmentIndex;
        [self.navigationController pushViewController:situationVC animated:YES];
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
}

#pragma mark - 切换视图
- (void)selectorButton:(UIButton *)button {
    NSInteger tag = button.tag - ButtonTag;
    
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        
        switch (tag) {
            case 1:
                self.lineupBtn.selected = NO;
                self.fundamentalsBtn.selected = YES;
                self.selectIndex = 0 ;
                break;
            case 3:
                self.fundamentalsBtn.selected = NO;
                self.lineupBtn.selected = YES;
                self.selectIndex = 1 ;
                break;
        
            default:
                break;
        }
        
        return ;
    }
    
    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
    if (tag == 7) {
        if (!userModel.userId) {
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:^{
                
            }] ;
            return ;
        }
    }
    
    if (self.oddsBtn.selected) {
        if (tag == 10) {
            return ;
        }
    }
    
    self.fundamentalsBtn.selected = NO;
    self.diskBtn.selected = NO;
    self.lineupBtn.selected = NO;
    self.oddsBtn.selected = NO;
    self.viewpointBtn.selected = NO;
    self.oddsView.hidden = YES ;
    if (tag < 10) {
        self.selectIndex = (int) tag - 1 ;
    } else {
        self.selectIndex = 3 ;
    }
    
    for (UIButton * btn in self.oddsView.subviews) {
        
        btn.selected = NO ;
        if (btn.tag == button.tag) {
            self.oddsView.hidden = NO ;
            self.oddsBtn.selected = YES;
            btn.selected = YES ;
        }
    }
    
    
    
    switch (tag) {
        case 1:
            self.fundamentalsBtn.selected = YES;
            break;
        case 2:
            self.diskBtn.selected = YES;
            break;
        case 3:
            self.lineupBtn.selected = YES;
            break;
        case 10:
            
                self.oddsBtn.selected = YES;
                self.oddsView.hidden = NO ;
                for (UIButton * btn in self.oddsView.subviews) {
                    btn.selected = NO ;
                    if (btn.tag == ButtonTag + 4) {
                        btn.selected = YES ;
                    }
                    
                }
        
            break;
        case 7:
            self.viewpointBtn.selected = YES;
            break;
            
        default:
            break;
    }
    
}

- (void)setUpUI {
    
    [self.view addSubview:self.blueView];
    
    [self.view addSubview:self.fundamentalsBtn];
    
    [self.view addSubview:self.lineupBtn];
    
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        self.fundamentalsBtn.frame = CGRectMake(0, screen_height - scaleWithSize(44) - (STATUS_AND_NAVIGATION_HEIGHT) - TABBAR_FRAME, screen_width / 2, scaleWithSize(44));
        self.lineupBtn.frame = CGRectMake(CGRectGetMaxX(self.fundamentalsBtn.frame) , CGRectGetMinY(self.fundamentalsBtn.frame), screen_width / 2, scaleWithSize(44));
        return ;
    } else {
        
        [self.view addSubview:self.diskBtn];
        [self.view addSubview:self.oddsBtn];
        [self.view addSubview:self.viewpointBtn];
    }
    
    self.fundamentalsBtn.frame = CGRectMake(0, screen_height - scaleWithSize(44) - (STATUS_AND_NAVIGATION_HEIGHT) - TABBAR_FRAME, screen_width / 5, scaleWithSize(44));
//    self.fundamentalsBtn.backgroundColor = [UIColor redColor] ;
    self.diskBtn.frame = CGRectMake(CGRectGetMaxX(self.fundamentalsBtn.frame) , CGRectGetMinY(self.fundamentalsBtn.frame), screen_width / 5, scaleWithSize(44));
    self.lineupBtn.frame = CGRectMake(CGRectGetMaxX(self.diskBtn.frame) , CGRectGetMinY(self.fundamentalsBtn.frame), screen_width / 5, scaleWithSize(44));
    self.oddsBtn.frame = CGRectMake(CGRectGetMaxX(self.lineupBtn.frame) , CGRectGetMinY(self.fundamentalsBtn.frame), screen_width / 5, scaleWithSize(44));
    self.viewpointBtn.frame = CGRectMake(CGRectGetMaxX(self.oddsBtn.frame) , CGRectGetMinY(self.fundamentalsBtn.frame), screen_width / 5, scaleWithSize(44));
    
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        return 2 ;
    }
    
    return 7;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return nil;
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue] > 0) {
        
        switch (index % 2) {
            case 0:
            {MXFundamentalsViewController * VC = [[MXFundamentalsViewController alloc] init] ;
                VC.matchId = _matchId ;
                VC.dataRefreshing = ^(MXEventBasicPanelModel *model) {
                    
                    self.isGetData = 1 ;
                    
                    self.status = (int)model.matchStatus ;
                    self.flashFlg = model.flashFlg ;
                    self.matchStartTime = model.matchStartTime ;
                    self.homeNm = model.homeNm ;
                    self.awayNm = model.awayNm ;
                    self.homeScore = [NSString stringWithFormat:@"%ld",model.homeScore] ;
                    self.awayScore = [NSString stringWithFormat:@"%ld",model.awayScore] ;
                    self.homeLogo = model.homeLogo ;
                    self.awayLogo = model.awayLogo ;
                    self.title = model.eventNm ;
                    self.bulletCsmScore = model.bulletCsmScore ;
                    self.bulletMinLv = model.bulletMinLv ;
                    self.chatMinLv = model.chatMinLv ;
                    
                    [self setEventInfo] ;
                } ;
                return VC;}
            case 1:
            {MXLineupViewController * VC = [[MXLineupViewController alloc] init] ;
                VC.matchId = _matchId ;
                return VC;}
                
        }
        
        return [[UIViewController alloc] init] ;
    }
    
    switch (index % 7) {
        case 0:
        {MXFundamentalsViewController * VC = [[MXFundamentalsViewController alloc] init] ;
            VC.matchId = _matchId ;
            VC.dataRefreshing = ^(MXEventBasicPanelModel *model) {
                
                self.isGetData = 1 ;
                
                self.status = (int)model.matchStatus ;
                self.flashFlg = model.flashFlg ;
                self.matchStartTime = model.matchStartTime ;
                self.homeNm = model.homeNm ;
                self.awayNm = model.awayNm ;
                self.homeScore = [NSString stringWithFormat:@"%ld",model.homeScore] ;
                self.awayScore = [NSString stringWithFormat:@"%ld",model.awayScore] ;
                self.homeLogo = model.homeLogo ;
                self.awayLogo = model.awayLogo ;
                self.title = model.eventNm ;
                self.bulletCsmScore = model.bulletCsmScore ;
                self.bulletMinLv = model.bulletMinLv ;
                self.chatMinLv = model.chatMinLv ;
                
                [self setEventInfo] ;
                
                //                self.timeLabel.text = [self timeInterverlToDateStr:model.matchStartTime] ;
                //                self.aTeamNameL.text = model.homeNm ;
                //                self.bTeamNameL.text = model.awayNm ;
                //                if (model.matchStatus == 8) {
                //
                //                    self.aNumberL.text = [NSString stringWithFormat:@"%ld",model.homeScore] ;
                //                    self.bNumberL.text = [NSString stringWithFormat:@"%ld",model.awayScore] ;
                ////                    self.statusLabel.text = @"完场";
                //                } else {
                //                    self.backImgView.image = Image(@"saishi_vs_beijing") ;
                //                    self.aTeamNameL.textColor = mx_Wode_colorBlue2374e4 ;
                //                    self.bTeamNameL.textColor = mx_Wode_colorBlue2374e4 ;
                //                    self.timeLabel.center = CGPointMake(screen_width/2, scaleWithSize(50)) ;
                //                    [self.homeLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.homeLogo]]];
                //                    [self.awayLogoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.awayLogo]]] ;
                //
                //                    self.aTeamNameL.center = CGPointMake(self.homeLogoView.center.x + self.backImgView.frame.origin.x, CGRectGetMaxY(self.homeLogoView.frame) + scaleWithSize(10)) ;
                //                    self.bTeamNameL.center = CGPointMake(self.awayLogoView.center.x + self.backImgView.frame.origin.x, CGRectGetMaxY(self.awayLogoView.frame) + scaleWithSize(10)) ;
                //
                //                }
                
            } ;
            return VC;}
        case 1:
        {MXDiskViewController * VC = [[MXDiskViewController alloc] init] ;
            VC.matchId = _matchId ;
            return VC;}
        case 2:
        {MXLineupViewController * VC = [[MXLineupViewController alloc] init] ;
            VC.matchId = _matchId ;
            return VC;}
        case 3:
        {MXOddsOuZhiViewController * VC = [[MXOddsOuZhiViewController alloc] init] ;
            VC.matchId = _matchId ;
            return VC;}
        case 4:
        {MXOddsAsianPlateViewController * VC = [[MXOddsAsianPlateViewController alloc] init] ;
            VC.matchId = _matchId ;
            return VC;}
        case 5:
        {MXOddsSizeViewController * VC = [[MXOddsSizeViewController alloc] init] ;
            VC.matchId = _matchId ;
            return VC;}
            //        case 6:
            //        {MXOddsLetTheBallViewController * VC = [[MXOddsLetTheBallViewController alloc] init] ;
            //            VC.matchId = _matchId ;
            //            return VC;}
            //        case 7:
            //            return [[MXOddsHotAndColdViewController alloc] init];
        case 6:
        {MXViewpointViewController * VC = [[MXViewpointViewController alloc] init] ;
            VC.matchId = _matchId ;
            return VC;}
    }
    
    
    return [[UIViewController alloc] init];
}
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
    
    MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
    if ([info[@"index"] integerValue] % 7 == 6) {
        if (!userModel.userId) {
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:^{
                
            }] ;
            self.selectIndex = 5 ;
            return ;
        }
    }
    
    self.fundamentalsBtn.selected = NO;
    self.diskBtn.selected = NO;
    self.lineupBtn.selected = NO;
    self.oddsBtn.selected = NO;
    self.viewpointBtn.selected = NO;
    
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue] > 0) {
        
        switch ([info[@"index"] integerValue] % 2) {
            case 0:
                self.fundamentalsBtn.selected = YES;
                self.oddsView.hidden = YES ;
                break;
            case 1:
                self.lineupBtn.selected = YES;
                self.oddsView.hidden = YES ;
                break;
            
            default:
                
                break;
                
        }
        
        return  ;
    }
    
    switch ([info[@"index"] integerValue] % 7) {
        case 0:
            self.fundamentalsBtn.selected = YES;
            self.oddsView.hidden = YES ;
            break;
        case 1:
            self.diskBtn.selected = YES;
            self.oddsView.hidden = YES ;
            break;
        case 2:
            self.lineupBtn.selected = YES;
            self.oddsView.hidden = YES ;
            break;
        
        case 6:
            self.viewpointBtn.selected = YES;
            self.oddsView.hidden = YES ;
            break;
            
        default:
            
            self.oddsView.hidden = NO;
            self.oddsBtn.selected = YES;
            for (UIButton * btn in self.oddsView.subviews) {
                btn.selected = NO ;
                
                if (btn.tag == ButtonTag + [info[@"index"] integerValue] % 7 + 1) {
                    btn.selected = YES ;
                }
                
            }
            
            break;
            
    }
    
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
//    if (self.menuViewPosition == WMMenuViewPositionBottom) {
//        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
//        return CGRectMake(0, self.view.frame.size.height - scaleWithSize(100), self.view.frame.size.width, 0);
//    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 0);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
//    if (self.menuViewPosition == WMMenuViewPositionBottom) {
//        return CGRectMake(0, STATUS_AND_NAVIGATION_HEIGHT + scaleWithSize(100), self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
//    }
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
//    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
////        originY += self.redView.frame.size.height;
//    }
//    STATUS_AND_NAVIGATION_HEIGHT +
    return CGRectMake(0,  0 + scaleWithSize(110), self.view.frame.size.width, screen_height - originY - scaleWithSize(110 + 44) - TABBAR_FRAME);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
