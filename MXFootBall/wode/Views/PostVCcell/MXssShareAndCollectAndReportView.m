//
//  MXssShareAndCollectAndReportView.m
//  MXFootBall
//
//  Created by Mac on 2018/3/15.
//  Copyright © 2018年 zt. All rights reserved.
//分享 收藏 举报

#import "MXssShareAndCollectAndReportView.h"

@implementation MXssShareAndCollectAndReportView

- (instancetype)initWithFrame:(CGRect)frame withNSString:(NSString *)strName {
    self = [super initWithFrame:frame];
    if (self) {
        [self addUIForIntegralDetailView:frame withNSString:strName];
    }
    return self;
}

//添加界面
-(void) addUIForIntegralDetailView:(CGRect)frame withNSString:(NSString *)strName {
    
    //透明层
    UIView *touMingView = [[UIView alloc]initWithFrame:frame];
    touMingView.backgroundColor = [UIColor blackColor];
    touMingView.alpha = 0.5;
    [self addSubview:touMingView];
    
    //背景View
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    //背景覆盖一层Button，添加点击事件
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    bgButton.frame = frame;
    bgButton.backgroundColor = [UIColor clearColor];
    [bgButton addTarget:self action:@selector(toClickForBGView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bgButton];
    
    //显示View
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(screen_width - 110, 100, 100, screen_height - 220)];
    showView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:showView];
    
    //信息标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 50, 30)];
    titleLabel.font = [UIFont systemFontOfSize:20 weight:8];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"分享";
    [showView addSubview:titleLabel];
    //奖牌
    CGFloat showViewWidth = showView.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(titleLabel.maxX, 0, 40, 40)];
//    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"my_post_Image_fenxiang"];
    imageView.layer.cornerRadius = 20.0f;
    imageView.layer.masksToBounds = YES;
    [showView addSubview:imageView];
    
    UIButton *bgButtonFenxiang = [UIButton buttonWithType:UIButtonTypeSystem];
    bgButtonFenxiang.frame = CGRectMake(0, 0, showViewWidth, 40);
    bgButtonFenxiang.backgroundColor = [UIColor clearColor];
    bgButtonFenxiang.tag = 0;
    [bgButtonFenxiang addTarget:self action:@selector(toClickFenxiangView:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:bgButtonFenxiang];
    
    
    //收藏
    UILabel *collectionTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, bgButtonFenxiang.maxY + 21, 50, 30)];
    collectionTitleLabel.font = [UIFont systemFontOfSize:20 weight:8];
    collectionTitleLabel.textColor = [UIColor whiteColor];
    collectionTitleLabel.backgroundColor = [UIColor clearColor];
    collectionTitleLabel.textAlignment = NSTextAlignmentCenter;
    collectionTitleLabel.text = @"收藏";
    [showView addSubview:collectionTitleLabel];
    //收藏图片
    UIImageView *imageViewcollect = [[UIImageView alloc]initWithFrame:CGRectMake(collectionTitleLabel.maxX, bgButtonFenxiang.maxY + 15, 40, 40)];
    imageViewcollect.backgroundColor = [UIColor redColor];
    imageViewcollect.image = [UIImage imageNamed:@"my_post_Image_shoucang"];
    imageViewcollect.layer.cornerRadius = 20.0f;
    imageViewcollect.layer.masksToBounds = YES;
    [showView addSubview:imageViewcollect];
    
    UIButton *bgButtonShoucang = [UIButton buttonWithType:UIButtonTypeSystem];
    bgButtonShoucang.frame = CGRectMake(0, bgButtonFenxiang.maxY + 15, showViewWidth, 40);
    bgButtonShoucang.backgroundColor = [UIColor clearColor];
    bgButtonShoucang.tag = 1;
    [bgButtonShoucang addTarget:self action:@selector(toClickFenxiangView:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:bgButtonShoucang];
    
    //举报
    UILabel *jubaoTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, bgButtonShoucang.maxY + 21, 50, 30)];
    jubaoTitleLabel.font = [UIFont systemFontOfSize:20 weight:8];
    jubaoTitleLabel.textColor = [UIColor whiteColor];
    jubaoTitleLabel.backgroundColor = [UIColor clearColor];
    jubaoTitleLabel.textAlignment = NSTextAlignmentCenter;
    jubaoTitleLabel.text = @"举报";
    [showView addSubview:jubaoTitleLabel];
    //收藏图片
    UIImageView *imageViewJubao = [[UIImageView alloc]initWithFrame:CGRectMake(jubaoTitleLabel.maxX, bgButtonShoucang.maxY + 15, 40, 40)];
//    imageViewJubao.backgroundColor = [UIColor redColor];
    imageViewJubao.image = [UIImage imageNamed:@"my_post_Image_jubao"];
    imageViewJubao.layer.cornerRadius = 20.0f;
    imageViewJubao.layer.masksToBounds = YES;
    [showView addSubview:imageViewJubao];
    
    UIButton *bgButtonJubao = [UIButton buttonWithType:UIButtonTypeSystem];
    bgButtonJubao.frame = CGRectMake(0, bgButtonShoucang.maxY + 15, showViewWidth, 40);
    bgButtonJubao.backgroundColor = [UIColor clearColor];
    bgButtonJubao.tag = 2;
    [bgButtonJubao addTarget:self action:@selector(toClickFenxiangView:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:bgButtonJubao];
    
//    CGSize size = [contentLabel sizeThatFits:CGSizeMake(200, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
//    contentLabel.frame = CGRectMake(16, showViewWidth / 2 + 40, showViewWidth - 32, size.height);////<span style="font-family:Menlo;">假如是自适应高度的话，就把宽度确定</span>
//    [showView addSubview:contentLabel];
    
}
-(void)toClickFenxiangView:(UIButton *)sender {
    NSLog(@"点击分享？收藏？举报？==%ld",sender.tag);
    if(sender.tag == 0){//分享
        NSLog(@"分享点击");
    }
    if (sender.tag == 1) {
        NSLog(@"收藏点击");
    }
    if (sender.tag == 2) {
        NSLog(@"举报点击");
    }
}
//背景View点击事件
- (void)toClickForBGView{
    [self removeFromSuperview];
}

@end
