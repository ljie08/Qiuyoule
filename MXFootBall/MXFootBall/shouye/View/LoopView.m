//
//  LoopView.m
//  MXFootBall
//
//  Created by wxw on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "LoopView.h"
#define TPI (2 * M_PI)

@interface LoopView()
@property (assign, nonatomic) CGFloat tempValue;        //临时存放
@end

@implementation LoopView

- (instancetype)initWithFrame:(CGRect)frame withRadius:(CGFloat)radius withModelArray:(NSMutableArray *)mArray
{
    self = [super initWithFrame:frame];
    if (self) {

        for (CircleModel *model in mArray) {
            
            [self setLoopView:radius withProportion:model.proportion withLoopColor:model.circleColor];
            
        }
    }
    return self;
}


/**
 设置圆环

 @param radius 半径
 @param propor 百分比
 @param loopColor 圆环颜色
 */
- (void)setLoopView:(CGFloat)radius withProportion:(CGFloat)propor withLoopColor:(UIColor *)loopColor{
    
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.lineWidth = 10;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = loopColor.CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2) radius:radius startAngle:self.tempValue * TPI endAngle:(propor + self.tempValue) * TPI clockwise:YES];
    layer.path = [path CGPath];
    
    [self.layer addSublayer:layer];
    
    self.tempValue = propor + self.tempValue;
    
}

@end
