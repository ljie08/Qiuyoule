//
//  MXSYJSaisiModel.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXSYJSaisiModel : NSObject

@property (nonatomic, copy) NSString *ID;//比赛id
//@property (nonatomic, copy) NSString *matchId;
@property (nonatomic, copy) NSString *title;
//@property (nonatomic, copy) NSString *reason;
//@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *createTime;
//@property (nonatomic, copy) NSString *support;
//@property (nonatomic, copy) NSString *username;
//@property (nonatomic, copy) NSString *headerPic;


@property (nonatomic , copy) NSString  *reason;//推荐理由
@property (nonatomic ,  copy) NSString *hit;//命中状态（0：未命中 1：命中 ）
@property (nonatomic , copy) NSString * viewId;//观点id
@property (nonatomic , copy) NSString *headerPic;//用户头像（发观点者）
@property (nonatomic ,  copy) NSString *homeNm;//主队名
@property (nonatomic , copy) NSString * isNotLock;//解锁状态（0：未解锁 1：已解锁，[观点]列表都为已解锁）
@property (nonatomic , copy) NSString *userId;//用户id（发观点者）
@property (nonatomic , copy) NSString *awayNm;//客队名
@property (nonatomic,copy) NSString *suportCount;//观点支持数
@property (nonatomic,copy) NSString *hitRate;//用户命中率（发观点者）
@property (nonatomic,copy) NSString *username;//用户名（发观点者）

@end
