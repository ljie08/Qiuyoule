//
//  MXBattleModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXBattleModel : NSObject


@property (nonatomic , assign) NSInteger awayId ;
@property (nonatomic , copy) NSString * awayNm ;
@property (nonatomic , assign) NSInteger awayScore ;

@property (nonatomic , assign) NSInteger eventId ;
@property (nonatomic , copy) NSString * eventNm ;

@property (nonatomic , assign) NSInteger homeId ;
@property (nonatomic , copy) NSString * homeNm ;
@property (nonatomic , assign) NSInteger homeScore ;

@property (nonatomic , assign) NSInteger matchId ;
@property (nonatomic , assign) NSInteger matchRst ;

@property (nonatomic , copy) NSString * matchStartTime ;




@end
