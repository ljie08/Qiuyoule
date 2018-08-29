
//
//  MXNetWorkConfig.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXNetWorkConfig.h"

/***********************************************************
                        请求接口
 ***********************************************************/
//发布域名地址
NSString *const SERVER_HOST = @"https://api.qiuyoule.com/";
//测试域名地址

//NSString *const SERVER_HOST = @"https://api.caipiaoq.com/";

NSString *const MX_KEY = @"1b5c68449a9df94143f478121749c260";

/************************* 首页  **********************************/
//广告页
NSString *const MXAds_PATH = @"api/ad/findAds";

//5 banner
NSString *const MXBanner_PATH = @"api/banner/list";

//112 首页数据
NSString *const MXHomeData_PATH = @"api/common/index";

//首页资讯列表
NSString *const MXHomeNews_PATH = @"api/news/officialTaglist";

//6 快速通道
NSString *const MXAccess_PATH = @"api/access/list";

//74 首页两条置顶官方文章（带图）
NSString *const MXTopNews_PATH = @"api/news/officialTopNews";

//75 首页滚动官方资讯
NSString *const MXRollNews_PATH = @"api/news/officialRollNews";

//76 官方资讯入口（官方资讯一览）
NSString *const MXNews_PATH = @"api/news/officialNews";

//99 今日赛事
NSString *const MXJRSaiShi_PATH = @"api/event/GoodRecommendation";

/************************* end ***********************************/

/************************* 赛事  **********************************/

//即时赛事 31
NSString * const MXEventInstantPATH = @"api/event/instant" ;

//完场赛事
NSString * const MXEventFindAfterGamePATH = @"api/event/findAfterGame" ;

//世界杯
NSString * const MXEventFindWorldCupPATH = @"api/event/findWorldCup" ;

//赔率公司
NSString * const MXEventFindAllLottCpyPATH = @"api/event/findAllLottCpy" ;

//赛事筛选
NSString * const MXEventFilterPATH = @"api/event/EventFilter" ;

//亚盘筛选
NSString * const MXEventGetDiscFiltersPATH = @"api/event/getDiscFilters" ;



//基本面 29
NSString * const MXEventBasicPanelPATH = @"api/event/basicPanel" ;

//赔率盘 65
NSString * const MXEventOddsPanelPATH = @"api/event/oddsPanel" ;



// 81 阵容
NSString * const MXEventGetSquadPATH = @"api/event/getSquad" ;
// 82 盘面
NSString * const MXEventGetdiskPATH = @"api/event/getdisk" ;
// 83 观点
NSString * const MXEventFindAppEventViewsPATH = @"api/event/findAppEventViews" ;

// 91 收藏球赛
NSString * const MXEventCollectMatchePATH = @"api/event/CollectMatche" ;

//109赛事模块（即时、完赛）
NSString *const MXApiCommonInstant2 = @"api/common/instant2" ;
//110赛事筛选列表
NSString *const MXApiCommonEventList2 = @"api/common/eventList2" ;
//111亚盘筛选列表
NSString *const MXApiCommonOddList2 = @"api/common/oddList2" ;


/************************* end ***********************************/

/************************* 圈子  **********************************/



/************************* end ***********************************/

/************************* 我的  **********************************/
//78 判断手机号是否被绑定
NSString *const MXCheckTelBind_PATH = @"api/user/checkTelBind";

//1 获取短信验证码
NSString *const MXSendCode_PATH = @"api/user/sendCode";

//2 注册
NSString *const MXReginster_PATH = @"api/user/reg";

//105 注册协议
NSString *const MXProtocol_PATH = @"api/user/protocol";

//3 登录
NSString *const MXLogin_PATH = @"api/user/login";
NSString *const MXUSER_DATA = @"mxuser.plist";//可以根据这个取出存本地的用户信息

//20 第三方登录
NSString *const MXThirdLogin_PATH = @"api/user/thirdPartyLogin";

//37 绑定手机号
NSString *const MXBindPhone_PATH = @"api/user/bindTel";

//63 忘记密码
NSString *const MXForgetPasswd_PATH = @"api/user/forgetPwd";

