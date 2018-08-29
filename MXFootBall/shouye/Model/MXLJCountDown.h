//
//  MXLJCountDown.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/18.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLJCountDown : NSObject

@property (nonatomic, copy) NSString *day;//天
@property (nonatomic, copy) NSString *hour;//时
@property (nonatomic, copy) NSString *minute;//分
@property (nonatomic, copy) NSString *second;//秒
@property (nonatomic, copy) NSString *millisecond;//毫秒
@property (nonatomic, assign) NSInteger showType;//倒计时显示类型。1为6月14之前，显示蓝色；2为6月14当天，显示黄色；3为比赛开始之后，根据后台返回的图显示。默认为1

//用于判断时间差，便于字符串和num互相转换
@property (nonatomic, assign) NSInteger dayNum;//天
@property (nonatomic, assign) NSInteger hourNum;//时
@property (nonatomic, assign) NSInteger minuteNum;//分
@property (nonatomic, assign) NSInteger secondNum;//秒
@property (nonatomic, assign) NSInteger millisecondNum;//毫秒

@end

@interface MXLJConduct : NSObject

@property (nonatomic, copy) NSString *advertPic;//倒计时背景图
@property (nonatomic, assign) NSInteger showStatus;//倒计时显示状态：1显示；0不显示(以showInfo为准)
@property (nonatomic, copy) NSString *targetUrl;//目标地址

@end

@interface MXLJShowInfo : NSObject

@property (nonatomic, assign) NSInteger showStatus;//倒计时显示状态：1显示；0不显示

@end
