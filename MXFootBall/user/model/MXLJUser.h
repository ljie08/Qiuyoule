//
//  MXLJUser.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLJUser : NSObject<NSCoding>

@property (nonatomic, copy) NSString *username;//用户名
@property (nonatomic, copy) NSString *headerPic;//用户默认头像
@property (nonatomic, copy) NSString *userSign;//用户默认个性签名
@property (nonatomic, copy) NSString *sex;//用户默认性别（3：保密，1：男，2：女）
@property (nonatomic, assign) NSInteger level;//用户等级
@property (nonatomic, copy) NSString *token;//用户token

@property (nonatomic, assign) NSInteger userId;//用户Id
@property (nonatomic, assign) NSInteger signIn;//用户签到状态（1：今日已签到，3：未签到）
@property (nonatomic, assign) NSInteger isFirstLogin;//是否第一次登录（0：不是第一次，1：是第一次登录）
@property (nonatomic, assign) NSInteger isBindingSocial;//是否绑定了社交账号（0：未绑定，1：已经绑定）                                                                                                        

@property (nonatomic, copy) NSString *telephone;//手机号码
@property (nonatomic, copy) NSString *isBindingQQ;//是否绑定了qq（0：未绑定，1：已经绑定）
@property (nonatomic, copy) NSString *isBindingWechat;//是否绑定了微信（0：未绑定，2：已经绑定）
@property (nonatomic, copy) NSString *totalScore;//总积分
@property (nonatomic, copy) NSString *restScore;//剩余总积分数
@end
