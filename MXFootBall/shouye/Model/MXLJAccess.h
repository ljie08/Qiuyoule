//
//  MXLJAccess.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//


//快速通道
#import <Foundation/Foundation.h>

@interface MXLJAccess : NSObject

@property (nonatomic, assign) NSInteger accessId;//1:即时赛事，2：官方发布，3：名人堂，4：个人收藏
@property (nonatomic, copy) NSString *imgUrl;//通道LOGO
@property (nonatomic, copy) NSString *nameZh;//通道名称

@end
