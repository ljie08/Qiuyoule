//
//  MXHomeVM.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeVM.h"

@implementation MXHomeVM

- (instancetype)init {
    if (self = [super init]) {
        _user = [[MXLJUser alloc] init];
        NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *listPath = [listFile stringByAppendingPathComponent:MXUSER_DATA];
        _user = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
        
        _bannerList = [NSMutableArray array];
        _accessList = [NSMutableArray array];
        _topList = [NSMutableArray array];
        _rollList = [NSMutableArray array];
        _channelList = [NSMutableArray array];
        _officialTopList = [NSMutableArray array];
        _info = [[MXSYJChannelModel alloc] init];
        _saishiList = [NSMutableArray array];
        
        _countdown = [[MXLJCountDown alloc] init];
        _conduct = [[MXLJConduct alloc] init];
        _showinfo = [[MXLJShowInfo alloc] init];
        
        _page = 1;
        _passtime = 0.0;
        _chatime = 0.0;
        _isShow = YES;
        _num = 10;
        
        //1.2
        _tagArr = [NSMutableArray array];
        _nameArr = [NSMutableArray array];
        _newsArr = [NSMutableArray array];
        _advertsArr = [NSMutableArray array];
        _dataArr = [NSMutableArray array];
    }
    return self;
}

/**
 首页数据
 
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getHomeDataWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config getHomeDataWithParameters:allParams success:^(NSArray *banners, NSArray *access, NSArray *topnews, NSArray *rollnews, NSArray *mactchs, NSArray *countdown, MXLJShowInfo *info, NSArray *tagArr) {
        //banner
        if (weakSelf.bannerList.count) {
            [weakSelf.bannerList removeAllObjects];
        }
        [weakSelf.bannerList addObjectsFromArray:banners];
        //快速通道
        if (weakSelf.accessList.count) {
            [weakSelf.accessList removeAllObjects];
        }
        [weakSelf.accessList addObjectsFromArray:access];
        //置顶文章
        if (weakSelf.topList.count) {
            [weakSelf.topList removeAllObjects];
        }
        [weakSelf.topList addObjectsFromArray:topnews];
        //滚动资讯
        if (weakSelf.rollList.count) {
            [weakSelf.rollList removeAllObjects];
        }
        [weakSelf.rollList addObjectsFromArray:rollnews];
        //今日赛事
        if (weakSelf.saishiList.count) {
            [weakSelf.saishiList removeAllObjects];
        }
        [weakSelf.saishiList addObjectsFromArray:mactchs];
        //倒计时
        if (countdown.count) {
            weakSelf.conduct = countdown[0];
        }
        //显示状态 1显示 0不显示
        info.showStatus = 0;
        weakSelf.showinfo = info;
        if (info.showStatus) {
            weakSelf.isShow = YES;
        } else {
            weakSelf.isShow = NO;
        }
        
        if (weakSelf.tagArr.count) {
            [weakSelf.tagArr removeAllObjects];
        }
        [weakSelf.tagArr addObjectsFromArray:tagArr];
        
        if (weakSelf.nameArr.count) {
            [weakSelf.nameArr removeAllObjects];
        }
        for (MXTagName *tag in weakSelf.tagArr) {
            [weakSelf.nameArr addObject:tag.tagName];
        }
        
#pragma mark - 隐藏
        //隐藏mingrt
//        if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue] > 0) {
//        }
        NSMutableArray *tempArr = [NSMutableArray array];
        [tempArr addObjectsFromArray:weakSelf.accessList];
        for (MXLJAccess *acc in weakSelf.accessList) {
            if (acc.accessId == 3) {
                [tempArr removeObject:acc];
            }
        }
        weakSelf.accessList = tempArr;
        
        success(YES);
    } failure:^(NSString *error) {
        failture(error);
    }];;
}

#pragma mark -- 毫秒倒计时
//获取时间差
- (void)getChaTime {
    //当前时间
    NSString *currentStr = [MXLJUtil getNowDateTimeString];//获取当前时间戳
    NSDate *currentDate = [MXLJUtil dateStrToDate:currentStr];//时间戳转date
    //比赛开始时间6月14日23点00分
    //测试修改这一处的时间即可
    NSDate *matchDate = [MXLJUtil dateStrToDate:@"1528988400"];
    
    self.chatime = [matchDate timeIntervalSinceDate:currentDate]*1000;
}

//将时间差转换为天、时、分、秒、毫秒显示
- (void)getChaData {
    self.passtime += 100.0;
    //时间差转换为天、时、分、秒、毫秒显示
    self.countdown = [MXLJUtil getCountDownFromFutureTime:self.chatime passTime:self.passtime];
    
    if (self.countdown.dayNum > 0) {
        self.countdown.showType = 1;//6.14日之前，显示蓝色
    }
    if (self.countdown.dayNum == 0 && self.countdown.hourNum >= 0 && self.countdown.minuteNum >= 0 && self.countdown.secondNum >= 0 && self.countdown.millisecondNum >= 0) {
        self.countdown.showType = 2;//6.14当天23点之前，显示黄色
    }
    if (self.countdown.dayNum < 0 || self.countdown.hourNum < 0 || self.countdown.minuteNum < 0 || self.countdown.secondNum < 0 || self.countdown.millisecondNum < 0 || self.chatime < 0) {//23点之后，比赛已经开始
        self.countdown.showType = 3;
    }
    
}

//1.2
/**
 首页官方资讯（tag切换）
 
 @param isRefresh <#isRefresh description#>
 @param type <#type description#>
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getHomeNewsWithRefresh:(BOOL)isRefresh type:(NSInteger)type success:(void (^)(BOOL result))success failture:(void (^)(NSString *error))failture {
    if (isRefresh) {
        self.page = 1;
    } else {
        self.page++;
    }
    
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    //page 分页起始位置(1,2,3...)
    //limit 分页条数(>0)
    //默认分页是page=1,limit=10
    //opid 1:全部，2：最新热帖，3：历史置顶
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"opid"];
    [parameters setObject:[NSNumber numberWithInteger:self.page] forKey:@"page"];
    
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    NSLog(@"all😯 %@", allParams);
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config getOfficialTagListParameters:allParams success:^(NSArray *advertsList, NSArray *newsList) {
//        if (weakSelf.newsArr.count && isRefresh) {
//            [weakSelf.newsArr removeAllObjects];
//        }
//        [weakSelf.newsArr addObjectsFromArray:newsList];
//
//        if (weakSelf.advertsArr.count && isRefresh) {
//            [weakSelf.advertsArr removeAllObjects];
//        }
//        [weakSelf.advertsArr addObjectsFromArray:advertsList];
        
        if (weakSelf.dataArr.count && isRefresh) {
            [weakSelf.dataArr removeAllObjects];
        }
        [weakSelf.dataArr addObjectsFromArray:newsList];
        if (advertsList.count) {
            MXAdvert *ad = advertsList[0];
            MXNews *news = [[MXNews alloc] init];
            news.advertPic = ad.advertPic;
            news.advertId = ad.advertId;
            news.targetUrl = ad.targetUrl;
            [weakSelf.dataArr addObject:news];
        }
        
        success(YES);
        
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 官方资讯入口（官方资讯一览）
 
 @param isRefresh 是否刷新
 @param type 1:全部，2：最新热帖，3：历史置顶
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getNewsWithRefresh:(BOOL)isRefresh type:(NSInteger)type success:(void (^)(BOOL result))success failture:(void (^)(NSString *error))failture {
    
    if (isRefresh) {
        self.page = 1;
    } else {
        self.page++;
    }
    
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    //page 分页起始位置(1,2,3...)
    //limit 分页条数(>0)
    //默认分页是page=1,limit=10
    //opid 1:全部，2：最新热帖，3：历史置顶
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSNumber numberWithInteger:self.page] forKey:@"page"];
    [parameters setObject:[NSNumber numberWithInteger:type] forKey:@"opid"];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    NSLog(@"all😯 %@", allParams);
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config getOfficialNewsWithParameters:allParams success:^(NSArray *newsList, NSArray *topList, MXSYJChannelModel *info) {
        if (weakSelf.channelList.count && isRefresh) {
//            if (isRefresh) {//刷新的时候清空一下再添加数据
            [weakSelf.channelList removeAllObjects];
//            }
            //加载更多的时候直接将新数据添加到数组
        }
        [weakSelf.channelList addObjectsFromArray:newsList];
        
        if (isRefresh) {//刷新置顶和资讯信息，加载更多的时候数据不用重新赋值
            if (weakSelf.officialTopList.count) {
                [weakSelf.officialTopList removeAllObjects];
            }
            [weakSelf.officialTopList addObjectsFromArray:topList];
            
            weakSelf.info = info;
        }
        
        success(YES);
        
    } failure:^(NSString *error) {
        failture(error);
    }];
}

#pragma mark --- 以下均弃用
//判断比赛是否已结束
//根据MXLJShowInfo来确定是否显示，故此方法弃用
- (void)matchEnd {
    //此处为比赛结束时间戳1531508400
    //7.14 03:00:00
    NSString *time = @"1531508400";
    
    NSDateComponents *date = [MXLJUtil dateFromNowToFutureTime:time];
    
    if (date.day < 0 || date.hour < 0 || date.minute < 0 || date.second < 0) {//7.14 03：00点之后，比赛结束
        self.isShow = NO;
    }
}

//毫秒倒计
- (void)countDownSecond {
    self.num--;
    if (self.num == 0) {
        self.num = 9;
    }
    self.countdown.millisecond = [NSString stringWithFormat:@"0%d", self.num];
}

/**
 倒计时 只到秒（已弃用）
 */
