//
//  MXDBsOddsModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/24.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDBsOddsModel : NSObject


@property (nonatomic , assign) double  bigOdds ;//大球赔率
@property (nonatomic , copy) NSString * ball ;//盘口
@property (nonatomic , assign) double  smallOdds ;//小球赔率

@property (nonatomic , copy) NSString * rtnRt ; //返还率

@property (nonatomic , copy) NSString * bigFluct ;//盘口浮动
@property (nonatomic , copy) NSString * hadpFluct ;//盘口浮动
@property (nonatomic , copy) NSString * smallFluct ;//盘口浮动

@property (nonatomic , assign) NSInteger hadpIsClose ;//是否封盘




@end
