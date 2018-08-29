//
//  MXFilterModel.m
//  MXFootBall
//
//  Created by dai on 2018/4/12.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXFilterModel.h"

@implementation MXFilterModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"ID":@"eventId",
             @"shortNameZh":@"eventShortName",
             @"count":@"eventNum",
             };
}

@end
