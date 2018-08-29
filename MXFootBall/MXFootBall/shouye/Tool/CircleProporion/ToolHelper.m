//
//  ToolHelper.m
//  MXFootBall
//
//  Created by wxw on 2018/3/6.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "ToolHelper.h"

@implementation ToolHelper
+(void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}
@end
