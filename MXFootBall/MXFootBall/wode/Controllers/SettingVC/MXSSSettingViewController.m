//
//  MXSSSettingViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSSettingViewController.h"
#import "MXPersonalInformationViewController.h"//账户信息 个人消息
#import "MXSSSettingAboutUSViewController.h"//关于我们
#import "MXSSSettingCustomerSViewController.h"//客服页面
#import "MXSSSettingAuxiliaryFunctionViewController.h"//辅助功能
#import "MXSSSettingYijianFankuiViewController.h"//意见反馈页面
@interface MXSSSettingViewController ()<UIAlertViewDelegate>
@property (nonatomic,strong) UIButton *btnLoginOut;
@property (nonatomic,strong) UIButton *btnMessage;
@property (nonatomic,strong) UIView *viewmyInsure;//账户信息

@end

@implementation MXSSSettingViewController
//UIButton *btnLoginOut;
{
    UIScrollView *applicationSV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.title = @"设置";
    self.view.backgroundColor = mx_Wode_bordColor;
//    [self setupUISetting];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [applicationSV removeFromSuperview];
    [self setupUISetting];
}

- (void)setupUISetting {
    
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    CGFloat border = 1.0f;
    //    CGFloat lblHeight = 44.0f;
    CGFloat spacingBig = scaleWithSize(16.0f);
    CGFloat spaingSmall = scaleWithSize(4.0f);
    
    // 背景ScrollView
    applicationSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    applicationSV.showsVerticalScrollIndicator = YES;
    applicationSV.showsVerticalScrollIndicator = NO;
    applicationSV.backgroundColor = [UIColor clearColor];
    //    applicationSV.delegate = self;
    applicationSV.scrollEnabled = YES;
    [self.view addSubview:applicationSV];
    UIImageView *beijing = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height + 50)];
    beijing.image = [UIImage imageNamed:@"beijingPic"];
    [applicationSV addSubview:beijing];
    /* 创建UIBlurEffect对象 */
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    /* 创建UIVisualEffectView的对象visualView, 以blur为参数 */
    UIVisualEffectView *visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    /* 将visualView的大小等于blurImageView的大小. (visualView的大小可以自行设定, 它的大小决定了显示毛玻璃效果区域的大小) */
    visualView.frame = beijing.frame;
    /* 设置透明度 */
    visualView.alpha = 0.5;
    [beijing addSubview:visualView];
    
    CGFloat viewHeight = scaleWithSize(44.0f);
    self.viewmyInsure = [[UIView alloc] initWithFrame:CGRectMake(0, spaingSmall, screen_width, viewHeight)];
    self.viewmyInsure.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:self.viewmyInsure];
    if (userModel.username) {
        [self addSubDetailViews:self.viewmyInsure iconName:@"my_Setting_zhanghuxinxi" iconLeft:scaleWithSize(15) title:@"账户信息" titleLeft:scaleWithSize(25) hint:userModel.username];
    }else{
        [self addSubDetailViews:self.viewmyInsure iconName:@"my_Setting_zhanghuxinxi" iconLeft:scaleWithSize(15) title:@"账户信息" titleLeft:scaleWithSize(25) hint:@"金硕珍"];
    }
    UITapGestureRecognizer *tapViewMyInsure = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewMyInsure:)];
    [self.viewmyInsure addGestureRecognizer:tapViewMyInsure];
    
    UIView *viewArticleCollection = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewmyInsure.frame.origin.y + self.viewmyInsure.frame.size.height + border, screen_width, viewHeight)];
    viewArticleCollection.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewArticleCollection];
    [self addSubDetailViews:viewArticleCollection iconName:@"my_Setting_xiaoxishezhi" iconLeft:scaleWithSize(15) title:@"消息设置" titleLeft:scaleWithSize(25) hint:@""];
    
    self.btnMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnMessage.frame = CGRectMake(screen_width - scaleWithSize(70), viewArticleCollection.frame.size.height/2- scaleWithSize(15), scaleWithSize(45), scaleWithSize(30));
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            NSLog(@"推送关闭 8.0");
            userModel.messageYesOrNo = @"0";
        }else{
            NSLog(@"推送打开 8.0");
            userModel.messageYesOrNo = @"1";
        }
    }else{
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone == type){
            NSLog(@"推送关闭");
            userModel.messageYesOrNo = @"1";
        }else{
            NSLog(@"推送打开");
            userModel.messageYesOrNo = @"1";
        }
    }
    [MXssWodeUtils savePersonInfo:userModel];//保存 是否推送的缓存
    
    [self.btnMessage setBackgroundColor: [UIColor clearColor]];
    if (userModel.messageYesOrNo.intValue ==1) {
        [self.btnMessage setBackgroundImage:[UIImage imageNamed:@"my_kaiguan_kai"] forState:UIControlStateNormal];
    }else{
        [self.btnMessage setBackgroundImage:[UIImage imageNamed:@"my_kaiguan_guan"] forState:UIControlStateNormal];
    }
    [self.btnMessage addTarget:self action:@selector(tapViewArticleCollection:) forControlEvents:UIControlEventTouchUpInside];//消息设置的显示状态
    self.btnMessage.layer.cornerRadius = 5.0f;
    [viewArticleCollection addSubview:self.btnMessage];
    
    
    UIView *viewCache = [[UIView alloc] initWithFrame:CGRectMake(0, viewArticleCollection.frame.origin.y + viewArticleCollection.frame.size.height + border, screen_width, viewHeight)];
    viewCache.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewCache];
    
    /* 获取缓存文件夹路径 */
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    /* 获取缓存文件夹的大小 */
    CGFloat size = [self folderSizeAtPath:cachPath];
    
    //    [self addSubDetailViews:viewmyInsure iconName:@"" iconLeft:8 title:@"清除缓存" titleLeft:20 hint:[NSString stringWithFormat:@"%.1fM",size]];
    [self addSubDetailViews:viewCache iconName:@"my_viewCacheClean" iconLeft:scaleWithSize(15) title:@"清理缓存" titleLeft:scaleWithSize(25) hint:[NSString stringWithFormat:@"%.1fM",size]];
    UITapGestureRecognizer *tapviewCache = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapviewCacheClick:)];
    [viewCache addGestureRecognizer:tapviewCache];
    
    
    
    UIView *viewYijian = [[UIView alloc] initWithFrame:CGRectMake(0, viewCache.frame.origin.y + viewCache.frame.size.height + border, screen_width, viewHeight)];
    viewYijian.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewYijian];
    [self addSubDetailViews:viewYijian iconName:@"my_yijianfankui" iconLeft:scaleWithSize(15) title:@"意见反馈" titleLeft:scaleWithSize(25) hint:@""];
    UITapGestureRecognizer *tapviewYijian = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapviewYijian:)];
    [viewYijian addGestureRecognizer:tapviewYijian];
    
    
    UIView *viewAboutUs = [[UIView alloc] initWithFrame:CGRectMake(0, viewYijian.frame.origin.y + viewYijian.frame.size.height + border, screen_width, viewHeight)];
    viewAboutUs.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewAboutUs];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    [self addSubDetailViews:viewAboutUs iconName:@"my_Setting_guanyuwomen" iconLeft:scaleWithSize(15) title:@"关于我们" titleLeft:scaleWithSize(25) hint:[NSString stringWithFormat:@"版本 %@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]]];
    UITapGestureRecognizer *tapviewAboutUs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapviewAboutUs:)];
    [viewAboutUs addGestureRecognizer:tapviewAboutUs];
    
    //    UIView *viewComPro = [[UIView alloc] initWithFrame:CGRectMake(0, viewAboutUs.frame.origin.y + viewAboutUs.frame.size.height + spaingSmall, screen_width, viewHeight)];
    //    viewComPro.backgroundColor = [UIColor whiteColor];
    //    [applicationSV addSubview:viewComPro];
    //
    //    [self addSubDetailViews:viewComPro iconName:@"mxWodeFans" iconLeft:8 title:@"辅助功能" titleLeft:20 hint:@""];
    //    UITapGestureRecognizer *tapViewComPro = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewComPro:)];
    //    [viewComPro addGestureRecognizer:tapViewComPro];
    
    //    UIView *viewAboutus = [[UIView alloc] initWithFrame:CGRectMake(0, viewAboutUs.frame.origin.y + viewAboutUs.frame.size.height + border, screen_width, viewHeight)];
    //    viewAboutus.backgroundColor = [UIColor whiteColor];
    //    [applicationSV addSubview:viewAboutus];
    //
    //    [self addSubDetailViews:viewAboutus iconName:@"my_Setting_kefu" iconLeft:scaleWithSize(15) title:@"客服" titleLeft:scaleWithSize(25) hint:@""];
    //    UITapGestureRecognizer *tapViewCustomer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewCustomer:)];
    //    [viewAboutus addGestureRecognizer:tapViewCustomer];
    
    //    UIView *viewAppVersion = [[UIView alloc] initWithFrame:CGRectMake(0, viewAboutus.frame.origin.y + viewAboutus.frame.size.height + spaingSmall, screen_width, viewHeight)];
    //    viewAppVersion.backgroundColor = [UIColor whiteColor];
    //    [applicationSV addSubview:viewAppVersion];
    //    NSString *titleBanben = NSLocalizedString(@"版本更新", nil );
    //    NSString *titleBanben2 = NSLocalizedString(@"版本:", nil );
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //    [self addSubDetailViews:viewAppVersion iconName:@"mxWodeFans" iconLeft:8 title:titleBanben titleLeft:20 hint:[NSString stringWithFormat:@"%@%@",titleBanben2,[infoDictionary objectForKey:@"CFBundleShortVersionString"]]];
    //    UITapGestureRecognizer *tapViewUpdate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewVersionUpdate:)];
    //    [viewAppVersion addGestureRecognizer:tapViewUpdate];
    
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, viewAboutUs.frame.origin.y + viewAboutUs.frame.size.height + spacingBig * 2, screen_width, scaleWithSize(44))];
    viewBottom.backgroundColor = [UIColor clearColor];
    [applicationSV addSubview:viewBottom];
    
    self.btnLoginOut = [UIButton buttonWithType:UIButtonTypeSystem];
    self.btnLoginOut.frame = CGRectMake(spacingBig, 0, viewBottom.frame.size.width - 2 * spacingBig, viewBottom.frame.size.height);
    NSString *title1 = NSLocalizedString(@"退出登录", nil );
    [self.btnLoginOut setTitle:title1 forState:UIControlStateNormal];
    [self.btnLoginOut setBackgroundColor: mx_Wode_colorBlue2374e4];
    [self.btnLoginOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnLoginOut addTarget:self action:@selector(btnLoginOutClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnLoginOut.layer.cornerRadius = 5.0f;
    [viewBottom addSubview:self.btnLoginOut];
    
    applicationSV.contentSize = CGSizeMake(screen_width, viewBottom.frame.origin.y + viewBottom.frame.size.height + scaleWithSize(49));
}
#pragma mark -- 账户信息
- (void)tapViewMyInsure:(UIGestureRecognizer *)tap {//账户信息
    //    NSLog(@"账户信息点击");
    MXPersonalInformationViewController *personView = [[MXPersonalInformationViewController alloc] init];
    personView.title = @"个人信息";
    [self.navigationController pushViewController:personView animated:NO];
//    [self removeFromParentViewController];
}
//各条件view块添加详细内容
-(UILabel *)addSubDetailViews:(UIView *)parentView iconName:(NSString *)imageName iconLeft:(CGFloat)iconX title:(NSString*)titleName titleLeft:(CGFloat)titleX hint:(NSString*)hintText{
    //开头图标
    UIImageView *viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 0, scaleWithSize(30), scaleWithSize(30))];
    [parentView addSubview:viewIcon];
    viewIcon.center = CGPointMake(viewIcon.center.x, parentView.frame.size.height/2);
    [viewIcon setImage:[UIImage imageNamed:imageName]];
    
    //标题
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX + scaleWithSize(30), 0, scaleWithSize(90), 32)];
    [parentView addSubview:lblTitle];
    lblTitle.center = CGPointMake(lblTitle.center.x, parentView.frame.size.height/2);
    lblTitle.numberOfLines = 1;
    lblTitle.text = titleName;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [lblTitle setTextColor:mx_Wode_color333333];
    lblTitle.backgroundColor =[UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Arial" size:16];
    
    
    //右箭头  15*15，距离右边也是15
    UIImageView *viewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(parentView.frame.size.width - scaleWithSize(15) - scaleWithSize(13), 0, scaleWithSize(8), scaleWithSize(13))];
    viewArrow.center = CGPointMake(viewArrow.center.x, parentView.frame.size.height/2);
    if ([titleName isEqualToString:@"消息设置"]||[titleName isEqualToString:@"版本更新"]||[titleName isEqualToString:@"清理缓存"]) {
        [viewArrow setImage:[UIImage imageNamed:@""]];//不显示右边的箭头
        
    }else {
        [viewArrow setImage:[UIImage imageNamed:@"mxWodeRightArrow"]];
    }
    //内容，初始化时为提示文字
    CGFloat left = scaleWithSize(62);
    [parentView addSubview:viewArrow];
    left = screen_width - 94 - 24;
    UILabel *lblContent = [[UILabel alloc] init];
    if ([titleName isEqualToString:@"账户信息"]||[titleName isEqualToString:@"关于我们"]) {
        lblContent.frame =CGRectMake(scaleWithSize(lblTitle.maxX), 0, screen_width - scaleWithSize(lblTitle.maxX)-scaleWithSize(35), 22 + 8 );
        //     lblContent.backgroundColor = [UIColor redColor];
    }else if ([titleName isEqualToString:@"清理缓存"]) {
        lblContent.frame =CGRectMake(scaleWithSize(lblTitle.maxX), 0, screen_width - scaleWithSize(lblTitle.maxX)-scaleWithSize(25), 22 + 8 );
        
    }else {
        lblContent.frame =CGRectMake(left, 0, viewArrow.frame.origin.x - left - 15 + 15 + 16, 22 + 8);
    }
    [parentView addSubview:lblContent];
    lblContent.center = CGPointMake(lblContent.center.x, parentView.frame.size.height/2);
    lblContent.text = hintText;
    lblContent.textColor = mx_Wode_color666666;
    lblContent.backgroundColor =[UIColor clearColor];
    lblContent.textAlignment = NSTextAlignmentRight;
    lblContent.font = [UIFont fontWithName:@"Arial" size:15.0f];
    
    return lblContent;
}


