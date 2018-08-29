//
//  MXSSMyVoteYESSettledTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//投票已结算cell

#import <UIKit/UIKit.h>
#import "MXssPostModel.h"
@interface MXSSMyVoteYESSettledTableViewCell : UITableViewCell
//@property (nonatomic,strong) UIImageView *myVoteYESSettledImage;//我的投票已结算图
//@property (nonatomic,strong) UIView *zongViewl;//我的投票已结算的右边总
//@property (nonatomic,strong) UILabel *myVoteYESSettledTitleNameLabel;//我的投票已结算昵称
//@property (nonatomic,strong) UILabel *myVoteYESSettledContentLabel;//我的投票已结算内容
//@property (nonatomic,strong) UILabel *myVoteYESSettledZanLabel;//我的投票已结算的点赞数
//@property (nonatomic,strong) UILabel *myVoteYESSettledSeeLabel;//我的投票已结算的阅读数
//@property (nonatomic,strong) UILabel *myVoteYESSettledTimeLabel;//我的投票已结算时间
//@property (nonatomic,strong) UIImageView *myVoteYESSettledZanImage;//我的投票已结算的点赞图
//@property (nonatomic,strong) UIImageView *myVoteYESSettledSeeImage;//我的投票已结算的阅读图
//@property (nonatomic,strong) UIImageView *myVoteYESSettledTimeImage;//我的投票已结算的时间图
@property (nonatomic,strong) UIImageView *myVoteYESSettledTouImage;//头像
@property (nonatomic,strong) UILabel *myVoteYESSettledTitleNameLabel;//标题
@property (nonatomic,strong) UILabel *myVoteYESSettledContentLabel;//内容
@property (nonatomic,strong) UILabel *myVoteYESSettledNameLabel;//参与人名字
//@property (nonatomic,strong) UILabel *myOpinionYESSettledTimeLabel;//时间显示 03-07 12:30
@property (nonatomic,strong) UILabel *myVoteYESSettledNumberLabel;//数量
@property (nonatomic,strong) UIImageView *myVoteYESSettledXinImage;//❤️ 图
@property (nonatomic,strong) UIImageView *myVoteYESSettledOrNoSuoImage;//🔐解锁图案
@property (nonatomic,strong) UIImageView *myVoteYESSettledOrNoBigImage;//大图 输赢
@property (nonatomic,strong) MXssPostModel *datemodel;
@end
