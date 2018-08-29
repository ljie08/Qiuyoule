//
//  MXSYJButton.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/3.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJButton.h"

@implementation MXSYJButton

#pragma mark Layout Subview
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    //根据YSLCustomButtonType和ysl_spacing得到imageEdgeInsets和labelEdgeInsets的值
    switch (self.ysl_buttonType) {
        case SYJCustomButtonImageTop:{
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - self.ysl_spacing , 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight - self.ysl_spacing , 0);
            break;
        }
        case SYJCustomButtonImageLeft:{
            imageEdgeInsets = UIEdgeInsetsMake(0, -self.ysl_spacing , 0, self.ysl_spacing );
            labelEdgeInsets = UIEdgeInsetsMake(0, self.ysl_spacing , 0, -self.ysl_spacing );
            break;
        }
        case SYJCustomButtonImageBottom:{
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight - self.ysl_spacing , -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - self.ysl_spacing , -imageWith, 0, 0);
            break;
        }
        case SYJCustomButtonImageRight:{
            
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + self.ysl_spacing - 5, 0, -labelWidth - self.ysl_spacing);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith - self.ysl_spacing , 0, imageWith + self.ysl_spacing);
            break;
        }
        default:
            break;
    }
    
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
    
}




#pragma mark lazy loading
- (CGFloat)ysl_spacing{
    if (!_ysl_spacing) {
        _ysl_spacing = 5;
    }
    return _ysl_spacing;
}

@end
