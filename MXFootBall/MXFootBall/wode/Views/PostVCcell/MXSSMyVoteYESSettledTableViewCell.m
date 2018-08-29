//
//  MXSSMyVoteYESSettledTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//投票已结算cell

#import "MXSSMyVoteYESSettledTableViewCell.h"

@implementation MXSSMyVoteYESSettledTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.myVoteYESSettledImage];//我的投票已结算图
//        [self.contentView addSubview:self.zongViewl];//我的投票已结算的右边总
//        [self.zongViewl addSubview:self.myVoteYESSettledTitleNameLabel];//我的投票已结算昵称
//        [self.zongViewl addSubview:self.myVoteYESSettledContentLabel];//我的投票已结算内容
//        [self.zongViewl addSubview:self.myVoteYESSettledZanLabel];//我的投票已结算的点赞数
//        [self.zongViewl addSubview:self.myVoteYESSettledSeeLabel];//我的投票已结算的阅读数
//        [self.zongViewl addSubview:self.myVoteYESSettledTimeLabel];//我的投票已结算的时间
//        [self.zongViewl addSubview:self.myVoteYESSettledZanImage];//我的投票已结算的点赞图
//        [self.zongViewl addSubview:self.myVoteYESSettledSeeImage];//我的投票已结算的阅读图
//        [self.zongViewl addSubview:self.myVoteYESSettledTimeImage];//我的投票已结算的时间图
        [self.contentView addSubview:self.myVoteYESSettledTouImage];//头像
        [self.contentView addSubview:self.myVoteYESSettledTitleNameLabel];//标题
        [self.contentView addSubview:self.myVoteYESSettledContentLabel];//内容
        [self.contentView addSubview:self.myVoteYESSettledNameLabel];//参与人名字
        //        [self.contentView addSubview:self.myOpinionYESSettledTimeLabel];//时间显示 03-07 12:30
        [self.contentView addSubview:self.myVoteYESSettledOrNoBigImage];//大图 输赢
        [self.contentView addSubview:self.myVoteYESSettledNumberLabel];//数量
        [self.contentView addSubview:self.myVoteYESSettledXinImage];//❤️ 图
        [self.contentView addSubview:self.myVoteYESSettledOrNoSuoImage];//🔐解锁图案
        
    }
    return self;
}
//数据
- (void)setDatemodel:(MXssPostModel *)datemodel {
    _datemodel = datemodel;
    
}


- (UIImageView *)myVoteYESSettledTouImage {//头像
    if (_myVoteYESSettledTouImage == nil) {
        _myVoteYESSettledTouImage = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(20), scaleWithSize(60), scaleWithSize(60))];
        _myVoteYESSettledTouImage.backgroundColor = [UIColor grayColor];
        _myVoteYESSettledTouImage.image = [UIImage imageNamed:@"saishi_morentouxiang"];
        _myVoteYESSettledTouImage.layer.cornerRadius = scaleWithSize(60/2.0f);
        _myVoteYESSettledTouImage.layer.masksToBounds = YES;
    }
    return _myVoteYESSettledTouImage;
}
- (UILabel *)myVoteYESSettledTitleNameLabel {//标题
    if (_myVoteYESSettledTitleNameLabel == nil) {
        _myVoteYESSettledTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myVoteYESSettledTouImage.maxX + scaleWithSize(10), scaleWithSize(10),screen_width -_myVoteYESSettledTouImage.maxX- scaleWithSize(90), 20)];
        _myVoteYESSettledTitleNameLabel.text = @"用户名 - 70%";
        _myVoteYESSettledTitleNameLabel.font = fontSize(scaleWithSize(12));
        _myVoteYESSettledTitleNameLabel.textColor = mx_Wode_color333333;
        //                _myOpinionYESSettledTitleNameLabel.backgroundColor = [UIColor blueColor];
    }
    return _myVoteYESSettledTitleNameLabel;
}


- (UILabel *)myVoteYESSettledContentLabel {//内容
    if (_myVoteYESSettledContentLabel == nil) {
        _myVoteYESSettledContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myVoteYESSettledTouImage.maxX + scaleWithSize(10), _myVoteYESSettledTitleNameLabel.maxY + scaleWithSize(5),screen_width -_myVoteYESSettledTouImage.maxX- scaleWithSize(90), scaleWithSize(20))];
        _myVoteYESSettledContentLabel.text = @"投票已结算内容内{一行显示}";
        _myVoteYESSettledContentLabel.font = fontSize(scaleWithSize(12));
        _myVoteYESSettledContentLabel.textColor = mx_Wode_color666666;
        //        _myOpinionYESSettledContentLabel.numberOfLines =0;
        //        _myOpinionYESSettledContentLabel.backgroundColor = [UIColor greenColor];
    }
    return _myVoteYESSettledContentLabel;
}

