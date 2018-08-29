//
//  MXSYJButton.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/3.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger) {
    SYJCustomButtonImageTop    = 0 , //图片在上边
    SYJCustomButtonImageLeft   = 1 , //图片在左边
    SYJCustomButtonImageBottom = 2 , //图片在下边
    SYJCustomButtonImageRight  = 3   //图片在右边
}SYJCustomButtonType;

@interface MXSYJButton : UIButton

/** 图片和文字间距 默认10px*/
@property (nonatomic , assign) CGFloat ysl_spacing;

/** 按钮类型 默认YSLCustomButtonImageTop 图片在上边*/
@property (nonatomic , assign) SYJCustomButtonType ysl_buttonType;

@end
