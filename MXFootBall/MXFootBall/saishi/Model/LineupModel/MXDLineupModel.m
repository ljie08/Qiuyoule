//
//  MXDLineupModel.m
//  MXFootBall
//
//  Created by dai on 2018/4/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXDLineupModel.h"



@implementation MXDLineupModel


+ (NSDictionary *)mj_objectClassInArray {
    
    return @{
             @"homeList" :@"MXDSoccerPlayerModel",
             @"awayList" :@"MXDSoccerPlayerModel",
             
             @"homeInjuryList" :@"MXDInjuredPlayerModel",
             @"awayInjuryList" :@"MXDInjuredPlayerModel"
             
             };
}


@end
