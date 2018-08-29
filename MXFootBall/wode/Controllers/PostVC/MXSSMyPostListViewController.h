//
//  MXSSMyPostListViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <WMPageController/WMPageController.h>

typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
};

@interface MXSSMyPostListViewController : WMPageController
@property (nonatomic,copy) NSString *mypostS;//传值 显示页面
@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;
@end
