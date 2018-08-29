//
//  ViewController.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "ViewController.h"
#import "MXShouYeViewController.h"
#import "MXAdsViewController.h"
#import "MXWelcomeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
}

- (void)viewDidLoad {
    //测试commit
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController.navigationBar.hidden == NO) {
        
        //设置导航栏背景颜色
        self.navigationController.navigationBar.barTintColor = mx_Wode_colorBlue2374e4;
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    //Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    if ([[self class] isEqual:[MXShouYeViewController class]] || [[self class] isEqual:[MXAdsViewController class]] || [[self class] isEqual:[MXWelcomeViewController class]]) {
        [ToolHelper setStatusBarBackgroundColor:[UIColor clearColor]];
//        [ToolHelper setStatusBarBackgroundColor:mx_shouye_status_color002374];
    }else{
        [ToolHelper setStatusBarBackgroundColor:mx_Wode_colorBlue2374e4];
    }
    self.navigationController.navigationBar.shadowImage=[UIImage new];//去导航栏最下面的那条线
}

/**
 自定义标题字体、颜色、大小等
 
 @param title 标题
 */
- (void)initTitleViewWithTitle:(NSString *)title {
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    titleLab.text = title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLab;
}

#pragma mark - 设置背景图
- (void)setThemeImgWithPicture:(NSString *)name {
    UIImage *image = [[UIImage alloc] init];
    if (name == nil) {
        image = [UIImage imageNamed:@"bg"];
        self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    } else {
        image = [UIImage imageNamed:name];
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:name]];
    }
    self.view.layer.contents = (id) image.CGImage;// 如果需要背景透明加上下面这句
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
}

/**
 * @brief  设置导航的标题 左右item
 *
 * @param
 *
 * @return
 */

/**
 设置导航栏
 
 @param title 标题
 @param left 左item
 @param right 右item
 @param view 标题view
 */
- (void)addNavigationWithTitle:(NSString *)title leftItem:(UIBarButtonItem  *)left rightItem:(UIBarButtonItem *)right titleView:(UIView *)view {
    if (title) {
        // 设置导航的标题
        self.navigationItem.title = title;
    }
    
    if (left) {
        // 设置左边的item
        self.navigationItem.leftBarButtonItem = left;
    }
    
    if (right) {
        // 设置右边的item
        self.navigationItem.rightBarButtonItem = right;
    }
    
    if (view) {
        // 设置标题view
        self.navigationItem.titleView = view;
    }
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@""];
}

//设置返回按钮是否显示
- (void)setBackButton:(BOOL)isShown{
    if (isShown) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 40, 40);
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //避免iOS 11上导航栏按钮frame小，点不到区域。将按钮设置大点，居左显示
        [backBtn setImage:[UIImage imageNamed:@"mxWodeBackbtn"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

        
        self.navigationItem.leftBarButtonItem = leftItem;
        //[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Goback"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

//返回
- (void)goBack {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];//remove 提示的：暂无数据
}

//返回到根视图控制器
- (void)goRootBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
 设置暂无数据按钮
 */
-(UIButton*)addUpDataBtnWithTitle:(NSString *)titleString superView:(UIView *) superView{
    float w = 180;
    float h = 270/2;
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btn.frame = CGRectMake(0, 0, w, h);
    btn.center = superView.center ;
//    btn.center = CGPointMake(screen_width/2, screen_height/2) ;
    [btn setTitle:titleString forState:(UIControlStateNormal)];
    [btn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)] ;
//    btn.titleLabel.font = fontSize(scaleWithSize(40)) ;
    [btn addTarget:self action:@selector(updataClick) forControlEvents:(UIControlEventTouchDown)];
//    [btn setBackgroundImage:[UIImage imageNamed:@"ic_net_no_connect"] forState:(UIControlStateNormal)];
    self.removeUpdataBlock = ^{
        [btn removeFromSuperview];
    };
    return btn;
}

-(void)updataClick{
    
    if (self.updataBlock!=nil) {
        self.updataBlock();
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
