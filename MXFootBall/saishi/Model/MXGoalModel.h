//
//  model.h
//  MXFootBall
//
//  Created by YY on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXGoalModel : NSObject

@property (nonatomic,strong)NSMutableArray *mainTeamScoreArr;

@property (nonatomic,strong)NSMutableArray *guestTeamScoreArr;

@property (nonatomic,strong)NSMutableArray *mainTeamScoreRate;

@property (nonatomic,strong)NSMutableArray *guestTeamScoreRate;

@property (nonatomic,strong)NSString *mainTeamTotalMatches;

@property (nonatomic,strong)NSString *guestTeamTotalMatches;
@end