//4 个人中心
NSString *const MXWodePersonal_PATH = @"api/user/personal";
//7 修改用户名
NSString *const MXWodemModifyUserName_PATH = @"api/user/modifyUName";
//9 修改用户个性签名
NSString *const MXWodemModifyUserSign_PATH = @"api/user/modifyUSign";
//10 修改用户性别
NSString *const MXWodemModifyUserSex_PATH = @"api/user/modifyUSex";
//11 修改用户头像
NSString *const MXWodemModifyUserHeadPic_PATH = @"api/user/modifyUHdrPic";
//12 收藏文章
NSString *const MXWodemCollectNews_PATH = @"api/user/collectNews";
//16 == 56 消息中心
NSString *const MXWodemModifyMessageCenter_PATH = @"api/user/messageCenter";
// 13 帖子详情
NSString *const MXWodemMyNewsDetail_PATH = @"api/user/newsDetail";
//14 == 53 我的发帖
NSString *const MXWodemFindMyPosting_PATH = @"api/user/myPost";
//15 == 52 我的跟帖
NSString *const MXWodemFindMycomments_PATH = @"api/user/myComment";
//40 == 54 粉丝列表
NSString *const MXWodemFindFans_PATH = @"api/user/myFans";
//39 任务积分
NSString *const MXWodemFindTaskAndLevel_PATH = @"api/user/findTaskAndLevel";
//38 == 55 粉丝关注
NSString *const MXWodemAddFan_PATH = @"api/user/addFans";
//59 修改用户头像
NSString *const MXWodeModifyUHeadern_PATH = @"api/user/modifyUHeader";
// 71 签到接口
NSString *const MXWodeMySignIn_PATH = @"api/user/signIn";
// 72 签到明细（签到时间）
NSString *const MXWodeMySignInTime_PATH = @"api/user/signInTime";
// 73 积分明细
NSString *const MXWodeMySignInScoreDetail_PATH = @"api/user/scoreDetail";
// 77 我的关注列表
NSString *const MXWodeMyAttentionList_PATH = @"api/user/myAttention";
// 79 关注、取消关注接口
NSString *const MXWodeMyAndCancelAtten_PATH = @"api/user/addAndCancelAtten";
// 88 获取个人收藏论坛
NSString *const MXWodeMyCollectForum_PATH = @"api/user/myCollectForum";
// 89 获取权限列表
NSString *const MXWodeMyFindPermission_PATH = @"api/user/findPermission";
// 92 收藏球赛列表
NSString *const MXWodeMyFindCollectMatches_PATH = @"api/event/findCollectMatches";
// 96 关于我们
NSString *const MXWodeMyAboutus_PATH = @"api/appInfo/aboutus";
// 98 修改手机号
NSString *const MXWodeModifyTel_PATH = @"api/user/modifyTel";
// 97 个人投票/观点
NSString *const MXWodeMyEventViews_PATH = @"api/user/myEventViews";
// 80 绑定社交账号
NSString *const MXWodeMybindSocial_PATH = @"api/user/bindSocial";
// 103 删除收藏球赛---多选删除
NSString *const MXWodeMyDeleteCollMatchesById_PATH = @"api/user/deleteCollMatchesById";
// 104 删除收藏文章---多选删除
NSString *const MXWodeMyDeleteCollestNewById_PATH = @"api/user/deleteCollestNewById";

// 108 意见反馈
NSString *const MXWodeMySettingSaveSuggest_PATH = @"appInfo/saveSuggest";
//

/************************* end ***********************************/


/************************* 论坛 ***********************************/

