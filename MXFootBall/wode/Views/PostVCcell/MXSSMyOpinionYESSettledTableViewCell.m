//
//  MXSSMyOpinionYESSettledTableViewCell.m
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//观点已结算cell

#import "MXSSMyOpinionYESSettledTableViewCell.h"

@implementation MXSSMyOpinionYESSettledTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        [self.contentView addSubview:self.myOpinionYESSettledImage];//我的观点已结算图
        //        [self.contentView addSubview:self.zongViewl];//我的观点已结算的右边总
        //        [self.zongViewl addSubview:self.myOpinionYESSettledTitleNameLabel];//我的观点已结算昵称
        //        [self.zongViewl addSubview:self.myOpinionYESSettledContentLabel];//我的观点已结算内容
        //        [self.zongViewl addSubview:self.myOpinionYESSettledZanLabel];//我的观点已结算的点赞数
        //        [self.zongViewl addSubview:self.myOpinionYESSettledSeeLabel];//我的观点已结算的阅读数
        //        [self.zongViewl addSubview:self.myOpinionYESSettledTimeLabel];//我的观点已结算的时间
        //        [self.zongViewl addSubview:self.myOpinionYESSettledZanImage];//我的观点已结算的点赞图
        //        [self.zongViewl addSubview:self.myOpinionYESSettledSeeImage];//我的观点已结算的阅读图
        //        [self.zongViewl addSubview:self.myOpinionYESSettledTimeImage];//我的观点已结算的时间图
        [self.contentView addSubview:self.myOpinionYESSettledTouImage];//头像
        [self.contentView addSubview:self.myOpinionYESSettledTitleNameLabel];//标题
        [self.contentView addSubview:self.myOpinionYESSettledContentLabel];//内容
        [self.contentView addSubview:self.myOpinionYESSettledNameLabel];//参与人名字
//        [self.contentView addSubview:self.myOpinionYESSettledTimeLabel];//时间显示 03-07 12:30
         [self.contentView addSubview:self.myOpinionYESSettledOrNoBigImage];//大图 输赢
        [self.contentView addSubview:self.myOpinionYESSettledNumberLabel];//数量
        [self.contentView addSubview:self.myOpinionYESSettledXinImage];//❤️ 图
        [self.contentView addSubview:self.myOpinionYESSettledOrNoSuoImage];//🔐解锁图案
       
    }
    return self;
}
//数据
- (void)setDatemodel:(MXssPostModel *)datemodel {
    _datemodel = datemodel;
    
}

- (UIImageView *)myOpinionYESSettledTouImage {//头像
    if (_myOpinionYESSettledTouImage == nil) {
        _myOpinionYESSettledTouImage = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(20), scaleWithSize(60), scaleWithSize(60))];
        _myOpinionYESSettledTouImage.backgroundColor = [UIColor grayColor];
        _myOpinionYESSettledTouImage.image = [UIImage imageNamed:@"saishi_morentouxiang"];
        _myOpinionYESSettledTouImage.layer.cornerRadius = scaleWithSize(60/2.0f);
        _myOpinionYESSettledTouImage.layer.masksToBounds = YES;
    }
    return _myOpinionYESSettledTouImage;
}
- (UILabel *)myOpinionYESSettledTitleNameLabel {//标题
    if (_myOpinionYESSettledTitleNameLabel == nil) {
        _myOpinionYESSettledTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionYESSettledTouImage.maxX + scaleWithSize(10), scaleWithSize(10),screen_width -_myOpinionYESSettledTouImage.maxX- scaleWithSize(90), 20)];
        _myOpinionYESSettledTitleNameLabel.text = @"用户名 - 80%";
        _myOpinionYESSettledTitleNameLabel.font = fontSize(scaleWithSize(12));
        _myOpinionYESSettledTitleNameLabel.textColor = mx_Wode_color333333;
//                _myOpinionYESSettledTitleNameLabel.backgroundColor = [UIColor blueColor];
    }
    return _myOpinionYESSettledTitleNameLabel;
}


- (UILabel *)myOpinionYESSettledContentLabel {//内容
    if (_myOpinionYESSettledContentLabel == nil) {
        _myOpinionYESSettledContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionYESSettledTouImage.maxX + scaleWithSize(10), _myOpinionYESSettledTitleNameLabel.maxY + scaleWithSize(5),screen_width -_myOpinionYESSettledTouImage.maxX- scaleWithSize(90), scaleWithSize(20))];
        _myOpinionYESSettledContentLabel.text = @"观点已结算内容内{一行显示}";
        _myOpinionYESSettledContentLabel.font = fontSize(scaleWithSize(12));
        _myOpinionYESSettledContentLabel.textColor = mx_Wode_color666666;
