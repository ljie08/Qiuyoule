//
//  MXSuccessData.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLJSuccessData : NSObject

@property (nonatomic, copy) NSString *code;//操作返回码
@property (nonatomic, copy) NSString *msg;//信息
@property (nonatomic, assign) id data;//数据

@end