//21 论坛广场
NSString *const MXWodemFindPointTypeList_PATH = @"api/news/squareList";
//22 论坛关注
NSString *const MXWodemFindListOfOnePeoplesPATH = @"api/news/attentionList";
//23 文章图片上传
NSString *const MXWodemModifyfileUploadPATH = @"api/news/saveForumHtml";
//24 点击关注api/user/addFans
NSString *const MXWodemAddFansPATH = @"api/user/addAndCancelAtten";
//25 圈子详情
NSString *const MXWodemChannelDetailPATH = @"api/news/channelDetail";
//26 论坛专题列表
NSString *const MXWodemChannelNewListPATH = @"api/news/channelForumList";
//27 帖子详情
NSString *const MXWodemNewsDetailPATH = @"api/news/forumDetail";
//28 圈子话题
NSString *const MXWodemNewsListOfOnePeoplePATH = @"api/news/newsListOfOnePeople";
//29 用户关注
NSString *const MXWodemAttentionListPATH = @"api/news/attentionList";
//29-1取消关注
NSString *const MXWodemCancelAttenPATH = @"api/user/cancelAtten";
//30 发送评论
NSString *const MXWodemPostForumComPATH = @"api/news/postForumCom";
//31 互评
NSString *const MXWodemPostForumUserComPATH = @"api/news/postForumUserCom";
//32 只看楼主评论
NSString *const MXWodemForumOwnerCommentPATH = @"api/news/forumOwnerComment";
//33收藏论坛&&取消收藏
NSString *const MXWodemCollectForumPATH = @"api/news/collectAndCancelForum";
//64 点击用户头像查看用户的圈子话题和赛事观点
NSString *const MXWodemUserSquarePATH = @"api/news/squareUser";
//35 圈子话题
NSString *const MXWodemPersonalForumListPATH = @"api/news/personalForumList";
//36 名称堂 api/news/fameHall
NSString *const MXWodemFameHallPATH = @"api/news/fameHall";
//37 打赏列表 api/news/rewardInfo
NSString *const MXWodemRewardInfoPATH = @"api/news/rewardInfo";

NSString *const MXPublishOpinionPATH = @"api/event/postView";

NSString *const MXEventStatisticalPATH = @"api/event/eventLive";
// 101 打赏
NSString *const MXEventRewardUserPATH = @"api/news/rewardUser";
/************************* end ***********************************/

NSString *const MXPublishOpinionInitPATH =@"api/event/eventView";

NSString *const MXOpinionDetailPATH = @"api/event/geteventViewDetail";

NSString *const MXSupportOpinionPATH = @"api/event/suportOperation";

NSString *const MXUnlockedOpinionPATH = @"api/event/unlockOperation";

NSString *const MXGoalPATH =@"api/event/scoreDistribution";
@implementation MXNetWorkConfig

#pragma mark -- 首页
/**
 广告页
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getAds:(NSMutableDictionary *)parameters success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *error))failure {
    
    NSString *url = [SERVER_HOST stringByAppendingString:MXAds_PATH];
    NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
    [[WebManager sharedManager] requestWithMethod:GET WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        success(dic);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 首页数据
 
 @param parameters 参数
 @param success banner数组，快速通道，置顶两条文章，滚动资讯，赛事，倒计时图片
 @param failure <#failure description#>
 */
- (void)getHomeDataWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *banners, NSArray *access, NSArray *topnews, NSArray *rollnews, NSArray *mactchs, NSArray *countdown, MXLJShowInfo *info, NSArray *tagArr))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXHomeData_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        NSArray *bannerArr = [MXLJBanner mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"bannerList"]];
        NSArray *accessArr = [MXLJAccess mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"accessList"]];
        NSArray *topArr = [MXLJArticle mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"topNewsList"]];
        NSArray *newsArr = [MXLJRoll mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"rollNewsList"]];
        NSMutableArray *news = [NSMutableArray array];
        for (MXLJRoll *roll in newsArr) {
            [news addObject:roll.title];
        }
        NSArray *macthArr = [MXHomeSaishi mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"topMatchsList"]];
        NSArray *countdown = [MXLJConduct mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"conductList"]];
        MXLJShowInfo *info = [MXLJShowInfo mj_objectWithKeyValues:[data.data objectForKey:@"showInfo"]];
        
        NSArray *tagArr = [MXTagName mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"tagNmList"]];
        
        success(bannerArr, accessArr, topArr, news, macthArr, countdown, info, tagArr);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 官方资讯入口（官方资讯一览）
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOfficialNewsWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *newsList, NSArray *topList, MXSYJChannelModel *info))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXNews_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"dic\n%@", dic);
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        NSArray *channels = [MXSYJFocusOnModel mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"channelForumList"]];
        NSArray *tops = [MXSYJIsTopModel mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"topForumList"]];
        MXSYJChannelModel *info = [MXSYJChannelModel mj_objectWithKeyValues:[data.data objectForKey:@"channelInfo"]];
        
        success(channels, tops, info);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 首页资讯列表
 
 @param parameters <#parameters description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOfficialTagListParameters:(NSDictionary *)parameters success:(void (^)(NSArray *advertsList, NSArray *newsList))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXHomeNews_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        
        NSArray *advertsArr = [MXAdvert mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"adverts"]];
        NSArray *tempArr = [MXNews mj_objectArrayWithKeyValuesArray:[data.data objectForKey:@"newsList"]];
        for (MXNews *news in tempArr) {
            NSArray *imgArr = [MXForumImg mj_objectArrayWithKeyValuesArray:news.forumImgs];
            news.forumImgs = imgArr;
        }
        NSArray *newsArr = [NSArray arrayWithArray:tempArr];
        
        success(advertsArr, newsArr);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark -- 首页以下均弃用
