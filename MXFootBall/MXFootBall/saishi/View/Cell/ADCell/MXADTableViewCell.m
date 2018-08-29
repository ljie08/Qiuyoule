//
//  MXADTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/5/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXADTableViewCell.h"

@implementation MXADTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.ADPicImgView] ;
        [self.contentView addSubview:self.ADLabel] ;
    }
    
    return self ;
}

- (UIImageView *)ADPicImgView {
    
    if (!_ADPicImgView) {
        _ADPicImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_width * 5 / 32)] ;
    }
    return _ADPicImgView ;
}
- (UILabel *)ADLabel {
    
    if (!_ADLabel) {
        _ADLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ADPicImgView.frame) - scaleWithSize(30), screen_width - scaleWithSize(15), scaleWithSize(30))] ;
        _ADLabel.text = @"广告";
        _ADLabel.textAlignment = 2 ;
        _ADLabel.textColor = kColorWithRGBF(0x888888) ;
        _ADLabel.font = fontSize(scaleWithSize(13)) ;
    }
    return _ADLabel ;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
