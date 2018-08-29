//
//  MXssIntegralQiandaoGuizeButtonViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/5/18.
//  Copyright © 2018年 zt. All rights reserved.
//签到规则页面

#import "MXssIntegralQiandaoGuizeButtonViewController.h"

@interface MXssIntegralQiandaoGuizeButtonViewController ()
@property (nonatomic,strong) UIWebView *webView;
@end

@implementation MXssIntegralQiandaoGuizeButtonViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.webView];
}
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
        [self initTitleViewWithTitle:@"签到规则"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]]];
//    if ([self.titleNameGuanOrFen isEqualToString:@"粉丝"]) {
//        //        [self initTitleViewWithTitle:@"粉丝"];
//        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"粉丝界面\"}"];
//    }else {
//        //        [self initTitleViewWithTitle:@"关注"];
//        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"关注界面\"}"];
//    }
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webViewURL]]];
//}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screen_width, self.view.height -64)];
        _webView.backgroundColor = [UIColor clearColor];
    }
    return _webView;
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