/**
 banner
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getBannerWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *banners))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXBanner_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        NSArray *bannerArr = [MXLJBanner mj_objectArrayWithKeyValuesArray:data.data];
        success(bannerArr);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 快速通道
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getAccessWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *accessList))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXAccess_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        NSArray *accessArr = [MXLJAccess mj_objectArrayWithKeyValuesArray:data.data];
        success(accessArr);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 首页两条置顶官方文章（带图）
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOfficialTopNewsWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *newsList))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXTopNews_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        NSArray *newsArr = [MXLJArticle mj_objectArrayWithKeyValuesArray:data.data];
        success(newsArr);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 首页滚动官方资讯
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOfficialRollNewsWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *newsList))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXRollNews_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        NSArray *newsArr = [MXLJRoll mj_objectArrayWithKeyValuesArray:data.data];
        NSMutableArray *arr = [NSMutableArray array];
        for (MXLJRoll *roll in newsArr) {
            [arr addObject:roll.title];
        }
        success(arr);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 今日赛事

 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getSaiShiWithParameters:(NSDictionary *)parameters success:(void (^)(NSArray *saishiList))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXJRSaiShi_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"今日赛事你还没好？ dic\n%@", dic);
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        NSArray *saishi = [MXHomeSaishi mj_objectArrayWithKeyValuesArray:data.data];
        success(saishi);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

#pragma mark -- 我的
/**
 判断手机号是否被绑定
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)checkPhoneBindWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXCheckTelBind_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 获取短信验证码
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)sendCodeWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXSendCode_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 新用户注册

 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)reginsterWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXReginster_PATH];

    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 注册协议
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)lookProtocolWithParameters:(NSDictionary *)parameters success:(void (^)(MXProtocol *protocol))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXProtocol_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        MXProtocol *pro = [MXProtocol mj_objectWithKeyValues:data.data];
        success(pro);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 登录
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)loginWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXLogin_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 第三方登录
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)thirdLoginWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJSuccessData *data))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXThirdLogin_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        MXLJUser *user = [MXLJUser mj_objectWithKeyValues:data.data];
        
        NSLog(@"微信登录成功🐷\ndic:%@\nuser:%ld", dic, user.isFirstLogin);
        
        success(data);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 绑定手机号
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)bindPhoneWithParameters:(NSDictionary *)parameters success:(void (^)(MXLJUser *user, NSString *msg))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXBindPhone_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        MXLJUser *user = [MXLJUser mj_objectWithKeyValues:data.data];
        NSString *msg = [NSString string];
        NSLog(@"dic %@", data.code);
        if ([data.code integerValue] == 0) {
            msg = @"";
        } else {
            msg = data.msg;
        }
        success(user, msg);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 忘记密码
 
 @param parameters 参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)forgetPasswdWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *msg, NSString *code))success failure:(void (^)(NSString *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXForgetPasswd_PATH];
    
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:parameters WithSuccessBlock:^(NSDictionary *dic) {
        MXLJSuccessData *data = [MXLJSuccessData mj_objectWithKeyValues:dic];
        success(data.msg, data.code);
        
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

/**
 微信

 @param appid 应用唯一标识，在微信开放平台提交应用审核通过后获得
 @param secret 应用密钥AppSecret，在微信开放平台提交应用审核通过后获得
 @param code 用户换取access_token的code，仅在ErrCode为0时有效
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getWXLoginCodeWithAppid:(NSString *)appid secret:(NSString *)secret code:(NSString *)code success:(void (^)(NSString *msg))success failure:(void (^)(NSString *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appid forKey:@"appid"];
    [params setObject:secret forKey:@"secret"];
    [params setObject:code forKey:@"code"];
    [params setObject:@"authorization_code" forKey:@"grant_type"];
    
    @weakSelf(self);
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token"];
    [[WebManager sharedManager] requestWithMethod:GET WithUrl:url WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        
        NSLog(@"信息  %@", dic);
        [weakSelf requestUserInfoByToken:[dic valueForKey:@"access_token"] openId:[dic valueForKey:@"openid"] success:^(BOOL isSuccess) {
            
            success(@"");
        } failure:^(NSString *error) {
            success(error);
        }];
        
    } WithFailureBlock:^(NSError *error) {
        NSLog(@"登录失败 error:%@", error);
        failure(error.localizedDescription);
    }];
}


/**
 获取微信用户信息

 @param token <#token description#>
 @param openId <#openId description#>
 */
