//
//  MXNews.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/6/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

//展示图列表
@interface MXForumImg : NSObject

@property (nonatomic, copy) NSString *imgUrl;//图片地址

@end

//首页资讯列表
@interface MXNews : NSObject

@property (nonatomic, assign) NSInteger isComment;// 是否评论过（0：未评论，1：已评论）
@property (nonatomic, assign) NSInteger comments;// 评论数
@property (nonatomic, assign) NSInteger level;// 等级
@property (nonatomic, assign) NSInteger isCollect;// 是否收藏过（0：未收藏，1：已收藏）
@property (nonatomic, copy) NSString *title;// 资讯标题
@property (nonatomic, assign) NSInteger userId;// 资讯作者ID
@property (nonatomic, copy) NSString *imgUrl;// 封面图
@property (nonatomic, assign) NSInteger newsId;// 资讯ID
@property (nonatomic, assign) NSInteger view;// 阅读数
@property (nonatomic, copy) NSString *headerPic;// 资讯作者头像
@property (nonatomic, copy) NSString *createTime;// 资讯发布时间
@property (nonatomic, assign) NSInteger articleType;// 资讯类型（0：官方发布，1：帖子）
@property (nonatomic, assign) NSInteger isTop;// 是否置顶（0：未置顶，1：已置顶）
@property (nonatomic, copy) NSString *channelName;// 频道名
@property (nonatomic, copy) NSString *tag;// 资讯标签（“头条”、“世界杯”等）
@property (nonatomic, assign) NSInteger collects;// 收藏数
@property (nonatomic, assign) NSInteger channelId;// 频道ID
@property (nonatomic, copy) NSString *subContent;// 内容简介（概括）
@property (nonatomic, copy) NSString *username;// 资讯作者名
@property (nonatomic, strong) NSArray<MXForumImg *> *forumImgs;//展示图列表

@property (nonatomic, assign) NSInteger advertId ;//广告id
@property (nonatomic, copy) NSString *advertPic;//广告图片地址
@property (nonatomic, copy) NSString *targetUrl;//广告跳转目标地址

@end

