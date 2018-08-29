//
//  MXNetWorkConfig.h
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXNetWorkConfig : NSObject

/***********************************************************
                        请求接口
 ***********************************************************/

extern NSString *const SERVER_HOST; //服务器请求地址

extern NSString *const MX_KEY;//密钥

/************************* 首页  **********************************/

//广告页
extern NSString *const MXAds_PATH;

/**
 banner
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getAds:(NSDictionary *)parameters success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *error))failure;

//首页数据
extern NSString *const MXHomeData_PATH;

/**
 首页数据
 
 @param parameters 参数
 @param success banner数组，快速通道，置顶两条文章，滚动资讯，赛事，倒计时图片
 @param failure <#failure description#>
 */
- (void)getHomeDataWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *banners, NSArray *access, NSArray *topnews, NSArray *rollnews, NSArray *mactchs, NSArray *countdown, MXLJShowInfo *info, NSArray *tagArr))success failure:(void (^)(NSString *error))failure;

//官方资讯入口（官方资讯一览）
extern NSString *const MXNews_PATH;

/**
 官方资讯入口（官方资讯一览）
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOfficialNewsWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *newsList, NSArray *topList, MXSYJChannelModel *info))success failure:(void (^)(NSString *error))failure;

//首页资讯列表
extern NSString *const MXHomeNews_PATH;

/**
 首页资讯列表

 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOfficialTagListParameters:(NSDictionary *)parameters success:(void (^)(NSArray *advertsList, NSArray *newsList))success failure:(void (^)(NSString *error))failure;

#pragma mark -- 首页以下均弃用
//banner
extern NSString *const MXBanner_PATH;

/**
 banner

 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getBannerWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *banners))success failure:(void (^)(NSString *error))failure;

//快速通道
extern NSString *const MXAccess_PATH;

/**
 快速通道

 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getAccessWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *accessList))success failure:(void (^)(NSString *error))failure;

//首页两条置顶官方文章（带图）
extern NSString *const MXTopNews_PATH;

/**
 首页两条置顶官方文章（带图）

 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOfficialTopNewsWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *newsList))success failure:(void (^)(NSString *error))failure;

//首页滚动官方资讯
extern NSString *const MXRollNews_PATH;

/**
 首页滚动官方资讯
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOfficialRollNewsWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *newsList))success failure:(void (^)(NSString *error))failure;

//今日赛事
extern NSString *const MXJRSaiShi_PATH;

- (void)getSaiShiWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *saishiList))success failure:(void (^)(NSString *error))failure;

/************************* end ***********************************/

/************************* 赛事  **********************************/

//即时赛事 31
extern NSString * const MXEventInstantPATH ;

//完场赛事 32
extern NSString * const MXEventFindAfterGamePATH ;

//世界杯 34
extern NSString * const MXEventFindWorldCupPATH ;

//赔率公司 36
extern NSString * const MXEventFindAllLottCpyPATH ;

//赛事筛选
extern NSString * const MXEventFilterPATH ;

//亚盘筛选 41
extern NSString * const MXEventGetDiscFiltersPATH ;


//基本面 29
extern NSString * const MXEventBasicPanelPATH ;

//赔率盘 65
extern NSString * const MXEventOddsPanelPATH ;


// 81 阵容
extern NSString * const MXEventGetSquadPATH ;
// 82 盘面
extern NSString * const MXEventGetdiskPATH ;
// 83 观点
extern NSString * const MXEventFindAppEventViewsPATH ;

// 91 收藏球赛
extern NSString * const MXEventCollectMatchePATH ;

extern NSString *const MXGoalPATH;

//109赛事模块（即时、完赛）
extern NSString *const MXApiCommonInstant2 ;
//110赛事筛选列表
extern NSString *const MXApiCommonEventList2 ;
//111亚盘筛选列表
extern NSString *const MXApiCommonOddList2 ;

/************************* end ***********************************/

/************************* 圈子  **********************************/



/************************* end ***********************************/

/************************* 我的  **********************************/

