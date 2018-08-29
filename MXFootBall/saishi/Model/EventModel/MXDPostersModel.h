//
//  MXDPostersModel.h
//  MXFootBall
//
//  Created by dai on 2018/5/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDPostersModel : NSObject

@property (nonatomic , copy) NSString * posterPic ;//海报图片地址
@property (nonatomic , assign) NSInteger matchId ;//海报对应的比赛ID
@property (nonatomic , copy) NSString * startGameTime ;//海报对应的比赛开赛时间（UnixTime)

@end
