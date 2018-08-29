//
//  MXWorldCupModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/11.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXWorldCupModel : NSObject

@property (nonatomic, assign) NSInteger  matchId ;//比赛id

@property (nonatomic, copy) NSString * homeTeam ;//主队

@property (nonatomic , copy) NSString * homeLogo ;

@property (nonatomic, copy) NSString * awayTeam ;//客队

@property (nonatomic , copy) NSString * awayLogo ;

@property (nonatomic, copy) NSString * matchTime ;//比赛时间

@property (nonatomic, copy) NSString * groupType ;//组别



//@property (nonatomic , copy) NSString * homeScore ;
//@property (nonatomic , copy) NSString * awayScore ;
//@property (nonatomic , assign) NSInteger matchStatus ;
//@property (nonatomic , assign) NSInteger flashFlg ;



@end
