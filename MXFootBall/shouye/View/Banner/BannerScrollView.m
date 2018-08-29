//
//  BannerScrollView.m
//  JJMedia
//
//  Created by ljie on 16/6/21.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import "BannerScrollView.h"
#import "JJPageControlView.h"//自定义pageControl
#define  imageViewCount 3

#import "UIImageView+WebCache.h"

#define ScreenBounds [[UIScreen mainScreen] bounds]     //屏幕frame
#define ScreenFullHeight [[UIScreen mainScreen] bounds].size.height //屏幕高度
#define ScreenFullWidth [[UIScreen mainScreen] bounds].size.width   //屏幕宽度

@interface BannerScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) JJPageControlView * jjPageControl;
@property (nonatomic, strong) NSTimer *timer;//计时器

@end

@implementation BannerScrollView

- (void)setImageUrls:(NSArray<NSString *> *)imageUrls {
    _imageUrls = imageUrls;
    [self setScrollView];//配置scrollView
    [self setPageControl];//配置pageControl
    [self stopTimer];
    if (_timer == nil) {
        [self startTimer];//开启定时器
    }
    [self updateImage];//imageView布局
}

- (void)setScrollView {
    if (self.scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.frame = CGRectMake(0, 0, ScreenFullWidth, self.bannerHeight);
#pragma mark - contentSize的高度设置后，图片大小和scroll大小一致，
        self.scrollView.contentSize = CGSizeMake(imageViewCount * self.frame.size.width, self.bannerHeight);
        //添加三张imageView 无论要显示多少张图片轮播  只需要用3个imageView
        for (NSUInteger i = 0; i < imageViewCount; i++) {
            UIImageView *imageV = [[UIImageView alloc]init];
            imageV.frame = CGRectMake(i * ScreenFullWidth, 0, ScreenFullWidth, self.bannerHeight);
            [self.scrollView addSubview:imageV];
            /**
             给图片添加手势
             */
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [imageV addGestureRecognizer:tap];
        }
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;//设置代理
        self.scrollView.bounces = NO;//设置 滑动不允许超出边界 (不会反弹)
        self.scrollView.pagingEnabled = YES;//翻页效果
        [self addSubview:self.scrollView];
    }
}

- (void)setPageControl {
    if (_jjPageControl == nil) {
        _jjPageControl = [[JJPageControlView alloc] init];
        _jjPageControl.count = self.imageUrls.count;//设置jjpagecontrol  总页数
        _jjPageControl.currentPage = 0;//当前页数为0
        _jjPageControl.frame = CGRectMake(screen_width - _jjPageControl.frame.size.width - 15,self.scrollView.frame.size.height - 15, _jjPageControl.frame.size.width, 5);
        [self addSubview:_jjPageControl];
    }
}

- (void)updateImage {//更新图片
    for (NSUInteger i = 0; i < self.scrollView.subviews.count; i++) {//取出scrollview 上的三个子试图 imageView
        UIImageView *imagV = self.scrollView.subviews[i];
        NSInteger index = _jjPageControl.currentPage;//拿到当前显示的页数
        if (i == 0) {//如果是第一张imageView，也就是最左边的那张imageView
            index--;//显示的图片应该是当前页数 -1
        }else if(i == 2) {//如果是第三张imageView，也就是最右边的imageView
            index++;//显示的图片应该是当前页数 +1
        }
        if (index < 0) {//如果inde < 0 把页数重置位最后一张
            index = self.imageUrls.count - 1;
        } else if (index >= self.imageUrls.count) {
            index = 0;//将右边的imageView的currentpage设为0
        }
        imagV.tag = index;//设置 iamge 的tag 值
        [imagV sd_setImageWithURL:[NSURL URLWithString:self.imageUrls[index]] placeholderImage:[UIImage imageNamed:@"banner-1"] options:SDWebImageAllowInvalidSSLCertificates];//加载图片 imageUrls存的图片地址
        imagV.userInteractionEnabled = YES;//设置允许点击
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);//始终让 偏移 量停留在最中间的这张
}

//banner被点击
- (void)tapClick:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(bannerTappedIndex:tap:)]) {
        [self.delegate bannerTappedIndex:tap.view.tag tap:tap];//代理传值
    }
}

- (void)next {//动画显示第二张
    [self.scrollView setContentOffset:CGPointMake(2 * self.scrollView.frame.size.width, 0) animated:YES];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];//用户操作scrollview时 停止定时器
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];//拖动结束 开始定时器
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateImage];//减速的时候 更新image
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self updateImage];//动画滚动时候 更新image
}

//在此方法中 设置pageControl 的page
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = 0;
    CGFloat minDistance = MAXFLOAT;
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(imageView.frame.origin.x - scrollView.contentOffset.x);
        if (distance < minDistance) {
            minDistance = distance;
            page = imageView.tag;
        }
    }
    _jjPageControl.currentPage = page;
#pragma mark - 禁止上下滑动
    scrollView.directionalLockEnabled = YES;
    scrollView.alwaysBounceHorizontal = YES;
}

#pragma mark - 定时器相关
- (void)startTimer {//开启定时器
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(next) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {//结束定时器
    if (self.timer.valid) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
