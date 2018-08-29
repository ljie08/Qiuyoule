//
//  MXssMessageModel.m
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//消息中心model

#import "MXssMessageModel.h"

@implementation MXssMessageModel
//@synthesize msgTypeId;//消息类型ID
//@synthesize message;//消息内容
//@synthesize messageType;//消息类型
//@synthesize createTime;//创建时间
//
//-(id) initWithDict:(NSDictionary *) dict{
//    self=[super init];
//    if (self) {
//        msgTypeId = [dict objectForKey:@"msgTypeId"];//消息类型ID
//        message = [dict objectForKey:@"message"];//消息内容
//        messageType = [dict objectForKey:@"messageType"];//消息中心的内容
//        createTime = [dict objectForKey:@"createTime"];//创建时间
//    }
//    return self;
//}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"desc":@"description"
             };
}
@end
