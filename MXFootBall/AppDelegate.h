//
//  AppDelegate.h
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;

//跳转到哪个tabbar
@property (nonatomic, assign) NSInteger count;



@end

