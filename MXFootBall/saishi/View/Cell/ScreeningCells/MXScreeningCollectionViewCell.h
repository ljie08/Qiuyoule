//
//  MXScreeningCollectionViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/29.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXFilterModel.h"

#import "MXAsianPlateScreeningModel.h"

@interface MXScreeningCollectionViewCell : UICollectionViewCell


@property (nonatomic ,strong) UIView * backView ;

@property (nonatomic ,strong) UILabel * nameLabel ;

@property (nonatomic ,strong) UILabel * numberLabel ;


@property (nonatomic ,strong) MXFilterModel * model ;


@property (nonatomic ,strong) MXAsianPlateScreeningModel * asianPlateModel ;

@end
