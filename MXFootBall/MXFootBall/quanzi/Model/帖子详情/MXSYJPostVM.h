//
//  MXSYJPostVM.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/18.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXSYJPostVM : NSObject

+ (instancetype)sharedInstance;

/**
 获取帖子详情

 @param userId 用户id
 @param newsId 新闻id
 @param page 分页
 @param limit 条数
 @param success 成功回调
 @param failture 失败回调
 */
- (void)getPostDetail:(NSString *)userId newsId:(NSString *)newsId page:(NSInteger)page limit:(NSInteger)limit success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture;

/**
 发送评论

 @param userId 用户id
 @param newsId 新闻id
 @param content 内容
 @param success 成功回调
 @param failture 失败回调
 */
- (void)commentUserId:(NSString *)userId newsId:(NSString *)newsId content:(NSString *)content  success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture;


/**
 只看楼主

 @param newsId  新闻id
 @param ownerId 作者id
 @param success 成功回调
 @param failture 失败回调
 */
- (void)onlyPosterNewsId:(NSString *)newsId ownerId:(NSString *)ownerId success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture;


/**
 互相评论

 @param newsId 帖子id
 @param userId 用户id
 @param parentId 目标用户ID
 @param firstUserId 主评论用户ID
 @param content 内容
 @param success 成功回调
 @param failture 失败回调
 */
- (void)eachOtherNewsId:(NSString *)newsId userId:(NSString *)userId parentId:(NSString *)parentId firstUserId:(NSString *)firstUserId content:(NSString *)content success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture;


/**
 收藏帖子

 @param newsId 帖子id
 @param userId 用户id
 @param success 成功回调
 @param failture 失败回调
 */
- (void)collectNewsId:(NSString *)newsId userId:(NSString *)userId opid:(NSInteger)opid success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture;


/**
 关注&&取消关注

 @param type 关注或取消关注
 @param ownerId 对象id
 @param userId 用户id
 @param success 成功回调
 @param failture 失败回调
 */
- (void)attentionType:(NSInteger)type ownerId:(NSString *)ownerId userId:(NSString *)userId  success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture;

/**
 圈子模块详细信息
 
 @param userId 用户id
 @param channleId 模块id
 @param page 页数
 @param limit 每次条数
 @param opid 1全部 2最新热帖 3历史置顶
 @param success 成功回调
 @param failture 失败回调
 */
- (void)getCircleDetail:(NSString *)userId channleId:(NSString *)channleId page:(NSInteger)page limit:(NSInteger)limit opid:(NSInteger)opid success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture;



/**
 个人信息

 @param userId 用户id
 @param ownerId 目标用户id
 @param page 页数
 @param limit 条数
 @param opid 1 赛事观点 2 圈子话题
 @param success 成功回调
 @param failture 失败回调
 */
- (void)getPersonUserId:(NSString *)userId ownerId:(NSString *)ownerId page:(NSInteger)page limit:(NSInteger)limit opid:(NSInteger)opid success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture;



@end
