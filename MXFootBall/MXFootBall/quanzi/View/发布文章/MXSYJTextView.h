//
//  MXSYJTextView.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FiledStr)(NSString *filedText);
typedef void(^TextViewStr)(NSString *textViewText);


@interface MXSYJTextView : UIView<UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *nameLab2;
@property (nonatomic, strong) UITextField *titleTextFiled;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, copy) FiledStr fiedStrBlock;
@property (nonatomic, copy) TextViewStr textViewBlcok;

@end
