//
//  MXSYJTopCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/2.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJIsTopModel.h"

@interface MXSYJTopCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIImageView *isNew;

@property (nonatomic, strong) MXSYJIsTopModel *model;

@end
