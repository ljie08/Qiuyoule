//
//  MXSYJCelebrityCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJHallModel.h"

@interface MXSYJCelebrityCell : UITableViewCell

@property (nonatomic, strong) UILabel *numLab;
@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, strong) HitTable *model;


@end
