//
//  MXSSToolConfig.m
//  MXFootBall
//
//  Created by Mac on 2018/3/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSToolConfig.h"
//static MXSSToolConfig *_manager = nil;


@interface MXSSToolConfig ()<NSCoding>

@end

@implementation MXSSToolConfig

@synthesize IsLogin;
- (instancetype)init{
    if (self = [super init]) {
        self.username = @"";//用户名
        self.headerPic= @"";//用户默认头像
        self.userSign= @"";//用户默认个性签名
        self.sex= @"";//用户默认性别（3：保密，1：男，2：女）
        self.level= @"";//用户等级
        self.token= @"";//用户token
        self.userId= @"0";//用户Id
        self.signIn= @"";//用户签到状态（1：今日已签到，3：未签到）
        self.isFirstLogin= @"";//是否第一次登录（0：不是第一次，1：是第一次登录）
        self.isBindingSocial= @"";//是否第一次登录（0：不是第一次，1：是第一次登录）
        self.restScore = @"";//剩余积分数
        self.articleNum = 0;//发帖数
        self.attentionNum = 0;//粉丝数
        self.fansNum = 0;//粉丝数
        self.level = 0;//等级
        self.levelIcon = @"";//等级图
        self.levelName = @"";//等级名称
        
        self.checkInNumber = @"0";//积分数
        self.telephone = @"";//手机号码
        
        self.isBindingQQ = @"";//是否绑定了qq（0：未绑定，1：已经绑定）
        self.isBindingWechat = @"";//是否绑定了微信（0：未绑定，2：已经绑定）
        self.totalScore = @"";//总积分
        self.messageYesOrNo = @"";//消息中心按钮
        self.homeTimeNumber = @"";//判断今天是否提醒过 等级特权弹框
        self.IntegralLVNumberID = @"0";//判断今天是否提醒过 等级特权弹框
        self.JifenRenwuLVNumberID = @"1";//判断今天是否提醒过 积分任务弹
        self.nextMinScore = @"";//下一等级的最低积分线
        self.JifenRenwuLVNumberIDStr=@"1";
    }
    return self;
}
//+ (MXSSToolConfig *)shareManager {
//    static MXSSToolConfig *__singletion;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        __singletion=[[self alloc] init];
//    });
//    return __singletion;
//}
//-(void)clearData{
////    self.userName =  nil;
//}
- (instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [self init]) {
        NSDictionary *data = dic[@"data"];
       
        self.username = data[@"username"];//用户名
        self.headerPic= data[@"headerPic"];//用户默认头像
        self.userSign= data[@"userSign"];//用户默认个性签名
        self.sex= data[@"sex"];//用户默认性别（3：保密，1：男，2：女）
        self.level = data[@"level"];//用户等级
        self.token= data[@"token"];//用户token
        self.userId = data[@"userId"];//用户Id
        self.signIn = data[@"signIn"];//用户签到状态（1：今日已签到，3：未签到）
        self.isFirstLogin = data[@"isFirstLogin"];//是否第一次登录（0：不是第一次，1：是第一次登录）
        self.isBindingSocial = data[@"isBindingSocial"];//是否第一次登录（0：不是第一次，1：是第一次登录）
        self.restScore = data[@"restScore"];//剩余积分数
        self.articleNum = data[@"articleNum"];//发帖数
        self.attentionNum = data[@"attentionNum"];//粉丝数
        self.fansNum = data[@"fansNum"];//粉丝数
        self.level = data[@"level"];//等级
        self.levelIcon = data[@"levelIcon"];//等级图
        self.levelName = data[@"levelName"];//等级名称
        
        self.checkInNumber = data[@"checkInNumber"];//积分数
        
        self.telephone =  data[@"telephone"];//手机号码
        self.isBindingQQ = data[@"isBindingQQ"];//是否绑定了qq（0：未绑定，1：已经绑定）
        self.isBindingWechat = data[@"isBindingWechat"];//是否绑定了微信（0：未绑定，2：已经绑定）
        self.totalScore = data[@"totalScore"];//总积分
        self.messageYesOrNo = data[@"messageYesOrNo"];//消息中心按钮
        self.homeTimeNumber = data[@"homeTimeNumber"];//判断今天是否提醒过 等级特权弹框
        self.IntegralLVNumberID = data[@"IntegralLVNumberID"];//判断今天是否提醒过 等级特权弹框
        self.JifenRenwuLVNumberID = data[@"JifenRenwuLVNumberID"];//判断今天是否提醒过 积分任务弹
         self.nextMinScore = data[@"nextMinScore"];//下一等级的最低积分线
        self.JifenRenwuLVNumberIDStr=data[@"JifenRenwuLVNumberIDStr"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
     [aCoder encodeObject:self.username forKey:@"username"];//用户名
     [aCoder encodeObject:self.headerPic forKey:@"headerPic"];//用户默认头像
     [aCoder encodeObject:self.userSign forKey:@"userSign"];//用户默认个性签名
     [aCoder encodeObject:self.sex forKey:@"sex"];////用户默认性别（3：保密，1：男，2：女）
    
    [aCoder encodeObject:self.level forKey:@"level"];//用户等级
     [aCoder encodeObject:self.token forKey:@"token"];//用户token
     [aCoder encodeObject:self.userId forKey:@"userId"];//用户Id
     [aCoder encodeObject:self.signIn forKey:@"signIn"];//用户签到状态（1：今日已签到，3：未签到）
     [aCoder encodeObject:self.isFirstLogin forKey:@"isFirstLogin"];//是否第一次登录（0：不是第一次，1：是第一次登录）
     [aCoder encodeObject:self.isBindingSocial forKey:@"isBindingSocial"];//是否第一次登录（0：不是第一次，1：是第一次登录）
    [aCoder encodeObject:self.restScore forKey:@"restScore"];//剩余积分数
    [aCoder encodeObject:self.articleNum forKey:@"articleNum"];//发帖数
    [aCoder encodeObject: self.attentionNum forKey: @"attentionNum"]; //关注数
    [aCoder encodeObject:self.fansNum forKey:@"fansNum"];//粉丝数
    [aCoder encodeObject:self.level forKey:@"level"];//等级
    [aCoder encodeObject:self.levelIcon forKey:@"levelIcon"];//等级图
    [aCoder encodeObject:self.levelName forKey:@"levelName"];////等级名称
    
    [aCoder encodeObject:self.checkInNumber forKey:@"checkInNumber"];//积分数
    
    [aCoder encodeObject:self.telephone forKey:@"telephone"];//手机号码
    [aCoder encodeObject:self.isBindingQQ forKey:@"isBindingQQ"];//是否绑定了qq（0：未绑定，1：已经绑定）
    [aCoder encodeObject:self.isBindingWechat forKey:@"isBindingWechat"];//是否绑定了微信（0：未绑定，2：已经绑定）
    [aCoder encodeObject:self.totalScore forKey:@"totalScore"];//总积分
    [aCoder encodeObject:self.messageYesOrNo forKey:@"messageYesOrNo"];//消息中心按钮
    [aCoder encodeObject:self.homeTimeNumber forKey:@"homeTimeNumber"];//判断今天是否提醒过 等级特权弹框
    [aCoder encodeObject:self.IntegralLVNumberID forKey:@"IntegralLVNumberID"];//判断今天是否提醒过 等级特权弹框
    [aCoder encodeObject:self.JifenRenwuLVNumberID forKey: @"JifenRenwuLVNumberID"];//判断今天是否提醒过 积分任务弹
      [aCoder encodeObject:self.nextMinScore forKey:@"nextMinScore"];//下一等级的最低积分线
   [aCoder encodeObject:self.JifenRenwuLVNumberIDStr forKey:@"JifenRenwuLVNumberIDStr"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        
        self.username = [aDecoder decodeObjectForKey:@"username"];//用户名
        self.headerPic= [aDecoder decodeObjectForKey:@"headerPic"];//用户默认头像
        self.userSign= [aDecoder decodeObjectForKey:@"userSign"];//用户默认个性签名
        self.sex= [aDecoder decodeObjectForKey:@"sex"];//用户默认性别（3：保密，1：男，2：女）
        self.level= [aDecoder decodeObjectForKey:@"level"];//用户等级
        self.token= [aDecoder decodeObjectForKey:@"token"];//用户token
        self.userId= [aDecoder decodeObjectForKey:@"userId"];//用户Id
        self.signIn= [aDecoder decodeObjectForKey:@"signIn"];//用户签到状态（1：今日已签到，3：未签到）
        self.isFirstLogin= [aDecoder decodeObjectForKey:@"isFirstLogin"];//是否第一次登录（0：不是第一次，1：是第一次登录）
        self.isBindingSocial= [aDecoder decodeObjectForKey:@"isBindingSocial"];//是否第一次登录（0：不是第一次，1：是第一次登录）
        self.restScore = [aDecoder decodeObjectForKey:@"restScore"];//剩余积分数
        self.articleNum = [aDecoder decodeObjectForKey:@"articleNum"];//发帖数
        self.attentionNum = [aDecoder decodeObjectForKey:@"attentionNum"]; //关注数
        self.fansNum = [aDecoder decodeObjectForKey:@"fansNum"];//粉丝数
        self.level = [aDecoder decodeObjectForKey:@"level"];//等级
        self.levelIcon = [aDecoder decodeObjectForKey:@"levelIcon"];  //等级图
        self.levelName = [aDecoder decodeObjectForKey:@"levelName"];//等级名称
        
        self.checkInNumber = [aDecoder decodeObjectForKey:@"checkInNumber"];//积分数
        
        self.telephone =  [aDecoder decodeObjectForKey:@"telephone"];//手机号码
        self.isBindingQQ = [aDecoder decodeObjectForKey:@"isBindingQQ"];//是否绑定了qq（0：未绑定，1：已经绑定）
        self.isBindingWechat = [aDecoder decodeObjectForKey:@"isBindingWechat"];//是否绑定了微信（0：未绑定，2：已经绑定）
        self.totalScore = [aDecoder decodeObjectForKey:@"totalScore"];//总积分
        self.messageYesOrNo= [aDecoder decodeObjectForKey:@"messageYesOrNo"];//消息中心按钮
        self.homeTimeNumber = [aDecoder decodeObjectForKey:@"homeTimeNumber"];;//判断今天是否提醒过 等级特权弹框
        self.IntegralLVNumberID = [aDecoder decodeObjectForKey:@"IntegralLVNumberID"];//判断今天是否提醒过 等级特权弹框
        self.JifenRenwuLVNumberID =  [aDecoder decodeObjectForKey:@"JifenRenwuLVNumberID"];//判断今天是否提醒过 积分任务弹
         self.nextMinScore = [aDecoder decodeObjectForKey:@"nextMinScore"];//下一等级的最低积分线
        self.JifenRenwuLVNumberIDStr=[aDecoder decodeObjectForKey:@"JifenRenwuLVNumberIDStr"];
    }
    return self;
}
@end
