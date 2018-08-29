//
//  MXssPostModel.h
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface imageUrlModel : NSObject

@property (nonatomic,copy) NSString *imgUrl;//任务规则id

@end

@interface MXssPostModel : NSObject
@property (nonatomic,copy) NSString *title;//论坛标题
@property (nonatomic,copy) NSString *createTime;//论坛发布时间
@property (nonatomic,copy) NSString *newsId;//论坛ID
@property (nonatomic,copy) NSString *comments;//评论数
@property (nonatomic,copy) NSString *view;//阅读数
@property (nonatomic,copy) NSString *collects;//被收藏数
@property (nonatomic,copy) NSString *subContent;//主题内容（内容的概述
@property (nonatomic,copy) NSString *channelName;//主题名称（频道名称
@property (nonatomic,copy) NSString *isComment;//是否已评论（0:未评论,1:已评论）
@property (nonatomic,copy) NSString *isCollect;//是否已收藏（0:未收藏,1:已收藏）
@property (nonatomic,copy) NSString *isTop;//是否置顶
//@property (nonatomic,copy) NSString *imgUrl;//被关注者论坛图片（lsit）
@property (nonatomic, strong) NSMutableArray<imageUrlModel *> *forumImgs;
@property (nonatomic,copy) NSString *imgUrl;//封面图

-(id) initWithDict:(NSDictionary *) dict;
@end
