//
//  MXOfficialDetailHeaderView.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOfficialDetailHeaderView.h"

@implementation MXOfficialDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _titleLab = [[UILabel alloc] init];
        _webview = [[UIWebView alloc] init];
        [self addSubview:_titleLab];
        [self addSubview:_webview];
    }
    
    return self;
}

- (void)layoutSubviews {
    self.titleLab.frame = CGRectMake(15, 10, screen_width-30, 40);
    self.titleLab.textColor = mx_FontGreyColor;
    self.titleLab.font = fontSize(17);
    
    self.webview.frame = CGRectMake(15, CGRectGetMaxY(self.titleLab.frame)+10, screen_width-30, CGFLOAT_MIN);
    self.webview.userInteractionEnabled = NO;
    
    [self.webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setDataWithModel:(MXSYJFocusOnModel *)model {
    self.titleLab.text = model.title;
    [self.webview loadHTMLString:model.content baseURL:nil];
}

//监听webview高度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize size = [self.webview sizeThatFits:CGSizeZero];
//        [self.webview setScalesPageToFit:YES];
        self.webview.frame = CGRectMake(0, 0, screen_width, size.height);
        
        self.webHeight = size.height;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:size.height] forKey:@"webheight"];
        // 用通知发送加载完成后的高度
        [[NSNotificationCenter defaultCenter] postNotificationName:@"webviewheight" object:self userInfo:dic];
    }
}

- (void)dealloc {
    [self.webview.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

@end
