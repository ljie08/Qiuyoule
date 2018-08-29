//
//  MXLJThirdData.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/4/10.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLJThirdData : NSObject<NSCoding>

@property (nonatomic, copy) NSString *openid;//
@property (nonatomic, copy) NSString *nickname;//用户名
@property (nonatomic, copy) NSString *sex;//性别
@property (nonatomic, copy) NSString *headimgurl;//用户头像
@property (nonatomic, assign) NSInteger userType;//用户类型（2：微信用户胡。3：qq用户）

@end
