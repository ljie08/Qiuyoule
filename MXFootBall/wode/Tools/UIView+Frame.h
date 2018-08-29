//
//  UIView+Frame.h
//  HITAPP
//
//  Created by tangfangyu on 16/3/15.
//  Copyright © 2016年 tangfangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic,assign) CGFloat x;

@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) CGFloat width;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign,readonly) CGFloat minX;

@property (nonatomic,assign,readonly) CGFloat maxX;

@property (nonatomic,assign,readonly) CGFloat minY;

@property (nonatomic,assign,readonly) CGFloat maxY;

@property (nonatomic,assign,readonly) CGFloat midX;

@property (nonatomic,assign,readonly) CGFloat midY;

@end
