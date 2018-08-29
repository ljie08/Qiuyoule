//
//  UIViewController+SYJViewContoller.m
//  MoXiDemo
//
//  Created by 尚勇杰 on 2017/5/26.
//  Copyright © 2017年 尚勇杰. All rights reserved.
//

#import "UIViewController+SYJViewContoller.h"
#import <objc/runtime.h>

@implementation UIViewController (SYJViewContoller)

+ (void)load{
    
    Method currentClass = class_getInstanceMethod(self, @selector(viewDidLoad))
    ;
    Method changeClass = class_getInstanceMethod(self, @selector(sw_viewDidLoad))
    ;
    
    method_exchangeImplementations(changeClass, currentClass);
    
    
}

- (void)sw_viewDidLoad{
    [self sw_viewDidLoad];
    if (![[self class] isKindOfClass:[UINavigationController class]]) {
        [UBT logPage:[NSString stringWithFormat:@"%@", [self class]]];
        NSLog(@"当前界面:%@",[NSString stringWithFormat:@"%@", [self class]]);
    }
    
}


@end
