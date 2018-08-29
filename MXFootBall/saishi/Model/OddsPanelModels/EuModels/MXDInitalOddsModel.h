//
//  MXDInitalOddsModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDInitalOddsModel : NSObject

@property (nonatomic , copy) NSString * won ; //胜
@property (nonatomic , copy) NSString * drawn ;//平
@property (nonatomic , copy) NSString * lost ;//负

@property (nonatomic , assign) NSInteger wonFluct ;//胜浮动
@property (nonatomic , assign) NSInteger drawnFluct ;//平浮动
@property (nonatomic , assign) NSInteger lostFluct ;//负浮动

@property (nonatomic , copy) NSString * rtnRt ;//返回率
//凯利 胜平负
@property (nonatomic , copy) NSString * wonKaiLi ;
@property (nonatomic , copy) NSString * drawnKaiLi ;
@property (nonatomic , copy) NSString * lostKaiLi ;
//hadpIsClose;

@end
