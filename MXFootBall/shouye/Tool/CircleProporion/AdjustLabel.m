//
//  AdjustLabel.m
//  MXFootBall
//
//  Created by wxw on 2018/3/16.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "AdjustLabel.h"

@implementation AdjustLabel

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self addAdjustFont];
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addAdjustFont];
    }
    return self;
}

//自动调整字体大小
- (void)addAdjustFont {
    if (IS_IPHONE_6) {
        self.font = [UIFont systemFontOfSize:self.minSizeOfFont];
    }
    
    if (IS_IPHONE_6P) {
        self.font = [UIFont systemFontOfSize:self.maxSizeOfFont];
    }
}

@end
