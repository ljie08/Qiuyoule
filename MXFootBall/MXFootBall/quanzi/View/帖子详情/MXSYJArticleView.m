//
//  MXSYJArticleView.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJArticleView.h"
#import "UIImage+Category.h"
#import "UIButton+ImagePosition.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YBImageBrowser.h"
#import "YBImageBrowserModel.h"

@interface MXSYJArticleView ()<UIGestureRecognizerDelegate, WKNavigationDelegate, UITextViewDelegate>{
    
    CGFloat height;
    NSMutableArray *_imgArr;
    
    NSMutableArray *imageViewArr;
    
    NSMutableArray *_smallImgArr;
    
    CGFloat imgTotalHeight;
    
    CGFloat textHeight;
    
    NSMutableArray *imgsHeight;
    
    CGFloat adsHeight;
    
    CGFloat titleHeight;
    
    NSArray *webviewImgArr;
}


@end

@implementation MXSYJArticleView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _imgArr = [NSMutableArray array];
        _smallImgArr = [NSMutableArray array];
        imageViewArr = [NSMutableArray array];
        
        imgsHeight = [NSMutableArray array];
        
        self.userInteractionEnabled = YES;
        
        self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topPlace"]];
        self.iconView.layer.cornerRadius = scaleWithSize(30);
        self.iconView.layer.masksToBounds = YES;
        [self addSubview:self.iconView];
        self.iconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToInfoClick)];
        [self.iconView addGestureRecognizer:tap1];
        
        self.nameLab = [[UILabel alloc]init];
        [self addSubview:self.nameLab];
        self.nameLab.textColor = mx_FontBalckColor;
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = fontSize(14);
        [self.nameLab setSingleLineAutoResizeWithMaxWidth:200];
        
        self.levelLab = [[UILabel alloc]init];
        [self addSubview:self.levelLab];
        self.levelLab.textColor = mx_FontGreyColor;
        self.levelLab.textAlignment = NSTextAlignmentCenter;
        self.levelLab.font = fontSize(12);
