//
//  MXSYJCommentView.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCommentView.h"
#import "UITextView+placeHolder.h"

@interface MXSYJCommentView()

@end

@implementation MXSYJCommentView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, screen_width - 80, 40)];
        [self addSubview:self.textView];
        self.textView.font = fontSize(14);
        //不然设置的行间距不起作用
        self.textView.yy_placeHolder = @"评论楼主";
        self.textView.yy_placeHolderColor = mx_FontLightGreyColor;
        self.textView.textColor = mx_FontBalckColor;
        //设置控件文字的上下距离
        self.textView.textContainerInset=UIEdgeInsetsMake(3, 0, 3, 0);
        self.textView.layer.masksToBounds = YES;
        self.textView.layer.borderColor = mx_LineColor.CGColor;
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.cornerRadius = 2;
        
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.sendBtn];
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        self.sendBtn.titleLabel.font = fontBoldSize(14);
        [self.sendBtn setTitleColor:mx_FontBalckColor forState:UIControlStateNormal];
        [self.sendBtn setBackgroundColor:[UIColor whiteColor]];
        self.sendBtn.frame = CGRectMake(screen_width - 60, 10, 50, 40);
        [self.sendBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.sendBtn.layer.masksToBounds = YES;
        self.sendBtn.layer.borderColor = mx_LineColor.CGColor;
        self.sendBtn.layer.borderWidth = 0.5;
        self.sendBtn.layer.cornerRadius = 2;
        
        
    }
    
    return self;
    
}

- (void)click:(UIButton *)btn{
    
    if (self.strBlock) {
        self.strBlock(self.textView.text);
    }
    
}


@end