- (void)requestUserInfoByToken:(NSString *)token openId:(NSString *)openId success:(void (^)(BOOL isSuccess))success failure:(void (^)(NSString *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:token forKey:@"access_token"];
    [params setObject:openId forKey:@"openid"];
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo"];
    [[WebManager sharedManager] requestWithMethod:GET WithUrl:url WithParams:params WithSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"登录成功啦啦啦啦 dic %@", dic);
        MXLJThirdData *data = [MXLJThirdData mj_objectWithKeyValues:dic];
        NSLog(@"我的微信信息 ：%@", data);
        
        NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *listPath = [listFile stringByAppendingPathComponent:@"wechat.plist"];
        
        //将微信用户信息存到本地
        [NSKeyedArchiver archiveRootObject:data toFile:listPath];
        
        success(YES);
        
    } WithFailureBlock:^(NSError *error) {
        NSLog(@"失败啊啊啊 error:%@", error.localizedDescription);
        failure(error.localizedDescription);
    }];
}

/**
 个人中心
 @param userId 用户ID
 @param token token
 @param time  当前Unix时间戳
 @param sign  签名
 */
- (void)personWithUserid:(NSString *)userId token:(NSString *)token time:(NSString *)time sign:(NSString *)sign success:(void (^)(NSDictionary *personDic))success failure:(void (^)(NSString *error))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:userId forKey:@"userId"];
    [parameters setObject:token forKey:@"token"];
    [parameters setObject:time forKey:@"time"];
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_HOST, MXWodePersonal_PATH];
    NSMutableDictionary *dic= [MXLJUtil sortedDictionary:parameters];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
//        NSLog(@"个人中心：=%@",dic);
        success(dic);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}

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
- (void)ModifyPersonMessagesWithDIC:(NSMutableDictionary *)dic withUrl:(NSString *)url success:(void (^)(NSDictionary *personDic))success failure:(void (^)(NSString *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_HOST, url];
    NSMutableDictionary *dics= [MXLJUtil sortedDictionary:dic];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:urlStr WithParams:dics WithSuccessBlock:^(NSDictionary *dic) {
         success(dic);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}
/**
 消息中心  发帖 跟帖 收藏文章 粉丝列表 粉丝关注按钮
 userId
 token
 time
 sign
 */
- (void)sMessageCenterWithDic:(NSMutableDictionary *)paramDic urlStr:(NSString *)url success:(void (^)(NSDictionary *personDic))success failure:(void (^)(NSString *error))failure{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", SERVER_HOST, url];
     NSMutableDictionary *dic= [MXLJUtil sortedDictionary:paramDic];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:urlStr WithParams:dic WithSuccessBlock:^(NSDictionary *dic) {
        NSLog(@"%@",dic);
        success(dic);
    } WithFailureBlock:^(NSError *error) {
        failure(error.localizedDescription);
    }];
}
@end
