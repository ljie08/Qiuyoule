//
//  MXSYJWebViewController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJWebViewController.h"
#import "MXSYJProgressLayer.h"

@interface MXSYJWebViewController ()<UIWebViewDelegate>

@end

@implementation MXSYJWebViewController
{
    UIWebView *_webView;
    
    MXSYJProgressLayer *_progressLayer; ///< 网页加载进度条
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBackButton:YES];
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (_adID) {
        
        [UBT logCode:@"ad" content:[NSString stringWithFormat:@"{\"id\":\"%@\"}",_adID]] ;
        
    }
     
    
    if (_guessBool) {
        MXSSToolConfig * userModel = [MXssWodeUtils loadPersonInfo] ;
        NSString *userId =[NSString stringWithFormat:@"%@",userModel.userId];
        NSString *token = userModel.token;
        if (userModel.userId) {
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?userId=%@&token=%@",self.url,userId,token]]];
            [_webView loadRequest:request];
            
        }
    }
    
}

- (void)setupUI {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-TABBAR_FRAME-STATUS_AND_NAVIGATION_HEIGHT)];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [_webView loadRequest:request];
    
    _webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_webView];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    _progressLayer = [MXSYJProgressLayer layerWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    [self.view.layer addSublayer:_progressLayer];
    [_progressLayer startLoad];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressLayer finishedLoad];
    
    [self initTitleViewWithTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_progressLayer finishedLoad];
}

- (void)dealloc {
    NSLog(@"i am dealloc");
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
//    NSString *url = request.URL.absoluteString ;
//    // 协议头是随便写的，为了区分http协议还是调用OC代码。。
//    NSString *scheme = @"test://";
//    if ([url hasPrefix:scheme]) {
//        
//    }
    
    NSURL *URL = request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"test"]) {
        
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}






@end
