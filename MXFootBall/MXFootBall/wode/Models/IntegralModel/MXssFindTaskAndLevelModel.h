//
//  MXssFindTaskAndLevelModel.h
//  MXFootBall
//
//  Created by Mac on 2018/4/11.
//  Copyright © 2018年 zt. All rights reserved.
//积分任务model

#import <Foundation/Foundation.h>

//@interface tasksListModel : NSObject
//
//@property (nonatomic,copy) NSString *ruleId;//任务规则id
//@property (nonatomic,copy) NSString *isSetUpper;//是否设置积分上限（0：不设置，1：设置）
//@property (nonatomic,copy) NSString *scoreRuleContent;//任务规则描述
//@property (nonatomic,copy) NSString *scoreUpperValue;//积分上限值
//@property (nonatomic,copy) NSString *scoreValue;//积分值
//@property (nonatomic,copy) NSString *isFinished;//是否完成任务(0：未完成，1：完成)
//
//@end
@interface MXssFindTaskAndLevelModel : NSObject
//@property (nonatomic,assign) NSInteger userId; //用户id
//@property (nonatomic,assign) NSInteger levelId;//用户等级id
//@property (nonatomic,copy) NSString *userSign;//用户签名
//@property (nonatomic, strong) NSMutableArray<tasksListModel *> *tasksListModelArr;

//
//-(id) initWithDict:(NSDictionary *) dict;

@property (nonatomic,copy) NSString *ruleId;//任务规则id
@property (nonatomic,copy) NSString *isSetUpper;//是否设置积分上限（0：不设置，1：设置）
@property (nonatomic,copy) NSString *scoreRuleContent;//任务规则描述
@property (nonatomic,copy) NSString *scoreUpperValue;//积分上限值
@property (nonatomic,copy) NSString *scoreValue;//积分值
@property (nonatomic,copy) NSString *isFinished;//是否完成任务(0：未完成，1：完成)
@property (nonatomic,copy) NSString *imgUrl;//头图标
@end
