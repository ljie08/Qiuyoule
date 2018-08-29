//
//  MXSSMyOpinionNOSettledTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//观点待结算cell

#import "MXSSMyOpinionNOSettledTableViewCell.h"

@implementation MXSSMyOpinionNOSettledTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.myOpinionNOSettledImage];//我的观点待结算图
//        [self.contentView addSubview:self.zongViewl];//我的观点待结算的右边总
//        [self.zongViewl addSubview:self.myOpinionNOSettledTitleNameLabel];//我的观点待结算昵称
//        [self.zongViewl addSubview:self.myOpinionNOSettledContentLabel];//我的观点待结算内容
//        [self.zongViewl addSubview:self.myOpinionNOSettledZanLabel];//我的观点待结算的点赞数
//        [self.zongViewl addSubview:self.myOpinionNOSettledSeeLabel];//我的观点待结算的阅读数
//        [self.zongViewl addSubview:self.myOpinionNOSettledTimeLabel];//我的观点待结算的时间
//        [self.zongViewl addSubview:self.myOpinionNOSettledZanImage];//我的观点待结算的点赞图
//        [self.zongViewl addSubview:self.myOpinionNOSettledSeeImage];//我的观点待结算的阅读图
//        [self.zongViewl addSubview:self.myOpinionNOSettledTimeImage];//我的观点待结算的时间图
        [self.contentView addSubview:self.myOpinionNOSettledTouImage];//头像
        [self.contentView addSubview:self.myOpinionNOSettledTitleNameLabel];//标题
        [self.contentView addSubview:self.myOpinionNOSettledContentLabel];//内容
        [self.contentView addSubview:self.myOpinionNOSettledNameLabel];//参与人名字
        //        [self.contentView addSubview:self.myOpinionYESSettledTimeLabel];//时间显示 03-07 12:30
        [self.contentView addSubview:self.myOpinionNOSettledOrNoBigImage];//大图 输赢
        [self.contentView addSubview:self.myOpinionNOSettledNumberLabel];//数量
        [self.contentView addSubview:self.myOpinionNOSettledXinImage];//❤️ 图
        [self.contentView addSubview:self.myOpinionNOSettledOrNoSuoImage];//🔐解锁图案
        
    }
    return self;
}
//数据
- (void)setDatemodel:(MXssPostModel *)datemodel {
    _datemodel = datemodel;
    
}

- (UIImageView *)myOpinionNOSettledTouImage {//头像
    if (_myOpinionNOSettledTouImage == nil) {
        _myOpinionNOSettledTouImage = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(20), scaleWithSize(60), scaleWithSize(60))];
        _myOpinionNOSettledTouImage.backgroundColor = [UIColor grayColor];
        _myOpinionNOSettledTouImage.image = [UIImage imageNamed:@"saishi_morentouxiang"];
        _myOpinionNOSettledTouImage.layer.cornerRadius = scaleWithSize(60/2.0f);
        _myOpinionNOSettledTouImage.layer.masksToBounds = YES;
    }
    return _myOpinionNOSettledTouImage;
}
- (UILabel *)myOpinionNOSettledTitleNameLabel {//标题
    if (_myOpinionNOSettledTitleNameLabel == nil) {
        _myOpinionNOSettledTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionNOSettledTouImage.maxX + scaleWithSize(10), scaleWithSize(10),screen_width -_myOpinionNOSettledTouImage.maxX- scaleWithSize(90), 20)];
        _myOpinionNOSettledTitleNameLabel.text = @"用户名 - 胜率";
        _myOpinionNOSettledTitleNameLabel.font = fontSize(scaleWithSize(12));
        _myOpinionNOSettledTitleNameLabel.textColor = mx_Wode_color333333;
        //                _myOpinionYESSettledTitleNameLabel.backgroundColor = [UIColor blueColor];
    }
    return _myOpinionNOSettledTitleNameLabel;
}


