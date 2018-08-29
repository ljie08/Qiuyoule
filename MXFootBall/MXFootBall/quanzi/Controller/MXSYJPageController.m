//
//  MXSYJPageController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJPageController.h"
#import "MXSYJFriendsController.h"
#import "MXQuanZiViewController.h"
#import "MXSYJPublicController.h"
#import "PYSearch.h"
#import "MXSearchResultController.h"

@interface MXSYJPageController ()

@end

@implementation MXSYJPageController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"广场界面\"}"];

    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [ToolHelper setStatusBarBackgroundColor:mx_Wode_colorBlue2374e4];
    [self setNaviBtn];

}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    //    [UBT logTrace:@"residenceTimeOut"; content:@"{\"VC\":\"\u9996\u9875\"}";
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"广场界面\"}"];
}


//设置导航栏

- (void)setNaviBtn{
    
    //设置导航栏背景颜色
    
    self.navigationController.navigationBar.barTintColor = mx_Wode_colorBlue2374e4;
    self.navigationController.navigationBar.translucent = NO;
    //设置按钮
    UIButton *publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [publishBtn setImage:[UIImage imageNamed:@"xiewen"] forState:UIControlStateNormal];
    publishBtn.frame = CGRectMake(10, 10, 24, 24);
    publishBtn.tag = 1;
    [publishBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:publishBtn];
    
    UIButton *squareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [squareBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
    squareBtn.frame = CGRectMake(10, 10, 24, 24);
    squareBtn.tag = 2;
    [squareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:squareBtn];
    
    
}

- (void)btnClick:(UIButton *)btn{
    NSLog(@"点击了按钮%ld个按钮",btn.tag);
    
    if (btn.tag == 1) {
        if (![MXssWodeUtils loadPersonInfo].userId) {
            //请先登录
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            //                login.isPageNumber = 1;
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:nil];
            
        }else{
            [self.navigationController pushViewController:[MXSYJPublicController new] animated:YES];
        }
        
        
    }else{
        NSArray *hotSeaches = @[@"种菜庄园",@"多彩讲堂",@"大力神杯",@"球友反馈",@"足球宝贝",@"精彩人生"];
        // 2. Create a search view controller
        
        mx_weakify(self);
        
        PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"输入关键字" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
            [searchViewController dismissViewControllerAnimated:YES completion:nil];
            MXSearchResultController *vc = [[MXSearchResultController alloc]init];
            vc.strTitle = searchText;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        // 3. Set style for popular search and search history
        searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
        searchViewController.searchHistoryStyle = PYHotSearchStyleARCBorderTag;
        // 4. Set delegate
//        searchViewController.delegate = self;
        // 5. Present a navigation controller
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
        [self presentViewController:nav animated:YES completion:nil];
        
    }
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置控制器
    [self setPageVC];
    
    
}

- (void)setPageVC{
    self.showOnNavigationBar = YES;
    self.titleColorSelected = [UIColor whiteColor];
    self.titleColorNormal = mx_FontLightGreyColor;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    self.titleSizeSelected = 15;
    self.titleSizeNormal = 14;
    
}


#pragma mark - 控制器代理

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return @"广场";
        case 1:
            return @"关注";
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            return [[MXQuanZiViewController alloc] init];
        }
        case 1: return [[MXSYJFriendsController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    //    if (self.menuViewPosition == WMMenuViewPositionBottom) {
    //        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    //        return CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    //    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {

    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);

    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - originY);
}


@end
