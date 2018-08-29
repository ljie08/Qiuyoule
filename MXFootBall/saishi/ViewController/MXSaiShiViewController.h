//
//  MXSaiShiViewController.h
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

//#import "ViewController.h"

#import "WMPageController.h"

typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
};


@interface MXSaiShiViewController : WMPageController

@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;


@end
