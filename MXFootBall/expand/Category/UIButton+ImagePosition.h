//
//  UIButton+ImagePosition.h
//  MXFootBall
//
//  Created by YY on 2018/4/11.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ImagePosition){
    ImagePositionLeft  =0, //图在左文字在右
    ImagePositionRight =1,
    ImagePositionTop   =2,//图在上文字在下
    ImagePositionBottom=3
};
typedef void (^TouchedButtonBlock)(UIButton *btn);
@interface UIButton (ImagePosition)

/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**
 *  用于设置单个按钮不需要被hook
 */
@property (nonatomic, assign) BOOL isIgnore;

- (void)setImagePosition:(ImagePosition)postion spacing:(CGFloat)spacing;

-(void)addActionHandler:(TouchedButtonBlock)touchHandler;

-(NSString *)titleForState:(UIControlState)state andSubstringWithRange:(NSRange) range;


-(NSString *)titleForState:(UIControlState)state andFormIndex:(NSInteger) index;
@end
