//
//  MXssWodeModel.h
//  MXFootBall
//
//  Created by Mac on 2018/3/21.
//  Copyright © 2018年 zt. All rights reserved.
//接口描述：个人中心 请求URI：api/user/personal

#import <Foundation/Foundation.h>
@interface levelListModel : NSObject

@property (nonatomic,copy) NSString *levelIcon;//等级图标
@property (nonatomic,copy) NSString *levelName;//等级名称
@property (nonatomic,assign) NSInteger level;//等级ID

@end
@interface MXssWodeModel : NSObject
@property (nonatomic,assign) NSInteger attentionNum; //关注数
@property (nonatomic,assign) NSInteger fansNum;//粉丝数
@property (nonatomic,assign) NSInteger articleNum;//发帖数
@property (nonatomic, strong) NSMutableArray<levelListModel *> *levelListModelArr;


-(id) initWithDict:(NSDictionary *) dict;
@end
