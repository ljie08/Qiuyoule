//
//  MXSSMessageTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssMessageModel.h"
@interface MXSSMessageTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *topView;//白色view
@property (nonatomic,strong) UIImageView *messageImage;//消息图片
@property (nonatomic,strong) UILabel *messageTitleNameLabel;//消息标题
@property (nonatomic,strong) UILabel *messageContentLabel;//消息内容
@property (nonatomic,strong) UILabel *messageTimeLabel;//消息时间

@property (nonatomic,strong) MXssMessageModel *datemodel;
@end
