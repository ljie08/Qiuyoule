//
//  MXWodeViewController.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//我的页面
#import "MXWodeViewController.h"
#import "MXPersonalInformationViewController.h"//个人信息
#import "MXSSFansViewController.h"//粉丝页面
#import "MXSSCollectionViewController.h"//收藏页面
#import "MXSSSettingViewController.h"//设置页面
#import "MXSSMyPostListViewController.h"//我的帖子页面
#import "MXSSIntegralViewController.h"//任务积分页面
#import "MXSSMessageViewController.h"//消息中心页面
#import "MXssWodeModel.h"//model个人中心

@interface MXWodeViewController ()
{
    UIScrollView *applicationSV;
    UIView *vabc;
}
@property (nonatomic, strong) UILabel *hysNickName;//昵称
@property (nonatomic, strong) UILabel *hysLVName;//等级
@property (nonatomic, strong) UIButton *hysMessage;//消息按钮
@property (nonatomic, strong) UILabel *hysSignature;//签名
@property (nonatomic, strong) UIButton *qiandaoButton;//积分任务按钮
@property (nonatomic, strong) UIButton *button2;//积分任务按钮

@property (nonatomic, strong) UIButton *hysPostButton;//帖子按钮
@property (nonatomic, strong) UIButton *hysAttentionButton;//关注按钮
@property (nonatomic, strong) UIButton *hysFansButton;//粉丝按钮
@property (nonatomic, strong) UILabel *hysPostLabel;//帖子
@property (nonatomic, strong) UILabel *hysAttentionLabel;//关注
@property (nonatomic, strong) UILabel *hysFansLabel;//粉丝
@property (nonatomic, strong) UIButton *qiandaoButtonOne;//签到按
@property (nonatomic, strong) UIButton *button3;//签到按钮
@property (nonatomic, assign) BOOL buttonIsSwitch;//签到相关

@end

@implementation MXWodeViewController
@synthesize imgHeader;

UIButton *btnLoginOut;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor;
    [self setupUI];
    // 左边返回按键颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark ----个人中心数据获取
- (void)dataListNumber {//个人中心数据获取
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    if (userModel.userId) {//判断是否登录
        NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
        NSString *token = userModel.token;
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
        MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
        [config personWithUserid:userid token:token time:timeStr sign:nil success:^(NSDictionary *personDic) {
            NSLog(@"个人中心keai😊=%@",personDic);
            NSDictionary *dic = [personDic objectForKey:@"data"];
            if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            MXSSToolConfig *infoModel = [MXssWodeUtils loadPersonInfo];//注意不可以 alloc
            infoModel.fansNum = dic[@"fansNum"];//粉丝数
            infoModel.articleNum = dic[@"articleNum"];//发帖数
            infoModel.attentionNum = dic[@"attentionNum"];//关注数
            infoModel.level = dic[@"level"];//等级
            infoModel.signIn = dic[@"signIn"];//是否已经签到（0：未签到，已签到）
            infoModel.restScore = dic[@"restScore"];//剩余总积分
            infoModel.totalScore = dic[@"totalScore"];//总积分
            infoModel.nextMinScore = dic[@"nextMinScore"];//下一等级的最低积分线
            [MXssWodeUtils savePersonInfo:infoModel];
            
                [self setupUI];
            }else if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
                [MXssWodeUtils removePersonInfo];
                [self setupUI];
               //请先登录
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                login.isPageNumber = 1;
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
            }else {
                NSLog(@"错误不能解析%@",dic);
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
            }
        } failure:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=NO;//显示下面的tabbar
    NSLog(@"%f,%f",self.tabBarController.tabBar.midX,self.tabBarController.tabBar.minY);
    if (UI_IS_IPHONEX) {
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.size.height = 83;
        frame.origin.y = 729;
        self.tabBarController.tabBar.frame = frame;
    }
    [self.navigationController setNavigationBarHidden:YES animated:NO];//隐藏导航栏
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"我的界面\"}"];
    [self dataListNumber];//个人中心 数据获取
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [self.navigationController setNavigationBarHidden:NO animated:NO];//隐藏导航栏
    [super viewWillDisappear:animated];
