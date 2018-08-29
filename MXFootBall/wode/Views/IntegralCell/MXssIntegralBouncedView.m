//
//  MXssIntegralBouncedView.m
//  MXFootBall
//
//  Created by Mac on 2018/4/3.
//  Copyright © 2018年 zt. All rights reserved.
//积分任务弹框显示view

#import "MXssIntegralBouncedView.h"

@interface MXssIntegralBouncedView ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation MXssIntegralBouncedView

- (instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)image withShowPermissionName:(NSString *)scoreRuleContent withPersonContent:(NSString *)scoreUpperValue
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUIForIntegralDetailView:frame withShowImage:image withShowPermissionName:scoreRuleContent withPersonContent:scoreUpperValue];
        
    }
    return self;
}

//添加界面
-(void) addUIForIntegralDetailView:(CGRect)frame withShowImage:(NSString *)showImage withShowPermissionName:(NSString *)scoreRuleContent withPersonContent:(NSString *)scoreUpperValue{
    
    //透明层
    UIView *touMingView = [[UIView alloc]initWithFrame:frame];
    touMingView.backgroundColor = [UIColor blackColor];
    touMingView.alpha = 0.4;
    [self addSubview:touMingView];
    
    //背景View
    UIView *bgView = [[UIView alloc]initWithFrame:frame];
    bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:bgView];
    
    //背景覆盖一层Button，添加点击事件
    UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    bgButton.frame = frame;
    bgButton.backgroundColor = [UIColor clearColor];
    [bgButton addTarget:self action:@selector(toClickForBGView) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:bgButton];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(60), (screen_width - scaleWithSize(120)) / 2, scaleWithSize(335), scaleWithSize(627))];
    imageView.image = [UIImage imageNamed:@"my_wanchengrenwu_beiban"];
    imageView.center = CGPointMake(screen_width/2, screen_height/2);//居中显示
    [bgView addSubview:imageView];
    
    //显示View
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(scaleWithSize(60), (screen_width - scaleWithSize(120)) / 2, screen_width - scaleWithSize(120), screen_width - scaleWithSize(120))];
    showView.backgroundColor = [UIColor clearColor];
    showView.center = CGPointMake(screen_width/2, screen_height/2);//居中显示
    [bgView addSubview:showView];
    
    
    
//    //奖牌
    CGFloat showViewWidth = showView.frame.size.width;
//    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((showViewWidth - (showViewWidth / 2 - scaleWithSize(20))) / 2, scaleWithSize(20), showViewWidth / 2 - scaleWithSize(20), showViewWidth / 2 - scaleWithSize(30))];
//    //    imageView.backgroundColor = [UIColor redColor];
//    //    imageView.image = showImage;
//    NSLog(@"????=%@",_numberimg);
//    self.imageView.image = [UIImage imageNamed:@"my_dengjitequan_xiao1"];
//    [showView addSubview:self.imageView];
    
//    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, scaleWithSize(50), showView.frame.size.width, scaleWithSize(30))];
//    titleText.textAlignment = 1;
//    //富文本 初始化
//    NSMutableAttributedString *dayTest = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"恭喜完成任务"]];
//    //设置颜色
//    [dayTest addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, 6)];
//    //设置字体
//    [dayTest addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:25] range:NSMakeRange(0, 6)];
//    //将字符串添加进控件
//    [titleText setAttributedText:dayTest];
////    [titleText sizeToFit];
//    [showView addSubview:titleText];
    
    UILabel *titleTextName = [[UILabel alloc] initWithFrame:CGRectMake(0, scaleWithSize(90), showView.frame.size.width, scaleWithSize(20))];
    titleTextName.textAlignment = 1;
//    titleTextName.text = @"注册任务";
    titleTextName.text = scoreRuleContent;
    titleTextName.textColor = [UIColor whiteColor];
    titleTextName.font = fontBoldSize(scaleWithSize(15.0f));
    [showView addSubview:titleTextName];
    
    //信息标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(10), showViewWidth / 2 , showViewWidth - scaleWithSize(20), scaleWithSize(30))];
    //    titleLabel.font = [UIFont systemFontOfSize:16 weight:8];
    titleLabel.font = fontSize(scaleWithSize(30.0f));
//    titleLabel.text = @"1000";
    titleLabel.text = scoreUpperValue;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
//    titleLabel.text = @"恭喜升级！将解锁以下功能";
    //富文本 初始化
//    NSMutableAttributedString *day = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"1000"]];
    //为字符串添加具体效果
    //设置颜色
//    [day addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2, day.length - 4)];
//    //设置字体
//    [day addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30] range:NSMakeRange(2, day.length - 4)];
//    //将字符串添加进控件
//    [titleLabel setAttributedText:day];
    [showView addSubview:titleLabel];
    
    UIButton *quedingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    quedingButton.frame = CGRectMake(showView.frame.size.width /2 - scaleWithSize(50), titleLabel.maxY + scaleWithSize(20), scaleWithSize(100), scaleWithSize(35));
    quedingButton.backgroundColor = mx_Wode_colorfee100;
    [quedingButton setTitle:@"确定" forState:UIControlStateNormal];
    quedingButton.titleLabel.font = fontSize(scaleWithSize(14.0f));
    quedingButton.layer.cornerRadius = 4.0f;
    quedingButton.layer.masksToBounds = YES;
    [quedingButton setTitleColor:mx_Wode_colorff4c35 forState:UIControlStateNormal];
    [quedingButton addTarget:self action:@selector(quedingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:quedingButton];
    
}
#pragma mark --- 确定按钮点击
- (void)quedingButtonClick:(UIButton*)sender {
    NSLog(@"确定按钮的点击~");
    [self removeFromSuperview];
}
- (void)setNumberimg:(NSString *)numberimg {
    _numberimg = numberimg;
    self.imageView.image = [UIImage imageNamed:_numberimg];
}
//背景View点击事件
- (void)toClickForBGView{
    [self removeFromSuperview];
}


@end