//        self.levelLab.sd_layout.leftSpaceToView(self.nameLab, 10).topSpaceToView(self, 20).heightIs(15).widthIs(30);
        self.levelLab.layer.masksToBounds = YES;
        self.levelLab.layer.cornerRadius = 5;
        self.levelLab.layer.borderColor = mx_FontLightGreyColor.CGColor;
        self.levelLab.layer.borderWidth = 1.0;
        
        self.postLab = [[UILabel alloc]init];
        [self addSubview:self.postLab];
        self.postLab.textColor = mx_FontGreyColor;
        self.postLab.textAlignment = NSTextAlignmentLeft;
        self.postLab.font = fontSize(12);
        [self.postLab setSingleLineAutoResizeWithMaxWidth:200];
        
        self.fansLab = [[UILabel alloc]init];
        [self addSubview:self.fansLab];
        self.fansLab.textColor = mx_FontGreyColor;
        self.fansLab.textAlignment = NSTextAlignmentLeft;
        self.fansLab.font = fontSize(12);
        [self.fansLab setSingleLineAutoResizeWithMaxWidth:200];
        
        self.focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.focusBtn];
        [self.focusBtn setBackgroundColor:mx_BlueColor];
        //        [self.focusBtn setTitle:@"+关注" forState:UIControlStateNormal];
        self.focusBtn.titleLabel.font = fontBoldSize(14);
        self.focusBtn.tag = 3;
        self.focusBtn.enabled = NO;
        [self.focusBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.focusBtn.sd_cornerRadius = @3;
        
//        self.titleLab = [[UILabel alloc]init];
//        [self addSubview:self.titleLab];
//        self.titleLab.numberOfLines = 2;
//        self.titleLab.textColor = mx_FontBalckColor;
//        self.titleLab.textAlignment = NSTextAlignmentLeft;
//        self.titleLab.isAttributedContent = YES;
        
        self.titleTextview = [[UITextView alloc]init];
        [self addSubview:self.titleTextview];
        self.titleTextview.contentInset = UIEdgeInsetsMake(0, -5, 0, -5);
        self.titleTextview.font = fontSize(scaleWithSize(20));
        self.titleTextview.userInteractionEnabled = NO;
        
        self.fromLab = [[UILabel alloc]init];
        [self addSubview:self.fromLab];
        self.fromLab.textColor = mx_FontGreyColor;
        self.fromLab.font = fontSize(13);
        self.fromLab.textAlignment = NSTextAlignmentLeft;
//        self.fromLab.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self.titleTextview, 5).heightIs(15);
        [self.fromLab setSingleLineAutoResizeWithMaxWidth:200];
        
        
        self.createTimeLab = [[UILabel alloc]init];
        [self addSubview:self.createTimeLab];
        self.createTimeLab.textColor = mx_FontGreyColor;
        self.createTimeLab.font = fontSize(13);
        [self.createTimeLab setSingleLineAutoResizeWithMaxWidth:200];
        
        self.readLab = [[UILabel alloc]init];
        [self addSubview:self.readLab];
        self.readLab.textColor = mx_FontGreyColor;
        self.readLab.font = fontSize(13);
        self.readLab.textAlignment = NSTextAlignmentLeft;
        [self.readLab setSingleLineAutoResizeWithMaxWidth:200];
        
        self.articleText = [[UILabel alloc]init];
        [self addSubview:self.articleText];
        self.articleText.textColor = mx_FontBalckColor;
        self.articleText.textAlignment = NSTextAlignmentLeft;
        self.articleText.isAttributedContent = YES;
        
        self.wkWebview = [[ZTGoodsDetailWebView alloc]init];
        self.wkWebview.navigationDelegate = self;
        self.wkWebview.scrollView.scrollEnabled = NO;
        self.wkWebview.scrollView.contentSize = CGSizeZero;
        [self addSubview:self.wkWebview];
        
        self.exceptionalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.exceptionalBtn];
        [self.exceptionalBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.exceptionalBtn.titleLabel.font = fontSize(14);
        [self.exceptionalBtn setTitle:@"打赏" forState:UIControlStateNormal];
        self.exceptionalBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.exceptionalBtn.backgroundColor = mx_redColor;
        self.exceptionalBtn.tag = 1;
        [self.exceptionalBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.exceptionalBtn.sd_cornerRadius = @5;
        self.exceptionalBtn.hidden = YES;
        
        self.statementLab = [[UILabel alloc]init];
        [self addSubview:self.statementLab];
        self.statementLab.textColor = mx_FontGreyColor;
        self.statementLab.font = fontSize(12);
        self.statementLab.textAlignment = NSTextAlignmentLeft;
        self.statementLab.hidden = YES;
        
        self.articleFromLab = [[UILabel alloc]init];
        [self addSubview:self.articleFromLab];
        self.articleFromLab.hidden = YES;
        self.articleFromLab.textColor = mx_FontGreyColor;
        self.articleFromLab.font = fontSize(12);
        self.articleFromLab.textAlignment = NSTextAlignmentLeft;
        //        self.articleFromLab.text = @"来源:足球原创!";
        [self.articleFromLab setSingleLineAutoResizeWithMaxWidth:240];
        
        self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.collectBtn];
        [self.collectBtn setImage:[UIImage imageNamed:@"luntan_wujiaoxing_kong"] forState:UIControlStateNormal];
        [self.collectBtn setTitleColor:mx_FontBalckColor forState:UIControlStateNormal];
        self.collectBtn.titleLabel.font = fontSize(13);
        [self.collectBtn setTitle:@"16" forState:UIControlStateNormal];
        self.collectBtn.tag = 2;
        [self.collectBtn setImagePosition:ImagePositionLeft spacing:5];
        [self.collectBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        self.collectBtn.hidden = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushClick)];
        
        self.adImageView = [[UIImageView alloc]init];
        [self addSubview:self.adImageView];
        [self.adImageView addGestureRecognizer:tap];
        self.adImageView.userInteractionEnabled = YES;
        self.adImageView.hidden = YES;
        
        self.loadingView = [[UIView alloc]init];
        self.loadingView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.loadingView];
        
        [self setLayout];
    }
    return self;
}

