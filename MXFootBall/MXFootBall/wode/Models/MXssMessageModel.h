//
//  MXssMessageModel.h
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//消息中心model

#import <Foundation/Foundation.h>

@interface MXssMessageModel : NSObject

//@property (nonatomic,copy) NSString *msgTypeId;//消息类型ID
//@property (nonatomic,copy) NSString *message;//消息内容
//@property (nonatomic,copy) NSString *messageType;//消息类型
//@property (nonatomic,copy) NSString *createTime;//创建时间

//-(id) initWithDict:(NSDictionary *) dict;

@property (nonatomic, assign) NSInteger action ;//跳转用action
@property (nonatomic, assign) NSInteger interactFlg ;//是否交互H5
@property (nonatomic, assign) NSInteger matchId ;//赛事ID
@property (nonatomic, assign) NSInteger msgId ;//消息ID
@property (nonatomic, assign) NSInteger newsId ;//资讯ID
@property (nonatomic, assign) NSInteger msgTypeId ;//消息类型ID
@property (nonatomic, copy) NSString * msgType ;//消息类型
@property (nonatomic, copy) NSString * content ;//消息内容
@property (nonatomic, copy) NSString * createTime ;//消息创建时间
@property (nonatomic, copy) NSString * targetUrl ;//目标地址
@property (nonatomic, copy) NSString * title ;//消息标题



@end
