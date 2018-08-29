//
//  BannerScrollView.h
//  JJMedia
//
//  Created by ljie on 16/6/21.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  BannerScrollViewDelegate;

@interface BannerScrollView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;//scrollview
@property (nonatomic, strong) UIImage *defaultImage;//默认图片
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;//banner的图片地址
@property (nonatomic, weak) id<BannerScrollViewDelegate> delegate;
- (void)startTimer;//开启计时器
-(void)stopTimer;//关闭定时器

@property (nonatomic, assign) float bannerHeight;

@end

@protocol BannerScrollViewDelegate <NSObject>

//第几个banner被点击了
- (void)bannerTappedIndex:(NSInteger)index tap:(UITapGestureRecognizer *)tap;

@end
