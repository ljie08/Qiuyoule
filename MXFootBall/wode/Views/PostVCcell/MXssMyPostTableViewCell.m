//
//  MXssMyPostTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXssMyPostTableViewCell.h"

@implementation MXssMyPostTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.myPostImage];//我的发帖图
        [self.contentView addSubview:self.zongViewl];//我的发帖的右边总
        [self.zongViewl addSubview:self.myPostTitleNameLabel];//我的发帖昵称
        [self.zongViewl addSubview:self.myPostContentLabel];//我的发帖内容
        [self.zongViewl addSubview:self.numberSumView];//总显示时间view
        [self.numberSumView addSubview:self.myPostZanLabel];//我的发帖的点赞数
        [self.numberSumView addSubview:self.myPostSeeLabel];//我的发帖的阅读数
        [self.numberSumView addSubview:self.myPostTimeLabel];//我的发帖时间
        [self.numberSumView addSubview:self.myPostZanImage];//我的发帖的点赞图
        [self.numberSumView addSubview:self.myPostSeeImage];//我的发帖的阅读图
        [self.numberSumView addSubview:self.myPostTimeImage];//我的发帖的时间图
    }
    return self;
}
//数据
- (void)setDatemodel:(MXssPostModel *)datemodel {
    _datemodel = datemodel;
    
}
- (UIImageView *)myPostImage {//我的发帖图
    if (_myPostImage == nil) {
        _myPostImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, scaleWithSize(80), scaleWithSize(80))];
//        _myPostImage.backgroundColor = [UIColor grayColor];
        _myPostImage.image = [UIImage imageNamed:@"bannerPlace"];
        //        _fansTouImageLabel.layer.cornerRadius = 25.0f;
        //        _fansTouImageLabel.layer.masksToBounds = YES;
    }
    return _myPostImage;
}

- (UIView *)zongViewl{//我的发帖的右边总
    if (_zongViewl == nil) {
        _zongViewl = [[UIView alloc] initWithFrame:CGRectMake(_myPostImage.frame.size.width + scaleWithSize(20), scaleWithSize(10), screen_width - _myPostImage.frame.size.width - scaleWithSize(30), scaleWithSize(80))];
        _zongViewl.backgroundColor = [UIColor clearColor];
    }
    return _zongViewl;

}
- (UILabel *)myPostTitleNameLabel {//我的发帖昵称
    if (_myPostTitleNameLabel == nil) {
        _myPostTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _zongViewl.frame.size.width, 20)];
        _myPostTitleNameLabel.text = @"帖子标题";
        _myPostTitleNameLabel.font = fontSize(scaleWithSize(13.0f));
        //        _collectionArticlesNickNameLabel.backgroundColor = [UIColor yellowColor];
    }
    return _myPostTitleNameLabel;
}

- (UILabel *)myPostContentLabel {//我的发帖内容
    if (_myPostContentLabel == nil) {
        _myPostContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, _zongViewl.frame.size.width, 45)];
        _myPostContentLabel.text = @"这是一个超级有趣的跟帖内容评论内容跟帖评论跟帖内容跟帖跟帖内容评论内容跟帖评论跟帖内容跟帖123跟";
        _myPostContentLabel.numberOfLines = 0;
        _myPostContentLabel.font =  fontSize(scaleWithSize(12.0f));
        _myPostContentLabel.textColor = mx_Wode_color999999;
        //        _collectionArticlesContentLabel.backgroundColor = [UIColor blueColor];
    }
    return _myPostContentLabel;
}
- (UIView *)numberSumView{//我的发帖的右边总
    if (_numberSumView == nil) {
        _numberSumView = [[UIView alloc] initWithFrame:CGRectMake(_zongViewl.frame.size.width - scaleWithSize(190),_zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10))];
        _numberSumView.backgroundColor = [UIColor clearColor];
    }
    return _numberSumView;
    
}
- (UIImageView *)myPostZanImage {//我的发帖的点赞图
    if (_myPostZanImage == nil) {
        _myPostZanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scaleWithSize(10), 10)];
//        _myPostZanImage.backgroundColor = [UIColor blackColor];
        _myPostZanImage.image = [UIImage imageNamed:@"my_post_pinglun"];//my_post_pinglun   my_post_yuedu
    }
    return _myPostZanImage;
}
- (UILabel *)myPostZanLabel{//我的发帖的点赞数
    if (_myPostZanLabel == nil) {
        _myPostZanLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), 0, scaleWithSize(30), 10)];
        _myPostZanLabel.text = @"999";
        _myPostZanLabel.font = fontSize(scaleWithSize(12.0f));
        _myPostZanLabel.textColor = mx_Wode_color999999;
//        _myPostZanLabel.backgroundColor = [UIColor greenColor];
    }
    return _myPostZanLabel;
}

- (UIImageView *)myPostSeeImage {//我的发帖的阅读图
    if (_myPostSeeImage == nil) {
        _myPostSeeImage = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(45), 0, scaleWithSize(10), 10)];
//        _myPostSeeImage.backgroundColor = [UIColor blackColor];
        _myPostSeeImage.image = [UIImage imageNamed:@"my_post_yuedu"];
    }
    return _myPostSeeImage;
}
- (UILabel *)myPostSeeLabel{//我的发帖的阅读数
    if (_myPostSeeLabel == nil) {
        _myPostSeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myPostZanLabel.maxX + scaleWithSize(15), 0, scaleWithSize(30), 10)];
        _myPostSeeLabel.text = @"888";
        _myPostSeeLabel.font = fontSize(scaleWithSize(12.0f));
        _myPostSeeLabel.textColor = mx_Wode_color999999;
//        _myPostSeeLabel.backgroundColor = [UIColor greenColor];
    }
    return _myPostSeeLabel;
}

- (UIImageView *)myPostTimeImage {//我的发帖的时间图
    if (_myPostTimeImage == nil) {
        _myPostTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_myPostSeeLabel.maxX + scaleWithSize(5), 0, scaleWithSize(10), 10)];
//        _myPostTimeImage.backgroundColor = [UIColor blackColor];
        _myPostTimeImage.image = [UIImage imageNamed:@"my_post_Image_shijian"];
    }
    return _myPostTimeImage;
}
- (UILabel *)myPostTimeLabel{//我的发帖的时间
    if (_myPostTimeLabel == nil) {
        _myPostTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myPostSeeLabel.maxX + scaleWithSize(20), 0, scaleWithSize(80), 10)];
        _myPostTimeLabel.text = @"2018/03/13";
        _myPostTimeLabel.font = fontSize(scaleWithSize(12.0f));
        _myPostTimeLabel.textColor = mx_Wode_color999999;
//                _myPostTimeLabel.backgroundColor = [UIColor greenColor];
    }
    return _myPostTimeLabel;
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
