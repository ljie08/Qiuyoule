//
//  MXDInjuredPlayerModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDInjuredPlayerModel : NSObject


@property (nonatomic , copy) NSString * ID ;//球员id
@property (nonatomic , copy) NSString * name ;//球员名称
@property (nonatomic , copy) NSString * logo ;//球员logo
@property (nonatomic , copy) NSString * position ;//球员位置
@property (nonatomic , copy) NSString * reason ;//伤停原因
@property (nonatomic , assign) NSInteger missedMatches ;//影响场次
@property (nonatomic , copy) NSString * startTime ;//开始时间
@property (nonatomic , copy) NSString * endTime ;//归队时间
@property (nonatomic , assign) NSInteger type ;//伤停情况


@end
