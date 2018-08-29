//
//  UITapGestureRecognizer+Category.m
//  MXFootBall
//
//  Created by YY on 2018/5/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "UITapGestureRecognizer+Category.h"
#import <objc/runtime.h>
static const void * TapClicked=&TapClicked;
@implementation UITapGestureRecognizer (Category)

-(void)addActionBlock:(TapClickedBlock)block{
    [self addTarget:self action:@selector(tapClicked:)];
    objc_setAssociatedObject(self, TapClicked, block, OBJC_ASSOCIATION_COPY);
}

-(void)tapClicked:(UITapGestureRecognizer *)tap{
   TapClickedBlock block= objc_getAssociatedObject(self, TapClicked);
    if (block) {
        block(tap);
    }
}
@end
