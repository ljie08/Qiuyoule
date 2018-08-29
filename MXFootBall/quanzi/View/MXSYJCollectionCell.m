//
//  MXSYJCollectionCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCollectionCell.h"

@implementation MXSYJCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"quanzixiangqingtouxiang"]];
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imgView];
        self.imgView.sd_cornerRadius = @3;
        self.imgView.sd_layout.leftSpaceToView(self.contentView, 10).centerYEqualToView(self.contentView).heightIs(55).widthIs(55);
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius = 2;
        self.imgView.layer.borderColor = mx_LineColor.CGColor;
        self.imgView.layer.borderWidth = 1.0;
        
        self.nameLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLab];
        self.nameLab.textColor = [UIColor blackColor];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = fontBoldSize(15);
        self.nameLab.sd_layout.leftSpaceToView(self.imgView, 6).topSpaceToView(self.contentView, 20).heightIs(20).rightSpaceToView(self.contentView, 5);
        //        限定最大宽度，单行Label的视图,如下，在文本单行在160范围内时按文本大小显示宽度，在大于160时只显示160宽度，其他的省略
        self.nameLab.text = @"球球名人堂";
        
        self.descLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.descLab];
        self.descLab.textColor = mx_Wode_darkGreyFontColor;
        self.descLab.textAlignment = NSTextAlignmentLeft;
        self.descLab.font = fontSize(14);
        self.descLab.sd_layout.leftSpaceToView(self.imgView, 6).topSpaceToView(self.nameLab, 5).heightIs(20).rightSpaceToView(self.contentView, 5);
        //        限定最大宽度，单行Label的视图,如下，在文本单行在160范围内时按文本大小显示宽度，在大于160时只显示160宽度，其他的省略
//        [self.descLab setSingleLineAutoResizeWithMaxWidth:160];
        self.descLab.text = @"最牛逼的描述";
 
    }
    
    return self;
    
}

- (void)setModel:(MXSYJChannelModel *)model{
    
    _model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
    self.nameLab.text = model.channelName;
    self.descLab.text = [NSString stringWithFormat:@"今日更新 %@", model.PubNum];
    
}


@end
