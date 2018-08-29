//
//  MXHomeSaishi.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/4/25.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXHomeSaishi : NSObject

@property (nonatomic, assign) NSInteger matchId;//比赛id
@property (nonatomic, assign) NSInteger eventId;//赛事id
@property (nonatomic, copy) NSString *eventNm;//赛事名
@property (nonatomic, copy) NSString *matchStartTime;//开赛时间(UnixTime)
@property (nonatomic, copy) NSString *homeNm;//主队名
@property (nonatomic, assign) NSInteger homeScore;//主队比分
@property (nonatomic, copy) NSString *homeLogo;//主队logo
@property (nonatomic, copy) NSString *awayNm;//客队名
@property (nonatomic, assign) NSInteger awayScore;//客队比分
@property (nonatomic, copy) NSString *awayLogo;//客队logo
@property (nonatomic, assign) NSInteger matchStatus;//比赛状态
@property (nonatomic, copy) NSString *reason;//推荐理由
@property (nonatomic, copy) NSString *flashFlg;//是否有动画（0：无  1：有）

@end
