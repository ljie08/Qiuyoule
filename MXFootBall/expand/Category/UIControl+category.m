//
//  UIControl+category.m
//  MXFootBall
//
//  Created by YY on 2018/5/15.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "UIControl+category.h"
#import <objc/runtime.h>
static const void *ClickedControlKey=&ClickedControlKey;

@implementation UIControl (category)

-(void)addActionHandler:(TouchedControlBlock)control{
    objc_setAssociatedObject(self, ClickedControlKey, control, OBJC_ASSOCIATION_RETAIN);
    [self addTarget:self action:@selector(clickedControlHandler:) forControlEvents:UIControlEventValueChanged];
}
-(void)clickedControlHandler:(UIControl *)control{
    TouchedControlBlock block=objc_getAssociatedObject(self, ClickedControlKey);
    if (block) {
        block(control);
    }
}
@end
