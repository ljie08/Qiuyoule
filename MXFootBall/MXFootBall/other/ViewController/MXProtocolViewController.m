//
//  MXProtocolViewController.m
//  MXFootBall
//
//  Created by zt on 2018/5/25.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXProtocolViewController.h"
#import "MXLJJudgeVM.h"
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "MXTabBarController.h"

@interface MXProtocolViewController ()

@property (nonatomic, strong) MXLJJudgeVM *judgeVM;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation MXProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getWebUrl];
    
    UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reportBtn setTitle:@"同意" forState:UIControlStateNormal];
    [reportBtn addTarget:self action:@selector(pushToShouyeVc) forControlEvents:UIControlEventTouchUpInside];
    [reportBtn setBackgroundColor:mx_Wode_colorBlue2374e4];
    reportBtn.titleLabel.font = fontSize(14);
    [self.view addSubview:reportBtn];
    
    WKWebView *webView = [[WKWebView alloc]init];
    self.webView = webView;
    [self.view addSubview:webView];
    self.title = @"球友乐协议";
    
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(scaleWithSize(50));
        make.bottom.mas_equalTo(-TABBAR_FRAME);
    }];
    
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(reportBtn.mas_top);
        make.top.mas_equalTo(0);
    }];
    
    // Do any additional setup after loading the view.
}

- (void)getWebUrl{
    [SVProgressHUD show];
    self.judgeVM = [[MXLJJudgeVM alloc]init];
    @weakSelf(self)
    [self.judgeVM protocolWithSuccess:^(BOOL isCorrect) {
        [SVProgressHUD dismiss];
        if (isCorrect) {
            
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _judgeVM.protocol.targetUrl]]]];
            weakSelf.title = [NSString stringWithFormat:@"%@", _judgeVM.protocol.title];
        }
        
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)pushToShouyeVc {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [MXTabBarController new];
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
