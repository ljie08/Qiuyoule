//
//  MXSYJAdCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJAdCell.h"
#import "UIView+CornerRadius.h"

@implementation MXSYJAdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerPlace"]];
        [self.contentView addSubview:self.imgView];
        self.imgView.userInteractionEnabled = YES;
        self.imgView.sd_layout.leftSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
        [self.imgView addGestureRecognizer:tap];
        
        UILabel *adsLab = [[UILabel alloc]init];
        adsLab.text = @"广告";
        adsLab.font = fontSize(13);
        adsLab.textColor = Color(136, 136, 136, 1);
        [self addSubview:adsLab];
        
        [adsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(scaleWithSize(-10));
            make.bottom.mas_equalTo(scaleWithSize(-5));
            make.width.mas_lessThanOrEqualTo(scaleWithSize(100));
        }];
        
    }
    
    return self;
    
}

- (void)setModel:(MXSYJFocusOnModel *)model{
    
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.advertPic] placeholderImage:[UIImage imageNamed:@"adPlace"]];
}

- (void)tapClick{
   
    if (self.imgClick) {
        self.imgClick();
    }
    
}

@end
