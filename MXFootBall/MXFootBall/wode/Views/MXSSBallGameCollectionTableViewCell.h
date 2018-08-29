//
//  MXSSBallGameCollectionTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssCollectionModel.h"
@interface MXSSBallGameCollectionTableViewCell : UITableViewCell
//@property (nonatomic,strong) UIImageView *collectionBallGameImageLabel;//收藏球赛图
@property (nonatomic,strong) UILabel *collectionBallGameMainTitleLabel;//收藏球赛主标题
@property (nonatomic,strong) UILabel *collectionBallGameTitleLabel;//收藏球赛标题
@property (nonatomic,strong) UILabel *collectionBallGameContentLabel;//收藏球赛内容

@property (nonatomic,strong) UIImageView *collectionBallGameNumberImage;//比分图片
@property (nonatomic,strong) UIView *collectionBallGameNumberView;//收藏球赛比分
@property (nonatomic,strong) UILabel *collectionBallGameNumberTitleLabel;//收藏比分标题
@property (nonatomic,strong) UILabel *collectionBallGameNumberContentLabel;//收藏比分内容
@property (nonatomic,strong) UILabel *collectionBallGameNumberTitleLabel1;//收藏比分标题
@property (nonatomic,strong) UILabel *collectionBallGameNumberContentLabel1;//收藏比分内容

@property (nonatomic,strong) UILabel *collectionBallGameNumberTitleLabel2;//收藏比分标题
@property (nonatomic,strong) UILabel *collectionBallGameNumberContentLabel2;//收藏比分内容
@property (nonatomic,strong) UILabel *collectionBallGameCellXian;//收藏比分线
@property (nonatomic,strong) MXssCollectionModel *datemodel;
@end
