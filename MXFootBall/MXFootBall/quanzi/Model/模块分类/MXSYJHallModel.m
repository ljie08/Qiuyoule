//
//  MXSYJHallModel.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/24.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJHallModel.h"

@implementation Illustrates

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"desc":@"description"
             };
}

@end
@implementation HitTable

@end

@implementation MXSYJHallModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"illustrates" : @"Illustrates",
             @"hitTable":@"HitTable"
             };
}

@end
