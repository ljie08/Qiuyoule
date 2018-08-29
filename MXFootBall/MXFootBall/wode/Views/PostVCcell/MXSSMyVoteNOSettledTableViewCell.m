//
//  MXSSMyVoteNOSettledTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//投票待结算cell

#import "MXSSMyVoteNOSettledTableViewCell.h"

@implementation MXSSMyVoteNOSettledTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.myVoteNOSettledImage];//我的投票待结算图
//        [self.contentView addSubview:self.zongViewl];//我的投票待结算的右边总
//        [self.zongViewl addSubview:self.myVoteNOSettledTitleNameLabel];//我的投票待结算昵称
//        [self.zongViewl addSubview:self.myVoteNOSettledContentLabel];//我的投票待结算内容
////        [self.zongViewl addSubview:self.myVoteNOSettledZanLabel];//我的投票待结算的点赞数
////        [self.zongViewl addSubview:self.myVoteNOSettledSeeLabel];//我的投票待结算的阅读数
//        [self.zongViewl addSubview:self.myVoteNOSettledTimeLabel];//我的投票待结算的时间
////        [self.zongViewl addSubview:self.myVoteNOSettledZanImage];//我的投票待结算的点赞图
////        [self.zongViewl addSubview:self.myVoteNOSettledSeeImage];//我的投票待结算的阅读图
//        [self.zongViewl addSubview:self.myVoteNOSettledTimeImage];//我的投票待结算的时间图
        [self.contentView addSubview:self.myVoteNOSettledTouImage];//头像
        [self.contentView addSubview:self.myVoteNOSettledTitleNameLabel];//标题
        [self.contentView addSubview:self.myVoteNOSettledContentLabel];//内容
        [self.contentView addSubview:self.myVoteNOSettledNameLabel];//参与人名字
        //        [self.contentView addSubview:self.myOpinionYESSettledTimeLabel];//时间显示 03-07 12:30
         [self.contentView addSubview:self.myVoteNOSettledOrNoBigImage];//大图
        [self.contentView addSubview:self.myVoteNOSettledNumberLabel];//数量
        [self.contentView addSubview:self.myVoteNOSettledXinImage];//❤️ 图
        [self.contentView addSubview:self.myVoteNOSettledOrNoSuoImage];//🔐解锁图案
       
    }
    return self;
}
//数据
- (void)setDatemodel:(MXssPostModel *)datemodel {
    _datemodel = datemodel;
    
}

- (UIImageView *)myVoteNOSettledTouImage {//头像
    if (_myVoteNOSettledTouImage == nil) {
        _myVoteNOSettledTouImage = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(20), scaleWithSize(60), scaleWithSize(60))];
        _myVoteNOSettledTouImage.backgroundColor = [UIColor grayColor];
        _myVoteNOSettledTouImage.image = [UIImage imageNamed:@"saishi_morentouxiang"];
        _myVoteNOSettledTouImage.layer.cornerRadius = scaleWithSize(60/2.0f);
        _myVoteNOSettledTouImage.layer.masksToBounds = YES;
    }
    return _myVoteNOSettledTouImage;
}
- (UILabel *)myVoteNOSettledTitleNameLabel {//标题
    if (_myVoteNOSettledTitleNameLabel == nil) {
        _myVoteNOSettledTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myVoteNOSettledTouImage.maxX + scaleWithSize(10), scaleWithSize(10),screen_width -_myVoteNOSettledTouImage.maxX- scaleWithSize(90), 20)];
        _myVoteNOSettledTitleNameLabel.text = @"用户名 - 30%";
        _myVoteNOSettledTitleNameLabel.font = fontSize(scaleWithSize(12));
        _myVoteNOSettledTitleNameLabel.textColor = mx_Wode_color333333;
        //                _myOpinionYESSettledTitleNameLabel.backgroundColor = [UIColor blueColor];
    }
    return _myVoteNOSettledTitleNameLabel;
}


- (UILabel *)myVoteNOSettledContentLabel {//内容
    if (_myVoteNOSettledContentLabel == nil) {
        _myVoteNOSettledContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myVoteNOSettledTouImage.maxX + scaleWithSize(10), _myVoteNOSettledTitleNameLabel.maxY + scaleWithSize(5),screen_width -_myVoteNOSettledTouImage.maxX- scaleWithSize(90), scaleWithSize(20))];
        _myVoteNOSettledContentLabel.text = @"投票待结算内容内{一行显示}";
        _myVoteNOSettledContentLabel.font = fontSize(scaleWithSize(12));
        _myVoteNOSettledContentLabel.textColor = mx_Wode_color666666;
        //        _myOpinionYESSettledContentLabel.numberOfLines =0;
        //        _myOpinionYESSettledContentLabel.backgroundColor = [UIColor greenColor];
    }
    return _myVoteNOSettledContentLabel;
}

