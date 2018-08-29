//
//  MXLJBanner.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//


//banner
#import <Foundation/Foundation.h>

@interface MXLJBanner : NSObject

@property (nonatomic, copy) NSString *bannerPic;//banner图片
@property (nonatomic, copy) NSString *title;//banner标题
@property (nonatomic, copy) NSString *targetUrl;//目标跳转地址（外部链接H5）
@property (nonatomic, copy) NSString *content;//banner展示内容（内部平台跳转）
@property (nonatomic, assign) NSInteger advertId;//广告id
@property (nonatomic, assign) NSInteger interactFlg;//

@end
