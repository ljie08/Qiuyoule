//
//  MXLJJudgeVM.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLJJudgeVM : NSObject

@property (nonatomic, strong) MXLJLogin *login;//注册手机号、密码等
@property (nonatomic, strong) MXLJUser *user;//用户信息

@property (nonatomic, assign) BOOL isShowScore;//是否显示积分

@property (nonatomic, assign) NSInteger hasTel;//是否为注册手机号（1：是，0：不是）

@property (nonatomic, strong) MXProtocol *protocol;//协议

/**
 判断注册是否填写完整

 @param isSelected 是否阅读并同意协议
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isRegisterCompleteWithTextAndButtonIsSelected:(BOOL)isSelected success:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure;

/**
 判断登录是否填写完整
 
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isLoginCompleteWithTextWithSuccess:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure;

/**
 判断忘记密码是否填写完整
 
 //type已弃用，忘记和重置合并了一个界面
 @param type 1，忘记；2，重置
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isForgetWithType:(NSInteger)type success:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure;

/**
 判断手机号是否被绑定

 @param phone 手机号
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)checkPhoneBindWithPhoneNum:(NSString *)phone success:(void (^)(NSString *msg, NSString *code))success failture:(void(^)(NSString *error))failture;

/**
 获取验证码

 @param phoneNum 手机号
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getCodeWithPhoneNum:(NSString *)phoneNum success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture;

/**
 注册
 
 @param phoneNum 手机号
 @param code 验证码
 @param passwd 密码
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)registerWithPhoneNum:(NSString *)phoneNum code:(NSString *)code passwd:(NSString *)passwd success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture;

/**
 注册协议

 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)protocolWithSuccess:(void (^)(BOOL isCorrect))success failture:(void(^)(NSString *error))failture;

/**
 登录

 @param phoneNum 手机号
 @param passwd 密码
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)loginWithPhoneNum:(NSString *)phoneNum passwd:(NSString *)passwd success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture;

/**
 第三方登录

 @param openId qq或者微信的唯一标识
 @param userName 用户社交账号的名称
 @param headerPic 社交账号头像地址
 @param userType 用户类型（1：平台注册、2：微信登录、3：qq登录）
 @param sex 用户性别（男、女、未知）                                                                                                                                                    
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)thirdLoginWithOpenid:(NSString *)openId userName:(NSString *)userName headerPic:(NSString *)headerPic userType:(NSInteger)userType sex:(NSString *)sex success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture;

/**
 绑定手机号

 @param phone 手机号
 @param code 验证码
 @param userName 第三方用户名
 @param sex 第三方用户性别
 @param headerPic 第三方头像
 @param userType 用户类型（2：微信用户。3：qq用户）
 @param openid openid                                                                                                                                                    
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)bindPhoneWithPhone:(NSString *)phone code:(NSString *)code userName:(NSString *)userName sex:(NSString *)sex headerPic:(NSString *)headerPic userType:(NSInteger)userType openid:(NSString *)openid success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture;

/**
 忘记密码

 @param login 手机号、验证码、密码                                                                                                                                                    
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)forgetPasswdWithLogin:(MXLJLogin *)login success:(void (^)(NSString *msg, NSString *code))success failture:(void(^)(NSString *error))failture;

/**
 获取微信用户信息

 @param code 获取到的code
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getWXDataWithCode:(NSString *)code success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture;

@end
