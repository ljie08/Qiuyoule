//
//  MXAdvert.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/6/22.
//  Copyright © 2018年 zt. All rights reserved.
//

//广告
#import <Foundation/Foundation.h>

@interface MXAdvert : NSObject

@property (nonatomic, assign) NSInteger interactFlg;// 是否需要交互（0：不需要，1：需要）
@property (nonatomic, assign) NSInteger showStatus;// 是否开启
@property (nonatomic, copy) NSString *targetUrl;// 活动地址（H5交互用）
@property (nonatomic, copy) NSString *advertPic;// 广告地址（外部广告用）
@property (nonatomic, assign) NSInteger showIndex;//  广告展示下标
@property (nonatomic, assign) NSInteger showIndexCopy;// 广告展示下标（副本）
@property (nonatomic, assign) NSInteger advertId;// 广告id

@end
