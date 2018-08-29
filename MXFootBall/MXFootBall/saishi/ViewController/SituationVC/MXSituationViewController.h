//
//  MXSituationViewController.h
//  MXFootBall
//
//  Created by YY on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//
#import <WMPageController.h>
#import <UIKit/UIKit.h>

@interface MXSituationViewController : WMPageController

@property (nonatomic,strong)NSString *startTime;

@property (nonatomic,strong)NSString *matchStatus;

@property (nonatomic,assign)NSInteger selectedIndex;
@end