- (void)getCountDown {
    //1528988400 2018.06.14 23:00:00 bisbis
    //1526310000 5.14比赛已经开始
    //1526655600 5.18比赛当天未开始
    //修改此处比赛开始时间，记得同时修改首页vc里setTimer方法里的时间戳为同一天00点00分的时间戳，比如比赛开始时间为6月14日23点00分，首页的时间须为6月14日00点00分的时间戳
    //之前写的是比赛开始当天0点开始显示毫秒计时，现已改为比赛开始前24小时显示毫秒，即showType为2的时候
    NSString *time = @"1528988400";
    
    NSDateComponents *date = [MXLJUtil dateFromNowToFutureTime:time];
    
    //小于10的时候前面加0，比如01天00时08分01秒
    self.countdown.day = date.day > 9 ? [NSString stringWithFormat:@"%ld", date.day] : [NSString stringWithFormat:@"0%ld", date.day];
    self.countdown.hour = date.hour > 9 ? [NSString stringWithFormat:@"%ld", date.hour] : [NSString stringWithFormat:@"0%ld", date.hour];
    self.countdown.minute = date.minute > 9 ? [NSString stringWithFormat:@"%ld", date. minute] : [NSString stringWithFormat:@"0%ld", date. minute];
    self.countdown.second = date.second > 9 ? [NSString stringWithFormat:@"%ld", date.second] : [NSString stringWithFormat:@"0%ld", date.second];
    //    self.countdown.millisecond = [NSString stringWithFormat:@"%ld", date.nanosecond/1000000];
    if (date.day > 0) {
        self.countdown.showType = 1;//6.14日之前，显示蓝色
    }
    if (date.day == 0 && date.hour >= 0 && date.minute >= 0 && date.second >= 0) {
        self.countdown.showType = 2;//6.14当天23点之前，显示黄色
    }
    if (date.day < 0 || date.hour < 0 || date.minute < 0 || date.second < 0) {//23点之后，比赛已经开始
        self.countdown.showType = 3;
    }
}

