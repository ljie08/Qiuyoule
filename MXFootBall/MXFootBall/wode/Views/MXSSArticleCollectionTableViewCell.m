//
//  MXSSArticleCollectionTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSArticleCollectionTableViewCell.h"

@implementation MXSSArticleCollectionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionArticlesImage];//我的发帖图
        [self.contentView addSubview:self.zongViewl];//我的发帖的右边总
        [self.zongViewl addSubview:self.collectionArticlesTitleNameLabel];//我的发帖昵称
        [self.zongViewl addSubview:self.collectionArticlesContentLabel];//我的发帖内容
        [self.zongViewl addSubview:self.numberSumView];//总显示时间view
       
        [self.numberSumView addSubview:self.collectionArticlesSeeImage];//我的发帖的阅读图
         [self.numberSumView addSubview:self.collectionArticlesZanImage];//我的发帖的点赞图
        [self.numberSumView addSubview:self.collectionArticlesZanLabel];//我的发帖的点赞数
        [self.numberSumView addSubview:self.collectionArticlesSeeLabel];//我的发帖的阅读数
        [self.numberSumView addSubview:self.collectionArticlesTimeLabel];//我的发帖时间
        [self.numberSumView addSubview:self.collectionArticlesTimeImage];//我的发帖的时间图
        [self.contentView addSubview:self.duoBut];//多选按钮
    }
    return self;
}
////数据
//- (void)setDatemodel:(MXssPostModel *)datemodel {
//    _datemodel = datemodel;
//
//}

- (UIButton *)duoBut {
    if (_duoBut == nil) {
        _duoBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _duoBut.frame = CGRectMake(0, scaleWithSize(30), scaleWithSize(30), scaleWithSize(40));
//         _duoBut.backgroundColor = [UIColor redColor];
        [_duoBut setImage:[UIImage imageNamed:@"my_duoxuan_weixuanzhong"] forState:UIControlStateNormal];
        _duoBut.hidden = YES;
    }
    return _duoBut;
}

- (UIImageView *)collectionArticlesImage {//我的发帖图
    if (_collectionArticlesImage == nil) {
        _collectionArticlesImage = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(10), scaleWithSize(10), scaleWithSize(80), scaleWithSize(80))];
        //        _myPostImage.backgroundColor = [UIColor grayColor];
        _collectionArticlesImage.image = [UIImage imageNamed:@"bannerPlace"];
        //        _fansTouImageLabel.layer.cornerRadius = 25.0f;
        //        _fansTouImageLabel.layer.masksToBounds = YES;
    }
    return _collectionArticlesImage;
}

- (UIView *)zongViewl{//我的发帖的右边总
    if (_zongViewl == nil) {
        _zongViewl = [[UIView alloc] initWithFrame:CGRectMake(_collectionArticlesImage.frame.size.width + scaleWithSize(20), scaleWithSize(10), screen_width - _collectionArticlesImage.frame.size.width - scaleWithSize(30), scaleWithSize(80))];
        _zongViewl.backgroundColor = [UIColor clearColor];
    }
    return _zongViewl;
    
}

- (UILabel *)collectionArticlesTitleNameLabel {//我的发帖昵称
    if (_collectionArticlesTitleNameLabel == nil) {
        _collectionArticlesTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _zongViewl.frame.size.width, 20)];
        _collectionArticlesTitleNameLabel.text = @"帖子标题";
//        _collectionArticlesTitleNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _collectionArticlesTitleNameLabel.font = fontSize(scaleWithSize(13.0f));
        //        _collectionArticlesNickNameLabel.backgroundColor = [UIColor yellowColor];
    }
    return _collectionArticlesTitleNameLabel;
}

- (UILabel *)collectionArticlesContentLabel {//我的发帖内容
    if (_collectionArticlesContentLabel == nil) {
        _collectionArticlesContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, _zongViewl.frame.size.width, 45)];
        _collectionArticlesContentLabel.text = @"这是一个超级有趣的跟帖内容评论内容跟帖评论跟帖内容跟帖跟帖内容评论内容跟帖评论跟帖内容跟帖123跟";
        _collectionArticlesContentLabel.numberOfLines = 0;
