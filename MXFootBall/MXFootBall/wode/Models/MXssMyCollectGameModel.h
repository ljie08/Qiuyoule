//
//  MXssMyCollectGameModel.h
//  MXFootBall
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
///我的收藏球赛的model

#import <Foundation/Foundation.h>

@interface MXssMyCollectGameModel : NSObject
@property (nonatomic , copy) NSString  *awayNm;//客队名
@property (nonatomic , copy) NSString *awayScore;//客队比分
@property (nonatomic , copy) NSString * eventId;//赛事id
@property (nonatomic , copy) NSString *eventNm;//赛事名
@property (nonatomic , copy) NSString *homeNm;//主队名
@property (nonatomic , copy) NSString * homeScore;//主队比分
@property (nonatomic , copy) NSString *matchId;//比赛id
@property (nonatomic , copy) NSString *matchStartTime;//开赛时间(UnixTime)
@property (nonatomic , copy) NSString *isCollect;//是否收藏
@property (nonatomic , copy) NSString *matchStatus;//规则
@property (nonatomic , copy) NSString *awayLogo;//客队logo的url
@property (nonatomic , copy) NSString *homeLogo;//主队logo的url
@property (nonatomic,assign) NSInteger yesOrNo;//是否选中 0 未选中 1 选中

@property (nonatomic , copy) NSString *collectId;
//@property (nonatomic , copy) NSString *
//@property (nonatomic , copy) NSString *

//@property (nonatomic, copy) NSString *matchStartTime;//开始时间
-(id) initWithDict:(NSDictionary *) dict;
@end
