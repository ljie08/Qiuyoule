//
//  MXDAdvertsModel.h
//  MXFootBall
//
//  Created by dai on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDAdvertsModel : NSObject

@property (nonatomic , copy) NSString * advertPic ;//广告图片地址

@property (nonatomic , copy) NSString * targetUrl ;//广告跳转目标地址

@property (nonatomic , assign) NSInteger advertId ;//广告id

@property (nonatomic , assign) NSInteger interactFlg ;//是否为交互类型（0：否 1：是）


@end
