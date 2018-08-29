//
//  MXssSinginRiliModel.m
//  MXFootBall
//
//  Created by Mac on 2018/4/24.
//  Copyright © 2018年 zt. All rights reserved.
//日历返回model

#import "MXssSinginRiliModel.h"

@implementation MXssSinginRiliModel
//@synthesize createTime;//时间显示

@synthesize signDays;
//@synthesize headerPic;//头像
//@synthesize restScore;//剩余积分

@synthesize signDone;
@synthesize signRule;
//@synthesize totalScore;//总积分
//@synthesize username;//昵称
//@synthesize scoreUrl;
-(id) initWithDict:(NSDictionary *) dict{
    self=[super init];
    if (self) {
//        createTime = [dict objectForKey:@"createTime"];//时间显示
        signDays = [dict objectForKey:@"signDays"];//时间数组
//        headerPic = [dict objectForKey:@"headerPic"];//头像
//        restScore = [dict objectForKey:@"restScore"];//剩余积分
        signDone = [dict objectForKey:@"signDone"];//
        signRule = [dict objectForKey:@"signRule"];//
//        totalScore = [dict objectForKey:@"totalScore"];//总积分
//        username = [dict objectForKey:@"username"];//昵称
    }
    return self;
}
//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    
//    return @{
//             @"desc":@"description"
//             };
//}
@end
