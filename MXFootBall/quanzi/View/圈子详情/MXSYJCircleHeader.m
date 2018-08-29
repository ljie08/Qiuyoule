//
//  MXSYJCircleHeader.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/2.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCircleHeader.h"

@implementation MXSYJCircleHeader

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerPlace"]];
        [self addSubview:img];
        img.userInteractionEnabled = YES;
        img.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0);
        UIView *view = [[UIView alloc]init];
        [img addSubview:view];
        view.backgroundColor = mx_Wode_colorBlue2374e4;
        view.alpha = 1.0;
        view.sd_layout.leftSpaceToView(img, 0).rightSpaceToView(img, 0).topSpaceToView(img, 0).bottomSpaceToView(img, 0);
        
        self.iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerPlace"]];
        [img addSubview:self.iconImg];
        self.iconImg.sd_layout.leftSpaceToView(img, 10).centerYEqualToView(img).heightIs(65).widthIs(65);
        
        self.nameLab = [[UILabel alloc]init];
        [img addSubview:self.nameLab];
        self.nameLab.font = fontBoldSize(15);
        self.nameLab.textColor = [UIColor whiteColor];
        self.nameLab.sd_layout.leftSpaceToView(self.iconImg, 10).topSpaceToView(img, 20).heightIs(20);
        [self.nameLab setSingleLineAutoResizeWithMaxWidth:240];
        
        self.circleLab = [[UILabel alloc]init];
        [img addSubview:self.circleLab];
        self.circleLab.font = fontSize(14);
        self.circleLab.textColor = [UIColor whiteColor];
        self.circleLab.textAlignment = NSTextAlignmentCenter;
        self.circleLab.text = @"圈规";
        self.circleLab.sd_layout.leftSpaceToView(self.nameLab, 10).centerYEqualToView(self.nameLab).heightIs(18).widthIs(40);
        self.circleLab.layer.masksToBounds = YES;
        self.circleLab.layer.cornerRadius = 5;
        self.circleLab.layer.borderColor = [UIColor whiteColor].CGColor;
        self.circleLab.layer.borderWidth = 1.0;
        
        self.descLab = [[UILabel alloc]init];
        [img addSubview:self.descLab];
        self.descLab.font = fontSize(14);
        self.descLab.textColor = [UIColor whiteColor];
        self.descLab.sd_layout.leftSpaceToView(self.iconImg, 10).topSpaceToView(self.nameLab, 10).heightIs(20);
        [self.descLab setSingleLineAutoResizeWithMaxWidth:280];
        
        self.postLab = [[UILabel alloc]init];
        [img addSubview:self.postLab];
        self.postLab.font = fontSize(14);
        self.postLab.textAlignment = NSTextAlignmentCenter;
        self.postLab.textColor = [UIColor whiteColor];
        self.postLab.sd_layout.rightSpaceToView(img, 15).centerYEqualToView(img).heightIs(20);
        [self.postLab setSingleLineAutoResizeWithMaxWidth:100];
        
    }
    
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
