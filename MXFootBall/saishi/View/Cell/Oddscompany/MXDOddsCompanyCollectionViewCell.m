//
//  MXDOddsCompanyCollectionViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/5/2.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXDOddsCompanyCollectionViewCell.h"

@implementation MXDOddsCompanyCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.titleNameLabel] ;
    }
    return self ;
}

- (UILabel *)titleNameLabel {
    
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scaleWithSize(100), scaleWithSize(32))] ;
        _titleNameLabel.layer.masksToBounds = YES ;
        _titleNameLabel.layer.cornerRadius = 3 ;
        _titleNameLabel.textAlignment = 1 ;
        _titleNameLabel.font = fontSize(scaleWithSize(13)) ;
    }
    return _titleNameLabel ;
}



@end
