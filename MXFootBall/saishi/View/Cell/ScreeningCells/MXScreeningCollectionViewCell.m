//
//  MXScreeningCollectionViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/29.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXScreeningCollectionViewCell.h"

@implementation MXScreeningCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame] ;
    if (self) {
        
//        [self.contentView addSubview:self.backView] ;
        [self.contentView addSubview:self.nameLabel] ;
        [self.contentView addSubview:self.numberLabel] ;
        
        
    }
    return self ;
}

- (UIView *)backView {
    
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:self.contentView.frame] ;
        _backView.layer.cornerRadius = 3 ;
        _backView.layer.masksToBounds = YES ;
    }
    return _backView ;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(10), 0, scaleWithSize(80), scaleWithSize(32))];
        _nameLabel.text = @"澳超" ;
        _nameLabel.font = fontSize(scaleWithSize(12)) ;
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    return _nameLabel ;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scaleWithSize(100), scaleWithSize(32))];
        _numberLabel.textAlignment = 2 ;
        _numberLabel.text = @"2" ;
        _numberLabel.font = fontSize(scaleWithSize(12)) ;
        _numberLabel.backgroundColor = [UIColor clearColor] ;
    }
    return _numberLabel ;
}


- (void)setModel:(MXFilterModel *)model {
    
    _model = model ;
    
    self.nameLabel.text = model.shortNameZh ;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)model.count] ;
    
}

- (void)setAsianPlateModel:(MXAsianPlateScreeningModel *)asianPlateModel {
    _asianPlateModel = asianPlateModel ;
    
    self.nameLabel.text = asianPlateModel.fract ;
    
    self.numberLabel.text = asianPlateModel.countNum ;
    
}


@end






