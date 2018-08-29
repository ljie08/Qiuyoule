//
//  MXDAsiaOddsModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDAsiaOddsModel : NSObject

@property (nonatomic , assign) double homeOdds ;//主胜
@property (nonatomic , copy) NSString * giveBall ;//盘口
@property (nonatomic , assign) double awayOdds ;//客胜

@property (nonatomic , copy) NSString * rtnRt ;//返还率
@property (nonatomic , assign) NSInteger hadpFluct ;//盘口浮动
@property (nonatomic , assign) NSInteger hadpIsClose ;//是否封盘

@property (nonatomic , assign) NSInteger homeFluct ;//主胜浮动
@property (nonatomic , assign) NSInteger awayFluct ;//客胜浮动




@end
