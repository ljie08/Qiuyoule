//
//  MXSYJCelebrityCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCelebrityCell.h"

@implementation MXSYJCelebrityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.numLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.numLab];
        self.numLab.text = @"4";
        self.numLab.textAlignment = NSTextAlignmentCenter;
        self.numLab.font = fontBoldSize(13);
        self.numLab.textColor = mx_FontBalckColor;
        self.numLab.sd_layout.leftSpaceToView(self.contentView, 0).centerYEqualToView(self.contentView).heightIs(20).widthIs(25);
        
        self.iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerPlace"]];
        [self.contentView addSubview:self.iconImg];
        self.iconImg.sd_layout.leftSpaceToView(self.numLab, 5).centerYEqualToView(self.contentView).heightIs(54).widthIs(54);
        self.iconImg.sd_cornerRadius = @27;
        
        self.nameLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLab];
        self.nameLab.text = @"这个是名称";
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = fontBoldSize(11);
        self.nameLab.textColor = mx_FontBalckColor;
        self.nameLab.sd_layout.leftSpaceToView(self.iconImg, 8).centerYEqualToView(self.contentView).heightIs(20).widthIs(80);
        
        self.descLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.descLab];
        self.descLab.text = @"命中率高达80%";
        self.descLab.textAlignment = NSTextAlignmentRight;
        self.descLab.font = fontSize(11);
        self.descLab.textColor = mx_redColor;
        self.descLab.sd_layout.rightSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).heightIs(20).leftSpaceToView(self.nameLab, 10);
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = mx_LineColor;
        [self.contentView addSubview:line];
        line.sd_layout.bottomSpaceToView(self.contentView, 1).heightIs(0.5).leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }
    
    return self;
    
}

- (void)setModel:(HitTable *)model{
    
    _model = model;
    self.nameLab.text = model.username;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.headerPic] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
    CGFloat hit = model.hitRate * 100;
    self.descLab.text = [NSString stringWithFormat:@"命中率高达 %.2f%@",hit,@"%"];
    self.numLab.text = [NSString stringWithFormat:@"%ld",model.num];
    
}

@end