- (UILabel *)myOpinionNOSettledContentLabel {//内容
    if (_myOpinionNOSettledContentLabel == nil) {
        _myOpinionNOSettledContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionNOSettledTouImage.maxX + scaleWithSize(10), _myOpinionNOSettledTitleNameLabel.maxY + scaleWithSize(5),screen_width -_myOpinionNOSettledTouImage.maxX- scaleWithSize(90), scaleWithSize(20))];
        _myOpinionNOSettledContentLabel.text = @"观点待结算内容内{一行显示}";
        _myOpinionNOSettledContentLabel.font = fontSize(scaleWithSize(12));
        _myOpinionNOSettledContentLabel.textColor = mx_Wode_color666666;
        //        _myOpinionYESSettledContentLabel.numberOfLines =0;
        //        _myOpinionYESSettledContentLabel.backgroundColor = [UIColor greenColor];
    }
    return _myOpinionNOSettledContentLabel;
}

- (UILabel *)myOpinionNOSettledNameLabel {//内容
    if (_myOpinionNOSettledNameLabel == nil) {
        _myOpinionNOSettledNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionNOSettledTouImage.maxX + scaleWithSize(10), _myOpinionNOSettledContentLabel.maxY + scaleWithSize(5),screen_width -_myOpinionNOSettledTouImage.maxX- scaleWithSize(90), scaleWithSize(20))];
        _myOpinionNOSettledNameLabel.text = @"欧罗巴 vs 萨斯宝";
        _myOpinionNOSettledNameLabel.font = fontSize(scaleWithSize(10));
        _myOpinionNOSettledNameLabel.textColor = mx_Wode_color999999;
        //        _myOpinionYESSettledNameLabel.numberOfLines =0;
        //        _myOpinionYESSettledNameLabel.backgroundColor = [UIColor yellowColor];
        //         CGSize size = CGSizeMake(20,20); //设置一个行高上限
        //         NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledNameLabel.font};
        //         CGSize labelsize = [_myOpinionYESSettledNameLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
        //         _myOpinionYESSettledNameLabel.frame = CGRectMake(_myOpinionYESSettledTouImage.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));
        
    }
    return _myOpinionNOSettledNameLabel;
}

//- (UILabel *)myOpinionYESSettledTimeLabel {//时间
//    if (_myOpinionYESSettledTimeLabel == nil) {
//        _myOpinionYESSettledTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionYESSettledNameLabel.maxX + scaleWithSize(5), scaleWithSize(100-40),screen_width - scaleWithSize(60), scaleWithSize(30))];
//        _myOpinionYESSettledTimeLabel.text = @"03-07 12:30";
//        _myOpinionYESSettledTimeLabel.font = fontSize(scaleWithSize(10));
//        _myOpinionYESSettledTimeLabel.textColor = mx_Wode_color999999;
//        _myOpinionYESSettledTimeLabel.numberOfLines =0;
//        //        _collectionArticlesNickNameLabel.backgroundColor = [UIColor yellowColor];
//        CGSize size = CGSizeMake(20,20); //设置一个行高上限
//        NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledTimeLabel.font};
//        CGSize labelsize = [_myOpinionYESSettledTimeLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
//        _myOpinionYESSettledTimeLabel.frame = CGRectMake(_myOpinionYESSettledNameLabel.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));
//
//    }
//    return _myOpinionYESSettledTimeLabel;
//}

- (UIImageView *)myOpinionNOSettledOrNoSuoImage {//🔐解锁图案
    if (_myOpinionNOSettledOrNoSuoImage == nil) {
        _myOpinionNOSettledOrNoSuoImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(80), scaleWithSize(90/2- 7.5), scaleWithSize(13), scaleWithSize(14))];
        //        _myOpinionYESSettledXinImage.backgroundColor = [UIColor grayColor];
        _myOpinionNOSettledOrNoSuoImage.image = [UIImage imageNamed:@"saishi_suo"];
        //        _myOpinionYESSettledXinImage.layer.cornerRadius = 15.0f;
        //        _myOpinionYESSettledXinImage.layer.masksToBounds = YES;
    }
    return _myOpinionNOSettledOrNoSuoImage;
}
- (UIImageView *)myOpinionNOSettledXinImage {//心❤️图
    if (_myOpinionNOSettledXinImage == nil) {
        _myOpinionNOSettledXinImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(60), scaleWithSize(90/2-7), scaleWithSize(15), scaleWithSize(13))];
        //        _myOpinionYESSettledXinImage.backgroundColor = [UIColor grayColor];
        _myOpinionNOSettledXinImage.image = [UIImage imageNamed:@"my_post_Image_aixin"];
        //        _myOpinionYESSettledXinImage.layer.cornerRadius = 15.0f;
        //        _myOpinionYESSettledXinImage.layer.masksToBounds = YES;
    }
    return _myOpinionNOSettledXinImage;
}


