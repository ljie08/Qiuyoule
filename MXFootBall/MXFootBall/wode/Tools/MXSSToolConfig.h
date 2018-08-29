//
//  MXSSToolConfig.h
//  MXFootBall
//
//  Created by Mac on 2018/3/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define MXSSToolConfigManager [MXSSToolConfig shareManager]

@interface MXSSToolConfig : NSObject

//+ (MXSSToolConfig *) shareManager;

@property (nonatomic,assign) BOOL    IsLogin;

@property (nonatomic,assign) id attentionNum; //关注数
@property (nonatomic,assign) id fansNum;//粉丝数
@property (nonatomic,assign) id articleNum;//发帖数

@property (nonatomic,copy) NSString *levelIcon;//等级图标
@property (nonatomic,copy) NSString *levelName;//等级名称
@property (nonatomic,copy) NSString *restScore;//剩余总积分数
@property (nonatomic, copy) NSString *checkInNumber;//积分数
@property (nonatomic, copy) NSString *username;//用户名
@property (nonatomic, copy) NSString *headerPic;//用户默认头像
@property (nonatomic, copy) NSString *userSign;//用户默认个性签名
@property (nonatomic, copy) NSString *sex;//用户默认性别（3：保密，1：男，2：女）
@property (nonatomic, copy) NSString *level;//用户等级
@property (nonatomic, copy) NSString *token;//用户token

@property (nonatomic, copy) NSString *userId;//用户Id
@property (nonatomic, copy) NSString *signIn;//用户签到状态（1：今日已签到，3：未签到）
@property (nonatomic, copy) NSString *isFirstLogin;//是否第一次登录（0：不是第一次，1：是第一次登录）
@property (nonatomic, copy) NSString *isBindingSocial;//是否绑定了社交账号（0：未绑定，1：已经绑定）                                                                                                        

@property (nonatomic, copy) NSString *telephone;//手机号码

@property (nonatomic, copy) NSString *isBindingQQ;//是否绑定了qq（0：未绑定，1：已经绑定）
@property (nonatomic, copy) NSString *isBindingWechat;//是否绑定了微信（0：未绑定，2：已经绑定）
@property (nonatomic, copy) NSString *totalScore;//总积分
@property (nonatomic, copy)  NSString *messageYesOrNo;//消息中心按钮

@property (nonatomic, copy)  NSString *homeTimeNumber;//判断今天是否提醒过 等级特权弹框
@property (nonatomic, copy)  NSString *IntegralLVNumberID;//判断今天是否提醒过 等级特权弹框
@property (nonatomic, copy)  NSString *JifenRenwuLVNumberID;//判断今天是否提醒过 积分任务弹框
@property (nonatomic, copy)  NSString *JifenRenwuLVNumberIDStr;//判断今天是否提醒过数组存放 积分任务弹框
@property (nonatomic, copy)  NSString *nextMinScore;//下一等级的最低积分线
- (MXSSToolConfig*)initWithDic:(NSDictionary*)dic;

//-(void)clearData;

@end
