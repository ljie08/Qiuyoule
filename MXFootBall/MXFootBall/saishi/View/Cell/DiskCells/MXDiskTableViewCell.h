//
//  MXDiskTableViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXDiskTableViewCell : UITableViewCell


@property (nonatomic,strong)UILabel * homeTeamL ;//主队标题
@property (nonatomic,strong)UILabel * homeTeamThisSeasonOddsL ;//主队本赛季赔率
@property (nonatomic,strong)UILabel * homeTeamThisSeasonExplanationL ;//主队本赛季赔率解释
@property (nonatomic,strong)UILabel * homeTeamLastSeasonOddsL ;//主队上赛季赔率
@property (nonatomic,strong)UILabel * homeTeamLastSeasonExplanationL ;//主队上赛季赔率解释


@property (nonatomic,strong)UILabel * thisSeasonLabel ;//本赛季
@property (nonatomic,strong)UILabel * lastSeasonLabel ;//上赛季


@property (nonatomic,strong)UILabel * visitingTeamL ;//客队标题
@property (nonatomic,strong)UILabel * visitingTeamThisSeasonOddsL ;//客队本赛季赔率
@property (nonatomic,strong)UILabel * visitingTeamThisSeasonExplanationL ;//客队本赛季赔率解释
@property (nonatomic,strong)UILabel * visitingTeamLastSeasonOddsL ;//客队上赛季赔率
@property (nonatomic,strong)UILabel * visitingTeamLastSeasonExplanationL ;//客队上赛季赔率解释


@end
