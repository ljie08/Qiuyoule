//
//  MXssIntegralListTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXssIntegralListTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *integralTitleLabel;//积分标题
@property (nonatomic,strong) UILabel *integralNumberLabel;//积分数 +30
@property (nonatomic,strong) UILabel *integralNumberSumLabel;//积分：总
@property (nonatomic,strong) UILabel *integralTimeLabel;//积分时间
//@property (nonatomic,strong) MXssFansModel *datemodel;
@end