#pragma mark ---消息设置点击
- (void)tapViewArticleCollection:(UIButton *)sender {
    
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
//    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
//    if (userModel.messageYesOrNo.intValue == 0) {
//        userModel.messageYesOrNo = @"1";
//        [sender setBackgroundImage:[UIImage imageNamed:@"my_kaiguan_kai"] forState:UIControlStateNormal];
//        [MXssWodeUtils savePersonInfo:userModel];
//    }else{
//        userModel.messageYesOrNo = @"0";
//        [sender setBackgroundImage:[UIImage imageNamed:@"my_kaiguan_guan"] forState:UIControlStateNormal];
//        [MXssWodeUtils savePersonInfo:userModel];
//    }
}
- (void)tapviewCacheClick:(UIButton *)sender {
[self clearCaches];
    
}
#pragma mark - 清除缓存
- (void)clearCaches {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    /* 确认按钮 */
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        /* 清除缓存 */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            /* 获取缓存文件夹路径 */
            NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            /* 获取缓存文件夹的大小 */
            CGFloat size = [self folderSizeAtPath:cachPath];
            
            /* 获取缓存文件夹路径下 的所有文件 */
            NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
            
            /* 遍历所有文件， 一一删除 */
            for(NSString *str in files) {
                NSError *error;
                NSString *path = [cachPath stringByAppendingPathComponent:str];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            
            /* 缓存清除成功后的提醒 */
            UIAlertController *success = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"成功清除%.1fM缓存", size] preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:success animated:YES completion:^{
                [applicationSV removeFromSuperview];
                [self setupUISetting];
            }];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
        
    }];
    [alert addAction:sure];
    
    /* 取消按钮 */
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"删除");
    }];
    [alert addAction:cancel];
    
    /* 推出alert */
    [self presentViewController:alert animated:YES completion:^{
        
    }];
    
}

