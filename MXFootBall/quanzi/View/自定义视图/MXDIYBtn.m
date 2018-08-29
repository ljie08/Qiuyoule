//
//  MXDIYBtn.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXDIYBtn.h"

@implementation MXDIYBtn

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
       
        self.nameLab = [[UILabel alloc]init];
        [self addSubview:self.nameLab];
        self.nameLab.textColor = mx_FontLightGreyColor;
        self.nameLab.font = fontSize(14);
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        self.nameLab.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 2);
        
        self.line = [[UIView alloc]init];
        [self addSubview:self.line];
        self.line.backgroundColor = [UIColor clearColor];
        self.line.frame = CGRectMake(0, self.nameLab.frame.size.height - 2, frame.size.width, 2);
        
        [self addTarget:self action:@selector(clcik:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
    
}

- (void)clcik:(UIControl *)control{
    
    if (self.click) {
        self.click(control);
    }
    
}

@end
