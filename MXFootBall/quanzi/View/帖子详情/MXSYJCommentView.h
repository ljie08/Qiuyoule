//
//  MXSYJCommentView.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextBlock)(NSString *textStr);

@interface MXSYJCommentView : UIView

/** 判断是否拖动来设置frame */
@property (nonatomic, assign, getter=isMark) BOOL mark;
/** textView */
@property (nonatomic, strong) UITextView *textView;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, copy) TextBlock strBlock;


@end
