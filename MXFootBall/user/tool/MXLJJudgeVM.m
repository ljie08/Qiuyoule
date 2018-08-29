//
//  MXLJJudgeVM.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXLJJudgeVM.h"

@implementation MXLJJudgeVM

- (instancetype)init {
    if (self = [super init]) {
        _login = [[MXLJLogin alloc] init];
        _user = [[MXLJUser alloc] init];
        _isShowScore = NO;
        _hasTel = 0;
        _protocol = [[MXProtocol alloc] init];
    }
    return self;
}

#pragma mark -- 验证
/**
 判断注册是否填写完整
 
 @param isSelected 是否阅读并同意协议
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isRegisterCompleteWithTextAndButtonIsSelected:(BOOL)isSelected success:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure {
    NSDictionary *dic = [self registerDataWithButtonIsSelected:isSelected];
    if ([[dic valueForKey:@"result"] isEqualToString:@"no"]) {
        failure([dic valueForKey:@"hint"]);
    } else {
        success(YES);
    }
}

//注册时判断所填信息是否正确
- (NSDictionary*)registerDataWithButtonIsSelected:(BOOL)isSelected {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"yes" forKey:@"result"];
    
    if (!self.login.registerPhoneNum || self.login.registerPhoneNum.length != 11) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"手机号码输入有误" forKey:@"hint"];
        return dic;
    }
    if (!self.login.code) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"请输入验证码" forKey:@"hint"];
        return dic;
    }
    if (!self.login.registerPasswd1 || self.login.registerPasswd1.length < 6 || self.login.registerPasswd1.length > 12) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"请输入6-12位登录密码" forKey:@"hint"];
        return dic;
    }
    if (!self.login.registerPasswd2 || ![self.login.registerPasswd2 isEqualToString:self.login.registerPasswd1]) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"两次输入密码不同，请重新输入" forKey:@"hint"];
        return dic;
    }
    if (!isSelected) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"请阅读并同意注册协议" forKey:@"hint"];
        return dic;
    }
    
    return dic;
}

/**
 判断登录是否填写完整
 
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isLoginCompleteWithTextWithSuccess:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure {
    NSDictionary *dic = [self loginData];
    if ([[dic valueForKey:@"result"] isEqualToString:@"no"]) {
        failure([dic valueForKey:@"hint"]);
    } else {
        success(YES);
    }
}

//登录时判断所填信息是否正确
- (NSDictionary*)loginData {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"yes" forKey:@"result"];
    
    if (!self.login.registerPhoneNum || self.login.registerPhoneNum.length != 11) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"手机号码输入有误" forKey:@"hint"];
        return dic;
    }
    if (!self.login.registerPasswd1 || self.login.registerPasswd1.length < 6 || self.login.registerPasswd1.length > 12) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"密码输入有误" forKey:@"hint"];
        return dic;
    }
    
    return dic;
}

/**
 判断忘记密码是否填写完整

 //type已弃用，忘记和重置合并了一个界面
 @param type 1，忘记；2，重置
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)isForgetWithType:(NSInteger)type success:(void (^)(BOOL isCorrect))success failure:(void (^)(NSString *errorString))failure {
    NSDictionary *dic = [self forgetWithType:type];
    if ([[dic valueForKey:@"result"] isEqualToString:@"no"]) {
        failure([dic valueForKey:@"hint"]);
    } else {
        success(YES);
    }
}

/**
 忘记密码时判断所填信息是否正确

 //type已弃用，忘记和重置合并了一个界面
 @param type 1，忘记；2，重置
 @return <#return value description#>
 */
- (NSDictionary *)forgetWithType:(NSInteger)type {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"yes" forKey:@"result"];
    
    if (!self.login.registerPhoneNum || self.login.registerPhoneNum.length != 11) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"手机号码输入有误" forKey:@"hint"];
        return dic;
    }
    if (!self.login.code) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"请输入验证码" forKey:@"hint"];
        return dic;
    }

    if (!self.login.registerPasswd1 || self.login.registerPasswd1.length < 6 || self.login.registerPasswd1.length > 12) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"请输入6-12位登录密码" forKey:@"hint"];
        return dic;
    }
    if (!self.login.registerPasswd2 || ![self.login.registerPasswd2 isEqualToString:self.login.registerPasswd1]) {
        [dic setObject:@"no" forKey:@"result"];
        [dic setObject:@"两次输入密码不同，请重新输入" forKey:@"hint"];
        return dic;
    }
    
    
    return dic;
}

