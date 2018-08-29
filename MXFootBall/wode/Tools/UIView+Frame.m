//
//  UIView+Frame.m
//  HITAPP
//
//  Created by tangfangyu on 16/3/15.
//  Copyright © 2016年 tangfangyu. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

-(CGFloat)x{
    return self.frame.origin.x;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGFloat)width{
    return self.frame.size.width;
}

-(CGFloat)height{
    return self.frame.size.height;
}

-(CGFloat)minX{
    return CGRectGetMinX(self.frame);
}

-(CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

-(CGFloat)minY{
    return CGRectGetMinY(self.frame);
}

-(CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

-(CGFloat)midX{
    return CGRectGetMidX(self.frame);
}

-(CGFloat)midY{
    return CGRectGetMidY(self.frame);
}

-(void)setX:(CGFloat)x{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

-(void)setY:(CGFloat)y{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

-(void)setWidth:(CGFloat)width{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

-(void)setHeight:(CGFloat)height{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

@end
