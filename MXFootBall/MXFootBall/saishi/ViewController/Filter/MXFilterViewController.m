//
//  MXFilterViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXFilterViewController.h"

#import "MXEventScreeningViewController.h"//赛事筛选
#import "MXAsianPlateScreeningViewController.h"//亚盘筛选


@interface MXFilterViewController ()

@property (nonatomic , strong) UIButton * closeWhiteButton ;


@property (nonatomic , strong) MXEventScreeningViewController * fristVc ; //赛事筛选
@property (nonatomic , strong) MXAsianPlateScreeningViewController * secondVc ; //亚盘筛选

@property (nonatomic , strong) UIButton * defineButton ;

@end

@implementation MXFilterViewController

- (UIButton *)defineButton {
    if (!_defineButton) {
        _defineButton = [UIButton buttonWithType:(UIButtonTypeCustom)] ;
        _defineButton.frame = CGRectMake(screen_width - scaleWithSize(15 + 60) , scaleWithSize(15) + STATUS_HEIGHT, scaleWithSize(60), scaleWithSize(30));
        _defineButton.contentHorizontalAlignment = 2 ;
        [_defineButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [_defineButton setTitleColor:mx_Wode_colorBlue2374e4 forState:(UIControlStateNormal)];
        [_defineButton addTarget:self action:@selector(selectorDefineButton:) forControlEvents:(UIControlEventTouchDown)];
    }
    return _defineButton ;
}

- (UIButton *)closeWhiteButton {
    if (!_closeWhiteButton) {
        _closeWhiteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeWhiteButton.frame = CGRectMake(scaleWithSize(15), scaleWithSize(15) + STATUS_HEIGHT, scaleWithSize(40), scaleWithSize(30)) ;
        [_closeWhiteButton setImage:[UIImage imageNamed:@"saishi_cha"] forState:(UIControlStateNormal)];
        [_closeWhiteButton addTarget:self action:@selector(selectorCloseWhiteButtonBackVC:) forControlEvents:(UIControlEventTouchDown)];
    }
    return _closeWhiteButton ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO ;
    self.view.backgroundColor = mx_Wode_backgroundColor ;
    [self.view addSubview:self.closeWhiteButton] ;
    [self.view addSubview:self.defineButton] ;
    
    
    
    self.fristVc = [[MXEventScreeningViewController alloc] init];
    self.fristVc.menuViewStyle = WMMenuViewStyleLine ;
    self.fristVc.optType = self.optType ;
    self.fristVc.view.frame = CGRectMake(0, scaleWithSize(60) + STATUS_HEIGHT, screen_width, screen_height - scaleWithSize(60) - STATUS_HEIGHT);
    
//    NSLog(@"---%@",self.optType) ;
    [self addChildViewController:_fristVc];
    
    __weak typeof(self) weakSelf = self ;
    [weakSelf.fristVc setSelectNameDic:^(NSMutableDictionary *dic) {
//        NSLog(@"%@",dic) ;
    }] ;
    
    self.secondVc = [[MXAsianPlateScreeningViewController alloc] init];
    self.secondVc.view.frame = CGRectMake(0, scaleWithSize(60) + STATUS_HEIGHT, screen_width, screen_height - scaleWithSize(60) - STATUS_HEIGHT);
    self.secondVc.optType = self.optType ;
    [self addChildViewController:_secondVc];
    
    [self.view addSubview:self.fristVc.view];
    
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  < 0) {
        [self.view addSubview:[self setupSegment]] ;
    }
    
    
    
}
//对战筛选界面
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([self.optType isEqualToString:@"1"]) {
        [defaults setValue:@"" forKey:@"AllAsianPlateKeyEnd1"] ;
    } else if ([self.optType isEqualToString:@"2"]) {
        [defaults setValue:@"" forKey:@"AllAsianPlateKeyWorldCup1"] ;
    } else {
        [defaults setValue:@"" forKey:@"AllAsianPlateKeyImm1"] ;
    }
    [defaults synchronize];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"对战筛选界面\"}"] ;
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated] ;
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"对战筛选界面\"}"] ;
}

