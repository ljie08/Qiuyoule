//
//  MXSSMyPostListViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSMyPostListViewController.h"
#import "MXSSMyPostViewController.h"//发帖页面
#import "MXSSMyVoteViewController.h"//投票页面
#import "MMSSMyOpinionViewController.h"//观点页面
//#import "MXssPostModel.h"//发帖model

@interface MXSSMyPostListViewController ()
//@property (nonatomic, strong) UIView *redView;
@end

@implementation MXSSMyPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];//这里注意，需要写在最后面，要不然上面的效果不会出现
    self.title = _mypostS;
    
    [self CreateleftBarButtonItem];//返回按钮
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
//    UIButton *confirmBtn = [[UIButton alloc]init];
//    confirmBtn.frame = CGRectMake(0, 0, 25, 25);
//    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"my_post_Image_fenxiangButton"] forState:UIControlStateNormal];
//    [confirmBtn addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmBtn];
}
//- (void)releaseClick {//分享按钮点击
//    NSLog(@"分享按钮的点击");
//}
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
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    switch (self.menuViewStyle) {
        case WMMenuViewStyleFlood: return 4;
        case WMMenuViewStyleSegmented: return 4;
        default: return 4;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 4) {
        case 0: {
            self.title = @"发帖";
            return @"发帖";
        }
        case 1: {
            self.title = @"跟帖";
           
            return @"跟帖";
        }
        case 2: {
            self.title = @"投票";
            return @"投票";
        }
        case 3: {
            self.title = @"观点";
            return @"观点";
        }
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 4) {
        case 0: {
            self.title = @"发帖";
             MXSSMyPostViewController *mypostview= [[MXSSMyPostViewController alloc] init];//发帖页面
            mypostview.yesOrOnString = @"发帖";
             [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            return mypostview;//发帖页面
        }
        case 1: {
            self.title = @"跟帖";
             [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
//             [self getFindMyPostingData:@"跟帖"];//跟帖数据请求
            return [[MXSSMyPostViewController alloc] init];
        }
        case 2: {
            self.title = @"投票";
             [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            return [[MXSSMyVoteViewController alloc] init];//投票页面
            
        }
        case 3: {
            self.title = @"观点";
             [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
            return [[MMSSMyOpinionViewController alloc] init];//观点页面
        }
    }
    return [[UIViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        //        menuView.backgroundColor = mx_Wode_colord9d9d9;
        //        return CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
        return CGRectMake(0, 0, self.view.frame.size.width, 44);
    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    //    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    //    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
    return CGRectMake(leftMargin, 0, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    }
    
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    //    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
    //        originY += self.redView.frame.size.height;
    //    }
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
