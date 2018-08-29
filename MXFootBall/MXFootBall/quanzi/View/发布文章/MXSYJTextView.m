//
//  MXSYJTextView.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJTextView.h"
#import "UITextView+placeHolder.h"

@interface MXSYJTextView()<UIWebViewDelegate>

@end

@implementation MXSYJTextView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
       
        self.backgroundColor = [UIColor whiteColor];
        
        self.nameLab = [[UILabel alloc]init];
        [self addSubview:self.nameLab];
        self.nameLab.font = fontBoldSize(15);
        self.nameLab.textColor = mx_FontBalckColor;
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.text = @"文章标题";
        self.nameLab.sd_layout.leftSpaceToView(self, 15).topSpaceToView(self, 10).heightIs(15);
        [self.nameLab setSingleLineAutoResizeWithMaxWidth:300];
        
        
        self.titleTextFiled = [[UITextField alloc]init];
        [self addSubview:self.titleTextFiled];
        self.titleTextFiled.delegate = self;
        self.titleTextFiled.textColor = mx_FontBalckColor;
        self.titleTextFiled.font = fontBoldSize(15);
        self.titleTextFiled.placeholder = @" 简介输入文章的概要~~~";
        self.titleTextFiled.sd_layout.leftSpaceToView(self, 15).topSpaceToView(self.nameLab, 10).rightSpaceToView(self, 15).heightIs(40);
        self.titleTextFiled.backgroundColor = mx_Wode_backgroundColor;
        
        self.nameLab2 = [[UILabel alloc]init];
        [self addSubview:self.nameLab2];
        self.nameLab2.font = fontBoldSize(15);
        self.nameLab2.textColor = mx_FontBalckColor;
        self.nameLab2.textAlignment = NSTextAlignmentLeft;
        self.nameLab2.text = @"这一刻的想法(大于30个字)";
        self.nameLab2.sd_layout.leftSpaceToView(self, 15).topSpaceToView(self.titleTextFiled, 10).heightIs(15);
        [self.nameLab2 setSingleLineAutoResizeWithMaxWidth:300];
        
        UIWebView *webView = [[UIWebView alloc]init];
        webView.delegate = self;
        [self addSubview:webView];
        webView.sd_layout.leftSpaceToView(self, 15).rightSpaceToView(self, 15).topSpaceToView(self.nameLab2, 10).bottomSpaceToView(self, 10);
        self.webView = webView;
        
        NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"richTextEditor" withExtension:@"html"];
        [webView loadRequest:[NSURLRequest requestWithURL:filePath]];
//        self.textView = [[UITextView alloc]init];
//        self.textView.font = fontBoldSize(15);
//        self.textView.backgroundColor = mx_Wode_backgroundColor;
//        self.textView.delegate = self;
//        self.textView.yy_placeHolder = @"在这写入这一刻的想法(大于30字)";
////        [self.ccTextView setPlaceholderOpacity:0.9];
//        self.textView.yy_placeHolderColor = [UIColor lightGrayColor] ;
//        [self addSubview:self.textView];
//        self.textView.sd_layout.leftSpaceToView(self, 15).rightSpaceToView(self, 15).topSpaceToView(self.nameLab2, 10).heightIs(100);
        
    }
    
    return self;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField.text.length > 30) {
        [SVProgressHUD showInfoWithStatus:@"长度太长,限制在30字符以内~~~"];
        return;
    }else{
        if (textField.text.length > 0) {
            if (self.fiedStrBlock) {
                self.fiedStrBlock(textField.text);
            }
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length > 30) {
        if (self.textViewBlcok) {
            self.textViewBlcok(textView.text);
        }
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
