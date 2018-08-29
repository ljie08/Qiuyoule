//
//  MXLineupTableViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXDInjuredPlayerModel.h"

@interface MXLineupTableViewCell : UITableViewCell


@property (nonatomic,strong)UILabel * playerLabel ;//球员
@property (nonatomic,strong)UILabel * positionLabel ;//位置
@property (nonatomic,strong)UILabel * reasonLabel ;//原因
@property (nonatomic,strong)UILabel * frequencyLabel ;//频率


@property (nonatomic , strong) MXDInjuredPlayerModel * injuredModel ;

@end
