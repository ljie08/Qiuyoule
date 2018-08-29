//
//  MXSYJProgressLayer.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface MXSYJProgressLayer : CAShapeLayer

+ (instancetype)layerWithFrame:(CGRect)frame;

- (void)finishedLoad;
- (void)startLoad;

- (void)closeTimer;


@end
