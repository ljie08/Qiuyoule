//
//  MXHomeVM.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXHomeVM : NSObject

@property (nonatomic, strong) MXLJUser *user;//用户信息
@property (nonatomic, strong) NSMutableArray *bannerList;//banner数组
@property (nonatomic, strong) NSMutableArray *accessList;//快速通道数组
@property (nonatomic, strong) NSMutableArray *topList;//置顶文章数组
@property (nonatomic, strong) NSMutableArray *rollList;//滚动资讯数组

@property (nonatomic, strong) NSMutableArray *channelList;//官方资讯
@property (nonatomic, strong) NSMutableArray *officialTopList;//官方资讯置顶
@property (nonatomic, strong) MXSYJChannelModel *info;//频道

@property (nonatomic, strong) NSMutableArray *saishiList;//今日赛事

@property (nonatomic, strong) MXLJCountDown *countdown;//倒计时
@property (nonatomic, strong) MXLJConduct *conduct;//倒计时图片
@property (nonatomic, strong) MXLJShowInfo *showinfo;//是否显示倒计时

@property (nonatomic, assign) NSInteger page;////页数 1，2，3，4，...

@property (nonatomic, assign) CGFloat passtime;//已过时间（毫秒）
@property (nonatomic, assign) CGFloat chatime;//时间差
@property (nonatomic, assign) BOOL isShow;//是否显示倒计时cell
@property (nonatomic, assign) int num;//毫秒倒计时（弃用）

//1.2
@property (nonatomic, strong) NSMutableArray *tagArr;//导航按钮数组 id,name
@property (nonatomic, strong) NSMutableArray *nameArr;//导航按钮数组 只有name
@property (nonatomic, strong) NSMutableArray *newsArr;//资讯
@property (nonatomic, strong) NSMutableArray *advertsArr;//广告
@property (nonatomic, strong) NSMutableArray *dataArr;//数据

/**
 首页数据
 
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getHomeDataWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture;

/**
 倒计时 精确到毫秒
 */
//获取时间差
- (void)getChaTime;
//将时间差转换为天、时、分、秒、毫秒显示
- (void)getChaData;

/**
 官方资讯入口（官方资讯一览）
 
 @param isRefresh 是否刷新
 @param type 1:全部，2：最新热帖，3：历史置顶
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getNewsWithRefresh:(BOOL)isRefresh type:(NSInteger)type success:(void (^)(BOOL result))success failture:(void (^)(NSString *error))failture;

//1.2
/**
 首页官方资讯（tag切换）

 @param isRefresh <#isRefresh description#>
 @param type <#type description#>
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getHomeNewsWithRefresh:(BOOL)isRefresh type:(NSInteger)type success:(void (^)(BOOL result))success failture:(void (^)(NSString *error))failture;

#pragma mark --- 以下均弃用。。。。。。。
//判断比赛是否已结束，结束了不显示倒计时
//根据MXLJShowInfo来确定是否显示，故此方法弃用
- (void)matchEnd;
/**
 倒计时
 */
- (void)getCountDown;
//毫秒倒计
- (void)countDownSecond;

/**
 banner

 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getBannerWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture;

/**
 快速通道

 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getAccessWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture;

/**
 首页两条置顶官方文章（带图）
 
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getTopNewsWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture;

/**
 首页滚动官方资讯
 
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getRollNewsWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture;


/**
 今日赛事

 @param isRefresh 刷新
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getSaishiWithRefresh:(BOOL)isRefresh success:(void (^)(BOOL result))success failture:(void (^)(NSString *error))failture;

@end
