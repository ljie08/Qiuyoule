//
//  MXSSIntegralDetailListViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//积分明细页面

#import "MXSSIntegralDetailListViewController.h"
#import "MXssIntegralListViewController.h"//积分明细页面
#import "MXssIntegralSignDetailViewController.h"//签到明细页面
@interface MXSSIntegralDetailListViewController ()

@end

@implementation MXSSIntegralDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateleftBarButtonItem];//返回按钮
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
}
-(void)CreateleftBarButtonItem{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 40, 40);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //避免iOS 11上导航栏按钮frame小，点不到区域。将按钮设置大点，居左显示
    [backBtn setImage:[UIImage imageNamed:@"mxWodeBackbtn"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}
// 左上角按钮点击事件
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
     [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark ---Posting comments Data 发帖、跟帖数据
//-(void)getFindMyPostingData:(NSString*)stringNameTitle{
//    //    bigCaiPiaoArrHome= [NSMutableArray array];
//    NSLog(@"发帖数据获取~");
//    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
//    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
//    NSString *token = userModel.token;
//    NSString *timeStr = [MXLJUtil getNowDateTimeString];
//    NSString *url = @"";
//    //        NSString *signStr = [[NSString stringWithFormat:@"userId=%@&token=%@&time=%@%@", userid, token, timeStr, MX_KEY] MD5];
//    if ([stringNameTitle isEqualToString:@""]) {
//        url = MXWodemFindMyPosting_PATH;//请求发帖数据接口
//    }else {
//        url = MXWodemFindMycomments_PATH;//请求跟帖数据接口
//    }
//    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//    [paraDic setObject:userid forKey:@"userId"];//用户ID
//    [paraDic setObject:token forKey:@"token"];//用户token
//    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
//    //    [paraDic setObject:signStr forKey:@"sign"];//签名
//    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
//    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
//        NSLog(@"发帖、跟帖数据==%@",personDic);
//        [SVProgressHUD showSuccessWithStatus:[personDic objectForKey:@"msg"]];
//    } failure:^(NSString *error) {
//        [SVProgressHUD showSuccessWithStatus:error];
//    }];
//}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    switch (index % 2) {
        case 0: {
            self.title = @"积分明细";
//            [self getFindMyPostingData:@"发帖"];//发帖数据请求
            return @"积分明细";
        }
        case 1: {
            self.title = @"签到明细";
//            [self getFindMyPostingData:@"跟帖"];//跟帖数据请求
            return @"签到明细";
        }
    }
    return @"NONE";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index % 2) {
        case 0: {
            self.title = @"积分明细";
            return [[MXssIntegralListViewController alloc] init];//发帖页面
        }
        case 1: {
            self.title = @"签到明细";
            return [[MXssIntegralSignDetailViewController alloc] init];
        }
    }
    return [[ViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return CGRectMake(0, 0, self.view.frame.size.width, 44);
    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    return CGRectMake(leftMargin, 0, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    }
    
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
