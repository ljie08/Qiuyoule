//
//  MXWelcomeViewController.m
//  MXFootBall
//
//  Created by zt on 2018/5/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXWelcomeViewController.h"
#import "MXShouYeViewController.h"
#import "AppDelegate.h"
#import "MXTabBarController.h"
#import "MXProtocolViewController.h"

@interface MXWelcomeViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *gesture;

@end

@implementation MXWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self cacheAdsImg];
    // Do any additional setup after loading the view.
}
- (void)createViews {
    
    NSArray *imgArr = @[@"guide_01", @"guide_02", @"guide_03"];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    
    for (int i = 0 ; i < imgArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * screen_width, 0, screen_width, screen_height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        if (UI_IS_IPHONEX) {
            imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_iphonex", imgArr[i]]];
        }else{
            imageView.image = [UIImage imageNamed:imgArr[i]];
        }
        [scrollView addSubview:imageView];
        if (i == imgArr.count - 1) {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToShouyeVc)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:gesture];
            self.gesture = gesture;
        }
        
    }
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.contentSize = CGSizeMake(screen_width * imgArr.count, screen_height);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
}
//缓存广告页
- (void)cacheAdsImg {
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc]init];
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:timeStr forKey:@"time"];
    
    [config getAds:dic success:^(NSDictionary *object) {
        
        if ([object[@"code"] isEqualToString: @"0"]) {
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            // 拼接图片名为"currentImage.png"的路径
            NSString *imageFilePath = [path stringByAppendingPathComponent:@"adsImage.png"];
            //获取网络请求中的url地址
            NSString *url = object[@"data"][@"imgUrl"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            //转换为图片保存到以上的沙盒路径中
            UIImage * adsImage = [UIImage imageWithData:data];
            //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
            [UIImageJPEGRepresentation(adsImage, 0.5) writeToFile:imageFilePath  atomically:YES];
        }
    } failure:^(NSString *error) {
        
    }];
}

- (void)pushToShouyeVc {
    MXProtocolViewController *vc = [[MXProtocolViewController alloc]init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    MXNavigationController *nav = [[MXNavigationController alloc]initWithRootViewController:vc];
    delegate.window.rootViewController = nav;
}

- (void)viewDidDisappear:(BOOL)animated{
    
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
