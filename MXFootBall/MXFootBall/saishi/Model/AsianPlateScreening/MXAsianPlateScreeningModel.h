//
//  MXAsianPlateScreeningModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXAsianPlateScreeningModel : NSObject

//@property (nonatomic, copy) NSString * key ;
//
//@property (nonatomic, copy) NSString * value ;

@property (nonatomic, assign) NSInteger isSelect ;


@property (nonatomic, copy) NSString * countNum ;//赛事统计数
@property (nonatomic, copy) NSString * fract ;//展示用的盘口数据
@property (nonatomic, copy) NSString * odd ;//真实盘口（用于109号接口的检索）


@end
