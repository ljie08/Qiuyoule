//
//  MXSSMyVoteNOSettledTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssPostModel.h"
@interface MXSSMyVoteNOSettledTableViewCell : UITableViewCell
//@property (nonatomic,strong) UIImageView *myVoteNOSettledImage;//我的投票待结算图
//@property (nonatomic,strong) UIView *zongViewl;//我的投票待结算的右边总
//@property (nonatomic,strong) UILabel *myVoteNOSettledTitleNameLabel;//我的投票待结算昵称
//@property (nonatomic,strong) UILabel *myVoteNOSettledContentLabel;//我的投票待结算内容
//@property (nonatomic,strong) UILabel *myVoteNOSettledZanLabel;//我的投票待结算的点赞数
//@property (nonatomic,strong) UILabel *myVoteNOSettledSeeLabel;//我的投票待结算的阅读数
//@property (nonatomic,strong) UILabel *myVoteNOSettledTimeLabel;//我的投票待结算时间
//@property (nonatomic,strong) UIImageView *myVoteNOSettledZanImage;//我的投票待结算的点赞图
//@property (nonatomic,strong) UIImageView *myVoteNOSettledSeeImage;//我的投票待结算的阅读图
//@property (nonatomic,strong) UIImageView *myVoteNOSettledTimeImage;//我的投票待结算的时间图
@property (nonatomic,strong) UIImageView *myVoteNOSettledTouImage;//头像
@property (nonatomic,strong) UILabel *myVoteNOSettledTitleNameLabel;//标题
@property (nonatomic,strong) UILabel *myVoteNOSettledContentLabel;//内容
@property (nonatomic,strong) UILabel *myVoteNOSettledNameLabel;//参与人名字
//@property (nonatomic,strong) UILabel *myOpinionYESSettledTimeLabel;//时间显示 03-07 12:30
@property (nonatomic,strong) UILabel *myVoteNOSettledNumberLabel;//数量
@property (nonatomic,strong) UIImageView *myVoteNOSettledXinImage;//❤️ 图
@property (nonatomic,strong) UIImageView *myVoteNOSettledOrNoSuoImage;//🔐解锁图案
@property (nonatomic,strong) UIImageView *myVoteNOSettledOrNoBigImage;//大图 输赢
@property (nonatomic,strong) MXssPostModel *datemodel;
@end
