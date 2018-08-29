//
//  IntegralDetailView.m
//  MXFootBall
//
//  Created by wxw on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "IntegralDetailView.h"
@interface IntegralDetailView ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;

@end
@implementation IntegralDetailView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addUIForIntegralDetailView:frame withShowImage:image];
        
    }
    return self;
}

//添加界面
-(void) addUIForIntegralDetailView:(CGRect)frame withShowImage:(UIImage *)showImage{
    
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
    
//    //显示View
//    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(scaleWithSize(60), (screen_width - scaleWithSize(120)) / 2, screen_width - scaleWithSize(120), screen_width - scaleWithSize(120))];
//    showView.backgroundColor = [UIColor whiteColor];
//    showView.center = CGPointMake(screen_width/2, screen_height/2);//居中显示
//    [bgView addSubview:showView];
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
//    CGFloat showViewWidth = showView.frame.size.width;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((showViewWidth - (showViewWidth / 2 - scaleWithSize(20))) / 2, scaleWithSize(20), showViewWidth / 2 - scaleWithSize(20), showViewWidth / 2 - scaleWithSize(30))];
    self.imageView.image = [UIImage imageNamed:_numberimg];
    [showView addSubview:self.imageView];
    
    //信息标题
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(10), showViewWidth / 2 + scaleWithSize(20), showViewWidth - scaleWithSize(20), scaleWithSize(20))];
//    titleLabel.font = [UIFont systemFontOfSize:16 weight:8];
    self.titleLabel.font = fontSize(scaleWithSize(14.0f));
//    self.titleLabel.textColor = mx_Wode_color333333;
    self.titleLabel.textColor =  [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.titleLabel.text = @"我的模块解锁";
//    self.titleLabel.text = self.titleLabelStr;
    [showView addSubview:self.titleLabel];
    
    //信息内容
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(20), self.titleLabel.maxY + scaleWithSize(20), showViewWidth - scaleWithSize(40), (showViewWidth - (showViewWidth / 2 + scaleWithSize(40))))];
//    self.contentLabel.textColor = mx_Wode_color666666;
    self.contentLabel.textColor =  [UIColor whiteColor];
    self.contentLabel.font = fontSize(scaleWithSize(11.0f));
   self.contentLabel.text = @"嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿嘿";
//    self.contentLabel.text = self.contentLabelStr;
    self.contentLabel.numberOfLines = 0;
    
#pragma mark ----段落的处理---间距问题
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];
    NSMutableParagraphStyle *style2 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style2.paragraphSpacing = 5;//段落后面的间距
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, [self.contentLabel.text length])];
    self.contentLabel.attributedText = attrString2;
    
//    contentLabel.backgroundColor = [UIColor lightGrayColor];
    
    CGSize size = [self.contentLabel sizeThatFits:CGSizeMake(scaleWithSize(200), MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    self.contentLabel.frame = CGRectMake(scaleWithSize(20), self.titleLabel.maxY + scaleWithSize(10), showViewWidth - scaleWithSize(40), size.height);////<span style="font-family:Menlo;">假如是自适应高度的话，就把宽度确定</span>
    
    [showView addSubview:self.contentLabel];
    
}
- (void)setNumberimg:(NSString *)numberimg {
    _numberimg = numberimg;
//     self.imageView.image = [UIImage imageNamed:_numberimg];
     [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", numberimg]] placeholderImage:[UIImage imageNamed:@"my_dengjitequan_xiao1_hui"]];
}
- (void)setTitleLabelStr:(NSString *)titleLabelStr {
    _titleLabelStr = titleLabelStr;
    self.titleLabel.text = titleLabelStr;
}
- (void)setContentLabelStr:(NSString *)contentLabelStr {
    _contentLabelStr = contentLabelStr;
    self.contentLabel.text = contentLabelStr;
}
//背景View点击事件
- (void)toClickForBGView{
    [self removeFromSuperview];
}

@end
