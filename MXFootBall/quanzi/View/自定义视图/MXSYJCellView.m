//
//  MXSYJCellView.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCellView.h"

@implementation MXSYJCellView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
       
        self.backgroundColor = [UIColor whiteColor];
        
//        self.sd_cornerRadius = @5;
//        self.layer.masksToBounds = YES;
//        self.layer.borderColor = mx_FontLightGreyColor.CGColor;
//        self.layer.borderWidth = 0.5;
        
        self.iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerPlace"]];
        [self addSubview:self.iconImg];
        self.iconImg.sd_layout.centerXEqualToView(self).topSpaceToView(self,5).heightIs(60).widthIs(60);
        self.iconImg.sd_cornerRadius = @30;
        
        
        self.nameLab = [[UILabel alloc]init];
        [self addSubview:self.nameLab];
        self.nameLab.text = @"这是名字";
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        self.nameLab.textColor = mx_FontBalckColor;
        self.nameLab.font = fontBoldSize(12);
        self.nameLab.sd_layout.topSpaceToView(self.iconImg, 5).leftSpaceToView(self, 7).rightSpaceToView(self, 7).heightIs(15);
        
        self.rankingLab = [[UILabel alloc]init];
        [self addSubview:self.rankingLab];
        self.rankingLab.textColor = [UIColor whiteColor];
        self.rankingLab.text = @"1";
        self.rankingLab.textAlignment = NSTextAlignmentCenter;
        self.rankingLab.font = fontSize(10);
        self.rankingLab.backgroundColor = mx_BlueColor;
    self.rankingLab.sd_layout.rightEqualToView(self.iconImg).bottomSpaceToView(self.nameLab, 10).heightIs(20).widthIs(20);
        self.rankingLab.sd_cornerRadius = @10;
        
        self.rankingImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huangguan"]];
        [self addSubview:self.rankingImg];
        self.rankingImg.sd_layout.
        rightEqualToView(self.iconImg).bottomSpaceToView(self.nameLab, 10).heightIs(20).widthIs(20);
        self.rankingImg.hidden = YES;

        
        
        self.descLab = [[UILabel alloc]init];
        [self addSubview:self.descLab];
        self.descLab.textAlignment = NSTextAlignmentCenter;
        self.descLab.textColor = mx_redColor;
        self.descLab.text = @"周命中率99%";
        self.descLab.font = fontSize(12);
        [self.descLab setSingleLineAutoResizeWithMaxWidth:200];
        self.descLab.sd_layout.topSpaceToView(self.nameLab, 0).centerXEqualToView(self).heightIs(15);
        
        

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clcik)];
        [self addGestureRecognizer:tap];
        
        
        
        
    }
    
    return self;
    
}

- (void)clcik{
    
    if (self.click) {
        self.click();
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