//     self.tabBarController.tabBar.hidden=YES;//显示下面的tabbar
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"我的界面\"}"];
}

- (void)setupUI {
    CGFloat border = scaleWithSize(1.0f);
    CGFloat spacingBig = scaleWithSize(10.0f);
    CGFloat spaingSmall = scaleWithSize(8.0f);
    CGFloat spacingMargins = scaleWithSize(15.0f);
    CGFloat labelWidth = scaleWithSize(60.0f);
    CGFloat withLeftNum = scaleWithSize(15.0f);
    [vabc removeFromSuperview];//页面rem
    [applicationSV removeFromSuperview];//页面
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    vabc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(20))];
    vabc.backgroundColor = mx_Wode_colorBlue2374e4;
    [self.view addSubview:vabc];
    // 背景ScrollView
    applicationSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - STATUS_HEIGHT)];

    applicationSV.showsVerticalScrollIndicator = NO;
    applicationSV.backgroundColor = mx_Wode_backgroundColor;
    applicationSV.scrollEnabled = YES;
    [self.view addSubview:applicationSV];

    UIView *viewMyInfo = [[UIView alloc] init];
//    NSLog(@"========%f",screen_height);
    if (screen_height > 568.0f) {
        viewMyInfo.frame =CGRectMake(0, 0, screen_width, scaleWithSize(156));
    }else {
        viewMyInfo.frame =CGRectMake(0, 0, screen_width, scaleWithSize(166));
    }
    viewMyInfo.backgroundColor =mx_Wode_colorBlue2374e4;
    [applicationSV addSubview:viewMyInfo];
    
    //头像viewMyInfo.frame.size.height / 3====20
    imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(spacingMargins, spacingMargins, scaleWithSize(57), scaleWithSize(57))];
    imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(spacingMargins, spacingMargins*2, scaleWithSize(57), scaleWithSize(57))];
    imgHeader.layer.cornerRadius = imgHeader.frame.size.height / 2;
    
    if (userModel.headerPic) {
        [imgHeader sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", userModel.headerPic]] placeholderImage:[UIImage imageNamed:@"saishi_morentouxiang"]];//[UIImage imageNamed:@"pro_up_img"]
    } else {
        imgHeader.image = [UIImage imageNamed:@"saishi_morentouxiang"];
    }
    imgHeader.layer.masksToBounds = YES;
    [viewMyInfo addSubview:imgHeader];
    imgHeader.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImgViewHead = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPersonalInfoTouchEvent)];
    [imgHeader addGestureRecognizer:tapImgViewHead];
    /**昵称**/
    _hysNickName = [[UILabel alloc] initWithFrame:CGRectMake(imgHeader.frame.origin.x + imgHeader.frame.size.width + spacingBig, imgHeader.frame.origin.y, viewMyInfo.frame.size.width - imgHeader.frame.size.width - 3 * spacingMargins, (imgHeader.frame.size.height - border) / 2)];
    
    [_hysNickName setTextColor:[UIColor whiteColor]];
    [_hysNickName setFont:fontSize(scaleWithSize(17.0f))];//
    
    if (userModel.username) {
        _hysNickName.text = [NSString stringWithFormat:@"%@",userModel.username];
    }else{
        _hysNickName.text = @"请登录";
    }
    CGSize size = CGSizeMake(20,20); //设置一个行高上限
    NSDictionary *attribute = @{NSFontAttributeName: _hysNickName.font};
    CGSize labelsize = [_hysNickName.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attribute context:nil].size;
    if (labelsize.height + 5 < 15) {
         _hysNickName.frame = CGRectMake(imgHeader.frame.origin.x + imgHeader.frame.size.width + spacingBig, spacingMargins*2, labelsize.width + scaleWithSize(20), 20.81);
    }else{
    _hysNickName.frame = CGRectMake(imgHeader.frame.origin.x + imgHeader.frame.size.width + spacingBig, spacingMargins*2, labelsize.width + scaleWithSize(20), labelsize.height+5);
    }
    _hysNickName.backgroundColor = [UIColor clearColor];
    [viewMyInfo addSubview:_hysNickName];
    
    /**等级**/
    _hysLVName = [[UILabel alloc] initWithFrame:CGRectMake(imgHeader.frame.origin.x + imgHeader.frame.size.width + spacingBig, imgHeader.frame.origin.y, viewMyInfo.frame.size.width - imgHeader.frame.size.width - 3 * spacingMargins, (imgHeader.frame.size.height - border) / 2)];
    
    [_hysLVName setTextColor:[UIColor whiteColor]];
    [_hysLVName setFont:fontSize(scaleWithSize(13.0f))];//
    if (userModel.level) {
        _hysLVName.text = [NSString stringWithFormat:@"LV%@",userModel.level];
    }else {
        _hysLVName.text = @"LV0";
    }
    CGSize sizeLVName = CGSizeMake(20,20); //设置一个行高上限
    NSDictionary *attributeLVName = @{NSFontAttributeName: _hysLVName.font};
    CGSize labelsizeLVName = [_hysLVName.text boundingRectWithSize:sizeLVName options:NSStringDrawingUsesDeviceMetrics attributes:attributeLVName context:nil].size;
    _hysLVName.frame =  CGRectMake(_hysNickName.maxX + spaingSmall / 2 - scaleWithSize(5), spacingMargins + (labelsizeLVName.height + scaleWithSize(5)) + scaleWithSize(3), labelsizeLVName.width + spacingBig, labelsizeLVName.height + scaleWithSize(5));//+ scaleWithSize(5)

    _hysLVName.backgroundColor = [UIColor clearColor];
    _hysLVName.textAlignment = 1;
    _hysLVName.layer.cornerRadius = (labelsizeLVName.height + scaleWithSize(5))/2;
    _hysLVName.layer.masksToBounds = YES;
    _hysLVName.layer.borderColor = [UIColor whiteColor].CGColor;
    _hysLVName.layer.borderWidth = 0.5f;
    [viewMyInfo addSubview:_hysLVName];
    
    /**签名 **/
    _hysSignature = [[UILabel alloc] initWithFrame:CGRectMake(imgHeader.frame.origin.x + imgHeader.frame.size.width + spacingBig, _hysNickName.maxY + withLeftNum, (_hysNickName.frame.size.width - border), _hysNickName.frame.size.height)];
    if (userModel.userSign) {//签名
        _hysSignature.text = userModel.userSign;
    }else{
        _hysSignature.text = @"这家伙超级懒什么都没有留下~";
    }
    [_hysSignature setTextColor:[UIColor whiteColor]];
    [_hysSignature setFont:fontSize(scaleWithSize(11.0f))];
    
    NSDictionary *attributeSignature = @{NSFontAttributeName: _hysSignature.font};
    CGSize labelsizeSignature = [_hysSignature.text boundingRectWithSize:size options:NSStringDrawingUsesDeviceMetrics attributes:attributeSignature context:nil].size;
    _hysSignature.frame = CGRectMake(imgHeader.frame.origin.x + imgHeader.frame.size.width + spacingBig, _hysNickName.maxY +scaleWithSize(15), screen_width - imgHeader.maxX - scaleWithSize(70), labelsizeSignature.height + 5);
    _hysSignature.backgroundColor = [UIColor clearColor];
    [viewMyInfo addSubview:_hysSignature];
    /**个人信息的点击按钮**/
    UIButton *personalInformationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    personalInformationButton.frame = CGRectMake(0, 0, screen_width - scaleWithSize(70), viewMyInfo.frame.size.height/2);
    [personalInformationButton addTarget:self action:@selector(tapPersonalInfoTouchEvent) forControlEvents:UIControlEventTouchUpInside];
    personalInformationButton.backgroundColor = [UIColor clearColor];
    [viewMyInfo addSubview:personalInformationButton];
    
    /**消息按钮**/
    _hysMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    _hysMessage.frame = CGRectMake(screen_width - scaleWithSize(70), scaleWithSize(spacingMargins), scaleWithSize(60), scaleWithSize(60));
    [_hysMessage setImage:[UIImage imageNamed:@"my_xiaoxi"] forState:UIControlStateNormal];
    [_hysMessage addTarget:self action:@selector(wodeMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _hysMessage.backgroundColor = [UIColor clearColor];
    [viewMyInfo addSubview:_hysMessage];
    
    /**帖子 关注 粉丝**/
    UIView *viewMyInfoPAF = [[UIView alloc] initWithFrame:CGRectMake(spacingMargins, imgHeader.maxY + scaleWithSize(10.0f), screen_width - 20 - spacingMargins, viewMyInfo.frame.size.height / 2 -30) ];
    viewMyInfoPAF.backgroundColor = [UIColor clearColor];
    [applicationSV addSubview:viewMyInfoPAF];
    
    _hysPostLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, viewMyInfo.frame.size.height / 2 -30)];
    if (userModel.restScore) {
        _hysPostLabel.text = [NSString stringWithFormat:@"%@ \n 积分",userModel.restScore];//剩余总积分数
    }else {
         _hysPostLabel.text = @"0 \n 积分";
    }
