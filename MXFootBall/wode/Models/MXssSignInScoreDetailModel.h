//
//  MXssSignInScoreDetailModel.h
//  MXFootBall
//
//  Created by Mac on 2018/4/18.
//  Copyright © 2018年 zt. All rights reserved.
//积分明细model

#import <Foundation/Foundation.h>

@interface MXssSignInScoreDetailModel : NSObject
@property (nonatomic,copy) NSString *remarks;//积分明细描述
@property (nonatomic,copy) NSString *scoreStatus;//积分状态（0：消费积分，1：获得积分）
@property (nonatomic,copy) NSString *scoreValue;//积分值

@property (nonatomic,copy) NSString *createTime;//时间
@property (nonatomic,copy) NSString *restScore;//用户当前积分值
@end