- (UILabel *)myVoteNOSettledNameLabel {//内容
    if (_myVoteNOSettledNameLabel == nil) {
        _myVoteNOSettledNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myVoteNOSettledTouImage.maxX + scaleWithSize(10), _myVoteNOSettledContentLabel.maxY + scaleWithSize(5),screen_width -_myVoteNOSettledTouImage.maxX- scaleWithSize(90), scaleWithSize(20))];
        _myVoteNOSettledNameLabel.text = @"萨斯宝 vs A队名";
        _myVoteNOSettledNameLabel.font = fontSize(scaleWithSize(10));
        _myVoteNOSettledNameLabel.textColor = mx_Wode_color999999;
        //        _myOpinionYESSettledNameLabel.numberOfLines =0;
        //        _myOpinionYESSettledNameLabel.backgroundColor = [UIColor yellowColor];
        //         CGSize size = CGSizeMake(20,20); //设置一个行高上限
        //         NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledNameLabel.font};
        //         CGSize labelsize = [_myOpinionYESSettledNameLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
        //         _myOpinionYESSettledNameLabel.frame = CGRectMake(_myOpinionYESSettledTouImage.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));
        
    }
    return _myVoteNOSettledNameLabel;
}

- (UIImageView *)myVoteNOSettledOrNoSuoImage {//🔐解锁图案
    if (_myVoteNOSettledOrNoSuoImage == nil) {
        _myVoteNOSettledOrNoSuoImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(80), scaleWithSize(90/2- 7.5), scaleWithSize(13), scaleWithSize(14))];
        //        _myOpinionYESSettledXinImage.backgroundColor = [UIColor grayColor];
        _myVoteNOSettledOrNoSuoImage.image = [UIImage imageNamed:@"saishi_suo"];
        //        _myOpinionYESSettledXinImage.layer.cornerRadius = 15.0f;
        //        _myOpinionYESSettledXinImage.layer.masksToBounds = YES;
    }
    return _myVoteNOSettledOrNoSuoImage;
}
- (UIImageView *)myVoteNOSettledXinImage {//心❤️图
    if (_myVoteNOSettledXinImage == nil) {
        _myVoteNOSettledXinImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(60), scaleWithSize(90/2-7), scaleWithSize(15), scaleWithSize(13))];
        //        _myOpinionYESSettledXinImage.backgroundColor = [UIColor grayColor];
        _myVoteNOSettledXinImage.image = [UIImage imageNamed:@"my_post_Image_aixin"];
        //        _myOpinionYESSettledXinImage.layer.cornerRadius = 15.0f;
        //        _myOpinionYESSettledXinImage.layer.masksToBounds = YES;
    }
    return _myVoteNOSettledXinImage;
}


- (UILabel *)myVoteNOSettledNumberLabel {//点赞数
    if (_myVoteNOSettledNumberLabel == nil) {
        _myVoteNOSettledNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(40), scaleWithSize(90/2-10), scaleWithSize(40), scaleWithSize(20))];
        _myVoteNOSettledNumberLabel.text = @"9";
        _myVoteNOSettledNumberLabel.font = fontSize(scaleWithSize(10));
        _myVoteNOSettledNumberLabel.textColor = mx_Wode_color999999;
        //        _myOpinionYESSettledNumberLabel.numberOfLines =0;
        //        _myOpinionYESSettledNumberLabel.backgroundColor = [UIColor yellowColor];
        //        CGSize size = CGSizeMake(20,20); //设置一个行高上限
        //        NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledTimeLabel.font};
        //        CGSize labelsize = [_myOpinionYESSettledTimeLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
        //        _myOpinionYESSettledNumberLabel.frame = CGRectMake(_myOpinionYESSettledNameLabel.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));
        
    }
    return _myVoteNOSettledNumberLabel;
}


- (UIImageView *)myVoteNOSettledOrNoBigImage {//大图 输赢
    if (_myVoteNOSettledOrNoBigImage == nil) {
        _myVoteNOSettledOrNoBigImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(50), 0, scaleWithSize(50), scaleWithSize(50))];
//        _myVoteNOSettledOrNoBigImage.backgroundColor = [UIColor grayColor];
        _myVoteNOSettledOrNoBigImage.image = [UIImage imageNamed:@"my_weizhong"];
        _myVoteNOSettledOrNoBigImage.hidden = YES;//不显示
    }
    return _myVoteNOSettledOrNoBigImage;
}

