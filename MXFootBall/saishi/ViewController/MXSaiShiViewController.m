//
//  MXSaiShiViewController.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSaiShiViewController.h"

#import "MXImmediateViewController.h"//即时
#import "MXWorldCupViewController.h"//世界杯赛程
#import "MXDWorldCupVCtrl.h"//世界杯
#import "MXFinishViewController.h"//完场

#import "MXFilterViewController.h"//对战筛选
#import "MXOddsCompanyViewController.h"//赔率公司


@interface MXSaiShiViewController ()

@property (nonatomic, strong) UIView *redView;

@property (nonatomic, strong) NSArray * titleArray ;


@property (nonatomic, assign) NSInteger integer ;


@end

@implementation MXSaiShiViewController


- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectZero];
        _redView.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    }
    return _redView;
}

- (void)viewWillAppear:(BOOL)animated {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赛事";
    
    self.integer = 0 ;

    // Do any additional setup after loading the view.
    
    
    self.navigationController.navigationBar.barTintColor = mx_Wode_colorBlue2374e4;
    self.navigationController.navigationBar.translucent = NO;
    
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    // 左边返回按键颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName :[UIFont systemFontOfSize:18]}];
    
    
    
    
    
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        [self.view addSubview:self.redView];
    }
    
    self.progressViewIsNaughty = YES ;
    self.progressWidth = screen_width / 3 ;
    
    [self CreateBarButtonItem];
    
    self.selectIndex = 1 ;
    [self reloadData] ;
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}


#pragma make - 创建BarButton
- (void)CreateBarButtonItem {
    
    UIButton * leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    leftButton.frame = CGRectMake(0, 0, 25, 25);
    [leftButton setImage:[UIImage imageNamed:@"saishi_shaixuan"] forState:(UIControlStateNormal)];
    [leftButton addTarget:self action:@selector(selectorLeftBarButtonItem:) forControlEvents:UIControlEventTouchDown];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton * rightButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    [rightButton setImage:[UIImage imageNamed:@"saishi_peilv"] forState:(UIControlStateNormal)];
    [rightButton addTarget:self action:@selector(selectorRightBarButtonItem:) forControlEvents:(UIControlEventTouchDown)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton] ;
    
}

//筛选
- (void)selectorLeftBarButtonItem:(UIButton *)button {
    
//    return ;
//    if (self.selectIndex == 1) {
//        [SVProgressHUD showInfoWithStatus:@"请选择即时或完场"] ;
//        return ;
//    }
    
    MXFilterViewController * filterVC = [[MXFilterViewController alloc]init] ;
    NSString * opid ;
    if (self.selectIndex == 2) {
        opid = @"1" ; // 1:完场
    } else if (self.selectIndex == 9) {
        opid = @"2" ; // 2:世界杯
    } else if (self.selectIndex == 1) {
        opid = @"0" ; // 0:即时
    } else if (self.selectIndex == 0){
        opid = @"3" ; // 3:收藏
    } else {
        return ;
    }
    
    
    filterVC.optType = [NSString stringWithFormat:@"%@",opid] ;
//    NSLog(@"%@",filterVC.optType) ;
    [self presentViewController:filterVC animated:YES completion:^{
        
    }];
    
}
//赔率公司
- (void)selectorRightBarButtonItem:(UIButton *)button {
    
    [self.navigationController pushViewController:[MXOddsCompanyViewController new] animated:YES];
    
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.redView.frame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame), self.view.frame.size.width, 2.0);
    
}



- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
//    switch (self.menuViewStyle) {
//        case WMMenuViewStyleFlood: return 3;
//        case WMMenuViewStyleSegmented: return 3;
//        default: return 3;
//    }
    return 10 ;
}
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    self.titleArray = @[@"收藏",@"即时",@"完场",@"中超",@"西甲",@"德甲",@"英超",@"意甲",@"中甲",@"世界杯"] ;
    
    return self.titleArray[index % 10] ;
    
//    switch ( index % 9 ) {
//        case 0:
//            return @"收藏";
//            break;
//        case 1:
//            return @"即时";
//            break;
//        case 2:
//            return @"完场";
//            break;
//
//        default:
//            break;
//    }
//
//    return @"";
    
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    MXImmediateViewController * viewCtr = [[MXImmediateViewController alloc]init] ;
    viewCtr.status = index % 10 ;
    return viewCtr;
    
//    switch ( index % 3 ) {
//        case 0:
//        {MXImmediateViewController * viewCtr = [[MXImmediateViewController alloc]init] ;
//            viewCtr.status = 0 ;
//            return viewCtr;}
//            break;
//        case 1:
//            if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
//                return [MXWorldCupViewController new] ;
//            }
//        {MXImmediateViewController * viewCtr = [[MXImmediateViewController alloc]init] ;
//            viewCtr.status = 1 ;
//            return viewCtr;}
////            return [MXWorldCupViewController new] ;
////            return [MXDWorldCupVCtrl new];
//            break;
//        case 2:
//        {MXImmediateViewController * viewCtr = [[MXImmediateViewController alloc]init] ;
//            viewCtr.status = 8 ;
//            return viewCtr;}
//            break;
//
//        default:
//            break;
//    }
//
//    return [UIViewController new];
    
}




- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, 0, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    }
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        originY += self.redView.frame.size.height;
    }
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}


- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    
//    NSLog(@"%@",info) ;
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
