//
//  UIControl+category.h
//  MXFootBall
//
//  Created by YY on 2018/5/15.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TouchedControlBlock)(id control);
@interface UIControl (category)

-(void)addActionHandler:(TouchedControlBlock) control;

@end