//        _myOpinionYESSettledContentLabel.numberOfLines =0;
//        _myOpinionYESSettledContentLabel.backgroundColor = [UIColor greenColor];
    }
    return _myOpinionYESSettledContentLabel;
}

- (UILabel *)myOpinionYESSettledNameLabel {//内容
    if (_myOpinionYESSettledNameLabel == nil) {
        _myOpinionYESSettledNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionYESSettledTouImage.maxX + scaleWithSize(10), _myOpinionYESSettledContentLabel.maxY + scaleWithSize(5),screen_width -_myOpinionYESSettledTouImage.maxX- scaleWithSize(90), scaleWithSize(20))];
        _myOpinionYESSettledNameLabel.text = @"队名 vs 队名";
        _myOpinionYESSettledNameLabel.font = fontSize(scaleWithSize(10));
        _myOpinionYESSettledNameLabel.textColor = mx_Wode_color999999;
//        _myOpinionYESSettledNameLabel.numberOfLines =0;
//        _myOpinionYESSettledNameLabel.backgroundColor = [UIColor yellowColor];
//         CGSize size = CGSizeMake(20,20); //设置一个行高上限
//         NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledNameLabel.font};
//         CGSize labelsize = [_myOpinionYESSettledNameLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
//         _myOpinionYESSettledNameLabel.frame = CGRectMake(_myOpinionYESSettledTouImage.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));

    }
    return _myOpinionYESSettledNameLabel;
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

- (UIImageView *)myOpinionYESSettledOrNoSuoImage {//🔐解锁图案
    if (_myOpinionYESSettledOrNoSuoImage == nil) {
        _myOpinionYESSettledOrNoSuoImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(80), scaleWithSize(90/2- 7.5), scaleWithSize(13), scaleWithSize(14))];
        //        _myOpinionYESSettledXinImage.backgroundColor = [UIColor grayColor];
        _myOpinionYESSettledOrNoSuoImage.image = [UIImage imageNamed:@"saishi_suo"];
        //        _myOpinionYESSettledXinImage.layer.cornerRadius = 15.0f;
        //        _myOpinionYESSettledXinImage.layer.masksToBounds = YES;
    }
    return _myOpinionYESSettledOrNoSuoImage;
}
- (UIImageView *)myOpinionYESSettledXinImage {//心❤️图
    if (_myOpinionYESSettledXinImage == nil) {
        _myOpinionYESSettledXinImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(60), scaleWithSize(90/2-7), scaleWithSize(15), scaleWithSize(13))];
//        _myOpinionYESSettledXinImage.backgroundColor = [UIColor grayColor];
        _myOpinionYESSettledXinImage.image = [UIImage imageNamed:@"my_post_Image_aixin"];
//        _myOpinionYESSettledXinImage.layer.cornerRadius = 15.0f;
//        _myOpinionYESSettledXinImage.layer.masksToBounds = YES;
    }
    return _myOpinionYESSettledXinImage;
}


- (UILabel *)myOpinionYESSettledNumberLabel {//点赞数
    if (_myOpinionYESSettledNumberLabel == nil) {
        _myOpinionYESSettledNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(40), scaleWithSize(90/2-10), scaleWithSize(40), scaleWithSize(20))];
        _myOpinionYESSettledNumberLabel.text = @"199";
        _myOpinionYESSettledNumberLabel.font = fontSize(scaleWithSize(10));
        _myOpinionYESSettledNumberLabel.textColor = mx_Wode_color999999;
//        _myOpinionYESSettledNumberLabel.numberOfLines =0;
//        _myOpinionYESSettledNumberLabel.backgroundColor = [UIColor yellowColor];
//        CGSize size = CGSizeMake(20,20); //设置一个行高上限
//        NSDictionary *attribute = @{NSFontAttributeName: _myOpinionYESSettledTimeLabel.font};
//        CGSize labelsize = [_myOpinionYESSettledTimeLabel.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
//        _myOpinionYESSettledNumberLabel.frame = CGRectMake(_myOpinionYESSettledNameLabel.maxX + scaleWithSize(10), scaleWithSize(100-40), labelsize.width + 3, scaleWithSize(30));
        
    }
    return _myOpinionYESSettledNumberLabel;
}


