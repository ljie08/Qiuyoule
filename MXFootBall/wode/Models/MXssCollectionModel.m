//
//  MXssCollectionModel.m
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXssCollectionModel.h"
@implementation imageUrlModelColl

- (instancetype)initWithDictionary:(NSDictionary*)dic{
    if (self = [self init]) {
        _imgUrl = [dic objectForKey:@"imgUrl"];//图片地址
    }
    return self;
}
@end
@implementation MXssCollectionModel
@synthesize title;//论坛标题
@synthesize createTime;//论坛发布时间
@synthesize newsId;//论坛ID
@synthesize comments;//评论数
@synthesize view;//阅读数
@synthesize collects;//被收藏数
@synthesize subContent;//主题内容（内容的概述
@synthesize channelName;//主题名称（频道名称
@synthesize isComment;//是否已评论（0:未评论,1:已评论）
@synthesize isCollect;//是否已收藏（0:未收藏,1:已收藏）
@synthesize isTop;//是否置顶
@synthesize yesOrNo;//是否选中 0 未选中 1 选中
@synthesize collectId;
@synthesize imgUrl;//封面图
//@synthesize imgUrl;//被关注者论坛图片（lsit）

-(id) initWithDict:(NSDictionary *) dict{
    self=[super init];
    if (self) {
        title = [dict objectForKey:@"title"];//论坛标题
        createTime = [dict objectForKey:@"createTime"];//论坛发布时间
        newsId = [dict objectForKey:@"newsId"];//论坛ID
        comments = [dict objectForKey:@"comments"];//评论数
        view = [dict objectForKey:@"view"];//阅读数
        collects = [dict objectForKey:@"collects"];//被收藏数
        subContent = [dict objectForKey:@"subContent"];//主题内容（内容的概述
        channelName = [dict objectForKey:@"channelName"];//主题名称（频道名称
        isComment = [dict objectForKey:@"isComment"];//是否已评论（0:未评论,1:已评论）
        isCollect = [dict objectForKey:@"isCollect"];//是否已收藏（0:未收藏,1:已收藏）
        isTop = [dict objectForKey:@"isTop"];//是否置顶
        yesOrNo = 0;//是否选中 0 未选中 1 选中
        collectId = [dict objectForKey:@"collectId"];
        //        imgUrl = [dict objectForKey:@"imgUrl"];//被关注者论坛图片（lsit）
        imgUrl=[dict objectForKey:@"imgUrl"];//封面图
    }
    return self;
}
@end
