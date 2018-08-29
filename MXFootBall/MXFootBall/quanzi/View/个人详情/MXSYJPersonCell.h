//
//  MXSYJPersonCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJSaisiModel.h"

@interface MXSYJPersonCell : UITableViewCell

/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLab;
/** 等级 */
@property (nonatomic, strong) UILabel *levelLab;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;
/** 盘口 */
@property (nonatomic, strong) UILabel *dishLab;
/** 内容 */
@property (nonatomic, strong) UILabel *contentLab;
/** 是否隐藏观点 */
@property (nonatomic, strong) UIImageView *lockImg;
/** 输赢 */
@property (nonatomic, strong) UILabel *winOrLoseLab;

@property (nonatomic, strong) MXSYJSaisiModel *model;

@end
