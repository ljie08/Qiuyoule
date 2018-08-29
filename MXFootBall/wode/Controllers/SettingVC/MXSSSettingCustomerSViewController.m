//
//  MXSSSettingCustomerSViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/12.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSSettingCustomerSViewController.h"

@interface MXSSSettingCustomerSViewController ()
@property (nonatomic, strong) UIImageView *appImages;//客服头像
@property (nonatomic, strong) UILabel *hysMessage;//客服
@property (nonatomic, strong) UILabel *contentCustomerListLabel;//客服简介
@property (nonatomic, strong) UIButton *shareCallPhoneButton;//拨打电话按钮
@property (nonatomic, strong) UILabel *compayTitleLabel;//公司名字
@end

@implementation MXSSSettingCustomerSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"客服";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self pageControlList];
}
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"客服"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"客服界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"客服界面\"}"];
}
- (void)pageControlList {
    CGFloat border = scaleWithSize(20.0f);
    CGFloat spacingBig = scaleWithSize(20.0f);
    //    CGFloat spaingSmall = 8.0f;
    //    CGFloat spacingMargins = 30.0f;
    CGFloat labelWidth = scaleWithSize(80.0f);
    
    _appImages = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width / 2 - labelWidth/2, spacingBig, labelWidth, labelWidth)];
    _appImages.layer.cornerRadius = labelWidth/2;
    _appImages.layer.masksToBounds = YES;
//    _appImages.backgroundColor = [UIColor blackColor];
    _appImages.image = [UIImage imageNamed:@"my_CustomerS_kefutouxiang"];
    [self.view addSubview:_appImages];
    
    _hysMessage = [[UILabel alloc] initWithFrame:CGRectMake(border, _appImages.frame.origin.y +labelWidth + 5, screen_width - border*2, 20)];
    _hysMessage.text = @"客服";
    _hysMessage.textAlignment = 1;
    _hysMessage.font = fontSize(scaleWithSize(14.0f));
    _hysMessage.textColor = mx_Wode_colorBlue2374e4;
    [self.view addSubview:_hysMessage];
    
    _contentCustomerListLabel = [[UILabel alloc] initWithFrame:CGRectMake(border, _hysMessage.frame.origin.y + scaleWithSize(30), screen_width - border*2, 150)];
    _contentCustomerListLabel.textColor = mx_Wode_color666666;
    _contentCustomerListLabel.text = @"lalalalaAPP是一款为彩民量身打造的专业书籍资讯服务工具。我们至于与为彩民提供更加优质的比分。赔率数据以及资讯服务等。 \n\n\n 客服电话：400-008-7865\n 官方网站：www.12345.com\n 官方微信公众号：fhisoij-fhuh";
    _contentCustomerListLabel.numberOfLines = 0;
    _contentCustomerListLabel.font = fontSize(scaleWithSize(14.0f));
    
    CGSize size = [_contentCustomerListLabel sizeThatFits:CGSizeMake(200, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    _contentCustomerListLabel.frame = CGRectMake(border, _hysMessage.frame.origin.y + scaleWithSize(33), screen_width - border*2, size.height);////<span style="font-family:Menlo;">假如是自适应高度的话，就把宽度确定</span>
    
    [self.view addSubview:_contentCustomerListLabel];
    
    _shareCallPhoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareCallPhoneButton.frame = CGRectMake(border, _contentCustomerListLabel.frame.origin.y + size.height + scaleWithSize(40), screen_width - border*2, scaleWithSize(50));
    [_shareCallPhoneButton setTitle:@"拨打电话" forState:UIControlStateNormal];
    [_shareCallPhoneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shareCallPhoneButton.titleLabel.font = fontSize(scaleWithSize(17.0f));
    _shareCallPhoneButton.backgroundColor = mx_Wode_colorBlue2374e4;
    [_shareCallPhoneButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareCallPhoneButton];
    
    _compayTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(border, screen_height - scaleWithSize(150), screen_width - border*2, scaleWithSize(20))];
    _compayTitleLabel.textColor = [UIColor grayColor];
    _compayTitleLabel.font = [UIFont systemFontOfSize:10.0f];
    _compayTitleLabel.text = @"魔曦广告传媒有限责任公司";
    _compayTitleLabel.textAlignment = 1;
    [self.view addSubview:_compayTitleLabel];
    
    
}
#pragma mark - shareButton 分享按钮
- (void)shareButtonClick:(UIButton *)sender {//拨打电话按钮点击
    NSLog(@"拨打电话按钮点击");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
