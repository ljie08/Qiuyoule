//
//  MXSSBallGameCollectionTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSBallGameCollectionTableViewCell.h"

@implementation MXSSBallGameCollectionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionBallGameMainTitleLabel];//收藏球赛主标题
        [self.contentView addSubview:self.collectionBallGameTitleLabel];//收藏球赛标题
        [self.contentView addSubview:self.collectionBallGameContentLabel];//收藏球赛内容
//        [self.contentView addSubview:self.collectionBallGameNumberImage];//收藏比分图片
        [self.contentView addSubview:self.collectionBallGameNumberView];//收藏比分view
        [self.collectionBallGameNumberView addSubview:self.collectionBallGameNumberTitleLabel];//收藏比分标题
        [self.collectionBallGameNumberView addSubview:self.collectionBallGameNumberContentLabel];//收藏比分内容
        [self.collectionBallGameNumberView addSubview:self.collectionBallGameNumberTitleLabel1];//收藏比分标题
        [self.collectionBallGameNumberView addSubview:self.collectionBallGameNumberContentLabel1];//收藏比分内容
        [self.collectionBallGameNumberView addSubview:self.collectionBallGameNumberTitleLabel2];//收藏比分标题
        [self.collectionBallGameNumberView addSubview:self.collectionBallGameNumberContentLabel2];//收藏比分内容
        [self.collectionBallGameNumberView addSubview:self.collectionBallGameCellXian];//cell线
    }
    return self;
}
//数据
- (void)setDatemodel:(MXssCollectionModel *)datemodel {
    _datemodel = datemodel;
    
}

- (UILabel *)collectionBallGameMainTitleLabel {//收藏球赛主标题
    if (_collectionBallGameMainTitleLabel == nil) {
        _collectionBallGameMainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, screen_width - 80, 15)];
        _collectionBallGameMainTitleLabel.text = @"内容";
        _collectionBallGameMainTitleLabel.textAlignment = 1;
        _collectionBallGameMainTitleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
        _collectionBallGameMainTitleLabel.backgroundColor = mx_Wode_color16a635;
        CGSize size = CGSizeMake(20,20); //设置一个行高上限
        NSDictionary *attribute = @{NSFontAttributeName: _collectionBallGameMainTitleLabel.font};
        CGSize labelsize = [_collectionBallGameMainTitleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
        _collectionBallGameMainTitleLabel.frame = CGRectMake(10, 10, labelsize.width + 3, labelsize.height +3);
        _collectionBallGameMainTitleLabel.layer.cornerRadius = 2.0f;
        _collectionBallGameMainTitleLabel.layer.masksToBounds = YES;
    }
    return _collectionBallGameMainTitleLabel;
}

- (UILabel *)collectionBallGameTitleLabel {//收藏球赛标题
    if (_collectionBallGameTitleLabel == nil) {
        _collectionBallGameTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27, screen_width  - 80, 20)];
        _collectionBallGameTitleLabel.text = @"内容介绍内容介绍内容介绍123";
//        _collectionBallGameTitleLabel.numberOfLines = 0;
        _collectionBallGameTitleLabel.font = [UIFont systemFontOfSize:14.0f];
//      _collectionBallGameTitleLabel.backgroundColor = [UIColor blueColor];
    }
    return _collectionBallGameTitleLabel;
}
- (UILabel *)collectionBallGameContentLabel {//收藏球赛内容
    if (_collectionBallGameContentLabel == nil) {
        _collectionBallGameContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, screen_width - 80, 30)];
        _collectionBallGameContentLabel.text = @"跟帖内容评论内容跟帖评论跟帖内容跟帖跟帖内容评论内容跟帖评论跟帖内容跟帖评论跟帖内容跟帖123";
        _collectionBallGameContentLabel.font = [UIFont systemFontOfSize:10.0f];
        _collectionBallGameContentLabel.numberOfLines = 0;