#pragma mark -- 数据
/**
 判断手机号是否被绑定
 
 @param phone 手机号
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)checkPhoneBindWithPhoneNum:(NSString *)phone success:(void (^)(NSString *msg, NSString *code))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phone forKey:@"telephone"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config checkPhoneBindWithParameters:allParams success:^(MXLJSuccessData *data) {
        weakSelf.hasTel = [[data.data objectForKey:@"hasTel"] integerValue];
        
        success(data.msg, data.code);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 获取验证码
 
 @param phoneNum 手机号
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getCodeWithPhoneNum:(NSString *)phoneNum success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phoneNum forKey:@"telephone"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config sendCodeWithParameters:allParams success:^(MXLJSuccessData *data){
        NSString *msgStr = [NSString string];
        if (![data.code isEqualToString:@"0"]) {
            msgStr = data.msg;
        } else {//请求成功
            msgStr = @"";
        }
        
        //获取到的密码保存，用来判断填写的是否正确
        NSString *code = [data.data objectForKey:@"code"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:code forKey:@"shortcode"];
        
        success(msgStr);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 注册

 @param phoneNum 手机号
 @param code 验证码
 @param passwd 密码
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)registerWithPhoneNum:(NSString *)phoneNum code:(NSString *)code passwd:(NSString *)passwd success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    passwd = [passwd MD5];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phoneNum forKey:@"telephone"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:passwd forKey:@"password"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config reginsterWithParameters:allParams success:^(MXLJSuccessData *data) {
        NSString *msgStr = [NSString string];
        if (![data.code isEqualToString:@"0"]) {
            msgStr = data.msg;
        } else {//请求成功
            msgStr = @"";
        }
        
        NSDictionary *jsondic = [NSDictionary dictionaryWithObjectsAndKeys:@"phone", @"way", nil];
        NSString *content = [MXLJUtil dictionaryToJson:jsondic];
        [UBT logTrace:@"registered" content:content];
        
        success(msgStr);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 注册协议
 
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)protocolWithSuccess:(void (^)(BOOL isCorrect))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config lookProtocolWithParameters:allParams success:^(MXProtocol *protocol) {
        weakSelf.protocol = protocol;
        success(YES);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 登录
 
 @param phoneNum 手机号
 @param passwd 密码
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)loginWithPhoneNum:(NSString *)phoneNum passwd:(NSString *)passwd success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    passwd = [passwd MD5];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phoneNum forKey:@"telephone"];
    [parameters setObject:passwd forKey:@"password"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    @weakSelf(self);
    [config loginWithParameters:allParams success:^(MXLJSuccessData *data) {
        NSString *msgStr = [NSString string];
        if (![data.code isEqualToString:@"0"]) {
            msgStr = data.msg;
        } else {//请求成功
            msgStr = @"";
            NSDictionary *dataDic = data.data;
            [weakSelf saveUserDataWithDic:dataDic];//保存用户信息
            
            //UBT存储登录信息
            MXLJUser *user = [MXLJUser mj_objectWithKeyValues:dataDic];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            user.token = @"";
            user.totalScore = @"";
            user.restScore = @"";
            user.level = 0;
            NSDictionary *ubtDic = user.mj_keyValues;
            [defaults setObject:ubtDic forKey:@"userInfo"];
            [UBT sync:nil];
            
            //是否第一次登录（0：不是第一次，1：是第一次登录）
            weakSelf.isShowScore = user.isFirstLogin == 0 ? NO : YES;
            
            NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *listPath = [listFile stringByAppendingPathComponent:MXUSER_DATA];
            
            //将登录成功返回的用户信息存到本地
            [NSKeyedArchiver archiveRootObject:user toFile:listPath];
        }
        
        success(msgStr);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 第三方登录成功调用
 
 @param openId qq或者微信的唯一标识
 @param userName 用户社交账号的名称
 @param headerPic 社交账号头像地址
 @param userType 用户类型（1：平台注册、2：微信登录、3：qq登录）
 @param sex 用户性别（男、女、未知）
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)thirdLoginWithOpenid:(NSString *)openId userName:(NSString *)userName headerPic:(NSString *)headerPic userType:(NSInteger)userType sex:(NSString *)sex success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:openId forKey:@"openid"];
    [parameters setObject:userName forKey:@"username"];
    [parameters setObject:headerPic forKey:@"headerPic"];
    [parameters setObject:@(userType) forKey:@"userType"];
    [parameters setObject:sex forKey:@"sex"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    @weakSelf(self);
    [config thirdLoginWithParameters:allParams success:^(MXLJSuccessData *data) {
        NSString *msg;
        if ([data.code integerValue] == 1003) {//请先绑定手机号,data为空
            msg = @"";
        } else {//成功或者其他信息
            msg = data.msg;
            NSDictionary *dic = data.data;
            [weakSelf saveUserDataWithDic:dic];//保存用户信息
            
            //UBT存储登录信息
            MXLJUser *user = [MXLJUser mj_objectWithKeyValues:data.data];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            user.token = @"";
            user.totalScore = @"";
            user.restScore = @"";
            user.level = 0;
            NSDictionary *ubtDic = user.mj_keyValues;
            [defaults setObject:ubtDic forKey:@"userInfo"];
            [UBT sync:nil];
        }
        
        
//        NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//        NSString *listPath = [listFile stringByAppendingPathComponent:MXUSER_DATA];
//
//        //将登录成功返回的用户信息存到本地
//        [NSKeyedArchiver archiveRootObject:user toFile:listPath];
        
        success(msg);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

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
- (void)bindPhoneWithPhone:(NSString *)phone code:(NSString *)code userName:(NSString *)userName sex:(NSString *)sex headerPic:(NSString *)headerPic userType:(NSInteger)userType openid:(NSString *)openid success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phone forKey:@"telephone"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:@(self.hasTel) forKey:@"opid"];
    [parameters setObject:userName forKey:@"username"];
    [parameters setObject:sex forKey:@"sex"];
    [parameters setObject:headerPic forKey:@"headerPic"];
    [parameters setObject:@(userType) forKey:@"userType"];
    [parameters setObject:openid forKey:@"openid"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    @weakSelf(self);
    [config bindPhoneWithParameters:allParams success:^(MXLJUser *user, NSString *msg) {
        
        //是否第一次登录（0：不是第一次，1：是第一次登录）
        weakSelf.isShowScore = user.isFirstLogin == 0 ? NO : YES;
        
        NSDictionary *dic = user.mj_keyValues;
        [weakSelf saveUserDataWithDic:dic];//保存用户信息
        
        NSDictionary *jsondic = [NSDictionary dictionaryWithObjectsAndKeys:@"wechat", @"way", nil];
        NSString *content = [MXLJUtil dictionaryToJson:jsondic];
        [UBT logTrace:@"registered" content:content];
        
        success(msg);
        NSLog(@"绑定成功🐷 dic\n%@", dic);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 忘记密码
 
 @param login 手机号、验证码、密码
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)forgetPasswdWithLogin:(MXLJLogin *)login success:(void (^)(NSString *msg, NSString *code))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    login.registerPasswd1 = [login.registerPasswd1 MD5];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:login.registerPhoneNum forKey:@"telephone"];
    [parameters setObject:login.code forKey:@"code"];
    [parameters setObject:login.registerPasswd1 forKey:@"newPassword"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config forgetPasswdWithParameters:allParams success:^(NSString *msg, NSString *code) {
        
        success(msg, code);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 获取微信用户信息
 
 @param code 获取到的code
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getWXDataWithCode:(NSString *)code success:(void (^)(NSString *msg))success failture:(void(^)(NSString *error))failture {
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config getWXLoginCodeWithAppid:WX_APPID secret:WX_SECRET code:code success:^(NSString *msg) {
        
        success(msg);
        
    } failure:^(NSString *error) {
        failture(error);
    }];
}

//保存用户信息
- (void)saveUserDataWithDic:(NSDictionary *)dataDic {
    MXSSToolConfig *infoModel = [[MXSSToolConfig alloc]initWithDic:dataDic];
    infoModel.userId = dataDic[@"userId"];//用户Id
    infoModel.headerPic = dataDic[@"headerPic"];//用户默认头像
    infoModel.username = dataDic[@"username"];//用户名
    infoModel.sex   = dataDic[@"sex"];//用户性别（男，女，未知）
    infoModel.signIn   = dataDic[@"signIn"];//用户签到状态（1：今日已签到，3：未签到）
    infoModel.token = dataDic[@"token"];//用户token
    infoModel.userSign = dataDic[@"userSign"];//用户默认个性签名
    infoModel.level = dataDic[@"level"];//用户等级
    infoModel.isFirstLogin = dataDic[@"isFirstLogin"];//是否第一次登录（0：不是第一次，1：是第一次登录）
    infoModel.isBindingSocial = dataDic[@"isBindingSocial"];//是否绑定了社交账号（0：未绑定，1：已经绑定）
    
    //            infoModel.checkInNumber = dataDic[@"checkInNumber"];//积分数
    infoModel.telephone = dataDic[@"telephone"];//手机号码
    infoModel.isBindingQQ = dataDic[@"isBindingQQ"];//是否绑定了qq（0：未绑定，1：已经绑定）
    infoModel.isBindingWechat = dataDic[@"isBindingWechat"];//是否绑定了微信（0：未绑定，2：已经绑定）
    infoModel.totalScore = dataDic[@"totalScore"];//登录成功总积分
    infoModel.restScore = dataDic[@"restScore"];//登录成功剩余总积分
    
    [MXssWodeUtils savePersonInfo:infoModel];
}

////保存用户信息
//- (void)saveUserDataWithModel:(MXLJUser *)user {
//    MXSSToolConfig *infoModel = [[MXSSToolConfig alloc]initWithDic:user];
//    infoModel.userId = user.userId;//用户Id
//    infoModel.headerPic = user.headerPic;//用户默认头像
//    infoModel.username = user.username;//用户名
//    infoModel.sex   = user.sex;//用户性别（男，女，未知）
//    infoModel.signIn   = user.signIn;//用户签到状态（1：今日已签到，3：未签到）
//    infoModel.token = user.token;//用户token
//    infoModel.userSign = user.userSign;//用户默认个性签名
//    infoModel.checkIn = user.checkIn;//用户签到状态（1：今日已签到，3：未签到）
//    infoModel.isFirstLogin = user.isFirstLogin;//是否第一次登录（0：不是第一次，1：是第一次登录）
//    infoModel.isBindingSocial = user.isBindingSocial;//是否绑定了社交账号（0：未绑定，1：已经绑定）
//
//    //            infoModel.checkInNumber = dataDic[@"checkInNumber"];//积分数
//
//    [MXssWodeUtils savePersonInfo:infoModel];
//}

@end
