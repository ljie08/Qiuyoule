//
//  MXAdsViewController.m
//  MXFootBall
//
//  Created by zt on 2018/4/18.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXAdsViewController.h"
#import "AppDelegate.h"
#import "MXTabBarController.h"
#import "MXHomeVM.h"

#import "MXDAdvertsModel.h"
#import "MXSYJWebViewController.h"

@interface MXAdsViewController ()
{
    dispatch_source_t _timer ;
}

//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger countDown;

@property (nonatomic, strong) UIButton *countDownBtn;

@property (nonatomic, strong) MXHomeVM *homeVM;

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation MXAdsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.countDown = 3;
    self.homeVM = [[MXHomeVM alloc]init];
    [self createViews];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated] ;
    [self resumeTimer] ;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated] ;

    
}

- (void)createViews {
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.userInteractionEnabled = YES ;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectorADImage)] ;
    [imageView addGestureRecognizer:tapGestureRecognizer];
    
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.layer.masksToBounds = YES;
    [bottomView addSubview:iconView];
    
    iconView.image = [UIImage imageNamed:@"adsBottomImage"];
    
    if (UI_IS_IPHONEX) {
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(748 / 4);
            make.right.mas_equalTo(0);
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(bottomView.mas_top);
        }];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bottomView.centerX);
            make.top.mas_equalTo((748 - 126) / 8);
            make.size.mas_equalTo(CGSizeMake(100, 42));
        }];
    }else{
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(- 209 / 2);
        }];
        
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(imageView.mas_bottom);
            make.height.mas_equalTo(104.5);
            make.right.mas_equalTo(0);
        }];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bottomView.mas_centerX);
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(scaleWithSize(75), scaleWithSize(32)));
        }];
    }
    
    // 读取沙盒路径图片
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"adsImage.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFilePath];
    if (image) {
        
        imageView.image = image;
        
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownClick) userInfo:nil repeats:YES];
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        self.timer = timer;
        
        [self startGCDTimer];

        
    }else{
//        [self.timer invalidate];
        [self stopTimer];
        [self setRootVC];
    }
    
    UIButton *countDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [countDownBtn setBackgroundColor:Color(200, 199, 204, 0.5)];
    countDownBtn.layer.cornerRadius = 5;
    countDownBtn.titleLabel.font = fontSize(scaleWithSize(13));
    [countDownBtn setTitle:[NSString stringWithFormat:@"%ld秒跳过", (long)self.countDown--] forState:UIControlStateNormal];
    [countDownBtn addTarget:self action:@selector(jumpToShouyeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:countDownBtn];
    self.countDownBtn = countDownBtn;
    
    [countDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(scaleWithSize(-16));
        make.bottom.mas_equalTo(-TABBAR_FRAME - scaleWithSize(20));
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];

    [self getAds];
    
}

- (void)getAds {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageFilePath = [path stringByAppendingPathComponent:@"adsImage.png"];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc]init];
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:timeStr forKey:@"time"];
    [dic setObject:@(1) forKey:@"locationId"];
    [config getAds:dic success:^(NSDictionary *object) {
        if ([object[@"code"] isEqualToString: @"0"]) {
            NSLog(@"%@",object);
            UIImage *newImage;
            [newImage getImageFromUrl:object[@"data"][@"imgUrl"]];
            
            MXDAdvertsModel * model = [[MXDAdvertsModel mj_objectArrayWithKeyValuesArray:object[@"data"][@"adverts"]]firstObject];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults] ;
            [defaults setValue:object[@"data"][@"adverts"] forKey:@"AdvertsModel"] ;
            
            NSData *oldImgData = [NSData dataWithContentsOfFile:imageFilePath];
            
            NSData *newImgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.advertPic]];
            
            if (![oldImgData isEqual:newImgData]) {
                //转换为图片保存到以上的沙盒路径中
                UIImage * adsImage = [UIImage imageWithData:newImgData];
                //其中参数0.5表示压缩比例，1表示不压缩，数值越小压缩比例越大
                [UIImageJPEGRepresentation(adsImage, 0.5) writeToFile:imageFilePath  atomically:YES];
            }
        }
    } failure:^(NSString *error) {
        
    }];
}

- (void)selectorADImage{
    
    //关闭定时器
    [self pauseTimer];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults] ;
    MXDAdvertsModel * model = [[MXDAdvertsModel mj_objectArrayWithKeyValuesArray:[defaults objectForKey:@"AdvertsModel"]]firstObject]; 
    
    MXSYJWebViewController * vc = [[MXSYJWebViewController alloc]init] ;
    vc.adID = [NSString stringWithFormat:@"%ld",model.advertId] ;
    vc.url = model.targetUrl ;
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:naviController
                                         animated:YES
                                       completion:NULL];
    
}

- (void)countDownClick {
    if (self.countDown == 0) {
//        [self.timer invalidate];
        [self stopTimer];
        [self setRootVC];
    }else{
        [self.countDownBtn setTitle:[NSString stringWithFormat:@"%ld秒跳过", (long)self.countDown--] forState:UIControlStateNormal];
    }
}

- (void)jumpToShouyeVC {
//    [self.timer invalidate];
    [self stopTimer];
    [self setRootVC];
}

- (void)setRootVC {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = [MXTabBarController new];
}



-(void) startGCDTimer{
    NSTimeInterval period = 1.0; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //dispatch_get_main_queue()
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
        NSLog(@"每秒执行test");
        mx_weakify(self) ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf countDownClick] ;
        }) ;
        
    });
    
//    dispatch_resume(_timer);
}


-(void) pauseTimer{
    if(_timer){
        dispatch_suspend(_timer);
    }
}
-(void) resumeTimer{
    if(_timer){
        dispatch_resume(_timer);
    }
}
-(void) stopTimer{
    if(_timer){
        dispatch_source_cancel(_timer);
//        _timer = nil;
    }
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
