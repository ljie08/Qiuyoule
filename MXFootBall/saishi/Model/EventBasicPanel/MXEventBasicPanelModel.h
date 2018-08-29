//
//  MXEventBasicPanelModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXEventVSModel.h"

@interface MXEventBasicPanelModel : NSObject

@property (nonatomic , assign) NSInteger eventId ;//赛事id
@property (nonatomic , copy) NSString * eventNm ;//赛事名

@property (nonatomic , assign) NSInteger awayId ;//客队ID
@property (nonatomic , copy) NSString * awayLogo ;//客队logo URL
@property (nonatomic , copy) NSString * awayNm ;//客队名
@property (nonatomic , assign) NSInteger awayScore ;//客队得分
@property (nonatomic , strong) MXEventVSModel * awayVs ;//客队战绩

@property (nonatomic , assign) NSInteger homeId ;
@property (nonatomic , copy) NSString * homeLogo ;
@property (nonatomic , copy) NSString * homeNm ;
@property (nonatomic , assign) NSInteger homeScore ;
@property (nonatomic , strong) MXEventVSModel * homeVs ;

@property (nonatomic , assign) NSInteger matchId ;//比赛ID
@property (nonatomic , copy) NSString * matchStartTime ;//比赛时间
@property (nonatomic , assign) NSInteger matchStatus ;//比赛状态
@property (nonatomic , strong) MXEventVSModel * vs ;//主客队历史交战

@property (nonatomic , strong) NSArray * score;//赛前积分排名


@property (nonatomic , assign) NSInteger flashFlg ;//是否有动画（0：无  1：有）

@property (nonatomic , assign) NSInteger bulletCsmScore ;//发弹幕需消耗的积分值

@property (nonatomic , assign) NSInteger bulletMinLv ;//发弹幕需要等级
@property (nonatomic , assign) NSInteger chatMinLv ;//聊天需要等级

@end
