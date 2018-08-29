//
//  MXSYJCustomNavitagionView.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCustomNavitagionView.h"

@interface MXSYJCustomNavitagionView ()

@end

@implementation MXSYJCustomNavitagionView

- (instancetype)init{
    
    if (self = [super init]) {
        
       
        self.backgroundColor = mx_Wode_colorBlue2374e4;
        
        self.publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.publishBtn];
        [self.publishBtn setImage:[UIImage imageNamed:@"xiewen"] forState:UIControlStateNormal];
        self.publishBtn.sd_layout.leftSpaceToView(self, 18).topSpaceToView(self, 10).bottomSpaceToView(self, 10).widthIs(25);
        self.publishBtn.tag = 1;
        [self.publishBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.squareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.squareBtn];
        [self.squareBtn setTitle:@"广场" forState:UIControlStateNormal];
        self.squareBtn.titleLabel.font = fontBoldSize(15);
        self.squareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self.squareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.squareBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        self.squareBtn.sd_layout.leftSpaceToView(self.publishBtn, 65).topSpaceToView(self, 10).bottomSpaceToView(self, 10).widthIs(80);
        self.squareBtn.tag = 2;
        [self.squareBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.serachBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.serachBtn];
        [self.serachBtn setImage:[UIImage imageNamed:@"sousuo"] forState:UIControlStateNormal];
        self.serachBtn.sd_layout.rightSpaceToView(self, 18).topSpaceToView(self, 10).bottomSpaceToView(self, 10).widthIs(25);
        self.serachBtn.tag = 4;
        [self.serachBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.focusBtn];
        [self.focusBtn setTitle:@"关注" forState:UIControlStateNormal];
        self.focusBtn.titleLabel.font = fontBoldSize(15);
        self.focusBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [self.focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self.focusBtn setTitleColor:mx_FontGreyColor  forState:UIControlStateNormal];
        self.focusBtn.sd_layout.rightSpaceToView(self.serachBtn, 65).topSpaceToView(self, 10).bottomSpaceToView(self, 10).widthIs(80);
        self.focusBtn.tag = 3;
        [self.focusBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    return self;
    
}

- (void)btnClick:(UIButton *)btn{
    
    if (self.clickBtnBlock) {
        self.clickBtnBlock(btn.tag);
    }
    
}





@end
