//
//  MXssLevelBouncedView.m
//  MXFootBall
//
//  Created by Mac on 2018/4/3.
//  Copyright © 2018年 zt. All rights reserved.
//等级弹框显示view

#import "MXssLevelBouncedView.h"
@interface MXssLevelBouncedView ()

@property (nonatomic,strong) UIImageView *imageView;
@end
@implementation MXssLevelBouncedView

- (instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)image withShowPermissionName:(NSString *)permissionName withPersonContent:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUIForIntegralDetailView:frame withShowImage:image withShowPermissionName:permissionName withPersonContent:content];
        
    }
    return self;
}

//添加界面
-(void) addUIForIntegralDetailView:(CGRect)frame withShowImage:(NSString *)showImage withShowPermissionName:(NSString *)permissionName withPersonContent:(NSString *)content{
    
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
    
    //显示View
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(scaleWithSize(60), (screen_width - scaleWithSize(120)) / 2, screen_width - scaleWithSize(120), screen_width - scaleWithSize(120))];
    showView.backgroundColor = mx_Wode_colorff4242;
    showView.center = CGPointMake(screen_width/2, screen_height/2);//居中显示
    [bgView addSubview:showView];
    
     CGFloat showViewWidth = showView.frame.size.width;
    
    UIImageView *imageGuang = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, showViewWidth / 2 - scaleWithSize(10))];
    imageGuang.image = [UIImage imageNamed:@"my_huang_guang"];
    [showView addSubview:imageGuang];
    
    //奖牌
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((showViewWidth - (showViewWidth / 2 - scaleWithSize(20))) / 2, scaleWithSize(20), showViewWidth / 2 - scaleWithSize(20), showViewWidth / 2 - scaleWithSize(10))];
    NSLog(@"????=%@",_numberimg);
//    showImage
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", showImage]] placeholderImage:[UIImage imageNamed:@"my_dengjitequan_xiao1"]];
//    self.imageView.image = [UIImage imageNamed:@"my_dengjitequan_xiao8"];
    [showView addSubview:self.imageView];
    
    //信息标题
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(10), showViewWidth / 2 + scaleWithSize(20), showViewWidth - scaleWithSize(20), scaleWithSize(20))];
    //    titleLabel.font = [UIFont systemFontOfSize:16 weight:8];
    titleLabel.font = fontSize(scaleWithSize(14.0f));
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //    titleLabel.backgroundColor = [UIColor redColor];
//    titleLabel.text = @"恭喜升级！将解锁以下功能";
    titleLabel.text = permissionName;
    [showView addSubview:titleLabel];
    
    //信息内容
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(20), titleLabel.maxY + scaleWithSize(20), showViewWidth - scaleWithSize(40), (showViewWidth - (showViewWidth / 2 + scaleWithSize(40))))];
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = fontSize(scaleWithSize(11.0f));
//    contentLabel.text = @"1.嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿 \n2.嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿";
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    //    contentLabel.backgroundColor = [UIColor lightGrayColor];
#pragma mark ----段落的处理---间距问题
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSMutableParagraphStyle *style2 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style2.paragraphSpacing = 5;//段落后面的间距
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, [contentLabel.text length])];
    contentLabel.attributedText = attrString2;
    CGSize size = [contentLabel sizeThatFits:CGSizeMake(scaleWithSize(200), MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    contentLabel.frame = CGRectMake(scaleWithSize(20), titleLabel.maxY + scaleWithSize(10), showViewWidth - scaleWithSize(40), size.height);////<span style="font-family:Menlo;">假如是自适应高度的话，就把宽度确定</span>
    
    [showView addSubview:contentLabel];
    
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
