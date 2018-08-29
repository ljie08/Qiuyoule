//
//  MXSSFansTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSFansTableViewCell.h"

@implementation MXSSFansTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.fansTouImageLabel];//粉丝头像
        [self.contentView addSubview:self.fansNickNameLabel];//粉丝昵称
        [self.contentView addSubview:self.fansGradeLabel];//粉丝等级
        [self.contentView addSubview:self.fansSignatureLabel];//粉丝签名
        [self.contentView addSubview:self.fansGuanzhuBut];//粉丝关注按钮
    }
    return self;
}
//数据
- (void)setDatemodel:(MXssFansModel *)datemodel {
    _datemodel = datemodel;
    
}
- (UIImageView *)fansTouImageLabel {//粉丝头像
    if (_fansTouImageLabel == nil) {
        _fansTouImageLabel = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(10), scaleWithSize(50), scaleWithSize(50))];
//        _fansTouImageLabel.backgroundColor = [UIColor grayColor];
        _fansTouImageLabel.image = [UIImage imageNamed:@"saishi_morentouxiang"];
        _fansTouImageLabel.layer.cornerRadius = scaleWithSize(50/2.0f);
        _fansTouImageLabel.layer.masksToBounds = YES;
    }
    return _fansTouImageLabel;
}
- (UIButton *)fansGuanzhuBut {
    if (_fansGuanzhuBut == nil) {
        _fansGuanzhuBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _fansGuanzhuBut.frame = CGRectMake(screen_width - scaleWithSize(70), scaleWithSize(70) / 2 - scaleWithSize(15), scaleWithSize(60), scaleWithSize(30));
//        [_fansGuanzhuBut setImage:[UIImage imageNamed:@"my_guangzhu"] forState:UIControlStateNormal];
//        [_fansGuanzhuBut setImage:[UIImage imageNamed:@"my_meiguangzhu"] forState:UIControlStateSelected];
         [_fansGuanzhuBut setBackgroundImage:[UIImage imageNamed:@"my_yiguan"] forState:UIControlStateNormal];
//        [_fansGuanzhuBut setTitle:@"＋关注" forState:UIControlStateNormal];
//        [_fansGuanzhuBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _fansGuanzhuBut.backgroundColor = mx_Wode_color16a635;
        _fansGuanzhuBut.titleLabel.font = fontSize(scaleWithSize(14.0f));
    }
    return _fansGuanzhuBut;
}
- (UILabel *)fansNickNameLabel {//粉丝昵称
    if (_fansNickNameLabel == nil) {
        _fansNickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_fansTouImageLabel.maxX + scaleWithSize(10), 10, screen_width - _fansTouImageLabel.maxX - scaleWithSize(60) - scaleWithSize(15)*2, scaleWithSize(20))];
        _fansNickNameLabel.text = @"小哲DBD";
        _fansNickNameLabel.textColor = mx_Wode_color333333;
        _fansNickNameLabel.font = fontSize(scaleWithSize(14.0f));
//        _fansNickNameLabel.backgroundColor = [UIColor yellowColor];
    }
    return _fansNickNameLabel;
}

- (UILabel *)fansGradeLabel {//粉丝等级
    if (_fansGradeLabel == nil) {
        _fansGradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_fansTouImageLabel.maxX + scaleWithSize(10), _fansNickNameLabel.maxY + scaleWithSize(5), screen_width - _fansTouImageLabel.maxX - scaleWithSize(60) - scaleWithSize(15)*2, 10)];
        _fansGradeLabel.text = @"知名博主";
        _fansGradeLabel.font = fontSize(scaleWithSize(10.0f));
        _fansGradeLabel.textColor = mx_Wode_color666666;
    }
    return _fansGradeLabel;
}
- (UILabel *)fansSignatureLabel {//粉丝签名
    if (_fansSignatureLabel == nil) {
        _fansSignatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(_fansTouImageLabel.maxX + scaleWithSize(10), _fansGradeLabel.maxY + scaleWithSize(7.5f), screen_width - _fansTouImageLabel.maxX - scaleWithSize(60) - scaleWithSize(15)*2, 10)];
        _fansSignatureLabel.text = @"天气很好,阳光很暖，一切都是……";
        _fansSignatureLabel.font = fontSize(scaleWithSize(11.0f));
        _fansSignatureLabel.textColor = mx_Wode_color999999;
    }
    return _fansSignatureLabel;
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
