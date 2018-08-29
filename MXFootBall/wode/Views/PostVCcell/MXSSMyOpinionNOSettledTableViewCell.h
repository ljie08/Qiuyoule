//
//  MXSSMyOpinionNOSettledTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssPostModel.h"

@interface MXSSMyOpinionNOSettledTableViewCell : UITableViewCell
//@property (nonatomic,strong) UIImageView *myOpinionNOSettledImage;//我的观点待结算图
//@property (nonatomic,strong) UIView *zongViewl;//我的观点待结算的右边总
//@property (nonatomic,strong) UILabel *myOpinionNOSettledTitleNameLabel;//我的观点待结算昵称
//@property (nonatomic,strong) UILabel *myOpinionNOSettledContentLabel;//我的观点待结算内容
//@property (nonatomic,strong) UILabel *myOpinionNOSettledZanLabel;//我的观点待结算的点赞数
//@property (nonatomic,strong) UILabel *myOpinionNOSettledSeeLabel;//我的观点待结算的阅读数
//@property (nonatomic,strong) UILabel *myOpinionNOSettledTimeLabel;//我的观点待结算时间
//@property (nonatomic,strong) UIImageView *myOpinionNOSettledZanImage;//我的观点待结算的点赞图
//@property (nonatomic,strong) UIImageView *myOpinionNOSettledSeeImage;//我的观点待结算的阅读图
//@property (nonatomic,strong) UIImageView *myOpinionNOSettledTimeImage;//我的观点待结算的时间图
@property (nonatomic,strong) UIImageView *myOpinionNOSettledTouImage;//头像
@property (nonatomic,strong) UILabel *myOpinionNOSettledTitleNameLabel;//标题
@property (nonatomic,strong) UILabel *myOpinionNOSettledContentLabel;//内容
@property (nonatomic,strong) UILabel *myOpinionNOSettledNameLabel;//参与人名字
//@property (nonatomic,strong) UILabel *myOpinionYESSettledTimeLabel;//时间显示 03-07 12:30
@property (nonatomic,strong) UILabel *myOpinionNOSettledNumberLabel;//数量
@property (nonatomic,strong) UIImageView *myOpinionNOSettledXinImage;//❤️ 图
@property (nonatomic,strong) UIImageView *myOpinionNOSettledOrNoSuoImage;//🔐解锁图案
@property (nonatomic,strong) UIImageView *myOpinionNOSettledOrNoBigImage;//大图 输赢
@property (nonatomic,strong) MXssPostModel *datemodel;
@end
