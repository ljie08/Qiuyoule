//
//  UITapGestureRecognizer+Category.h
//  MXFootBall
//
//  Created by YY on 2018/5/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TapClickedBlock)(UITapGestureRecognizer *tap);
@interface UITapGestureRecognizer (Category)

- (void)addActionBlock:(TapClickedBlock) block;

@end
