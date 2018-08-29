//
//  SVProgressHUD+MXProgressHUD.m
//  MXFootBall
//
//  Created by zt on 2018/5/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "SVProgressHUD+MXProgressHUD.h"
#import <objc/runtime.h>
#import <UIImage+GIF.h>

@implementation SVProgressHUD (MXProgressHUD)

+ (void)load{
    Method sw_showWithStatus = class_getClassMethod(self, @selector(sw_showWithStatus:));
    
    Method showWithStatus = class_getClassMethod(self, @selector(showWithStatus:));
    
    method_exchangeImplementations(showWithStatus, sw_showWithStatus);
    
    Method showSuccess = class_getClassMethod(self, @selector(showSuccessWithStatus:));
    
    Method sw_showSuccess = class_getClassMethod(self, @selector(sw_showSuccessWithStatus:));
    
    method_exchangeImplementations(showSuccess, sw_showSuccess);
    
    Method showError = class_getClassMethod(self, @selector(showErrorWithStatus:));
    
    Method sw_showError = class_getClassMethod(self, @selector(sw_showErrorWithStatus:));
    
    method_exchangeImplementations(showError, sw_showError);
    
    Method showInfo = class_getClassMethod(self, @selector(showInfoWithStatus:));
    
    Method sw_showInfo = class_getClassMethod(self, @selector(sw_showInfoWithStatus:));
    
    method_exchangeImplementations(showInfo, sw_showInfo);
    
}

+ (void)sw_showWithStatus: (NSString *)status {
//    [SVProgressHUD setBackgroundColor:[UIColor whiteColor]];
    [self sw_showWithStatus:status];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"progress" ofType:@"gif"];
    NSData *data=[NSData dataWithContentsOfFile:filePath];
    [SVProgressHUD showImage:[UIImage sd_animatedGIFWithData:data] status:status];
}

+ (void)sw_showSuccessWithStatus:(NSString *)status{
    [self sw_showSuccessWithStatus:status];
    
    [SVProgressHUD dismissWithDelay:0.8f];
}

+ (void)sw_showErrorWithStatus:(NSString *)status{
    [self sw_showErrorWithStatus:status];
    
    [SVProgressHUD dismissWithDelay:0.8f];
}

+ (void)sw_showInfoWithStatus:(NSString *)status{
    [self sw_showInfoWithStatus:status];
    
    [SVProgressHUD dismissWithDelay:0.8f];
}

@end