- (UILabel *)myOpinionNOSettledNumberLabel {//点赞数
    if (_myOpinionNOSettledNumberLabel == nil) {
        _myOpinionNOSettledNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(40), scaleWithSize(90/2-10), scaleWithSize(40), scaleWithSize(20))];
        _myOpinionNOSettledNumberLabel.text = @"1";
        _myOpinionNOSettledNumberLabel.font = fontSize(scaleWithSize(10));
        _myOpinionNOSettledNumberLabel.textColor = mx_Wode_color999999;
        //        _myOpinionYESSettledNumberLabel.numberOfLines =0;
        //        _myOpinionYESSettledNumberLabel.backgroundColor = [UIColor yellowColor];
        //        CGSize size = CGSizeMake(20,20); //设置一个行高上限
        //        NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledTimeLabel.font};
        //        CGSize labelsize = [_myOpinionYESSettledTimeLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
        //        _myOpinionYESSettledNumberLabel.frame = CGRectMake(_myOpinionYESSettledNameLabel.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));
        
    }
    return _myOpinionNOSettledNumberLabel;
}

- (UIImageView *)myOpinionNOSettledOrNoBigImage {//大图 输赢
    if (_myOpinionNOSettledOrNoBigImage == nil) {
        _myOpinionNOSettledOrNoBigImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(50), 0, scaleWithSize(50), scaleWithSize(50))];
//        _myOpinionNOSettledOrNoBigImage.backgroundColor = [UIColor grayColor];
        _myOpinionNOSettledOrNoBigImage.image = [UIImage imageNamed:@"my_weizhong"];
        _myOpinionNOSettledOrNoBigImage.hidden = YES;//不显示
    }
    return _myOpinionNOSettledOrNoBigImage;
}

