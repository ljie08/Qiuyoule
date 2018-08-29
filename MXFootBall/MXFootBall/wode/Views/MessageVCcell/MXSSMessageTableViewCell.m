//
//  MXSSMessageTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSMessageTableViewCell.h"

@implementation MXSSMessageTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.messageTimeLabel];//消息时间
        [self.contentView addSubview:self.messageImage];//消息图片
         [self.contentView addSubview:self.topView];//白色view
        [self.topView addSubview:self.messageTitleNameLabel];//消息标题
        [self.topView addSubview:self.messageContentLabel];//消息内容
        
        
    }
    return self;
}
//数据
- (void)setDatemodel:(MXssMessageModel *)datemodel {
    _datemodel = datemodel;
    
}
- (UILabel *)messageTimeLabel {//消息时间
    if (_messageTimeLabel == nil) {
        _messageTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2 - scaleWithSize(70), scaleWithSize(10), scaleWithSize(144), scaleWithSize(20))];
        _messageTimeLabel.text = @"周三 18:20";
        _messageTimeLabel.font = fontSize(scaleWithSize(12.0f));
        _messageTimeLabel.backgroundColor = mx_Wode_colorcccccc;
        _messageTimeLabel.textColor = [UIColor whiteColor];
        _messageTimeLabel.textAlignment = 1;
        _messageTimeLabel.layer.cornerRadius = 4.0f;
        _messageTimeLabel.layer.masksToBounds = YES;
    }
    return _messageTimeLabel;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(scaleWithSize(15), _messageTimeLabel.frame.size.height + scaleWithSize(20), screen_width - scaleWithSize(30), scaleWithSize(80))];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}


- (UIImageView *)messageImage {//消息图片
    if (_messageImage == nil) {
        _messageImage = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(15), _messageTimeLabel.frame.size.height + scaleWithSize(20), screen_width - scaleWithSize(30), scaleWithSize(100))];
        _messageImage.backgroundColor = [UIColor clearColor];
//        _messageImage.image = [UIImage imageNamed:@"DefaultImage"];
//        _messageImage.layer.cornerRadius = 25.0f;
//        _messageImage.layer.masksToBounds = YES;
        _messageImage.image = [UIImage imageNamed:@"bannerPlace"];
        _messageImage.hidden = YES;//
    }
    return _messageImage;
}

- (UILabel *)messageTitleNameLabel {//消息标题
    if (_messageTitleNameLabel == nil) {
        _messageTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(10), scaleWithSize(10), screen_width - scaleWithSize(40), scaleWithSize(20))];
        _messageTitleNameLabel.text = @"重大消息";
        _messageTitleNameLabel.font = fontSize(scaleWithSize(19.0f));
        _messageTitleNameLabel.textAlignment = 1;
        _messageTitleNameLabel.hidden = YES;//
        //        _fansNickNameLabel.backgroundColor = [UIColor yellowColor];
    }
    return _messageTitleNameLabel;
}

- (UILabel *)messageContentLabel {//消息内容
    if (_messageContentLabel == nil) {
        _messageContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(10), _messageTitleNameLabel.frame.size.height + scaleWithSize(10), screen_width - scaleWithSize(50), 40)];
        _messageContentLabel.text = @"官方活动知名博主官方活动知名博主官方活动知名博主官方活动知名博主官方活动知名博主官方活动知名博主官方活动知名博主官方活动知名博主";
        _messageContentLabel.font = fontSize(scaleWithSize(14.0f));
        _messageContentLabel.textColor = mx_Wode_darkGreyFontColor;
        _messageContentLabel.numberOfLines = 0;
    }
    return _messageContentLabel;
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
