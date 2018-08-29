//
//  MXSYJArticleView.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJFocusOnModel.h"
#import "ZTGoodsDetailWebView.h"
#import "ZTGoodsDetailWebView.h"
#import "MXSYJAdModel.h"

@protocol MXHeaderViewDelegate <NSObject>

-(void)setHeaderViewHeight:(CGFloat)height imgsHeight: (NSArray *)imgsHeight textHeight: (CGFloat)textHeight;

- (void)pushToAdsVc: (MXSYJAdModel *) adModel ;

- (void)pushToUserInfo;

@end

typedef void(^BtnClick)(UIButton *btn);

@interface MXSYJArticleView : UIView

@property (nonatomic, copy) BtnClick click;

/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 帖子数 */
@property (nonatomic, strong) UILabel *postLab;
/** 粉丝数 */
@property (nonatomic, strong) UILabel *fansLab;
/** 等级 */
@property (nonatomic, strong) UILabel *levelLab;
/** 关注 */
@property (nonatomic, strong) UIButton *focusBtn;

/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UITextView *titleTextview;
/** 来自 */
@property (nonatomic, strong) UILabel *fromLab;
/** 阅读数 */
@property (nonatomic, strong) UILabel *readLab;
/** 文章内容 */
@property (nonatomic, strong) UILabel *articleText;
/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *articleImg;

@property (nonatomic, assign) NSInteger articleType;

/** 文章来源 */
@property (nonatomic, strong) UILabel *articleFromLab;
/** 声明 */
@property (nonatomic, strong) UILabel *statementLab;
/** 收藏 */
@property (nonatomic, strong) UIButton *collectBtn;
/** 打赏 */
@property (nonatomic, strong) UIButton *exceptionalBtn;

@property (nonatomic, strong) MXSYJFocusOnModel *model;

@property (nonatomic, strong) MXSYJAdModel *adModel;

@property (nonatomic, strong) ZTGoodsDetailWebView *wkWebview;

/** 广告 */
@property (nonatomic, strong) UIImageView *adImageView;
/** 发布时间 */
@property (nonatomic, strong) UILabel *createTimeLab;

//加载前显示界面
@property (nonatomic, strong) UIView *loadingView;


- (CGFloat)cellHegith:(NSString *)text font:(UIFont *)font;

- (CGFloat)imageHeight:(MXSYJFocusOnModel *)model;

@property (nonatomic, weak) id<MXHeaderViewDelegate> delegate;


@end
