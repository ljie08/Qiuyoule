//
//  MXEventScreeningViewController.h
//  MXFootBall
//
//  Created by dai on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "WMPageController.h"

typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
};

@interface MXEventScreeningViewController : WMPageController

@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;

@property (nonatomic , strong) NSString * optType ;

@property (nonatomic , weak) void (^selectNameDic)(NSMutableDictionary * dic) ;

@end