- (UIImageView *)myOpinionYESSettledOrNoBigImage {//大图 输赢
    if (_myOpinionYESSettledOrNoBigImage == nil) {
        _myOpinionYESSettledOrNoBigImage = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(50), 0, scaleWithSize(50), scaleWithSize(50))];
//        _myOpinionYESSettledOrNoBigImage.backgroundColor = [UIColor grayColor];
        _myOpinionYESSettledOrNoBigImage.image = [UIImage imageNamed:@"my_weizhong"];
        _myOpinionYESSettledOrNoBigImage.hidden = NO;//不显示
    }
    return _myOpinionYESSettledOrNoBigImage;
}

//- (UIImageView *)myOpinionYESSettledImage {//我的观点已结算图
//    if (_myOpinionYESSettledImage == nil) {
//        _myOpinionYESSettledImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 130, 80)];
//        _myOpinionYESSettledImage.backgroundColor = [UIColor grayColor];
//        //        _fansTouImageLabel.layer.cornerRadius = 25.0f;
//        //        _fansTouImageLabel.layer.masksToBounds = YES;
//    }
//    return _myOpinionYESSettledImage;
//}
//
//- (UIView *)zongViewl{//我的观点已结算的右边总
//    if (_zongViewl == nil) {
//        _zongViewl = [[UIView alloc] initWithFrame:CGRectMake(_myOpinionYESSettledImage.frame.size.width + 20, 10, screen_width - _myOpinionYESSettledImage.frame.size.width - 30, 80)];
//        _zongViewl.backgroundColor = [UIColor clearColor];
//    }
//    return _zongViewl;
//
//}
//- (UILabel *)myOpinionYESSettledTitleNameLabel {//我的观点已结算昵称
//    if (_myOpinionYESSettledTitleNameLabel == nil) {
//        _myOpinionYESSettledTitleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _zongViewl.frame.size.width, 20)];
//        _myOpinionYESSettledTitleNameLabel.text = @"观点已结算帖子标题";
//        _myOpinionYESSettledTitleNameLabel.font = [UIFont boldSystemFontOfSize:15.0f];
//        //        _collectionArticlesNickNameLabel.backgroundColor = [UIColor yellowColor];
//    }
//    return _myOpinionYESSettledTitleNameLabel;
//}
//
//- (UILabel *)myOpinionYESSettledContentLabel {//我的观点已结算内容
//    if (_myOpinionYESSettledContentLabel == nil) {
//        _myOpinionYESSettledContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, _zongViewl.frame.size.width, 45)];
//        _myOpinionYESSettledContentLabel.text = @"我的观点这是一个观点已结算的内容评论123abce已结算内容评论论坛帖子标题1234567890-内容评论整理精彩";
//        _myOpinionYESSettledContentLabel.numberOfLines = 0;
//        _myOpinionYESSettledContentLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _collectionArticlesContentLabel.backgroundColor = [UIColor blueColor];
//    }
//    return _myOpinionYESSettledContentLabel;
//}
//
//- (UIImageView *)myOpinionYESSettledZanImage {//我的观点已结算的点赞图
//    if (_myOpinionYESSettledZanImage == nil) {
//        _myOpinionYESSettledZanImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, _zongViewl.frame.size.height - 10, 10, 10)];
//        _myOpinionYESSettledZanImage.backgroundColor = [UIColor blackColor];
//    }
//    return _myOpinionYESSettledZanImage;
//}
//- (UILabel *)myOpinionYESSettledZanLabel{//我的发帖的观点的点赞数
//    if (_myOpinionYESSettledZanLabel == nil) {
//        _myOpinionYESSettledZanLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _zongViewl.frame.size.height - 10, 30, 10)];
//        _myOpinionYESSettledZanLabel.text = @"999";
//        _myOpinionYESSettledZanLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _myPostZanLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myOpinionYESSettledZanLabel;
//}
//
//- (UIImageView *)myOpinionYESSettledSeeImage {//我的观点已结算的阅读图
//    if (_myOpinionYESSettledSeeImage == nil) {
//        _myOpinionYESSettledSeeImage = [[UIImageView alloc] initWithFrame:CGRectMake(_myOpinionYESSettledZanLabel.frame.size.width + 15, _zongViewl.frame.size.height - 10, 10, 10)];
//        _myOpinionYESSettledSeeImage.backgroundColor = [UIColor blackColor];
//    }
//    return _myOpinionYESSettledSeeImage;
//}
//- (UILabel *)myOpinionYESSettledSeeLabel{//我的观点已结算的阅读数
//    if (_myOpinionYESSettledSeeLabel == nil) {
//        _myOpinionYESSettledSeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myOpinionYESSettledZanLabel.frame.size.width + 30, _zongViewl.frame.size.height - 10, 30, 10)];
//        _myOpinionYESSettledSeeLabel.text = @"888";
//        _myOpinionYESSettledSeeLabel.font = [UIFont systemFontOfSize:12.0f];
//        //        _myPostSeeLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myOpinionYESSettledSeeLabel;
//}
//
//- (UIImageView *)myOpinionYESSettledTimeImage {//我的观点已结算的时间图
//    if (_myOpinionYESSettledTimeImage == nil) {
//        _myOpinionYESSettledTimeImage = [[UIImageView alloc] initWithFrame:CGRectMake((_myOpinionYESSettledSeeLabel.frame.size.width + 15)*2, _zongViewl.frame.size.height - 10, 10, 10)];
//        _myOpinionYESSettledTimeImage.backgroundColor = [UIColor blackColor];
//    }
//    return _myOpinionYESSettledTimeImage;
//}
//- (UILabel *)myOpinionYESSettledTimeLabel{//我的观点已结算的时间
//    if (_myOpinionYESSettledTimeLabel == nil) {
//        _myOpinionYESSettledTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((_myOpinionYESSettledSeeLabel.frame.size.width + 15)*2 + 15, _zongViewl.frame.size.height - 10, 80, 10)];
//        _myOpinionYESSettledTimeLabel.text = @"2018/03/13";
//        _myOpinionYESSettledTimeLabel.font = [UIFont systemFontOfSize:12.0f];
//        //                _myPostTimeLabel.backgroundColor = [UIColor greenColor];
//    }
//    return _myOpinionYESSettledTimeLabel;
//}