- (UILabel *)myVoteYESSettledNameLabel {//内容
    if (_myVoteYESSettledNameLabel == nil) {
        _myVoteYESSettledNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myVoteYESSettledTouImage.maxX + scaleWithSize(10), _myVoteYESSettledContentLabel.maxY + scaleWithSize(5),screen_width -_myVoteYESSettledTouImage.maxX- scaleWithSize(90), scaleWithSize(20))];
        _myVoteYESSettledNameLabel.text = @"萨斯宝 vs 队名";
        _myVoteYESSettledNameLabel.font = fontSize(scaleWithSize(10));
        _myVoteYESSettledNameLabel.textColor = mx_Wode_color999999;
        //        _myOpinionYESSettledNameLabel.numberOfLines =0;
        //        _myOpinionYESSettledNameLabel.backgroundColor = [UIColor yellowColor];
        //         CGSize size = CGSizeMake(20,20); //设置一个行高上限
        //         NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledNameLabel.font};
        //         CGSize labelsize = [_myOpinionYESSettledNameLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
        //         _myOpinionYESSettledNameLabel.frame = CGRectMake(_myOpinionYESSettledTouImage.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));
        
    }
    return _myVoteYESSettledNameLabel;
}

- (UIImageView *)myVoteYESSettledOrNoSuoImage {//🔐解锁图案
    if (_myVoteYESSettledOrNoSuoImage == nil) {
        _myVoteYESSettledOrNoSuoImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(80), scaleWithSize(90/2- 7.5), scaleWithSize(13), scaleWithSize(14))];
        //        _myOpinionYESSettledXinImage.backgroundColor = [UIColor grayColor];
        _myVoteYESSettledOrNoSuoImage.image = [UIImage imageNamed:@"saishi_suo"];
        //        _myOpinionYESSettledXinImage.layer.cornerRadius = 15.0f;
        //        _myOpinionYESSettledXinImage.layer.masksToBounds = YES;
    }
    return _myVoteYESSettledOrNoSuoImage;
}
- (UIImageView *)myVoteYESSettledXinImage {//心❤️图
    if (_myVoteYESSettledXinImage == nil) {
        _myVoteYESSettledXinImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(60), scaleWithSize(90/2-7), scaleWithSize(15), scaleWithSize(13))];
        //        _myOpinionYESSettledXinImage.backgroundColor = [UIColor grayColor];
        _myVoteYESSettledXinImage.image = [UIImage imageNamed:@"my_post_Image_aixin"];
        //        _myOpinionYESSettledXinImage.layer.cornerRadius = 15.0f;
        //        _myOpinionYESSettledXinImage.layer.masksToBounds = YES;
    }
    return _myVoteYESSettledXinImage;
}


- (UILabel *)myVoteYESSettledNumberLabel {//点赞数
    if (_myVoteYESSettledNumberLabel == nil) {
        _myVoteYESSettledNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(40), scaleWithSize(90/2-10), scaleWithSize(40), scaleWithSize(20))];
        _myVoteYESSettledNumberLabel.text = @"99";
        _myVoteYESSettledNumberLabel.font = fontSize(scaleWithSize(10));
        _myVoteYESSettledNumberLabel.textColor = mx_Wode_color999999;
        //        _myOpinionYESSettledNumberLabel.numberOfLines =0;
        //        _myOpinionYESSettledNumberLabel.backgroundColor = [UIColor yellowColor];
        //        CGSize size = CGSizeMake(20,20); //设置一个行高上限
        //        NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledTimeLabel.font};
        //        CGSize labelsize = [_myOpinionYESSettledTimeLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
        //        _myOpinionYESSettledNumberLabel.frame = CGRectMake(_myOpinionYESSettledNameLabel.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));
        
    }
    return _myVoteYESSettledNumberLabel;
}


- (UIImageView *)myVoteYESSettledOrNoBigImage {//大图 输赢
    if (_myVoteYESSettledOrNoBigImage == nil) {
        _myVoteYESSettledOrNoBigImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(50), 0, scaleWithSize(50), scaleWithSize(50))];
//        _myVoteYESSettledOrNoBigImage.backgroundColor = [UIColor grayColor];
        _myVoteYESSettledOrNoBigImage.image = [UIImage imageNamed:@"my_weizhong"];
        _myVoteYESSettledOrNoBigImage.hidden = NO;//不显示
    }
    return _myVoteYESSettledOrNoBigImage;
}