//        _collectionArticlesContentLabel.font = [UIFont systemFontOfSize:12.0f];
        _collectionArticlesContentLabel.font = fontSize(scaleWithSize(12.0f));
        _collectionArticlesContentLabel.textColor = mx_Wode_color999999;
        //        _collectionArticlesContentLabel.backgroundColor = [UIColor blueColor];
    }
    return _collectionArticlesContentLabel;
}
- (UIView *)numberSumView{//我的发帖的右边总
    if (_numberSumView == nil) {
        _numberSumView = [[UIView alloc] initWithFrame:CGRectMake(_zongViewl.frame.size.width - scaleWithSize(190),_zongViewl.maxY - scaleWithSize(12), scaleWithSize(200), scaleWithSize(10))];
        _numberSumView.backgroundColor = [UIColor clearColor];
    }
    return _numberSumView;
    
}
- (UIImageView *)collectionArticlesZanImage {//我的发帖的点赞图
    if (_collectionArticlesZanImage == nil) {
        _collectionArticlesZanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scaleWithSize(10), 10)];
        //        _myPostZanImage.backgroundColor = [UIColor blackColor];
        _collectionArticlesZanImage.image = [UIImage imageNamed:@"my_post_pinglun"];//my_post_pinglun   my_post_yuedu
    }
    return _collectionArticlesZanImage;
}
- (UILabel *)collectionArticlesZanLabel{//我的发帖的点赞数
    if (_collectionArticlesZanLabel == nil) {
        _collectionArticlesZanLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), 0, scaleWithSize(30), 10)];
        _collectionArticlesZanLabel.text = @"999";
//        _collectionArticlesZanLabel.font = [UIFont systemFontOfSize:12.0f];
        _collectionArticlesZanLabel.font = fontSize(scaleWithSize(12.0f));
        _collectionArticlesZanLabel.textColor = mx_Wode_color999999;
        //        _myPostZanLabel.backgroundColor = [UIColor greenColor];
    }
    return _collectionArticlesZanLabel;
}

- (UIImageView *)collectionArticlesSeeImage {//我的发帖的阅读图
    if (_collectionArticlesSeeImage == nil) {
        _collectionArticlesSeeImage = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(45), 0, scaleWithSize(10), 10)];
        //        _myPostSeeImage.backgroundColor = [UIColor blackColor];
        _collectionArticlesSeeImage.image = [UIImage imageNamed:@"my_post_yuedu"];
    }
    return _collectionArticlesSeeImage;
}
- (UILabel *)collectionArticlesSeeLabel{//我的发帖的阅读数
    if (_collectionArticlesSeeLabel == nil) {
        _collectionArticlesSeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_collectionArticlesZanLabel.maxX + scaleWithSize(15), 0, scaleWithSize(30), 10)];
        _collectionArticlesSeeLabel.text = @"888";
//        _collectionArticlesSeeLabel.font = [UIFont systemFontOfSize:12.0f];
        _collectionArticlesSeeLabel.font = fontSize(scaleWithSize(12.0f));
        _collectionArticlesSeeLabel.textColor = mx_Wode_color999999;
        //        _myPostSeeLabel.backgroundColor = [UIColor greenColor];
    }
    return _collectionArticlesSeeLabel;
}

- (UIImageView *)collectionArticlesTimeImage {//我的发帖的时间图
    if (_collectionArticlesTimeImage == nil) {
        _collectionArticlesTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_collectionArticlesSeeLabel.maxX + scaleWithSize(5), 0, scaleWithSize(10), 10)];
        //        _myPostTimeImage.backgroundColor = [UIColor blackColor];
        _collectionArticlesTimeImage.image = [UIImage imageNamed:@"my_post_Image_shijian"];
    }
    return _collectionArticlesTimeImage;
}
- (UILabel *)collectionArticlesTimeLabel{//我的发帖的时间
    if (_collectionArticlesTimeLabel == nil) {
        _collectionArticlesTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_collectionArticlesSeeLabel.maxX + scaleWithSize(20), 0, scaleWithSize(80), 10)];
        _collectionArticlesTimeLabel.text = @"2018/03/13";
//        _collectionArticlesTimeLabel.font = [UIFont systemFontOfSize:12.0f];
        _collectionArticlesTimeLabel.font = fontSize(scaleWithSize(12.0f));
        _collectionArticlesTimeLabel.textColor = mx_Wode_color999999;
        //                _myPostTimeLabel.backgroundColor = [UIColor greenColor];
    }
    return _collectionArticlesTimeLabel;
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
