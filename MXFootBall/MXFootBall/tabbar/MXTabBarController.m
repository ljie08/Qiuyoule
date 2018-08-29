//
//  MXTabBarController.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXTabBarController.h"
#import "MXNavigationController.h"
#import "MXShouYeViewController.h"
#import "MXSaiShiViewController.h"
#import "MXQuanZiViewController.h"
#import "MXWodeViewController.h"
#import "MXSYJPageController.h"
#import "MXLoginViewController.h"//登录
#import "AppDelegate.h"

@interface MXTabBarController ()<MXLoginViewControllerDelegate>

@end

@implementation MXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self addAllVCs];
    
    // Do any additional setup after loading the view.
}

- (void)addAllVCs {
    
//    MXShouYeViewController *vc1 = [[MXShouYeViewController alloc]init];
    MXShouYeViewController *vc1 = [[UIStoryboard storyboardWithName:@"ShouYe" bundle:nil]instantiateViewControllerWithIdentifier:@"MXShouYeViewController"];
//    [self addOneVC:vc1 title:@"首页" imgName:@"dilan-home-hui" seletImage:@"dilan-home-hong"];
    
//    [self addChildVc:vc1 Title:@"首页" withTitleSize:17.0 andFoneName:nil selectedImage:@"dilan-home-hong" withTitleSelectColor:mx_redColor unselectedImage:@"dilan-home-hui" withTitleUnSelectColor:mx_FontGreyColor];

    [self addChildVc:vc1 Title:@"首页" withTitleSize:14.0 andFoneName:nil selectedImage:@"dilan-home-hong" withTitleSelectColor:mx_redColor unselectedImage:@"dilan-home-hui" withTitleUnselectColor:mx_FontGreyColor tag:1];
    
    MXSaiShiViewController *vc2 = [[MXSaiShiViewController alloc]init];
//    vc2.menuViewStyle = WMMenuViewStyleLine ;
//    vc2.titleColorSelected = mx_Wode_colorBlue2374e4;
//    [self addOneVC:vc2 title:@"赛事" imgName:@"dilan-saishi-hui"];
//    [self addOneVC:vc2 title:@"赛事" imgName:@"dilan-saishi-hui" seletImage:@"dilan-saishi-hong"];
    [self addChildVc:vc2 Title:@"赛事" withTitleSize:12.0 andFoneName:nil selectedImage:@"dilan-saishi-hong" withTitleSelectColor:mx_redColor unselectedImage:@"dilan-saishi-hui" withTitleUnselectColor:mx_FontGreyColor tag:2];


    MXSYJPageController *vc3 = [[MXSYJPageController alloc]init];
//    [self addOneVC:vc3 title:@"圈子" imgName:@""];
//    [self addOneVC:vc3 title:@"圈子" imgName:@"dilan-luntan-hui" seletImage:@"dilan-luntan-hong"];
    
    [self addChildVc:vc3 Title:@"论坛" withTitleSize:12.0 andFoneName:nil selectedImage:@"dilan-luntan-hong" withTitleSelectColor:mx_redColor unselectedImage:@"dilan-luntan-hui" withTitleUnselectColor:mx_FontGreyColor tag:3];

    

    MXWodeViewController *vc4 = [[MXWodeViewController alloc]init];
//    [self addOneVC:vc4 title:@"我的" imgName:@""];
//    [self addOneVC:vc4 title:@"我的" imgName:@"dilan-wode-hui" seletImage:@"dilan-wode-hong"];
    
     [self addChildVc:vc4 Title:@"我的" withTitleSize:12.0 andFoneName:nil selectedImage:@"dilan-wode-hong" withTitleSelectColor:mx_redColor unselectedImage:@"dilan-wode-hui" withTitleUnselectColor:mx_FontGreyColor tag:4];

    

//    self.tabBar.tintColor = Color(191, 53, 54, 1);
    
    
}

//第一种设置方法

- (void)addChildVc:(UIViewController *)childVc
             Title:(NSString *)title
     withTitleSize:(CGFloat)size
       andFoneName:(NSString *)foneName
     selectedImage:(NSString *)selectedImage
    withTitleSelectColor:(UIColor *)selectColor
   unselectedImage:(NSString *)unselectedImage
    withTitleUnselectColor:(UIColor *)unselectColor
         tag:(NSInteger)tag{
    childVc.title = title;
    //设置图片
    childVc.tabBarItem  = [childVc.tabBarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    childVc.tabBarItem.tag = tag;//设置
//    self.tabBarController.selectedIndex = tag;
    childVc.tabBarController.selectedIndex = tag;
    //未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateNormal];
    
    //选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateSelected];
    
    MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
    
}
#pragma mark - UITabBarControllerDelegate
//这个方法根据官方文档解释意思就是点击下面的tabBar的按钮时候  根据BOOL值来判断是否处于可继续点击状态
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    if (viewController.tabBarItem.tag == 4){
        MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
        NSLog(@"我的点击===%@",userModel.userId);
        if (userModel.userId.intValue <= 0) {//判断是否登录
            
            MXLoginViewController *loginss = [[MXLoginViewController alloc] init];
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:loginss];
            loginss.delegate = self;
            [self presentViewController:nav animated:YES completion:nil];
            return NO;
        }else
        {
            return YES;
        }
    } else
    {
        return YES;
    }
}

- (void)loginSuccessCalled{
    NSLog(@"登录成功了");
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *controller = app.window.rootViewController;
//    [(SuerTabBarViewController是继承于TabBarViewController的相当于mainViewController)]
    MXTabBarController *rvc = (MXTabBarController *)controller;
    [rvc setSelectedIndex:3];//假如要跳转到第四个tabBar那里，因为tabBar默认索引是从0开始的
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//第二种设置方法

/**
 
- (void)addOneVC: (UIViewController *)vc title: (NSString *)title imgName: (NSString *)imgName seletImage:(NSString *)seletImage{
    MXNavigationController *nav = [[MXNavigationController alloc]initWithRootViewController:vc];
    nav.tabBarItem.title = title;
//    nav.tabBarItem.selecte
    nav.tabBarItem.image = [UIImage imageNamed:imgName];

    nav.tabBarItem.selectedImage = [UIImage imageNamed:seletImage];

//    self.tabBarItem.image = [UIImage imageNamed:imgName];
//    self.tabBarItem.selectedImage = [UIImage imageNamed:seletImage];


    [self addChildViewController:nav];
}
 
*/

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
