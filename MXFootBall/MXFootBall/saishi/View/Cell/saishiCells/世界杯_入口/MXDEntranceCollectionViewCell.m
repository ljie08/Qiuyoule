//
//  MXDEntranceCollectionViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/5/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXDEntranceCollectionViewCell.h"

@implementation MXDEntranceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imgView] ;
        [self.contentView addSubview:self.titleLabel] ;
    }
    return self ;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, scaleWithSize(10), scaleWithSize(55), scaleWithSize(55))] ;
    }
    return _imgView ;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imgView.frame), scaleWithSize(55), scaleWithSize(30))] ;
        _titleLabel.textAlignment = 1 ;
        _titleLabel.font = fontSize(scaleWithSize(11)) ;
        _titleLabel.textColor = mx_FontLightGreyColor ;
    }
    return _titleLabel ;
}


@end
