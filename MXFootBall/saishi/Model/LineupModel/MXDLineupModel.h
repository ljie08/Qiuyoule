//
//  MXDLineupModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXDInjuredPlayerModel.h" //伤员

#import "MXDSoccerPlayerModel.h" //球员

@interface MXDLineupModel : NSObject

//球员
@property (nonatomic , strong) NSArray * homeList ;//主
@property (nonatomic , strong) NSArray * awayList ;//客
//伤员
@property (nonatomic , strong) NSArray * homeInjuryList ;
@property (nonatomic , strong) NSArray * awayInjuryList ;


@end