/* 获取单个文件的大小 */
- (long long)fileSizeAtPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/* 通过回调函数，获取路径下的所有文件总大小 */
- (float)folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *child = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [child nextObject]) != nil) {
        NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:filePath];
    }
    return folderSize / (1024.0 * 1024.0);
}

#pragma mark -- Event Methods 意见反馈的点击
-(void)tapviewYijian:(UIButton *)sender {//NSLog(@"意见反馈的点击");
    MXSSSettingYijianFankuiViewController *yijianfankuiVC = [[MXSSSettingYijianFankuiViewController alloc] init];
    [self.navigationController pushViewController:yijianfankuiVC animated:NO];
}


#pragma mark -- Event Methods关于我们的点击
-(void)tapviewAboutUs:(UIButton *)sender {//NSLog(@"关于我们的点击");
    MXSSSettingAboutUSViewController *aboutUSVC = [[MXSSSettingAboutUSViewController alloc] init];
    [self.navigationController pushViewController:aboutUSVC animated:NO];
}
//#pragma mark -- Event Methods辅助功能的点击
//-(void)tapViewComPro:(UIButton *)sender {///NSLog(@"辅助功能的点击");
//    MXSSSettingAuxiliaryFunctionViewController *auxiliaryView = [[MXSSSettingAuxiliaryFunctionViewController alloc] init];
//    [self.navigationController pushViewController:auxiliaryView animated:YES];
//}

