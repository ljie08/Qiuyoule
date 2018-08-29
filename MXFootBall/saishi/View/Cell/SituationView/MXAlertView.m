//
//  MXAlertView.m
//  MXAlertView
//
//  Created by YY on 2018/5/9.
//  Copyright © 2018年 YY. All rights reserved.
//

#import "MXAlertView.h"

@implementation MXAlertView

-(void)showErrorInfo:(NSString *)info{
    UIWindow *window=[[UIApplication sharedApplication] keyWindow];
    CGSize Size=[info boundingRectWithSize:CGSizeMake(window.frame.size.width-80, window.frame.size.width-60) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    self.frame=CGRectMake(0, 0, Size.width+20, Size.height+50);
    self.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.layer.cornerRadius=10;
    self.clipsToBounds=YES;
    
    window.backgroundColor=[UIColor whiteColor];
    [window addSubview:self];
    self.center=window.center;
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-30)/2, 5, 30, 30)];
    if (_type==MXErrorInfo) {
       imageView.image=[UIImage imageNamed:@"error"];
    }else{
       imageView.image=[UIImage imageNamed:@"info"];
    }
    
    [self addSubview:imageView];
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.frame.size.width-20, Size.height+10)];
    label.text=info;
    label.lineBreakMode=0;
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [self addSubview:label];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}
@end