#pragma mark ----段落的处理---间距问题
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_hysPostLabel.text];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 5;//段落后面的间距
     [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [_hysPostLabel.text length])];
    _hysPostLabel .attributedText = attrString;
    _hysPostLabel.numberOfLines = 0;
    _hysPostLabel.textAlignment = 1;
    _hysPostLabel.font = fontSize(scaleWithSize(14.0f));
    _hysPostLabel.textColor = [UIColor whiteColor];
    [viewMyInfoPAF addSubview:_hysPostLabel];
    
    _hysPostButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hysPostButton.frame = CGRectMake(0, 0, labelWidth, viewMyInfo.frame.size.height / 2 -30);
    _hysPostButton.tag = 0;
    _hysPostButton.backgroundColor = [UIColor clearColor];
    [_hysPostButton addTarget:self action:@selector(buttonJifenClick:) forControlEvents:UIControlEventTouchUpInside];//积分点击
    [viewMyInfoPAF addSubview:_hysPostButton];
    
    UILabel *xianLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth-1, 10, 1, viewMyInfoPAF.frame.size.height - 20)];
    xianLabel.backgroundColor = [UIColor whiteColor];
    [viewMyInfoPAF addSubview:xianLabel];
    
    _hysAttentionLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hysPostLabel.frame.size.width, 0, labelWidth, viewMyInfo.frame.size.height / 2 -30)];
    if (userModel.attentionNum) {
        _hysAttentionLabel.text = [NSString stringWithFormat:@"%@ \n 关注",userModel.attentionNum];;
    }else {
        _hysAttentionLabel.text = @"0 \n 关注";
    }
