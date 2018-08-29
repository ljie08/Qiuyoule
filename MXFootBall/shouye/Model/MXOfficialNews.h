//
//  MXOfficialNews.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/4/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXOfficialNews : NSObject

@property (nonatomic, assign) NSInteger userId;//论坛作者ID
@property (nonatomic, copy) NSString *username;//论坛作者名称
@property (nonatomic, copy) NSString *headerPic;//论坛作者头像
@property (nonatomic, copy) NSString *createTime;//论坛发布时间
@property (nonatomic, assign) NSInteger level;//论坛作者等级
@property (nonatomic, copy) NSString *title;//论坛标题
@property (nonatomic, assign) NSInteger newsId;//论坛ID
@property (nonatomic, assign) NSInteger comments;//评论数
@property (nonatomic, assign) NSInteger view;//阅读数
@property (nonatomic, assign) NSInteger collects;//被收藏数
@property (nonatomic, copy) NSString *subContent;//主题内容（内容的概述）
@property (nonatomic, copy) NSString *channelName;//主题名称（频道名称）
@property (nonatomic, assign) NSInteger isComment;//是否已评论（0:未评论,1:已评论）
@property (nonatomic, assign) NSInteger isCollect;//是否已收藏（0:未收藏,1:已收藏）
@property (nonatomic, assign) NSInteger isTop;//是否置顶

@end

@interface MXChannelInfo : NSObject

@property (nonatomic, copy) NSString *imgUrl;//主题图片地址                                                                                                        
@property (nonatomic, copy) NSString *channelName;//主题名称（频道名称）
@property (nonatomic, copy) NSString *title;//主题（频道）名
@property (nonatomic, copy) NSString *forumCount;//帖子数

@end
