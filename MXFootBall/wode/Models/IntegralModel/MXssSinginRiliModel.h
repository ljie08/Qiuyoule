//
//  MXssSinginRiliModel.h
//  MXFootBall
//
//  Created by Mac on 2018/4/24.
//  Copyright © 2018年 zt. All rights reserved.
//日历返回model

#import <Foundation/Foundation.h>

@interface MXssSinginRiliModel : NSObject
//@property (nonatomic,copy) NSString *createTime;//时间显示

@property (nonatomic,strong) NSArray *signDays;
//@property (nonatomic,copy) NSString *headerPic;//头像
//@property (nonatomic,copy) NSString *restScore;//剩余积分

@property (nonatomic,copy) NSString *signDone;//当天是否签到（0：未签到 1：已签到）
@property (nonatomic,copy) NSString *signRule;//签到规则
//@property (nonatomic,copy) NSString *totalScore;//总积分
//@property (nonatomic,copy) NSString *username;//昵称
//@property (nonatomic,copy) NSString *scoreUrl;

-(id) initWithDict:(NSDictionary *) dict;
@end
