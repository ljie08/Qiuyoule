//
//  MXssMyPostTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssPostModel.h"
@interface MXssMyPostTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *myPostImage;//我的发帖图
@property (nonatomic,strong) UIView *zongViewl;//我的发帖的右边总
@property (nonatomic,strong) UILabel *myPostTitleNameLabel;//我的发帖昵称
@property (nonatomic,strong) UILabel *myPostContentLabel;//我的发帖内容
@property (nonatomic,strong) UILabel *myPostZanLabel;//我的发帖的点赞数
@property (nonatomic,strong) UILabel *myPostSeeLabel;//我的发帖的阅读数
@property (nonatomic,strong) UILabel *myPostTimeLabel;//我的发帖时间
@property (nonatomic,strong) UIImageView *myPostZanImage;//我的发帖的点赞图
@property (nonatomic,strong) UIImageView *myPostSeeImage;//我的发帖的阅读图
@property (nonatomic,strong) UIImageView *myPostTimeImage;//我的发帖的时间图
@property (nonatomic,strong) UIView *numberSumView;//时间总view
@property (nonatomic,strong) MXssPostModel *datemodel;
@end
