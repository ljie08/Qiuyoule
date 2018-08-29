//
//  MXOfficialDetailHeaderView.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXOfficialDetailHeaderView : UIView

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, assign) CGFloat webHeight;
@property (nonatomic, strong) UILabel *titleLab;

- (void)setDataWithModel:(MXSYJFocusOnModel *)model;

@end
