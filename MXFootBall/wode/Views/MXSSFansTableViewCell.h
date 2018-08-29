//
//  MXSSFansTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssFansModel.h"
@interface MXSSFansTableViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *fansTouImageLabel;//粉丝头像
@property (nonatomic,strong) UILabel *fansNickNameLabel;//粉丝昵称
@property (nonatomic,strong) UILabel *fansGradeLabel;//粉丝等级
@property (nonatomic,strong) UILabel *fansSignatureLabel;//粉丝签名
@property (nonatomic,strong) UIButton *fansGuanzhuBut;//粉丝关注按钮
@property (nonatomic,strong) MXssFansModel *datemodel;

@end
