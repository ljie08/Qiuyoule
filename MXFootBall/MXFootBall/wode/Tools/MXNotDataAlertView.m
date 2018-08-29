//
//  MXNotDataAlertView.m
//  MXFootBall
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXNotDataAlertView.h"
@interface MXNotDataAlertView ()
@property (nonatomic,strong)UILabel *alertLabel;
@end
@implementation MXNotDataAlertView
+(instancetype)shareInstance{
    static MXNotDataAlertView *magager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (magager == nil) {
            magager = [[self alloc] init];
        }
    });
    return magager;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        return self;
    }
    return self;
}
-(void)showNotDataAlertViewWithAlertText:(NSString*)text{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, screen_width, 40);
    self.center = CGPointMake(window.midX, window.midY);
    [window addSubview:self];
    
    self.alertLabel.frame = self.bounds;
    self.alertLabel.text  = text;
    [self addSubview:self.alertLabel];
}
- (void)hideNotDataAlertView{
    [self removeFromSuperview];
}
-(UILabel *)alertLabel{
    if (_alertLabel == nil) {
        _alertLabel = [[UILabel alloc]init];
        _alertLabel.textColor = [UIColor grayColor];
        _alertLabel.font = [UIFont systemFontOfSize:18.0];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.numberOfLines = 0;
    }
    return _alertLabel;
}

@end
