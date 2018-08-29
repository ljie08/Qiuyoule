//
//  MXSSMyOpinionYESSettledTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//观点已结算cell

#import <UIKit/UIKit.h>
#import "MXssPostModel.h"
#import "MXDViewpointModel.h" //赛事观点
@interface MXSSMyOpinionYESSettledTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *myOpinionYESSettledTouImage;//头像
@property (nonatomic,strong) UILabel *myOpinionYESSettledTitleNameLabel;//标题
@property (nonatomic,strong) UILabel *myOpinionYESSettledContentLabel;//内容
@property (nonatomic,strong) UILabel *myOpinionYESSettledNameLabel;//参与人名字
//@property (nonatomic,strong) UILabel *myOpinionYESSettledTimeLabel;//时间显示 03-07 12:30
@property (nonatomic,strong) UILabel *myOpinionYESSettledNumberLabel;//数量
@property (nonatomic,strong) UIImageView *myOpinionYESSettledXinImage;//❤️ 图
@property (nonatomic,strong) UIImageView *myOpinionYESSettledOrNoSuoImage;//🔐解锁图案
@property (nonatomic,strong) UIImageView *myOpinionYESSettledOrNoBigImage;//大图 输赢
//@property (nonatomic,strong) UIImageView *myOpinionYESSettledImage;//我的观点已结算图
//@property (nonatomic,strong) UIView *zongViewl;//我的观点已结算的右边总
//@property (nonatomic,strong) UILabel *myOpinionYESSettledTitleNameLabel;//我的观点已结算昵称
//@property (nonatomic,strong) UILabel *myOpinionYESSettledContentLabel;//我的观点已结算内容
//@property (nonatomic,strong) UILabel *myOpinionYESSettledZanLabel;//我的观点已结算的点赞数
//@property (nonatomic,strong) UILabel *myOpinionYESSettledSeeLabel;//我的观点已结算的阅读数
//@property (nonatomic,strong) UILabel *myOpinionYESSettledTimeLabel;//我的观点已结算时间
//@property (nonatomic,strong) UIImageView *myOpinionYESSettledZanImage;//我的观点已结算的点赞图
//@property (nonatomic,strong) UIImageView *myOpinionYESSettledSeeImage;//我的观点已结算的阅读图
//@property (nonatomic,strong) UIImageView *myOpinionYESSettledTimeImage;//我的观点已结算的时间图

@property (nonatomic,strong) MXssPostModel *datemodel;

@property (nonatomic , strong) MXDViewpointModel * eventViewpointModel ;//赛事观点
@property (nonatomic , strong) NSString * matchStatus ;//比赛状态
@end
