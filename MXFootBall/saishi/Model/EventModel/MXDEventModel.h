//
//  MXDEventModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/10.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXDTeamInfoModel.h"
#import "MXDEventOddsModel.h"



@interface MXDEventModel : NSObject


//@property (nonatomic , assign) NSInteger  eventId ;//赛事id
//@property (nonatomic , assign) NSInteger  matchId ;//比赛id
//@property (nonatomic , assign) int matchStatus ;//比赛状态
//@property (nonatomic , copy) NSString * odds ;//盘口数据
//@property (nonatomic , strong) NSArray * ComInfoSeason ;//比赛信息
//@property (nonatomic , copy) NSString * TeeTime ;//开球时间
//@property (nonatomic , copy) NSString * matchTime ;//比赛时间
//@property (nonatomic , strong) MXDTeamInfoModel * homeTeam ;//主队信息
//@property (nonatomic , strong) MXDTeamInfoModel * visitingTeam ;//客队信息
//@property (nonatomic , strong) MXDTeamInfoModel * event ;//赛事

//@property (nonatomic , strong) NSArray * homeTeamData ;//主队比分
//@property (nonatomic , strong) NSArray * visitingTeamData ;//客队比分
//@property (nonatomic , assign) NSInteger flashFlg ;//是否有动画（0：无  1：有）

@property (nonatomic , copy) NSString * advertPic ;//广告图片地址
@property (nonatomic , copy) NSString * targetUrl ;//广告跳转目标地址
@property (nonatomic , copy) NSString * advertId ; //广告id



@property (nonatomic, assign) NSInteger isCollect ; //收藏falg

@property (nonatomic , assign) NSInteger eventId ;//赛事ID
@property (nonatomic , copy) NSString * eventName ;//赛事全称
@property (nonatomic , copy) NSString * eventShortName ;//赛事别名（简称）
@property (nonatomic , assign) NSInteger flashFlg ;//动画flg（0：没有动画，1：有动画）
@property (nonatomic , copy) NSString * homeTeamLogo ;//主队名
@property (nonatomic , copy) NSString * homeTeamName ;//主队logo
@property (nonatomic , assign) NSInteger homeTeamScore ;//主队得分
@property (nonatomic , assign) NSInteger matchId ;//比赛ID
@property (nonatomic , assign) NSInteger matchStatus ;//赛事状态Id
@property (nonatomic , copy) NSString * startBallTime ;//开球时间
@property (nonatomic , copy) NSString * startGameTime ;//开赛时间
@property (nonatomic , copy) NSString * statusName ;//赛事状态描述
@property (nonatomic , copy) NSString * visitTeamLogo ;//客队名
@property (nonatomic , copy) NSString * visitTeamName ;//客队logo
@property (nonatomic , assign) NSInteger visitTeamScore ;//客队比分


@end