//      _collectionBallGameContentLabel.backgroundColor = [UIColor greenColor];
    }
    return _collectionBallGameContentLabel;
}
- (UIView *)collectionBallGameNumberView {//收藏比分view
    if (_collectionBallGameNumberView == nil) {
        _collectionBallGameNumberView = [[UIView alloc] initWithFrame:CGRectMake(screen_width - 70, 90/2 - 20, 60, 40)];
        _collectionBallGameNumberView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionBallGameNumberView;
}

- (UILabel *)collectionBallGameNumberTitleLabel {//收藏比分标题
    if (_collectionBallGameNumberTitleLabel == nil) {
        _collectionBallGameNumberTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 25)];
        _collectionBallGameNumberTitleLabel.text = @"60%";
        _collectionBallGameNumberTitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        _collectionBallGameNumberTitleLabel.textAlignment = 1;
        _collectionBallGameNumberTitleLabel.hidden = YES;
        //      _collectionBallGameContentLabe.backgroundColor = [UIColor greenColor];
    }
    return _collectionBallGameNumberTitleLabel;
}
- (UILabel *)collectionBallGameNumberContentLabel {//收藏比分内容
    if (_collectionBallGameNumberContentLabel == nil) {
        _collectionBallGameNumberContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 60, 10)];
        _collectionBallGameNumberContentLabel.text = @"解释";
        _collectionBallGameNumberContentLabel.font = [UIFont systemFontOfSize:10.0f];
        _collectionBallGameNumberContentLabel.textAlignment = 1;
        _collectionBallGameNumberContentLabel.textColor = [UIColor grayColor];
        _collectionBallGameNumberContentLabel.hidden = YES;
        // _collectionBallGameNumberContentLabel.backgroundColor = [UIColor greenColor];
    }
    return _collectionBallGameNumberContentLabel;
}
- (UILabel *)collectionBallGameNumberTitleLabel1 {//收藏比分标题
    if (_collectionBallGameNumberTitleLabel1 == nil) {
        _collectionBallGameNumberTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60/2, 25)];
        _collectionBallGameNumberTitleLabel1.text = @"13";
        _collectionBallGameNumberTitleLabel1.font = [UIFont boldSystemFontOfSize:17.0f];
        _collectionBallGameNumberTitleLabel1.textAlignment = 1;
        _collectionBallGameNumberTitleLabel1.hidden = YES;
        //      _collectionBallGameContentLabel.backgroundColor = [UIColor greenColor];
    }
    return _collectionBallGameNumberTitleLabel1;
}
- (UILabel *)collectionBallGameNumberContentLabel1 {//收藏比分内容
    if (_collectionBallGameNumberContentLabel1 == nil) {
        _collectionBallGameNumberContentLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 60/2, 10)];
        _collectionBallGameNumberContentLabel1.text = @"解释";
        _collectionBallGameNumberContentLabel1.font = [UIFont systemFontOfSize:10.0f];
        _collectionBallGameNumberContentLabel1.textAlignment = 1;
        _collectionBallGameNumberContentLabel1.textColor = [UIColor grayColor];
        _collectionBallGameNumberContentLabel1.hidden = YES;
        // _collectionBallGameNumberContentLabel1.backgroundColor = [UIColor greenColor];
    }
    return _collectionBallGameNumberContentLabel1;
}
- (UILabel *)collectionBallGameNumberTitleLabel2 {//收藏比分标题
    if (_collectionBallGameNumberTitleLabel2 == nil) {
        _collectionBallGameNumberTitleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(60/2, 0, 60/2, 25)];
        _collectionBallGameNumberTitleLabel2.text = @"6";
        _collectionBallGameNumberTitleLabel2.font = [UIFont boldSystemFontOfSize:17.0f];
        _collectionBallGameNumberTitleLabel2.textAlignment = 1;
        _collectionBallGameNumberTitleLabel2.hidden = YES;
        //      _collectionBallGameContentLabel2.backgroundColor = [UIColor greenColor];
    }
    return _collectionBallGameNumberTitleLabel2;
}
- (UILabel *)collectionBallGameNumberContentLabel2 {//收藏比分内容
    if (_collectionBallGameNumberContentLabel2 == nil) {
        _collectionBallGameNumberContentLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(60/2, 27, 60/2, 10)];
        _collectionBallGameNumberContentLabel2.text = @"解释";
        _collectionBallGameNumberContentLabel2.font = [UIFont systemFontOfSize:10.0f];
        _collectionBallGameNumberContentLabel2.textAlignment = 1;
        _collectionBallGameNumberContentLabel2.textColor = [UIColor grayColor];
        _collectionBallGameNumberContentLabel2.hidden = YES;
        // _collectionBallGameNumberContentLabel2.backgroundColor = [UIColor greenColor];
    }
    return _collectionBallGameNumberContentLabel2;
}
- (UILabel *)collectionBallGameCellXian {//收藏比分内容
    if (_collectionBallGameCellXian == nil) {
        _collectionBallGameCellXian = [[UILabel alloc] initWithFrame:CGRectMake(60/2, 0, 1, 40)];
       
             _collectionBallGameCellXian.hidden = YES;
        _collectionBallGameCellXian.backgroundColor = [UIColor grayColor];
    }
    return _collectionBallGameCellXian;
}

- (UIImageView *)collectionBallGameNumberImage {//收藏比分图片
    if (_collectionBallGameNumberImage == nil) {
        _collectionBallGameNumberImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - 70, 90/2 - 20, 60, 40)];
        _collectionBallGameNumberImage.backgroundColor = [UIColor whiteColor];
    }
    return _collectionBallGameNumberImage;
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
