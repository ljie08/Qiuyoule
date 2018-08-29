//
//  MXssFansModel.h
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXssFansModel : NSObject
@property (nonatomic,copy) NSString *headerPic;//粉丝头像
@property (nonatomic,copy) NSString *username;//粉丝昵称
@property (nonatomic,copy) NSString *levelName;//粉丝等级
@property (nonatomic,copy) NSString *userSign;//粉丝签名
@property (nonatomic,copy) NSString *fansId;//粉丝id
@property (nonatomic,copy) NSString *isAttention;//是否关注
@property (nonatomic,copy) NSString *isEach;//是否互相关注
//@property (nonatomic,copy) NSString *fansGuanzhuBut;//粉丝关注按钮

//-(id) initWithDict:(NSDictionary *) dict;
@end
