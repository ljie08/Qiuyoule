//
//  MXSYJScrollerView.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJScrollerView.h"
#import "MXSYJChannelModel.h"

#define KW 25

@implementation MXSYJScrollerView

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.backgroundColor = mx_Wode_backgroundColor;
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;//设置 滑动不允许超出边界 (不会反弹)
    self.contentSize = CGSizeMake(KW * self.arrImg.count + 50 * self.arrImg.count, 60);
    self.userInteractionEnabled = YES;
    
    
    for (int i = 0; i < self.arrImg.count; i ++) {
        
        MXSYJChannelModel *model = self.arrImg[i];
        
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.frame = CGRectMake(KW * (i+1) + 45 * i, 5, 50, 50);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = mx_LineColor.CGColor;
        btn.layer.borderWidth = 0.7;
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager loadImageWithURL:[NSURL URLWithString:model.imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image) {
                [btn setImage:image forState:UIControlStateNormal];
                
            }
        }];
//        [manager downloadImageWithURL:[NSURL URLWithString:model.imgUrl] options:0 progress:^(NSInteger   receivedSize, NSInteger expectedSize) {
//            // progression tracking code
//        }  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,   BOOL finished, NSURL *imageURL) {
//        if (image) {
//        [btn setImage:image forState:UIControlStateNormal];
//
//        }
//        }];
        
    }
    
    
}

- (void)btnClick:(UIButton *)btn{
    
    if (self.pushAction) {
        self.pushAction(btn.tag);
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        
        
    }
    return self;
}

@end