//- (UIImageView *)myVoteNOSettledImage {//我的投票待结算图
//    if (_myVoteNOSettledImage == nil) {
//        _myVoteNOSettledImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 80)];
//        _myVoteNOSettledImage.image = [UIImage imageNamed:@"bannerPlace"];
////        _myVoteNOSettledImage.backgroundColor = [UIColor grayColor];
//        //        _fansTouImageLabel.layer.cornerRadius = 25.0f;
//        //        _fansTouImageLabel.layer.masksToBounds = YES;
//    }
//    return _myVoteNOSettledImage;
//}
//
//- (UIView *)zongViewl{//我的投票待结算的右边总
//    if (_zongViewl == nil) {
//        _zongViewl = [[UIView alloc] initWithFrame:CGRectMake(_myVoteNOSettledImage.frame.size.width + 20, 10, screen_width - _myVoteNOSettledImage.frame.size.width - 30, 80)];
//        _zongViewl.backgroundColor = [UIColor clearColor];
//    }
//    return _zongViewl;
//
//}
//- (UILabel *)myVoteNOSettledTitleNameLabel {//我的投票待结算昵称
//    if (_myVoteNOSettledTitleNameLabel == nil) {
//        _myVoteNOSettledTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _zongViewl.frame.size.width, 20)];
//        _myVoteNOSettledTitleNameLabel.text = @"待结算帖子标题";
//        _myVoteNOSettledTitleNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
//        //        _collectionArticlesNickNameLabel.backgroundColor = [UIColor yellowColor];
//    }
//    return _myVoteNOSettledTitleNameLabel;
//}
//
//- (UILabel *)myVoteNOSettledContentLabel {//我的投票待结算内容
//    if (_myVoteNOSettledContentLabel == nil) {
//        _myVoteNOSettledContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, _zongViewl.frame.size.width, 45)];
//        _myVoteNOSettledContentLabel.text = @"123456789这是一个投票待结算的内容评论内容跟帖评论跟帖内容跟帖跟帖内容评论内容跟帖评论跟帖内容跟帖123跟";
//        _myVoteNOSettledContentLabel.numberOfLines = 0;
//        _myVoteNOSettledContentLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _collectionArticlesContentLabel.backgroundColor = [UIColor blueColor];
//    }
//    return _myVoteNOSettledContentLabel;
//}
//
////- (UIImageView *)myVoteNOSettledZanImage {//我的投票待结算的点赞图
////    if (_myVoteNOSettledZanImage == nil) {//my_post_Image_dainzan
////        _myVoteNOSettledZanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myVoteNOSettledZanImage.backgroundColor = [UIColor blackColor];
////    }
////    return _myVoteNOSettledZanImage;
////}
////- (UILabel *)myVoteNOSettledZanLabel{//我的发帖的点赞数
////    if (_myVoteNOSettledZanLabel == nil) {
////        _myVoteNOSettledZanLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _zongViewl.frame.size.height - 10, 30, 10)];
////        _myVoteNOSettledZanLabel.text = @"999";
////        _myVoteNOSettledZanLabel.font = [UIFont systemFontOfSize:12.0f];
////        //        _myPostZanLabel.backgroundColor = [UIColor greenColor];
////    }
////    return _myVoteNOSettledZanLabel;
////}
////
////- (UIImageView *)myVoteNOSettledSeeImage {//我的投票待结算的阅读图
////    if (_myVoteNOSettledSeeImage == nil) {//my_post_Image_jifen
////        _myVoteNOSettledSeeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_myVoteNOSettledZanLabel.frame.size.width + 15, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myVoteNOSettledSeeImage.backgroundColor = [UIColor blackColor];
////    }
////    return _myVoteNOSettledSeeImage;
////}
////- (UILabel *)myVoteNOSettledSeeLabel{//我的投票待结算的阅读数
////    if (_myVoteNOSettledSeeLabel == nil) {
////        _myVoteNOSettledSeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myVoteNOSettledZanLabel.frame.size.width + 30, _zongViewl.frame.size.height - 10, 30, 10)];
////        _myVoteNOSettledSeeLabel.text = @"888";
////        _myVoteNOSettledSeeLabel.font = [UIFont systemFontOfSize:12.0f];
////        //        _myPostSeeLabel.backgroundColor = [UIColor greenColor];
////    }
////    return _myVoteNOSettledSeeLabel;
////}
//
//- (UIImageView *)myVoteNOSettledTimeImage {//我的投票待结算的时间图
//    if (_myVoteNOSettledTimeImage == nil) {
////        _myVoteNOSettledTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake((_myVoteNOSettledSeeLabel.frame.size.width + 15)*2, _zongViewl.frame.size.height - 10, 10, 10)];
//        _myVoteNOSettledTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _zongViewl.frame.size.height - 10, 10, 10)];
////        _myVoteNOSettledTimeImage.backgroundColor = [UIColor blackColor];
//        _myVoteNOSettledTimeImage.image = [UIImage imageNamed:@"my_post_Image_shijian"];
//    }
//    return _myVoteNOSettledTimeImage;
//}
//- (UILabel *)myVoteNOSettledTimeLabel{//我的投票待结算的时间
//    if (_myVoteNOSettledTimeLabel == nil) {
////        _myVoteNOSettledTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((_myVoteNOSettledSeeLabel.frame.size.width + 15)*2 + 15, _zongViewl.frame.size.height - 10, 80, 10)];
//         _myVoteNOSettledTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _zongViewl.frame.size.height - 10, 80, 10)];
//        _myVoteNOSettledTimeLabel.text = @"2018/03/13";
//        _myVoteNOSettledTimeLabel.font = [UIFont systemFontOfSize:12.0f];
//        //                _myPostTimeLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myVoteNOSettledTimeLabel;
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
