//
//  MXLeagueTitleTableViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXBattleModel.h"

@interface MXLeagueTitleTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel * timeLabel ;//时间

@property (nonatomic,strong) UILabel * leagueLabel ;//联赛

@property (nonatomic, strong) UILabel * homeNameLabel ;//主队名
@property (nonatomic,strong) UILabel * gameLabel ;//比分
@property (nonatomic, strong) UILabel * awayNameLabel ;//客队名

@property (nonatomic,strong) UILabel * resultsLabel ;//赛果
@property (nonatomic,strong) UILabel * resultsContentLabel;//赛果 胜/平/负

@property (nonatomic , strong) MXBattleModel * battleModel ;


@end
