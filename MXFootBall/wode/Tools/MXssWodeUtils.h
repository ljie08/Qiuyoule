//
//  MXssWodeUtils.h
//  MXFootBall
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXSSToolConfig.h"


@interface MXssWodeUtils : NSObject
/**
 *  缓存用户数据到本地
 *
 *  @param model 用户数据模型
 *
 *  @return 是否缓存成功
 */
+(BOOL)savePersonInfo:(MXSSToolConfig *)model;
/**
 *  获取本地缓存的用户数据
 *
 *  @return 用户数据模型
 */
+(MXSSToolConfig *)loadPersonInfo;

+(BOOL)removePersonInfo;
@end
