//
//  MXBattleDetailsViewController.h
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "WMPageController.h"

typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
};

@interface MXBattleDetailsViewController : WMPageController

@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;

@property (nonatomic, assign) NSInteger matchId ;//赛事id

@property (nonatomic, strong) NSString * titleString ;//赛事名eventNm

@property (nonatomic, copy) NSString *yesOrNoButton;//返回按钮的显示


@property (nonatomic , copy) NSString * homeNm ;//主队名
@property (nonatomic , copy) NSString * homeScore ;//主队比分
@property (nonatomic , copy) NSString * homeLogo ;//主队logo

@property (nonatomic , copy) NSString * awayNm ;//客队名
@property (nonatomic , copy) NSString * awayScore ;//客队比分
@property (nonatomic , copy) NSString * awayLogo ;//客队logo

@property (nonatomic , copy) NSString * matchStartTime ;//开始时间
//@property (nonatomic , assign) int matchStatus ;//比赛状态
@property (nonatomic , assign) int status ; //比赛状态

@property (nonatomic , assign) NSInteger flashFlg ;//是否有动画（0：无  1：有）

@property (nonatomic , assign) NSInteger bulletCsmScore ;//发弹幕需消耗的积分值


@property (nonatomic , assign) NSInteger bulletMinLv ;//发弹幕需要等级
@property (nonatomic , assign) NSInteger chatMinLv ;//聊天需要等级


@end
