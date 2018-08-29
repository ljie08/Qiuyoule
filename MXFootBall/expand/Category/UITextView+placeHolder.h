//
//  UITextView+placeHolder.h
//  UITextView加placeHolderDemo
//
//  Created by YY on 2018/3/30.
//  Copyright © 2018年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (placeHolder)
/**
 *  UITextView+placeholder
 */
@property (nonatomic, copy) NSString *yy_placeHolder;
/**
 *  IQKeyboardManager等第三方框架会读取placeholder属性并创建UIToolbar展示
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 *  placeHolder颜色
 */
@property (nonatomic, strong) UIColor *yy_placeHolderColor;

-(void)setTextMaxLength:(NSInteger) maxLength;

@end
