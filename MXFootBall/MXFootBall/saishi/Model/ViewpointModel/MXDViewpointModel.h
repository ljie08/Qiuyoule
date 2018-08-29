//
//  MXDViewpointModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDViewpointModel : NSObject


@property (nonatomic , assign) NSInteger ID;//观点id

@property (nonatomic , assign) NSInteger matchId ;//比赛id

@property (nonatomic , copy) NSString * title ;//标题
@property (nonatomic , copy) NSString * reason ;//原因

@property (nonatomic , copy) NSString * createTime ;//发布时间

@property (nonatomic , assign) NSInteger isNotLock ;//是否解锁（0：未解锁，1：已解锁）
@property (nonatomic , assign) NSInteger suportCount ;//支持数

@property (nonatomic , assign) NSInteger userId ;//用户ID
@property (nonatomic , copy) NSString * username ;//用户名
@property (nonatomic , copy) NSString * headerPic ;//头像链接

//观点命中状态（0：不中 1：中）
@property (nonatomic , assign) NSInteger hit ;

@property (nonatomic , copy) NSString * homeNm ;//主队名
@property (nonatomic , copy) NSString * awayNm ;//客队名
@property (nonatomic , copy) NSString * eventNm ;//赛事名
@property (nonatomic , copy) NSString * eventId;

@property (nonatomic , copy) NSString * hitRate ;//命中率

@end
