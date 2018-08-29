//
//  UITextView+placeHolder.m
//  UITextView加placeHolderDemo
//
//  Created by YY on 2018/3/30.
//  Copyright © 2018年 YY. All rights reserved.
//

#import "UITextView+placeHolder.h"
#import <objc/runtime.h>
static const void *yy_placeHolderKey;
@interface UITextView ()
<UITextViewDelegate>
@property (nonatomic,strong)NSNumber *maxLength;
@property (nonatomic, readonly) UILabel *yy_placeHolderLabel;
@end
@implementation UITextView (placeHolder)

+(void)load{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(zwPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(zwPlaceHolder_swizzled_dealloc)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")),
                                   class_getInstanceMethod(self.class, @selector(zwPlaceHolder_swizzled_setText:)));
}
#pragma mark - swizzled
- (void)zwPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self zwPlaceHolder_swizzled_dealloc];
}
- (void)zwPlaceHolder_swizzling_layoutSubviews {
    if (self.yy_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.yy_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.yy_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self zwPlaceHolder_swizzling_layoutSubviews];
}
- (void)zwPlaceHolder_swizzled_setText:(NSString *)text{
    [self zwPlaceHolder_swizzled_setText:text];
    if (self.yy_placeHolder) {
        [self updatePlaceHolder];
    }
}
#pragma mark - associated
-(NSString *)yy_placeHolder{
    return objc_getAssociatedObject(self, &yy_placeHolderKey);
}
-(void)setYy_placeHolder:(NSString *)yy_placeHolder{
    objc_setAssociatedObject(self, &yy_placeHolderKey, yy_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}
-(UIColor *)yy_placeHolderColor{
    return self.yy_placeHolderLabel.textColor;
}
-(void)setYy_placeHolderColor:(UIColor *)yy_placeHolderColor{
    self.yy_placeHolderLabel.textColor = yy_placeHolderColor;
}
-(NSString *)placeholder{
    return self.yy_placeHolder;
}
-(void)setPlaceholder:(NSString *)placeholder{
    self.yy_placeHolder = placeholder;
}
#pragma mark - update
- (void)updatePlaceHolder{
    if (self.text.length) {
        [self.yy_placeHolderLabel removeFromSuperview];
        return;
    }
    self.yy_placeHolderLabel.font = self.font?self.font:self.cacutDefaultFont;
    self.yy_placeHolderLabel.textAlignment = self.textAlignment;
    self.yy_placeHolderLabel.text = self.yy_placeHolder;
    [self insertSubview:self.yy_placeHolderLabel atIndex:0];
}
#pragma mark - lazzing
-(UILabel *)yy_placeHolderLabel{
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(yy_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(yy_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}
- (UIFont *)cacutDefaultFont{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}

-(void)setMaxLength:(NSNumber *)maxLength{
    objc_setAssociatedObject(self, @selector(maxLength), maxLength, OBJC_ASSOCIATION_COPY);
}

-(NSNumber *)maxLength{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setTextMaxLength:(NSInteger)maxLength{
    self.maxLength=@(maxLength);
    self.delegate=self;
}
-(void)textViewDidChange:(UITextView *)textView{
    NSString *toBeString=textView.text;
    if ([textView.textInputMode.primaryLanguage isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange=[textView markedTextRange];
        if (!selectedRange &&toBeString.length>[self.maxLength integerValue]) {
            textView.text=[toBeString substringToIndex:5];
        }
    }else if (toBeString.length>[self.maxLength integerValue]){
        textView.text=[toBeString substringToIndex:[self.maxLength integerValue]];
    }
}
@end