#pragma mark ----段落的处理---间距问题
    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:_hysAttentionLabel.text];
    NSMutableParagraphStyle *style2 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style2.paragraphSpacing = 5;//段落后面的间距
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(0, [_hysAttentionLabel.text length])];
    _hysAttentionLabel .attributedText = attrString2;
    _hysAttentionLabel.numberOfLines = 0;
    _hysAttentionLabel.textAlignment = 1;
    _hysAttentionLabel.font = fontSize(scaleWithSize(14.0f));
    _hysAttentionLabel.textColor = [UIColor whiteColor];
    [viewMyInfoPAF addSubview:_hysAttentionLabel];
    
    _hysAttentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hysAttentionButton.frame = CGRectMake(_hysPostLabel.frame.size.width, 0, labelWidth, viewMyInfo.frame.size.height / 2 -30);
    _hysAttentionButton.tag = 0;
    _hysAttentionButton.backgroundColor = [UIColor clearColor];
    [_hysAttentionButton addTarget:self action:@selector(tapViewFans:) forControlEvents:UIControlEventTouchUpInside];//关注的点击
    [viewMyInfoPAF addSubview:_hysAttentionButton];
    
    UILabel *xianLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(_hysAttentionLabel.frame.size.width +labelWidth-1, 10, 1, viewMyInfoPAF.frame.size.height - 20)];
    xianLabel2.backgroundColor = [UIColor whiteColor];
    [viewMyInfoPAF addSubview:xianLabel2];
    
    _hysFansLabel = [[UILabel alloc] initWithFrame:CGRectMake(_hysAttentionLabel.frame.size.width*2, 0, labelWidth, viewMyInfo.frame.size.height / 2 - 30)];
    if (userModel.fansNum) {
        _hysFansLabel.text = [NSString stringWithFormat:@"%@ \n 粉丝",userModel.fansNum];;
    }else {
        _hysFansLabel.text = @"0 \n 粉丝";
    }