- (void)setLayout{
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scaleWithSize(10));
        make.top.mas_equalTo(scaleWithSize(10));
        make.size.mas_equalTo(CGSizeMake(scaleWithSize(60), scaleWithSize(60)));
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconView.mas_centerY).offset(scaleWithSize(-5));
        make.left.mas_equalTo(self.iconView.mas_right).offset(scaleWithSize(5));
        make.width.mas_lessThanOrEqualTo(scaleWithSize(150));
    }];
    
    [self.levelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab.mas_right).offset(scaleWithSize(10));
        make.top.mas_equalTo(self.nameLab);
        make.width.mas_equalTo(scaleWithSize(30));
    }];
    
    [self.postLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLab);
//        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(scaleWithSize(10));
        make.top.mas_equalTo(self.iconView.mas_centerY).offset(scaleWithSize(5));
        make.width.mas_lessThanOrEqualTo(scaleWithSize(100));
    }];
    
    [self.fansLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.postLab.mas_right).offset(scaleWithSize(5));
        make.top.mas_equalTo(self.postLab);
        make.width.mas_lessThanOrEqualTo(scaleWithSize(100));
    }];
    
    [self.focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.right.mas_equalTo(scaleWithSize(-10));
        make.size.mas_equalTo(CGSizeMake(scaleWithSize(70), scaleWithSize(40)));
    }];
    
//    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(scaleWithSize(10));
//        make.top.mas_equalTo(self.iconView.mas_bottom).offset(scaleWithSize(10));
////        make.right.mas_equalTo(scaleWithSize(-10));
//        make.width.mas_lessThanOrEqualTo(screen_width - scaleWithSize(20));
//    }];
    
    [self.titleTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(10);
        make.trailing.equalTo(self).offset(-10);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(scaleWithSize(10));
        //        make.right.mas_equalTo(scaleWithSize(-10));
//        make.width.mas_lessThanOrEqualTo(screen_width - scaleWithSize(20));
    }];
    
    [self.readLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(scaleWithSize(-10));
        make.top.mas_equalTo(self.titleTextview.mas_bottom).offset(scaleWithSize(5));
        make.width.mas_lessThanOrEqualTo(scaleWithSize(100));
    }];
    
    [self.articleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextview);
        make.top.mas_equalTo(self.readLab.mas_bottom).offset(scaleWithSize(10));
        make.right.mas_equalTo(scaleWithSize(-10));
    }];
    
    [self.wkWebview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTextview);
        make.top.mas_equalTo(self.readLab.mas_bottom).offset(scaleWithSize(20));
        make.right.mas_equalTo(scaleWithSize(-10));
    }];
    
    [self.exceptionalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(scaleWithSize(60), scaleWithSize(30)));
    }];
    
//    [self.statementLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.exceptionalBtn.mas_top).offset(scaleWithSize(-10));
//        make.left.mas_equalTo(scaleWithSize(10));
//        make.width.mas_lessThanOrEqualTo(scaleWithSize(200));
//    }];
    
    [self.articleFromLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.collectBtn.mas_centerY);
        make.width.mas_lessThanOrEqualTo(scaleWithSize(100));
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(scaleWithSize(-10));
        make.bottom.mas_equalTo(self.exceptionalBtn.mas_top).offset(scaleWithSize(-10));
        make.size.mas_equalTo(CGSizeMake(scaleWithSize(60), scaleWithSize(40)));
    }];
    
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(screen_width, screen_width / 32 * 5 * 2));
    }];
}

- (void)click:(UIButton *)btn{
    
    if (self.click) {
        self.click(btn);
    }
    
}


#pragma mark - 数据源赋值
- (void)setModel:(MXSYJFocusOnModel *)model{
    
    _model = model;
    adsHeight = 0;
    self.exceptionalBtn.hidden = NO;
//    self.statementLab.text = @"声明：原创版权所有 违者必究";
    if (!self.articleType) {
        self.iconView.hidden = YES;
        self.levelLab.hidden = YES;
        self.postLab.hidden = YES;
        self.fansLab.hidden = YES;
        self.focusBtn.hidden = YES;
        self.fromLab.hidden = YES;
        [self.titleTextview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(scaleWithSize(10));
        }];
        self.nameLab.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self.titleTextview, 5).heightIs(15);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToInfoClick)];
        [self.nameLab addGestureRecognizer:tap];
        self.nameLab.userInteractionEnabled = YES;
        self.nameLab.textColor = mx_Wode_colorBlueprogress;
        self.createTimeLab.sd_layout.leftSpaceToView(self.nameLab, 10).topEqualToView(self.nameLab).heightIs(15);
    }else{
        self.statementLab.text = @"";
        self.fromLab.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self.titleTextview, 5).heightIs(15);
        self.createTimeLab.sd_layout.leftSpaceToView(self.fromLab, 10).topEqualToView(self.fromLab).heightIs(15);