//判断手机号是否被绑定
extern NSString *const MXCheckTelBind_PATH;

/**
 判断手机号是否被绑定

 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)checkPhoneBindWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

//获取短信验证码
extern NSString *const MXSendCode_PATH;

/**
 获取短信验证码
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)sendCodeWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

//注册
extern NSString *const MXReginster_PATH;

/**
 新用户注册

 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)reginsterWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

//注册协议
extern NSString *const MXProtocol_PATH;

/**
 注册协议

 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)lookProtocolWithParameters:(NSDictionary *)parameters success:(void (^)(MXProtocol *protocol))success failure:(void (^)(NSString *error))failure;

//登录
extern NSString *const MXLogin_PATH;//登录url
extern NSString *const MXUSER_DATA;//存本地的用户信息key

/**
 登录
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)loginWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure;

//第三方登录
extern NSString *const MXThirdLogin_PATH;

/**
 第三方登录
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)thirdLoginWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure;


//绑定手机号
extern NSString *const MXBindPhone_PATH;

/**
 绑定手机号
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)bindPhoneWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJUser *user, NSString *msg))success failure:(void (^)(NSString *error))failure;

//忘记密码
extern NSString *const MXForgetPasswd_PATH;

/**
 忘记密码
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)forgetPasswdWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *msg, NSString *code))success failure:(void (^)(NSString *error))failure;

/**
 微信
 
 @param appid 应用唯一标识，在微信开放平台提交应用审核通过后获得
 @param secret 应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
 @param code 用户换取access_token的code，仅在ErrCode为0时有效
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getWXLoginCodeWithAppid:(NSString *)appid secret:(NSString *)secret code:(NSString *)code success:(void (^)(NSString *msg))success failure:(void (^)(NSString *error))failure;

//4 个人中心
extern NSString *const MXWodePersonal_PATH;
//7 修改用户名
extern NSString *const MXWodemModifyUserName_PATH;
//9 修改用户个性签名
extern NSString *const MXWodemModifyUserSign_PATH;
//10 修改用户性别
extern NSString *const MXWodemModifyUserSex_PATH;
//11 修改用户头像
extern NSString *const MXWodemModifyUserHeadPic_PATH;
//12 收藏文章
extern NSString *const MXWodemCollectNews_PATH;
//16 == 56 消息中心
extern NSString *const MXWodemModifyMessageCenter_PATH;
// 13 帖子详情
extern NSString *const MXWodemMyNewsDetail_PATH;
//14 == 53 发帖
extern NSString *const MXWodemFindMyPosting_PATH;
//15 == 52 跟帖
extern NSString *const MXWodemFindMycomments_PATH;
//40 == 54 粉丝列表
extern NSString *const MXWodemFindFans_PATH;
//39 任务积分
extern NSString *const MXWodemFindTaskAndLevel_PATH;
//38 == 55 粉丝关注
extern NSString *const MXWodemAddFan_PATH;
//59 修改用户头像
extern NSString *const MXWodeModifyUHeadern_PATH;
// 71 签到接口
extern NSString *const MXWodeMySignIn_PATH;
// 72 签到明细（签到时间）
extern NSString *const MXWodeMySignInTime_PATH;
// 73 积分明细
extern NSString *const MXWodeMySignInScoreDetail_PATH;
// 77 我的关注列表
extern NSString *const MXWodeMyAttentionList_PATH;
// 79 关注、取消关注接口
extern NSString *const MXWodeMyAndCancelAtten_PATH;
// 88 获取个人收藏论坛
extern NSString *const MXWodeMyCollectForum_PATH;
// 89 获取权限列表
extern NSString *const MXWodeMyFindPermission_PATH;
// 92 收藏球赛列表
extern NSString *const MXWodeMyFindCollectMatches_PATH;
// 96 关于我们
extern NSString *const MXWodeMyAboutus_PATH;
// 98 修改手机号
extern NSString *const MXWodeModifyTel_PATH;
// 97 个人投票/观点
extern NSString *const MXWodeMyEventViews_PATH;
// 80 绑定社交账号
extern NSString *const MXWodeMybindSocial_PATH;
// 103 删除收藏球赛---多选删除
extern NSString *const MXWodeMyDeleteCollMatchesById_PATH;
// 104 删除收藏文章---多选删除
extern NSString *const MXWodeMyDeleteCollestNewById_PATH;
// 108 意见反馈
extern NSString *const MXWodeMySettingSaveSuggest_PATH;

//21 论坛广场
extern NSString *const MXWodemFindPointTypeList_PATH;
//22 论坛关注
extern NSString *const MXWodemFindListOfOnePeoplesPATH;
//23 文章图片上传
extern NSString *const MXWodemModifyfileUploadPATH;
//24 点击关注api/user/addFans
extern NSString *const MXWodemAddFansPATH;
//25 圈子详情
extern NSString *const MXWodemChannelDetailPATH;
//26 论坛专题列表
extern NSString *const MXWodemChannelNewListPATH;
//27 帖子详情
extern NSString *const MXWodemNewsDetailPATH;
//28 圈子话题
extern NSString *const MXWodemNewsListOfOnePeoplePATH;
//29 用户关注
extern NSString *const MXWodemAttentionListPATH;
//29-1取消关注
extern NSString *const MXWodemCancelAttenPATH;
//30 发送评论 api/news/postForumCom
extern NSString *const MXWodemPostForumComPATH;
//31 互评 api/news/postForumUserCom
extern NSString *const MXWodemPostForumUserComPATH;
//32 只看楼主评论 api/news/forumOwnerComment
extern NSString *const MXWodemForumOwnerCommentPATH;
//33 收藏论坛&&取消收藏 api/news/collectForum
extern NSString *const MXWodemCollectForumPATH;
//34 点击用户头像查看用户的圈子话题和赛事观点api/news/userSquare
extern NSString *const MXWodemUserSquarePATH;
//35 圈子话题api/news/personalForumList
extern NSString *const MXWodemPersonalForumListPATH;
//36 名称堂 api/news/fameHall
extern NSString *const MXWodemFameHallPATH;
//37 打赏 api/news/rewardInfo
extern NSString *const MXWodemRewardInfoPATH;
// 101 打赏
extern NSString *const MXEventRewardUserPATH;
//发布观点
extern NSString *const MXPublishOpinionPATH;

//时间统计

//api/event/eventLive
extern NSString *const MXEventStatisticalPATH;

//发布赛事观点初始化
extern NSString *const MXPublishOpinionInitPATH;
//观点详情
extern NSString *const MXOpinionDetailPATH;

extern NSString *const MXSupportOpinionPATH;

extern NSString *const MXUnlockedOpinionPATH;


/**
 个人中心
 
 @param userId 用户ID
 @param token token
 @param time  当前Unix时间戳
 @param sign  签名
 */
- (void)personWithUserid:(NSString *)userId token:(NSString *)token time:(NSString *)time sign:(NSString *)sign success:(void (^)(NSDictionary *personDic))success failure:(void (^)(NSString *error))failure;

/**
 修改昵称、签名、性别、头像
 
 userId 用户ID
 token token
 time  当前Unix时间戳
 sign  签名
 
 nickname  新用户名
 userSign 新用户个性签名
 sex 用户性别（字符串：男、女、未知）
 baseStr 头像图片base64码
 */
- (void)ModifyPersonMessagesWithDIC:(NSMutableDictionary *)dic withUrl:(NSString *)url success:(void (^)(NSDictionary *personDic))success failure:(void (^)(NSString *error))failure;

/**
 消息中心 发帖 跟帖 收藏文章 粉丝列表 粉丝关注按钮
 userId
 token
 time
 sign
 */
- (void)sMessageCenterWithDic:(NSMutableDictionary *)paramDic urlStr:(NSString *)url success:(void (^)(NSDictionary *personDic))success failure:(void (^)(NSString *error))failure;

/************************* end ***********************************/

@end