#pragma mark ----段落的处理---间距问题
    NSMutableAttributedString *attrString3 = [[NSMutableAttributedString alloc] initWithString:_hysFansLabel.text];
    NSMutableParagraphStyle *style3 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style3.paragraphSpacing = 5;//段落后面的间距
    [attrString3 addAttribute:NSParagraphStyleAttributeName value:style3 range:NSMakeRange(0, [_hysFansLabel.text length])];
    _hysFansLabel .attributedText = attrString3;
    _hysFansLabel.numberOfLines = 0;
    _hysFansLabel.textAlignment = 1;
    _hysFansLabel.font = fontSize(scaleWithSize(14.0f));
    _hysFansLabel.textColor = [UIColor whiteColor];
    [viewMyInfoPAF addSubview:_hysFansLabel];
    
    _hysFansButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hysFansButton.frame = CGRectMake(_hysAttentionLabel.frame.size.width*2, 0, labelWidth, viewMyInfo.frame.size.height / 2 -30);
    _hysFansButton.tag = 1;
    _hysFansButton.backgroundColor = [UIColor clearColor];
    [_hysFansButton addTarget:self action:@selector(tapViewFans:) forControlEvents:UIControlEventTouchUpInside];//粉丝的点击
    [viewMyInfoPAF addSubview:_hysFansButton];
    
    /**积分任务按钮**/
    _qiandaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _qiandaoButton.frame = CGRectMake(screen_width - scaleWithSize(80) - spacingMargins * 2, viewMyInfoPAF.frame.size.height/2 - 15, scaleWithSize(80), scaleWithSize(30));
    [_qiandaoButton setTintColor:[UIColor whiteColor]];
    _qiandaoButton.backgroundColor = [UIColor clearColor];
    [viewMyInfoPAF addSubview:_qiandaoButton];
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2.frame = CGRectMake(0, 0, scaleWithSize(80), scaleWithSize(30));
    [_button2 setBackgroundImage:[UIImage imageNamed:@"my_jifenrenwu"] forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(jifenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_qiandaoButton addSubview:_button2];
    [viewMyInfoPAF addSubview:_qiandaoButton];
    
    /**签到按钮**/
    _qiandaoButtonOne = [UIButton buttonWithType:UIButtonTypeCustom];
    _qiandaoButtonOne.frame = CGRectMake(screen_width - scaleWithSize(80) - spacingMargins * 2-scaleWithSize(40) - scaleWithSize(10), viewMyInfoPAF.frame.size.height/2 - 15, scaleWithSize(30), scaleWithSize(30));
    [_qiandaoButtonOne setTintColor:[UIColor whiteColor]];
    _qiandaoButtonOne.backgroundColor = [UIColor clearColor];
    [viewMyInfoPAF addSubview:_qiandaoButtonOne];
    _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button3.frame = CGRectMake(0, 0, scaleWithSize(30), scaleWithSize(30));
    if (userModel.signIn.integerValue == 1) {
        [_button3 setBackgroundImage:[UIImage imageNamed:@"my_yiqiandao"] forState:UIControlStateNormal];
    } else {
        [_button3 setBackgroundImage:[UIImage imageNamed:@"my_weiqiandao"] forState:UIControlStateNormal];
    }
//    [_button3 setBackgroundImage:[UIImage imageNamed:@"my_weiqiandao"] forState:UIControlStateNormal];
    [_button3 addTarget:self action:@selector(qiandaoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_qiandaoButtonOne addSubview:_button3];
    [viewMyInfoPAF addSubview:_qiandaoButtonOne];
    
    CGFloat viewHeight = scaleWithSize(44.0f);
    UIView *viewmyInsure = [[UIView alloc] initWithFrame:CGRectMake(0, viewMyInfo.frame.origin.y + spacingBig + viewMyInfo.frame.size.height, screen_width, viewHeight)];
    viewmyInsure.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewmyInsure];
    [self addSubDetailViews:viewmyInsure iconName:@"" iconLeft:scaleWithSize(8) title:@"我的帖子" titleLeft:scaleWithSize(20) hint:@""];
    
    UIView *viewArticleCollection = [[UIView alloc] initWithFrame:CGRectMake(0, viewmyInsure.frame.origin.y + viewmyInsure.frame.size.height + border, screen_width, viewHeight*2)];
    viewArticleCollection.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewArticleCollection];
    [self addSubDetailViews:viewArticleCollection iconName:@"" iconLeft:scaleWithSize(8) title:@"" titleLeft:scaleWithSize(20) hint:@""];
    
    NSArray *arr = @[@"发帖",@"跟帖",@"投票",@"观点"];
    NSArray *arrImage = @[@"my_fatie",@"my_gentie",@"my_toupiao",@"my_guandian"];
    for (int i = 0; i < 4; i++) {
        UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(i * screen_width / 4, 0, screen_width/4, viewHeight*2);
        but.tag = i;
        [but addTarget:self action:@selector(buttonMyPostClick:) forControlEvents:UIControlEventTouchUpInside];
        [viewArticleCollection addSubview:but];
        
        UILabel *fatieLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, but.frame.size.height - scaleWithSize(30), screen_width/4, scaleWithSize(20))];
        fatieLabel.textColor = mx_Wode_color666666;
        fatieLabel.textAlignment = 1;
        fatieLabel.font = [UIFont systemFontOfSize:scaleWithSize(11.0f)];
        fatieLabel.text = arr[i];
        [but addSubview:fatieLabel];
        
        UIImageView *imageViewFatie = [[UIImageView alloc] initWithFrame:CGRectMake(scaleWithSize(21), 10, but.frame.size.height - scaleWithSize(40), but.frame.size.height - fatieLabel.frame.size.height - scaleWithSize(20))];
        imageViewFatie.image = [UIImage imageNamed:arrImage[i]];
        [but addSubview:imageViewFatie];
    }
    
    UIView *viewAboutus = [[UIView alloc] initWithFrame:CGRectMake(0, viewArticleCollection.frame.origin.y + viewArticleCollection.frame.size.height + spaingSmall, screen_width, viewHeight)];
    viewAboutus.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewAboutus];
    [self addSubDetailViews:viewAboutus iconName:@"my_shoucang" iconLeft:scaleWithSize(15) title:@"收藏" titleLeft:scaleWithSize(50) hint:[NSString stringWithFormat:@""]];
    UITapGestureRecognizer *tapViewAboutus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewCollection:)];
    [viewAboutus addGestureRecognizer:tapViewAboutus];
    
    UIView *viewContactus = [[UIView alloc] initWithFrame:CGRectMake(0, viewAboutus.frame.origin.y + viewAboutus.frame.size.height + border, screen_width, viewHeight)];
    viewContactus.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewContactus];
    [self addSubDetailViews:viewContactus iconName:@"my_shezhi" iconLeft:scaleWithSize(15) title:@"设置" titleLeft:scaleWithSize(50) hint:[NSString stringWithFormat:@""]];
    UITapGestureRecognizer *tapViewContactus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewSet:)];
    [viewContactus addGestureRecognizer:tapViewContactus];
    
    applicationSV.contentSize = CGSizeMake(screen_width, viewContactus.frame.origin.y + viewContactus.frame.size.height + scaleWithSize(50));
}
#pragma mark --MessageBut 消息中心点击
- (void)wodeMessageButtonClick:(UIButton*)sender{///NSLog(@"消息中心点击");
    MXSSMessageViewController *messageVC = [[MXSSMessageViewController alloc] init];
    messageVC.title = @"消息中心";
    [self.navigationController pushViewController:messageVC animated:YES];
}
#pragma mark --IntegralViewC 积分任务点击
- (void)jifenButtonClick:(UIButton*)sender{///NSLog(@"积分任务点击");
    MXSSIntegralViewController *integralVC = [[MXSSIntegralViewController alloc]init];
    integralVC.title = @"任务积分";
    [self.navigationController pushViewController:integralVC animated:YES];
}

