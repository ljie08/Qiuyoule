//
//  LoopView.h
//  MXFootBall
//
//  Created by wxw on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleModel.h"

@interface LoopView : UIView


/**
 重写init方法

 @param frame frame
 @param radius 半径
 @param mArray 圆环百分比和颜色
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame withRadius:(CGFloat)radius withModelArray:(NSMutableArray *)mArray;

@end
