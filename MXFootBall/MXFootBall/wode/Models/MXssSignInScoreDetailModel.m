//
//  MXssSignInScoreDetailModel.m
//  MXFootBall
//
//  Created by Mac on 2018/4/18.
//  Copyright © 2018年 zt. All rights reserved.
//积分明细model

#import "MXssSignInScoreDetailModel.h"

@implementation MXssSignInScoreDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"desc":@"description"
             };
}
@end