#pragma mark ----qiandaoButton 签到按钮
-(void)qiandaoButtonClick:(UIButton *)sender{
//    NSLog(@"签到按钮点击");
    self.buttonIsSwitch = !self.buttonIsSwitch;
//    if signIn=1 签到了
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    if (userModel.signIn.integerValue == 1) {
        [SVProgressHUD showInfoWithStatus:@"今天已经【签到】了~"];
    } else {
        [self qiandaoButtonData];//签到接口
    }
}
#pragma mark ----签到按钮点击调用接口
- (void)qiandaoButtonData{
    
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMySignIn_PATH;//请求签到数据接口
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
//            NSLog(@"签到接口返回😊=%@",personDic);
            NSDictionary *dic = [personDic objectForKey:@"data"];
            if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
                MXSSToolConfig *infoModel = [MXssWodeUtils loadPersonInfo];//注意不可以 alloc
                infoModel.signIn = dic[@"isSign"];//签到
                infoModel.level = dic[@"level"];//用户等级
                infoModel.restScore = dic[@"restScore"];//剩余总积分
                infoModel.totalScore = dic[@"totalScore"];//总积分
                [MXssWodeUtils savePersonInfo:infoModel];
                _hysPostLabel.text = [NSString stringWithFormat:@"%@ \n 积分", [dic objectForKey:@"restScore"]];
                if (infoModel.signIn.integerValue == 1) {
                    [_button3 setBackgroundImage:[UIImage imageNamed:@"my_yiqiandao"] forState:UIControlStateNormal];
                } else {
                    [_button3 setBackgroundImage:[UIImage imageNamed:@"my_weiqiandao"] forState:UIControlStateNormal];
                }
                [self dataListNumber];//
            }else if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
                //请先登录
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                login.isPageNumber = 1;
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
            }else {
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
            }
        } failure:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
}