//- (UIImageView *)myVoteYESSettledImage {//我的投票已结算图
//    if (_myVoteYESSettledImage == nil) {
//        _myVoteYESSettledImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 80)];
////        _myVoteYESSettledImage.backgroundColor = [UIColor grayColor];
//        _myVoteYESSettledImage.image = [UIImage imageNamed:@"bannerPlace"];
//        //        _fansTouImageLabel.layer.cornerRadius = 25.0f;
//        //        _fansTouImageLabel.layer.masksToBounds = YES;
//    }
//    return _myVoteYESSettledImage;
//}
//
//- (UIView *)zongViewl{//我的投票已结算的右边总
//    if (_zongViewl == nil) {
//        _zongViewl = [[UIView alloc] initWithFrame:CGRectMake(_myVoteYESSettledImage.frame.size.width + 20, 10, screen_width - _myVoteYESSettledImage.frame.size.width - 30, 80)];
//        _zongViewl.backgroundColor = [UIColor clearColor];
//    }
//    return _zongViewl;
//
//}
//- (UILabel *)myVoteYESSettledTitleNameLabel {//我的投票已结算昵称
//    if (_myVoteYESSettledTitleNameLabel == nil) {
//        _myVoteYESSettledTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _zongViewl.frame.size.width, 20)];
//        _myVoteYESSettledTitleNameLabel.text = @"已结算帖子标题";
//        _myVoteYESSettledTitleNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
//        //        _collectionArticlesNickNameLabel.backgroundColor = [UIColor yellowColor];
//    }
//    return _myVoteYESSettledTitleNameLabel;
//}
//
//- (UILabel *)myVoteYESSettledContentLabel {//我的投票已结算内容
//    if (_myVoteYESSettledContentLabel == nil) {
//        _myVoteYESSettledContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, _zongViewl.frame.size.width, 45)];
//        _myVoteYESSettledContentLabel.text = @"这是一个投票已结算的内容评论123abce已结算内容评论论坛帖子标题1234567890-内容评论整理精彩";
//        _myVoteYESSettledContentLabel.numberOfLines = 0;
//        _myVoteYESSettledContentLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _collectionArticlesContentLabel.backgroundColor = [UIColor blueColor];
//    }
//    return _myVoteYESSettledContentLabel;
//}
//
//- (UIImageView *)myVoteYESSettledZanImage {//我的投票已结算的点赞图
//    if (_myVoteYESSettledZanImage == nil) {
//        _myVoteYESSettledZanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myVoteYESSettledZanImage.backgroundColor = [UIColor blackColor];
//        _myVoteYESSettledZanImage.image = [UIImage imageNamed:@"my_post_Image_dainzan"];
//    }
//    return _myVoteYESSettledZanImage;
//}
//- (UILabel *)myVoteYESSettledZanLabel{//我的发帖的点赞数
//    if (_myVoteYESSettledZanLabel == nil) {
//        _myVoteYESSettledZanLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _zongViewl.frame.size.height - 10, 30, 10)];
//        _myVoteYESSettledZanLabel.text = @"999";
//        _myVoteYESSettledZanLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _myPostZanLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myVoteYESSettledZanLabel;
//}
//
//- (UIImageView *)myVoteYESSettledSeeImage {//我的投票已结算的阅读图
//    if (_myVoteYESSettledSeeImage == nil) {
//        _myVoteYESSettledSeeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_myVoteYESSettledZanLabel.frame.size.width + 15, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myVoteYESSettledSeeImage.backgroundColor = [UIColor blackColor];
//        _myVoteYESSettledSeeImage.image = [UIImage imageNamed:@"my_post_Image_jifen"];
//    }
//    return _myVoteYESSettledSeeImage;
//}
//- (UILabel *)myVoteYESSettledSeeLabel{//我的投票已结算的阅读数
//    if (_myVoteYESSettledSeeLabel == nil) {
//        _myVoteYESSettledSeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myVoteYESSettledZanLabel.frame.size.width + 30, _zongViewl.frame.size.height - 10, 30, 10)];
//        _myVoteYESSettledSeeLabel.text = @"888";
//        _myVoteYESSettledSeeLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _myPostSeeLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myVoteYESSettledSeeLabel;
//}
//
//- (UIImageView *)myVoteYESSettledTimeImage {//我的投票已结算的时间图
//    if (_myVoteYESSettledTimeImage == nil) {
//        _myVoteYESSettledTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake((_myVoteYESSettledSeeLabel.frame.size.width + 15)*2, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myVoteYESSettledTimeImage.backgroundColor = [UIColor blackColor];
//        _myVoteYESSettledTimeImage.image = [UIImage imageNamed:@"my_post_Image_shijian"];
//    }
//    return _myVoteYESSettledTimeImage;
//}
//- (UILabel *)myVoteYESSettledTimeLabel{//我的投票已结算的时间
//    if (_myVoteYESSettledTimeLabel == nil) {
//        _myVoteYESSettledTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((_myVoteYESSettledSeeLabel.frame.size.width + 15)*2 + 15, _zongViewl.frame.size.height - 10, 80, 10)];
//        _myVoteYESSettledTimeLabel.text = @"2018/03/13";
//        _myVoteYESSettledTimeLabel.font = [UIFont systemFontOfSize:12.0f];
//        //                _myPostTimeLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myVoteYESSettledTimeLabel;
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
