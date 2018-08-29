//
//  MXssMyCollectGameModel.m
//  MXFootBall
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
///我的收藏球赛的model

#import "MXssMyCollectGameModel.h"

@implementation MXssMyCollectGameModel
@synthesize awayNm;//客队名
@synthesize awayScore;//客队比分
@synthesize eventId;//赛事id
@synthesize eventNm;//赛事名
@synthesize homeNm;//主队名
@synthesize homeScore;//主队比分
@synthesize matchId;//比赛id
@synthesize matchStartTime;//开赛时间(UnixTime)
@synthesize isCollect;//是否收藏
@synthesize matchStatus;//规则
@synthesize awayLogo;//客队logo的url
@synthesize homeLogo;//主队logo的url
@synthesize yesOrNo;//是否选中 0 未选中 1 选中
@synthesize collectId;
-(id) initWithDict:(NSDictionary *) dict{
    self=[super init];
    if (self) {
        awayNm = [dict objectForKey:@"awayNm"];//客队名
        awayScore = [dict objectForKey:@"awayScore"];//客队比分
        eventId = [dict objectForKey:@"eventId"];//赛事id
        eventNm = [dict objectForKey:@"eventNm"];//赛事名
        homeNm = [dict objectForKey:@"homeNm"];//主队名
        homeScore = [dict objectForKey:@"homeScore"];//主队比分
        matchId = [dict objectForKey:@"matchId"];//比赛id
        matchStartTime = [dict objectForKey:@"matchStartTime"];//开赛时间(UnixTime)
        matchStatus = [dict objectForKey:@"matchStatus"];//规则
        isCollect = [dict objectForKey:@"isCollect"];//是否已收藏（0:未收藏,1:已收藏）
        awayLogo = [dict objectForKey:@"awayLogo"];//客队logo的url
        homeLogo = [dict objectForKey:@"homeLogo"];//主队logo的url
        
        yesOrNo = 0;//是否选中 0 未选中 1 选中
        collectId = [dict objectForKey:@"collectId"];
    }
    return self;
}
@end

