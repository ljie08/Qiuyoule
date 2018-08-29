//
//  MXDEventTableVCell.h
//  MXFootBall
//
//  Created by dai on 2018/4/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXDEventModel.h"

typedef void(^EventCollectMatcheBlock)(void); //赛事收藏


@interface MXDEventTableVCell : UITableViewCell

@property (nonatomic , strong) UILabel * titleLabel ;
@property (nonatomic , strong) UILabel * viewsLabel ;//观点

@property (nonatomic , strong) UILabel * oddsLabel ; //赔率

@property (nonatomic , strong) UIButton * selectButton ;//多选按钮

@property (nonatomic , strong) UIView * backView ;//赛事信息背景View


@property (nonatomic , strong) UILabel * matchTime ;//联赛/比赛时间
@property (nonatomic , strong) UILabel * matchStatusLabel ;//比赛状态
@property (nonatomic , strong) UIButton * collectButton ;//收藏按钮
@property (nonatomic , strong) UIView * blackView ;//-
@property (nonatomic , strong) UILabel * timeLabel ; //开赛时间

@property (nonatomic , strong) UILabel * homeNameLabel ;//主队名
@property (nonatomic , strong) UIImageView * homeLogoImgView ;//主队logo
@property (nonatomic , strong) UILabel * homeScore ;//主队比分

@property (nonatomic , strong) UILabel * awayNameLabel ;//客队名
@property (nonatomic , strong) UIImageView * awayLogoImgView ;//客队logo
@property (nonatomic , strong) UILabel * awayScore ;//客队比分


@property (nonatomic , strong) UIImageView * matchStatusImgView ;//比赛状态


@property (nonatomic , strong) EventCollectMatcheBlock eventCollectMatcheBlock ; //赛事收藏

@property (nonatomic , strong) MXDEventModel * eventModel ;

@end