#pragma mark -- Event Methods头像的点击
- (void)tapPersonalInfoTouchEvent {//NSLog(@"头像的点击");
    MXPersonalInformationViewController *mxPerInfoView = [[MXPersonalInformationViewController alloc] init];
    mxPerInfoView.title = @"个人信息";
    [self.navigationController pushViewController:mxPerInfoView animated:NO];
}

//#pragma mark ---关注的点击cell
//-(void)tapViewGuanzhuClick:(UIButton *)sender {
//    MXSSIntegralViewController *integralVC = [[MXSSIntegralViewController alloc]init];
//    integralVC.title = @"任务积分";
//    [self.navigationController pushViewController:integralVC animated:YES];
//}


#pragma mark -- 粉丝cell
- (void)tapViewFans:(UIButton*)sender{//NSLog(@"粉丝点击");
    MXSSFansViewController *fansView = [[MXSSFansViewController alloc] init];
    if(sender.tag == 0){
        fansView.title = @"关注";
        fansView.titleNameGuanOrFen = @"关注";
    }else{
        fansView.title = @"粉丝";
        fansView.titleNameGuanOrFen = @"粉丝";
    }
    [self.navigationController pushViewController:fansView animated:YES];
}
#pragma mark -- 收藏cell
- (void)tapViewCollection:(UIButton*)sender{//NSLog(@"收藏点击");
    MXSSCollectionViewController *mxCollectionView = [[MXSSCollectionViewController alloc] init];
    mxCollectionView.title = @"收藏";
    [self.navigationController pushViewController:mxCollectionView animated:YES];
}
#pragma mark -- 设置cell
- (void)tapViewSet:(UIButton*)sender{//NSLog(@"设置点击");
    MXSSSettingViewController *settingView1 = [[MXSSSettingViewController alloc] init];
    settingView1.title = @"设置";
    [self.navigationController pushViewController:settingView1 animated:YES];
}