//- (UIImageView *)myOpinionNOSettledImage {//我的观点待结算图
//    if (_myOpinionNOSettledImage == nil) {
//        _myOpinionNOSettledImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 80)];
////        _myOpinionNOSettledImage.backgroundColor = [UIColor grayColor];
//        _myOpinionNOSettledImage.image = [UIImage imageNamed:@"bannerPlace"];
//        //        _fansTouImageLabel.layer.cornerRadius = 25.0f;
//        //        _fansTouImageLabel.layer.masksToBounds = YES;
//    }
//    return _myOpinionNOSettledImage;
//}
//
//- (UIView *)zongViewl{//我的观点待结算的右边总
//    if (_zongViewl == nil) {
//        _zongViewl = [[UIView alloc] initWithFrame:CGRectMake(_myOpinionNOSettledImage.frame.size.width + 20, 10, screen_width - _myOpinionNOSettledImage.frame.size.width - 30, 80)];
//        _zongViewl.backgroundColor = [UIColor clearColor];
//    }
//    return _zongViewl;
//
//}
//- (UILabel *)myOpinionNOSettledTitleNameLabel {//我的观点待结算昵称
//    if (_myOpinionNOSettledTitleNameLabel == nil) {
//        _myOpinionNOSettledTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _zongViewl.frame.size.width, 20)];
//        _myOpinionNOSettledTitleNameLabel.text = @"观点待结算帖子标题";
//        _myOpinionNOSettledTitleNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
//        //        _collectionArticlesNickNameLabel.backgroundColor = [UIColor yellowColor];
//    }
//    return _myOpinionNOSettledTitleNameLabel;
//}
//
//- (UILabel *)myOpinionNOSettledContentLabel {//我的观点待结算内容
//    if (_myOpinionNOSettledContentLabel == nil) {
//        _myOpinionNOSettledContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, _zongViewl.frame.size.width, 45)];
//        _myOpinionNOSettledContentLabel.text = @"观点待结算123456789这是一个投票待结算的内容评论内容跟帖评论跟帖内容跟帖跟帖内容评论内容跟帖评论跟帖内容跟帖123跟";
//        _myOpinionNOSettledContentLabel.numberOfLines = 0;
//        _myOpinionNOSettledContentLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _collectionArticlesContentLabel.backgroundColor = [UIColor blueColor];
//    }
//    return _myOpinionNOSettledContentLabel;
//}
//
//- (UIImageView *)myOpinionNOSettledZanImage {//我的观点待结算的点赞图
//    if (_myOpinionNOSettledZanImage == nil) {
//        _myOpinionNOSettledZanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myOpinionNOSettledZanImage.backgroundColor = [UIColor blackColor];
//        _myOpinionNOSettledZanImage.image = [UIImage imageNamed:@"my_post_Image_dainzan"];
//    }
//    return _myOpinionNOSettledZanImage;
//}
//- (UILabel *)myOpinionNOSettledZanLabel{//我的观点的点赞数
//    if (_myOpinionNOSettledZanLabel == nil) {
//        _myOpinionNOSettledZanLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _zongViewl.frame.size.height - 10, 30, 10)];
//        _myOpinionNOSettledZanLabel.text = @"999";
//        _myOpinionNOSettledZanLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _myPostZanLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myOpinionNOSettledZanLabel;
//}
//
//- (UIImageView *)myOpinionNOSettledSeeImage {//我的观点待结算的阅读图
//    if (_myOpinionNOSettledSeeImage == nil) {
//        _myOpinionNOSettledSeeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_myOpinionNOSettledZanLabel.frame.size.width + 15, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myOpinionNOSettledSeeImage.backgroundColor = [UIColor blackColor];
//          _myOpinionNOSettledSeeImage.image = [UIImage imageNamed:@"my_post_Image_jifen"];
//    }
//    return _myOpinionNOSettledSeeImage;
//}
//- (UILabel *)myOpinionNOSettledSeeLabel{//我的观点待结算的阅读数
//    if (_myOpinionNOSettledSeeLabel == nil) {
//        _myOpinionNOSettledSeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionNOSettledZanLabel.frame.size.width + 30, _zongViewl.frame.size.height - 10, 30, 10)];
//        _myOpinionNOSettledSeeLabel.text = @"888";
//        _myOpinionNOSettledSeeLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _myPostSeeLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myOpinionNOSettledSeeLabel;
//}
//
//- (UIImageView *)myOpinionNOSettledTimeImage {//我的观点待结算的时间图
//    if (_myOpinionNOSettledTimeImage == nil) {
//        _myOpinionNOSettledTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake((_myOpinionNOSettledSeeLabel.frame.size.width + 15)*2, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myOpinionNOSettledTimeImage.backgroundColor = [UIColor blackColor];
//        _myOpinionNOSettledTimeImage.image = [UIImage imageNamed:@"my_post_Image_shijian"];
//    }
//    return _myOpinionNOSettledTimeImage;
//}
//- (UILabel *)myOpinionNOSettledTimeLabel{//我的观点待结算的时间
//    if (_myOpinionNOSettledTimeLabel == nil) {
//        _myOpinionNOSettledTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((_myOpinionNOSettledSeeLabel.frame.size.width + 15)*2 + 15, _zongViewl.frame.size.height - 10, 80, 10)];
//        _myOpinionNOSettledTimeLabel.text = @"2018/03/13";
//        _myOpinionNOSettledTimeLabel.font = [UIFont systemFontOfSize:12.0f];
//        //                _myPostTimeLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myOpinionNOSettledTimeLabel;
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
