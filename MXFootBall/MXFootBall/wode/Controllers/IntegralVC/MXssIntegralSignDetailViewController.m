//
//  MXssIntegralSignDetailViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXssIntegralSignDetailViewController.h"
//#import "GFCalendar.h"//日历相关
#import "JF_CalendarView.h"//日历相关
#import "MXssSinginRiliModel.h"//日历返回model
#import "MXssIntegralQiandaoGuizeButtonViewController.h"//签到规则页面

@interface MXssIntegralSignDetailViewController ()
@property (nonatomic,strong) UIView *riliView;//日历

//@property (nonatomic,strong) UIView *signRulesView;//签到规则
//@property (nonatomic,strong) UILabel *signRulesLabel;//签到规则Label

@property(nonatomic,strong) JF_CalendarView *calendarView;
@property (nonatomic,strong) NSMutableArray *riliArr;//日历数组
@property (nonatomic,strong) UIButton *qiandaoGuizeButton;//签到规则按钮
@end

@implementation MXssIntegralSignDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.riliArr = [NSMutableArray array];
    self.view.backgroundColor = mx_Wode_backgroundColor;
    [self.view addSubview:self.riliView];//日历
    [self.view addSubview:self.qiandaoGuizeButton];//签到规则按钮
//    [self.view addSubview:self.signRulesView];//签到规则
//    [self.signRulesView addSubview:self.signRulesLabel];
    [self setupCalendar]; //  配置 Calendar
    [self signInTimeMoreData];//签到明细 时间请求数据
}

#pragma mark ---signInTimeData签到明细(签到时间)
-(void)signInTimeMoreData {//签到明细(签到时间)
    [SVProgressHUD showWithStatus:@"正在加载..."];
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMySignInTime_PATH;//签到明细(签到时间)
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"签到明细(签到时间)列表==%@",personDic);
        //        NSDictionary *dic = [personDic objectForKey:@"data"];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            // [self.mainTableview.mj_header endRefreshing];
            NSDictionary *riliDict = personDic[@"data"];

            MXssSinginRiliModel *model = [MXssSinginRiliModel modelWithDictionary:riliDict];
            self.calendarView.arrayNumberTime = model.signDays.copy;
//            self.signRulesLabel.text = model.signRule;//签到规则
        }

        else{ if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
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
//        [SVProgressHUD showErrorWithStatus:@"请求错误"];
    }];
}


- (void)setupCalendar {
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing=0;
    self.calendarView=[[JF_CalendarView alloc]initWithFrame:CGRectMake(0, scaleWithSize(30), self.riliView.frame.size.width, self.riliView.frame.size.height - scaleWithSize(34)) collectionViewLayout:layout];
    [self.riliView addSubview:self.calendarView];
}

- (UIView *)riliView {//日历
    if (!_riliView) {
        _riliView = [[UIView alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(20), screen_width - scaleWithSize(30), scaleWithSize(320))];
        _riliView.backgroundColor = [UIColor clearColor];
        _riliView.layer.cornerRadius = scaleWithSize(5.0f);
        _riliView.layer.masksToBounds = YES;
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _riliView.frame.size.width, _riliView.frame.size.height)];
        image.image = [UIImage imageNamed:@"my_rili_BEIjing"];
        [_riliView addSubview:image];
    }
    return _riliView;
}

- (UIButton *)qiandaoGuizeButton {
    if (!_qiandaoGuizeButton) {
        _qiandaoGuizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _qiandaoGuizeButton.frame = CGRectMake(screen_width - scaleWithSize(100), _riliView.maxY + scaleWithSize(25), scaleWithSize(100-15), scaleWithSize(30));
        [_qiandaoGuizeButton setTitle:@"签到规则>>" forState:UIControlStateNormal];
        _qiandaoGuizeButton.titleLabel.font = fontSize(scaleWithSize(13.0f));
        [_qiandaoGuizeButton setTitleColor:mx_Wode_colorBlueprogress forState:UIControlStateNormal];
        [_qiandaoGuizeButton addTarget:self action:@selector(qiandaoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qiandaoGuizeButton;
}
- (void)qiandaoClick:(UIButton *)sender {
    NSLog(@"签到规则按钮跳转页面");
    MXssIntegralQiandaoGuizeButtonViewController *qiandaoView = [[MXssIntegralQiandaoGuizeButtonViewController alloc] init];
    qiandaoView.webViewURL = @"https://qiuyoule.com/integralLevel.html";
    [self.navigationController pushViewController:qiandaoView animated:YES];
}
//- (UIView *)signRulesView {
//    if (!_signRulesView) {
//        _signRulesView = [[UIView alloc] initWithFrame:CGRectMake(scaleWithSize(15), _riliView.maxY + scaleWithSize(20), screen_width - scaleWithSize(30), scaleWithSize(150))];
//        _signRulesView.backgroundColor = [UIColor whiteColor];
//        _signRulesView.layer.cornerRadius = scaleWithSize(15.0f);
//        _signRulesView.layer.masksToBounds = YES;
//
//        UILabel *lis = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(20), _signRulesView.frame.size.width - scaleWithSize(30), 1)];
//        lis.backgroundColor = mx_Wode_colord9d9d9;
//        [_signRulesView addSubview:lis];
//
//        UILabel *signRulesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_signRulesView.frame.size.width / 2 - scaleWithSize(35), scaleWithSize(10), scaleWithSize(70), scaleWithSize(20))];
//        signRulesLabel.backgroundColor = [UIColor whiteColor];
//        signRulesLabel.textAlignment= 1;
//        signRulesLabel.text = @"签到规则";
//        signRulesLabel.textColor = mx_Wode_color999999;
//        signRulesLabel.font = fontSize(scaleWithSize(14.0f));
//        [_signRulesView addSubview:signRulesLabel];
//    }
//    return _signRulesView;
//}

//- (UILabel *)signRulesLabel {
//    if (_signRulesLabel == nil) {
//        _signRulesLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(30), _signRulesView.frame.size.width - scaleWithSize(30), 50)];
//        _signRulesLabel.textColor = mx_Wode_color999999;
//        _signRulesLabel.numberOfLines = 0;
//        _signRulesLabel.text = @"1.每日签到领积分。\n2.超过15天未上线用户，每日扣除10积分，直到1级";
//        _signRulesLabel.font = fontSize(scaleWithSize(13));
//        CGSize size = [_signRulesLabel sizeThatFits:CGSizeMake(200, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
//        _signRulesLabel.frame = CGRectMake(scaleWithSize(15), scaleWithSize(30), _signRulesView.frame.size.width - scaleWithSize(30), size.height + 3);////<span style="font-family:Menlo;">假如是自适应高度的话，就把宽度确定</span>
//
//    }
//    return _signRulesLabel;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
