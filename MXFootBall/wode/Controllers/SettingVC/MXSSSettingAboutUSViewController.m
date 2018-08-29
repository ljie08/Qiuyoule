//
//  MXSSSettingAboutUSViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//关于我们

#import "MXSSSettingAboutUSViewController.h"

@interface MXSSSettingAboutUSViewController ()
@property (nonatomic, strong) UIImageView *appImages;//app
@property (nonatomic, strong) UILabel *hysMessage;//版本号
@property (nonatomic, strong) UILabel *contentAboutUSLabel;//关于app简介
@property (nonatomic, strong) UIButton *shareAboutUSButton;//签到按钮
@property (nonatomic, strong) UILabel *compayTitleLabel;//公司名字
@end

@implementation MXSSSettingAboutUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self MyAboutusMoreData];//关于我们s数据请求接口
}

#pragma mark ---MyAboutusData关于我们
-(void)MyAboutusMoreData{
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMyAboutus_PATH;//关于我们的列表
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
//    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"请求数据粉丝？关注？列表==%@",personDic);
//        [weakSelf.mainTableview.mj_header endRefreshing];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //            [SVProgressHUD dismiss];
            //            [self.mainTableview.mj_header endRefreshing];
//        content
            NSString *str =personDic[@"data"][@"content"];
            [self pageControlList:str];
            
//            [SVProgressHUD dismiss];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.mainTableview reloadData];
//            });
        }else {
            if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
                //请先登录
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                login.isPageNumber = 1;
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
            }else {
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
            }
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
//        [self.mainTableview.mj_header endRefreshing];
//        [self.mainTableview.mj_footer endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"关于我们"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"关于我们界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"关于我们界面\"}"];
}
- (void)pageControlList:(NSString *)str {
    CGFloat border = 15.0f;
    CGFloat spacingBig = 20.0f;
    CGFloat labelWidth = 80.0f;
    UIScrollView *applicationSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - STATUS_HEIGHT + scaleWithSize(20))];
    applicationSV.showsVerticalScrollIndicator = NO;
    applicationSV.backgroundColor = mx_Wode_backgroundColor;
    applicationSV.scrollEnabled = YES;
    [self.view addSubview:applicationSV];
    
    _appImages = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width / 2 - labelWidth/2, spacingBig, labelWidth, labelWidth)];
    _appImages.layer.cornerRadius = 5.0f;
    _appImages.layer.masksToBounds = YES;
    _appImages.image = [UIImage imageNamed:@"logoImage"];
    [applicationSV addSubview:_appImages];
    
//    _hysMessage = [[UILabel alloc] initWithFrame:CGRectMake(border, _appImages.frame.origin.y +labelWidth + 5, screen_width - border*2, 20)];
//    _hysMessage.text = [NSString stringWithFormat:@"版本 %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//    _hysMessage.textAlignment = 1;
//    _hysMessage.font = [UIFont systemFontOfSize:17.0f];
//    _hysMessage.textColor = [UIColor grayColor];
//    [applicationSV addSubview:_hysMessage];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[str  dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:15.0f] } documentAttributes:nil error:nil];
    _contentAboutUSLabel = [[UILabel alloc] init];
    _contentAboutUSLabel.textColor = [UIColor blackColor];
     _contentAboutUSLabel.attributedText = attrStr;//用于显示
     _contentAboutUSLabel.numberOfLines = 0;
    CGSize size = [_contentAboutUSLabel sizeThatFits:CGSizeMake(200, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度_appImages  _hysMessage
    _contentAboutUSLabel.frame = CGRectMake(border, _appImages.frame.origin.y+ scaleWithSize(20), screen_width - border*2, size.height/2+scaleWithSize(200));////<span style="font-family:Menlo;">假如是自适应高度的话，就把宽度确定</span>
    
#pragma mark ----段落的处理---间距问题
//    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:_contentAboutUSLabel.text];
//    NSMutableParagraphStyle *style2 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    style2.paragraphSpacing = 5;//段落后面的间距
//    [attrString2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, [_contentAboutUSLabel.text length])];
//    _contentAboutUSLabel .attributedText = attrString2;
//    _contentAboutUSLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [applicationSV addSubview:_contentAboutUSLabel];
    
//    _shareAboutUSButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _shareAboutUSButton.frame = CGRectMake(border, _contentAboutUSLabel.maxY + scaleWithSize(0), screen_width - border * 2, 40);
//    [_shareAboutUSButton setTitle:@"分享给好友" forState:UIControlStateNormal];
//    [_shareAboutUSButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _shareAboutUSButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    _shareAboutUSButton.backgroundColor = mx_Wode_colorBlue2374e4;
//    [_shareAboutUSButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [applicationSV addSubview:_shareAboutUSButton];
//
//    _compayTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(border, _shareAboutUSButton.maxY + scaleWithSize(40), screen_width - border*2, 20)];
//    _compayTitleLabel.textColor = [UIColor grayColor];
//    _compayTitleLabel.font = [UIFont systemFontOfSize:10.0f];
//    _compayTitleLabel.text = @"魔曦广告设计有限责任公司";
//    _compayTitleLabel.textAlignment = 1;
//    [applicationSV addSubview:_compayTitleLabel];
    
    UIView *viewContactus = [[UIView alloc] initWithFrame:CGRectMake(border,_contentAboutUSLabel.maxY + scaleWithSize(40), screen_width - border*2, size.height +scaleWithSize(4))];
//    viewContactus.backgroundColor = [UIColor whiteColor];
//    [applicationSV addSubview:viewContactus];
    
     applicationSV.contentSize = CGSizeMake(screen_width, viewContactus.frame.origin.y + scaleWithSize(10));
}
#pragma mark - shareButton 分享按钮
- (void)shareButtonClick:(UIButton *)sender {//分享按钮点击
    NSLog(@"分享按钮点击");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
