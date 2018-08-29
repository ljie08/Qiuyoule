//
//  AppDelegate.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "AppDelegate.h"
#import "MXTabBarController.h"
#import <IQKeyboardManager.h>
#import <Bugly/Bugly.h>
#import "MXAdsViewController.h"
#import "MXWelcomeViewController.h"
#import "MXFundamentalsViewController.h"
#import "MXSYJPostDetailsController.h"
#import "MXBattleDetailsViewController.h"
#import <AdSupport/AdSupport.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong) MXTabBarController *tabVC;

@property (nonatomic, assign) NSInteger myCount;


@end

@implementation AppDelegate

static NSString *buglyAppID = @"67021e896b";

static NSString *appKey = @"b69ff29e76472ab688c058d7";

static NSString *channel = @"qiuyoule";

- (void)setCount:(NSInteger)count{
    
    _count = count;
    self.tabVC = [[MXTabBarController alloc]init];
    self.tabVC.selectedIndex = count;
    self.window.rootViewController = self.tabVC;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //app杀死情况下 接受推送判断
    if (launchOptions != nil) {
        //app关闭时，收到推送
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [MXwodeUnitObject shareManager].JpushUserInfo=userInfo;
        [self application:application didReceiveRemoteNotification:launchOptions[@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
    }
    
    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    //设置UBT的域名
    [[NSUserDefaults standardUserDefaults] setObject:@"https://ubt.qiuyoule.com/ubt" forKey:@"ubt.host"];
    //修改状态栏颜色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //判断是否第一次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        //    self.tabVC = [[MXTabBarController alloc]init];
        self.window.rootViewController = [MXWelcomeViewController new];
        [self.window makeKeyAndVisible];
        
    }else{
        self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        //    self.tabVC = [[MXTabBarController alloc]init];
        self.window.rootViewController = [MXAdsViewController new];
        [self.window makeKeyAndVisible];
    }
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 20.0;
    
    //注册微信
    [WXApi registerApp:WX_APPID];
    
    //bugly
    //腾讯bugly
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.reportLogLevel = BuglyLogLevelWarn;
    config.unexpectedTerminatingDetectionEnable = YES;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    [Bugly startWithAppId:buglyAppID config:config];
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
    
    return YES;
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support

 //接收
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置

}


// iOS 10 Support
//点击通知
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    //
        
    MXTabBarController *rootVC = [[MXTabBarController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:rootVC];
    [self.window addSubview:rootVC.view];
    [self.window makeKeyAndVisible];
    MXTabBarController *baseTabBar = (MXTabBarController *)self.window.rootViewController;
    [self JpushJumpViewControllerWithUserInfo:userInfo Tabbar:baseTabBar];


    completionHandler();  // 系统要求执行这个方法

}
//-(void)pushNotification:(NSNotification *)notification{
//    [self JpushJumpViewControllerWithUserInfo:notification.userInfo];
//}
- (void)JpushJumpViewControllerWithUserInfo:(NSDictionary *)dict Tabbar:(MXTabBarController *)tabbar
{
    switch ([[dict objectForKey:@"action"]intValue]) {
        case 1:
        {//资讯
            NSLog(@"资讯+++++++++++");
            MXSYJPostDetailsController *postDetailVC  = [[MXSYJPostDetailsController alloc]init];
            postDetailVC.newsID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
            [tabbar.viewControllers[0] pushViewController:postDetailVC animated:YES];
            
        }
            
            break;
        case 2:
        {//赛事
            NSLog(@"赛事 +++++++++++++");
            MXBattleDetailsViewController *BattleDetails  = [[MXBattleDetailsViewController alloc]init];
            BattleDetails.matchId = [[dict objectForKey:@"id"] integerValue];
            [tabbar.viewControllers[0] pushViewController:BattleDetails animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark -- wechat
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode == 0) {
        NSString *code = aresp.code;
        NSDictionary *dictionary = @{@"code":code};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wechat" object:self userInfo:dictionary];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (@available(iOS 11.0, *)) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    } else {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.applicationIconBadgeNumber = -1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    if (@available(iOS 11.0, *)) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = -1;
    } else {
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate date];
        localNotification.applicationIconBadgeNumber = -1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