//        [self.articleFromLab mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        }];
    }
    
    // 广告页
    if (self.adModel) {
        self.adImageView.hidden = NO;
        
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:self.adModel.advertPic]];
        [self.exceptionalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.adImageView.mas_top).offset(scaleWithSize(-10));
        }];
        adsHeight = screen_width / 32 * 5 * 2 ;
    }else{
        [self.exceptionalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(scaleWithSize(-10));
        }];
    }
    
    imgTotalHeight = 0;
    
    _imgArr = (NSMutableArray *)model.forumImgs;
    
    if (model.isAttention == 1) {
        [self.focusBtn setBackgroundColor:[UIColor grayColor]];
        [self.focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [self.focusBtn setBackgroundColor:mx_BlueColor];
        [self.focusBtn setTitle:@"+关注" forState:UIControlStateNormal];
        self.focusBtn.enabled = YES;
    }
    
    self.nameLab.text = model.username.length ? model.username : @" ";
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headerPic] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
    self.postLab.text = [NSString stringWithFormat:@"帖子 %@",model.articleNum];
    self.fansLab.text = [NSString stringWithFormat:@"粉丝 %@",model.fansNum];
    self.levelLab.text = [NSString stringWithFormat:@"LV%ld",(long)model.level];
//    self.titleLab.attributedText = [self cellTextAttributed:model.title font:fontBoldSize(20)];
    
    self.titleTextview.text = model.title;
    titleHeight = [self heightForString:self.titleTextview andWidth:screen_width - scaleWithSize(20)];
    [self.titleTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(titleHeight);
    }];
//    self.titleLab.lineBreakMode = NSLineBreakByTruncatingTail;
    self.fromLab.text = [NSString stringWithFormat:@"来自 %@",model.channelName];
    self.readLab.text = [NSString stringWithFormat:@"阅读数 %ld",(long)model.view];
    
    self.wkWebview.html = _model.content;
    
    if (![_model.content containsString:@"<"]) {
        UIImageView *lastImageView = nil;
        for (int i = 0; i < model.forumImgs.count; i++) {
            
            NSDictionary *dic = model.forumImgs[i];
            UIImage *img = [UIImage getImageFromUrl:dic[@"imgUrl"]];
            [_smallImgArr addObject:img];
            CGFloat imgHeight;
            if (_model.imgsHeight.count) {
                imgHeight = [_model.imgsHeight[i] floatValue];
            }else{
                UIImage *newImg = [img resizeImage:screen_width - 20];
                imgHeight = newImg.size.height;
            }
            
            [imgsHeight addObject:@(imgHeight)];
            
            imgTotalHeight = imgTotalHeight + 10 + imgHeight;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
            imageView.image = img;
            [self addSubview:imageView];
            [imageViewArr addObject:imageView];
            
            if (!i) {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo( self.wkWebview.mas_bottom).offset(10);
                    make.left.mas_equalTo(10);
                    make.size.mas_equalTo(CGSizeMake(screen_width - 20, imgHeight));
                }];
            }else{
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(lastImageView.mas_bottom).offset(10);
                    make.left.mas_equalTo(10);
                    make.size.mas_equalTo(CGSizeMake(screen_width - 20, imgHeight));
                }];
            }
            lastImageView = imageView;
        }
    }
    
    
    
    if ([model.comeFrom isEqualToString:@""]) {
        self.articleFromLab.text = [NSString stringWithFormat:@"来源：%@",model.channelName];
    }else{
        self.articleFromLab.text = [NSString stringWithFormat:@"来源：%@",model.comeFrom];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:_model.createTime];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"MM-dd HH:mm"];
    self.createTimeLab.text = [formatter1 stringFromDate:date];
    
    
    if (model.isCollect == 1) {
        [self.collectBtn setImage:[UIImage imageNamed:@"luntan_wujiaoxing_shi"] forState:UIControlStateNormal];
    }else{
        [self.collectBtn setImage:[UIImage imageNamed:@"luntan_wujiaoxing_kong"] forState:UIControlStateNormal];
    }
    
    [self.collectBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.collects] forState:UIControlStateNormal];

    self.focusBtn.enabled = YES;
    
    
    if (model.userId == [[MXssWodeUtils loadPersonInfo].userId integerValue]) {
        self.focusBtn.hidden = YES;
        self.exceptionalBtn.hidden = YES;
    }
}

- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)pushClick{
    if ([self.delegate respondsToSelector:@selector(pushToAdsVc:)]) {
        [self.delegate pushToAdsVc:self.adModel];
    }
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    
    //配置数据源（图片浏览器每一张图片对应一个 YBImageBrowserModel 实例）
    NSMutableArray *tempArr = [NSMutableArray array];
    [_imgArr enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YBImageBrowserModel *model = [YBImageBrowserModel new];
        UIImage *image = [UIImage getImageFromUrl:obj[@"imgUrl"]];
//        [model setImageWithFileName:obj[@"imgUrl"] fileType:@"jpeg"];
        [model setImage:image];
        model.sourceImageView = imageViewArr[idx];
        [tempArr addObject:model];
    }];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataArray = tempArr;
    browser.currentIndex = imageView.tag;
    [browser show];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    __weak typeof(self) weakSelf = self;
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable height, NSError * _Nullable error) {
        CGFloat webViewHeight = [height floatValue];
        [self.wkWebview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(webViewHeight);
        }];
        if ([weakSelf.delegate respondsToSelector:@selector(setHeaderViewHeight:imgsHeight:textHeight:)]) {
            [weakSelf.delegate setHeaderViewHeight:webViewHeight + imgTotalHeight + adsHeight + titleHeight imgsHeight:imgsHeight textHeight:textHeight];
        }
    }];
    
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    if(i==0){\
    if(objs[i].alt==''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt==''){\
    imgUrlStr+='#'+objs[i].src;\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt==''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    [webView evaluateJavaScript:jsGetImages completionHandler:nil];
    NSString *js2=@"getImages()";
    __block NSArray *array=[NSArray array];
    [webView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {

        NSString *resurlt = [NSString stringWithFormat:@"%@",Result];
        if([resurlt hasPrefix:@"#"]){
            resurlt = [resurlt substringFromIndex:1];
        }
        
        array = [resurlt componentsSeparatedByString:@"#"];
        webviewImgArr = array;
        
    }];
    
}
//显示大图

-(BOOL)showBigImage:(NSURLRequest *)request
{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"])
    {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        NSArray *imgUrlArr = webviewImgArr;
        NSInteger index=0;
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {
            if([imageUrl isEqualToString:imgUrlArr[i]])
            {
                index=i;
                break;
            }
        }
        //配置数据源（图片浏览器每一张图片对应一个 YBImageBrowserModel 实例）
        NSMutableArray *tempArr = [NSMutableArray array];
        [webviewImgArr enumerateObjectsUsingBlock:^(NSString *imgUrl, NSUInteger idx, BOOL * _Nonnull stop) {
            YBImageBrowserModel *model = [YBImageBrowserModel new];
            UIImage *image = [UIImage getImageFromUrl:imgUrl];
            [model setImage:image];
            [tempArr addObject:model];
        }];
        
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataArray = tempArr;
        browser.currentIndex = index;
        [browser show];
//        [WFImageUtil showImgWithImageURLArray:[NSMutableArrayarrayWithArray:imgUrlArr] index:index myDelegate:nil];
        return NO;
    }
    return YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    [self showBigImage:navigationAction.request];
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)pushToInfoClick{
    if ([self.delegate respondsToSelector:@selector(pushToUserInfo)]) {
        [self.delegate pushToUserInfo];
    }
    
}

@end