- (void)setEventViewpointModel:(MXDViewpointModel *)eventViewpointModel {
    
    _eventViewpointModel = eventViewpointModel ;
    
    [self.myOpinionYESSettledTouImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", eventViewpointModel.headerPic]] placeholderImage:[UIImage imageNamed:@"saishi_morentouxiang"]];
    self.myOpinionYESSettledTitleNameLabel.text = [NSString stringWithFormat:@"%@ - %g%%",eventViewpointModel.username,eventViewpointModel.hitRate.doubleValue * 100] ;
    
    self.myOpinionYESSettledContentLabel.text = eventViewpointModel.reason ;
    
    self.myOpinionYESSettledNameLabel.text = [NSString stringWithFormat:@"%@ vs %@",eventViewpointModel.homeNm,eventViewpointModel.awayNm] ;
    
    if (eventViewpointModel.isNotLock) {
        self.myOpinionYESSettledOrNoSuoImage.image = [UIImage imageNamed:@""] ;
    } else {
        self.myOpinionYESSettledOrNoSuoImage.image = [UIImage imageNamed:@"saishi_suo"] ;

    }
    self.myOpinionYESSettledNumberLabel.text = [NSString stringWithFormat:@"%ld",eventViewpointModel.suportCount] ;
    
    if ([self.matchStatus isEqualToString:@"8"]) {
        if (eventViewpointModel.hit == 0) {
            self.myOpinionYESSettledOrNoBigImage.image = [UIImage imageNamed:@"my_weizhong"];
        } else if (eventViewpointModel.hit == 1) {
            self.myOpinionYESSettledOrNoBigImage.image = [UIImage imageNamed:@"my_mingzhong"];
        } else {
            self.myOpinionYESSettledOrNoBigImage.image = [UIImage imageNamed:@""];
        }
        
    } else {
        
        if ([self.matchStatus isEqualToString:@"2"]||
            [self.matchStatus isEqualToString:@"3"]||
            [self.matchStatus isEqualToString:@"4"]||
            [self.matchStatus isEqualToString:@"5"]||
            [self.matchStatus isEqualToString:@"6"]||
            [self.matchStatus isEqualToString:@"7"]) {
            self.myOpinionYESSettledOrNoBigImage.image = [UIImage imageNamed:@"my_fengpan"];
        } else {
            self.myOpinionYESSettledOrNoBigImage.image = [UIImage imageNamed:@""];
        }
        
        
    }
    
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