//#pragma mark -- Event Methods客服的点击
//-(void)tapViewCustomer:(UIButton *)sender {///NSLog(@"客服的点击");
//    MXSSSettingCustomerSViewController *customerView = [[MXSSSettingCustomerSViewController alloc] init];
//    [self.navigationController pushViewController:customerView animated:NO];
//}

#pragma mark -- Event Methods版本更新点击
- (void)topViewVersionUpdate:(UIButton*)sender {//版本更新点击
    NSString *alertTitle = @"XXXX已下载完成";
    NSString *alertInfo = @"更新说明\n 本次更新\n 1、新春版本来临，精彩活动闹新年\n 2、比分列表技术优化，加载速度越来越快\n 3、论坛体验优化，告别卡顿";
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:alertTitle message:alertInfo preferredStyle:UIAlertControllerStyleAlert];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"稍后下载" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"稍后下载点击");
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:@"立即下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"立即下载点击");
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}

- (void)btnLoginOutClicked:(UIButton *)sender {//退出当前账号
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认退出?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * action) {
        [MXssWodeUtils removePersonInfo];
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        login.isPageNumber = 1;
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        
        [self presentViewController:nav animated:YES completion:nil];
        [self removeFromParentViewController];
        // 发出通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"NOTI_LOGOUT" object:nil];
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //响应事件
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"设置"];
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
    //设置返回按钮是否显示
    [self setBackButton:YES];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"设置界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"设置界面\"}"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
