//
//  MXssIntegralListTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//积分明细页面cell

#import "MXssIntegralListTableViewCell.h"

@implementation MXssIntegralListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.integralTitleLabel];//积分标题
        [self.contentView addSubview:self.integralNumberLabel];//积分数 +30
        [self.contentView addSubview:self.integralNumberSumLabel];//积分：总
        [self.contentView addSubview:self.integralTimeLabel];//积分时间
    }
    return self;
}
//数据
//- (void)setDatemodel:(MXssFansModel *)datemodel {
//    _datemodel = datemodel;
//
//}

- (UILabel *)integralTitleLabel {//积分标题
    if (_integralTitleLabel == nil) {
        _integralTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), 10, screen_width - scaleWithSize(70) - scaleWithSize(15)*2, scaleWithSize(20))];
        _integralTitleLabel.text = @"打赏***文章";
        _integralTitleLabel.textColor = mx_Wode_color333333;
        _integralTitleLabel.font = fontSize(scaleWithSize(14.0f));
        //        _fansNickNameLabel.backgroundColor = [UIColor yellowColor];
    }
    return _integralTitleLabel;
}
- (UILabel *)integralNumberSumLabel {//积分：总
    if (_integralNumberSumLabel == nil) {
        _integralNumberSumLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), _integralTitleLabel.maxY + scaleWithSize(0), screen_width - scaleWithSize(70) - scaleWithSize(15)*2, scaleWithSize(20))];
        _integralNumberSumLabel.text = @"积分：222141";
        _integralNumberSumLabel.font = fontSize(scaleWithSize(11.0f));
        _integralNumberSumLabel.textColor = mx_Wode_color999999;
    }
    return _integralNumberSumLabel;
}
- (UILabel *)integralNumberLabel {//积分数 +30
    if (_integralNumberLabel == nil) {
        _integralNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(70) - scaleWithSize(15), _integralTitleLabel.maxY + scaleWithSize(0), scaleWithSize(70), scaleWithSize(20))];
        _integralNumberLabel.text = @"+30";
        _integralNumberLabel.textAlignment = 2;
        _integralNumberLabel.font = fontSize(scaleWithSize(14.0f));
        _integralNumberLabel.textColor = mx_Wode_color333333;
    }
    return _integralNumberLabel;
}
- (UILabel *)integralTimeLabel {//积分时间
    if (_integralTimeLabel == nil) {
        _integralTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(140) - scaleWithSize(15), 10, scaleWithSize(140), scaleWithSize(20))];
        _integralTimeLabel.text = @"2018-03-30";
        _integralTimeLabel.textAlignment = 2;
        _integralTimeLabel.backgroundColor = [UIColor clearColor];
        _integralTimeLabel.font = fontSize(scaleWithSize(11.0f));
        _integralTimeLabel.textColor = mx_Wode_color999999;
    }
    return _integralTimeLabel;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
