//
//  MXssMyAttentionModel.h
//  MXFootBall
//
//  Created by Mac on 2018/4/18.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXssMyAttentionModel : NSObject
@property (nonatomic,copy) NSString *headerPic;//粉丝头像
@property (nonatomic,copy) NSString *username;//用户名
@property (nonatomic,copy) NSString *levelName;//用户等级
@property (nonatomic,copy) NSString *userSign;//用户等级描述
@property (nonatomic,copy) NSString *ownerId;//关注者ID
@property (nonatomic,copy) NSString *isAttention;//是否关注
//@property (nonatomic,copy) NSString *isYesOrNoAttention;//是否关注

@end