#pragma mark -- 我的积分的按钮的点击
- (void)buttonJifenClick:(UIButton *)sender {
    NSLog(@"积分点击");
    MXSSIntegralViewController *integralVC = [[MXSSIntegralViewController alloc]init];
    integralVC.title = @"任务积分";
    [self.navigationController pushViewController:integralVC animated:YES];
}
#pragma mark -- 我的帖子里的按钮的点击
- (void)buttonMyPostClick:(UIButton*)sender{
    NSLog(@"我的帖子里的 点击%ld",sender.tag);
    NSArray *arr = @[@"发帖",@"跟帖",@"投票",@"观点"];
    MXSSMyPostListViewController *mypostView = [[MXSSMyPostListViewController alloc] init];
    mypostView.mypostS = [NSString stringWithFormat:@"%@",arr[sender.tag]];
    mypostView.selectIndex = (int)sender.tag;
    mypostView.menuViewStyle = WMMenuViewStyleLine;
    mypostView.automaticallyCalculatesItemWidths = YES;
    //    [self customizePageController:mypostView];
    mypostView.titleColorSelected = mx_Wode_colorBlue2374e4;
    mypostView.titleColorNormal = [UIColor blackColor];
    mypostView.progressColor = mx_Wode_colorBlue2374e4;
    [self.navigationController pushViewController:mypostView animated:YES];
}

//各条件view块添加详细内容
-(UILabel *)addSubDetailViews:(UIView *)parentView iconName:(NSString *)imageName iconLeft:(CGFloat)iconX title:(NSString*)titleName titleLeft:(CGFloat)titleX hint:(NSString*)hintText{
    //开头图标
    UIImageView *viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 0, scaleWithSize(30), scaleWithSize(30))];
    [parentView addSubview:viewIcon];
    viewIcon.center = CGPointMake(viewIcon.center.x, parentView.frame.size.height/2);
    [viewIcon setImage:[UIImage imageNamed:imageName]];
    
    //标题
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, screen_width - 50, 32)];
    [parentView addSubview:lblTitle];
    lblTitle.center = CGPointMake(lblTitle.center.x, parentView.frame.size.height/2);
    lblTitle.numberOfLines = 1;
    lblTitle.text = titleName;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    //lblTitle.textColor = [UIColor colorWithRed:167.0/255 green:167.0/255 blue:167.0/255 alpha:1];
    [lblTitle setTextColor:mx_Wode_color333333];
    lblTitle.backgroundColor =[UIColor clearColor];
    //    lblTitle.font = [UIFont fontWithName:@"Arial" size:scaleWithSize(17)];//fontSize()
    lblTitle.font = fontSize(scaleWithSize(17));
    //右箭头  15*15，距离右边也是15
    UIImageView *viewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(parentView.frame.size.width - scaleWithSize(15) - scaleWithSize(13), 0, scaleWithSize(8), scaleWithSize(13))];
    viewArrow.center = CGPointMake(viewArrow.center.x, parentView.frame.size.height/2);
    if ([titleName isEqualToString:@"我的帖子"]||[titleName isEqualToString:@""]) {
        [viewArrow setImage:[UIImage imageNamed:@""]];//不显示右边的箭头
        lblTitle.textColor = mx_Wode_color666666;
        lblTitle.font = fontSize(scaleWithSize(16));
    }else {
        [viewArrow setImage:[UIImage imageNamed:@"mxWodeRightArrow"]];
    }
    
    //内容，初始化时为提示文字
    CGFloat left = 62;
    [parentView addSubview:viewArrow];
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, viewArrow.frame.origin.x - left - 15 + 15 + 16 - 20, 22 + 8)];
    [parentView addSubview:lblContent];
    lblContent.center = CGPointMake(lblContent.center.x, parentView.frame.size.height/2);
    lblContent.text = hintText;
    lblContent.textColor = mx_Wode_darkGreyFontColor;
    lblContent.backgroundColor =[UIColor clearColor];
    lblContent.textAlignment = NSTextAlignmentRight;
    lblContent.font = [UIFont fontWithName:@"Arial" size:15];
    return lblContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