- (UISegmentedControl *)setupSegment{
    NSArray *items = @[@"1", @"2"];
    UISegmentedControl *sgc = [[UISegmentedControl alloc] initWithItems:items];
    sgc.frame = CGRectMake(0, 0, screen_width / 2, scaleWithSize(30)) ;
    sgc.center = CGPointMake(screen_width / 2, scaleWithSize(30) + STATUS_HEIGHT) ;
    sgc.tintColor = mx_Wode_colorBlue2374e4 ;
    //默认选中的位置
    sgc.selectedSegmentIndex = 0;
    //设置segment的文字
    [sgc setTitle:@"赛事筛选" forSegmentAtIndex:0];
    [sgc setTitle:@"亚盘筛选" forSegmentAtIndex:1];
    //监听点击
    [sgc addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    return sgc;
}

- (void)segmentChange:(UISegmentedControl *)sgc{
    //NSLog(@"%ld", sgc.selectedSegmentIndex);
    switch (sgc.selectedSegmentIndex) {
            case 0:
//            self.fristVc.view.frame=self.view.frame;
            [self.fristVc.view removeFromSuperview] ;
            [self.view addSubview:self.fristVc.view];
            self.fristVc.optType = self.optType ;
            [self.fristVc didMoveToParentViewController:self];
            break;
            
        default:
        {
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSString * allScreeningIDsString ;
//            = [defaults valueForKey:@"AllScreeningKey1"] ;
            if ([self.optType isEqualToString:@"1"]) {
                allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyEnd1"] ;
            } else if ([self.optType isEqualToString:@"2"]) {
                allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyWorldCup1"] ;
            } else{
                allScreeningIDsString = [defaults valueForKey:@"AllScreeningKeyImm1"] ;
            }
            
            if ([allScreeningIDsString isEqualToString:@""]||!allScreeningIDsString) {
                [SVProgressHUD showErrorWithStatus:@"请先筛选联赛"];
                sgc.selectedSegmentIndex = 0 ;
            } else {
                [self.secondVc.view removeFromSuperview] ;
                [self.view addSubview:self.secondVc.view];
                self.secondVc.optType = self.optType ;
                [self.secondVc didMoveToParentViewController:self];
            }
//            self.secondVc.view.frame=self.view.frame;
            
        }
            break;
    }
}



- (void)selectorDefineButton:(UIButton *)button {
    
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults] ;
    if ([self.optType isEqualToString:@"1"]) {
//        NSLog(@"%@----%@",[defaults objectForKey:@"AllScreeningKeyEnd1"],[defaults objectForKey:@"AllAsianPlateKeyEnd1"]) ;
        [defaults setValue:[defaults objectForKey:@"AllScreeningKeyEnd1"] forKey:@"AllScreeningKeyEnd"] ;
        [defaults setValue:[defaults objectForKey:@"AllAsianPlateKeyEnd1"] forKey:@"AllAsianPlateKeyEnd"] ;
    } else if ([self.optType isEqualToString:@"2"]) {
//        NSLog(@"%@----%@",[defaults objectForKey:@"AllScreeningKeyWorldCup1"],[defaults objectForKey:@"AllAsianPlateKeyWorldCup1"]) ;
        [defaults setValue:[defaults objectForKey:@"AllScreeningKeyWorldCup1"] forKey:@"AllScreeningKeyWorldCup"] ;
        [defaults setValue:[defaults objectForKey:@"AllAsianPlateKeyWorldCup1"] forKey:@"AllAsianPlateKeyWorldCup"] ;
    } else if ([self.optType isEqualToString:@"3"]) {
        //        NSLog(@"%@----%@",[defaults objectForKey:@"AllScreeningKeyWorldCup1"],[defaults objectForKey:@"AllAsianPlateKeyWorldCup1"]) ;
        [defaults setValue:[defaults objectForKey:@"AllScreeningKeyImm1"] forKey:@"AllScreeningKeyCollect"] ;
        [defaults setValue:[defaults objectForKey:@"AllAsianPlateKeyImm1"] forKey:@"AllAsianPlateKeyCollect"] ;
    } else {
//        NSLog(@"%@---%@",[defaults objectForKey:@"AllScreeningKeyImm1"],[defaults objectForKey:@"AllAsianPlateKeyImm1"]) ;
        [defaults setValue:[defaults objectForKey:@"AllScreeningKeyImm1"] forKey:@"AllScreeningKeyImm"] ;
        [defaults setValue:[defaults objectForKey:@"AllAsianPlateKeyImm1"] forKey:@"AllAsianPlateKeyImm"] ;
    }
    
    
    //创建通知
    NSNotification * notification =[NSNotification notificationWithName:@"selectDefineButton" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults] ;
//    if ([defaults objectForKey:@"AllScreeningKey"] == nil) {
//        [SVProgressHUD showErrorWithStatus:@"请选择赛事"] ;
//        if ([defaults objectForKey:@"AllAsianPlateKey"] == nil) {
//            [SVProgressHUD showInfoWithStatus:@"请选择亚盘"] ;
//        } else {
            [self dismissViewControllerAnimated:YES completion:nil] ;
//        }
//    }
    
    
}

- (void)selectorCloseWhiteButtonBackVC:(UIButton *)button {
    
    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults] ;
//    [defaults setValue:@"" forKey:@"AllScreeningKey"] ;
    
    [self dismissViewControllerAnimated:YES completion:nil] ;
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