/**
 banner
 
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getBannerWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@1 forKey:@"locationId"];//banner位置ID（1：首页，默认为1）
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config getBannerWithParameters:allParams success:^(NSArray *banners) {
        if (weakSelf.bannerList.count) {
            [weakSelf.bannerList removeAllObjects];
        }
        [weakSelf.bannerList addObjectsFromArray:banners];
        
        success(YES);
    } failure:^(NSString *error) {
        failture(error);
    }];
}


/**
 快速通道
 
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getAccessWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config getAccessWithParameters:allParams success:^(NSArray *accessList) {
        if (weakSelf.accessList.count) {
            [weakSelf.accessList removeAllObjects];
        }
        [weakSelf.accessList addObjectsFromArray:accessList];
        
        success(YES);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 首页两条置顶官方文章（带图）

 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getTopNewsWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config getOfficialTopNewsWithParameters:allParams success:^(NSArray *newsList) {
        if (weakSelf.topList.count) {
            [weakSelf.topList removeAllObjects];
        }
        [weakSelf.topList addObjectsFromArray:newsList];
        
        success(YES);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 首页滚动官方资讯

 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getRollNewsWithSuccess:(void (^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config getOfficialRollNewsWithParameters:allParams success:^(NSArray *newsList) {
        if (weakSelf.rollList.count) {
            [weakSelf.rollList removeAllObjects];
        }
        [weakSelf.rollList addObjectsFromArray:newsList];
        
        success(YES);
    } failure:^(NSString *error) {
        failture(error);
    }];
}

/**
 今日赛事
 
 @param isRefresh 刷新
 @param success <#success description#>
 @param failture <#failture description#>
 */
- (void)getSaishiWithRefresh:(BOOL)isRefresh success:(void (^)(BOOL result))success failture:(void (^)(NSString *error))failture {
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    
    //page 分页起始位置(1,2,3...)
    //limit 分页条数(>0)
    //默认分页是page=1,limit=10
    //opid 1:全部，2：最新热帖，3：历史置顶
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:timeStr forKey:@"time"];
    
    NSMutableDictionary *allParams = [MXLJUtil sortedDictionary:parameters];
    NSLog(@"all😯 %@", allParams);
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    
    @weakSelf(self);
    [config getSaiShiWithParameters:allParams success:^(NSArray *saishiList) {
        if (weakSelf.saishiList.count) {
            [weakSelf.saishiList removeAllObjects];
        }
        [weakSelf.saishiList addObjectsFromArray:saishiList];
        success(YES);
        NSLog(@"haaa");
    } failure:^(NSString *error) {
        failture(error);
    }];
}

@end
