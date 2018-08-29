//
//  MXSSArticleCollectionTableViewCell.h
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MXssCollectionModel.h"
@interface MXSSArticleCollectionTableViewCell : UITableViewCell
//@property (nonatomic,strong) UIImageView *collectionArticlesImageLabel;//收藏文章图
//@property (nonatomic,strong) UILabel *collectionArticlesNickNameLabel;//收藏文章昵称
//@property (nonatomic,strong) UILabel *collectionArticlesContentLabel;//收藏文章内容
//@property (nonatomic,strong) UILabel *collectionArticlesTimeLabel;//收藏文章时间
//@property (nonatomic,strong) UIImageView *collectionArticlesDian;//

@property (nonatomic,strong) UIImageView *collectionArticlesImage;//我的发帖图
@property (nonatomic,strong) UIView *zongViewl;//我的发帖的右边总
@property (nonatomic,strong) UILabel *collectionArticlesTitleNameLabel;//我的发帖昵称
@property (nonatomic,strong) UILabel *collectionArticlesContentLabel;//我的发帖内容
@property (nonatomic,strong) UILabel *collectionArticlesZanLabel;//我的发帖的点赞数
@property (nonatomic,strong) UILabel *collectionArticlesSeeLabel;//我的发帖的阅读数
@property (nonatomic,strong) UILabel *collectionArticlesTimeLabel;//我的发帖时间
@property (nonatomic,strong) UIImageView *collectionArticlesZanImage;//我的发帖的点赞图
@property (nonatomic,strong) UIImageView *collectionArticlesSeeImage;//我的发帖的阅读图
@property (nonatomic,strong) UIImageView *collectionArticlesTimeImage;//我的发帖的时间图
@property (nonatomic,strong) UIView *numberSumView;//时间总view
@property (nonatomic,strong) UIButton *duoBut;//多选按钮

//@property (nonatomic,strong) MXssCollectionModel *datemodel;
@end
