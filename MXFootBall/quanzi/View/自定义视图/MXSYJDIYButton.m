//
//  MXSYJDIYButton.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJDIYButton.h"

@implementation MXSYJDIYButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wenhao"]];
        self.img.contentMode = UIViewContentModeCenter;
        [self addSubview:self.img];
        self.img.sd_layout.leftSpaceToView(self, 5).centerYEqualToView(self).widthIs(40).heightIs(40);
        
        self.nameLab = [[UILabel alloc]init];
        [self addSubview:self.nameLab];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = fontSize(12);
        self.nameLab.sd_layout.leftSpaceToView(self.img, 8).centerYEqualToView(self.img).heightIs(20).rightSpaceToView(self, 5);
        
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    
    return self;
    
}

- (void)click:(UIControl *)sender{
    
    if (self.click) {
        self.click(sender);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
