//
//  MXLJLogin.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLJLogin : NSObject

@property (nonatomic, copy) NSString *registerPhoneNum;//注册手机号
@property (nonatomic, copy) NSString *registerPasswd1;//输入密码
@property (nonatomic, copy) NSString *registerPasswd2;//再次输入密码

@property (nonatomic, copy) NSString *code;//验证码

@end
