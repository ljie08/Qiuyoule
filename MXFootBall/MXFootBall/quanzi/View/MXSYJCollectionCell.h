//
//  MXSYJCollectionCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJChannelModel.h"

@interface MXSYJCollectionCell : UICollectionViewCell

/** 名人堂头像 */
@property (nonatomic, strong) UIImageView *imgView;
/** 名人堂名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 名人堂描述 */
@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, strong) MXSYJChannelModel *model;

@end
