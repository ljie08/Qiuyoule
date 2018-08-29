//
//  MXTeamTitleTableViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXDScoreModel.h"

@interface MXTeamTitleTableViewCell : UITableViewCell


@property (nonatomic,strong) UILabel * rankLabel ;//排名

@property (nonatomic,strong) UILabel * teamLabel ;//球队

@property (nonatomic,strong) UILabel * winFlatNegativeLabel ;//胜/平/负

@property (nonatomic,strong) UILabel * inOutLabel ;//进/失

@property (nonatomic,strong) UILabel * integralLabel ;//积分

@property (nonatomic , strong) MXDScoreModel * scoreModel ;



@end
