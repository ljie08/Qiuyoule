//
//  MXssPersonalAccountViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//账户绑定页面

#import "MXssPersonalAccountViewController.h"
#import "MXBindingViewController.h"//绑定手机号

@interface MXssPersonalAccountViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,WXApiDelegate>
{
    UIScrollView *applicationSV;
}
@end

@implementation MXssPersonalAccountViewController
@synthesize zhanghuPhoneLabel;//绑定手机号码
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor;
    //    [self setupUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeChatLoginCode:) name:@"wechat" object:nil];
}

#pragma mark -- 微信
- (void)getWeChatLoginCode:(NSNotification *)notification {
    NSString *weChatCode = [[notification userInfo] objectForKey:@"code"];
    /*
     使用获取的code换取access_token，并执行登录的操作
     */
    @weakSelf(self);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json",@"text/plain", nil];
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", WX_APPID, WX_SECRET, weChatCode];
    
    [SVProgressHUD show];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"🐷信息相关信息❤️=  %@", dic);
        
        [weakSelf requestUserInfoByToken:[dic valueForKey:@"access_token"] openId:[dic valueForKey:@"openid"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//        NSLog(@"🐽失败==  error:%@", error.localizedDescription);
    }];
}

- (void)requestUserInfoByToken:(NSString *)token openId:(NSString *)openId {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", token, openId];
    
    @weakSelf(self);
    [SVProgressHUD show];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"🐷登录成功啦啦啦啦 dic %@", dic);
        if ([dic objectForKey:@"errcode"]) {
            [SVProgressHUD showErrorWithStatus:@"登录失败，请重新登录"];
            return;
        }
        
        //将微信用户信息存到本地
        MXLJThirdData *data = [MXLJThirdData mj_objectWithKeyValues:dic];
        data.userType = 2;
//        NSLog(@"🐷我的微信 ：%@", data);
        NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *listPath = [listFile stringByAppendingPathComponent:@"wechat.plist"];
        [NSKeyedArchiver archiveRootObject:data toFile:listPath];
        
        //80 绑定社交账号
        [weakSelf bindSocialWithData:data];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//        NSLog(@"🐽失败啊啊啊 error:%@", error.localizedDescription);
    }];
}
//80 绑定社交账号
- (void)bindSocialWithData:(MXLJThirdData *)data {
    [SVProgressHUD show];
    @weakSelf(self);
    //    MXWodeMybindSocial_PATH
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMybindSocial_PATH;//请求绑定社交账号数据接口
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    [paraDic setObject:[NSString stringWithFormat:@"%ld",(long)data.userType] forKey:@"userType"];//绑定的用户类型（2：微信，3：qq）
    [paraDic setObject:data.openid forKey:@"openid"];//用户openid
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
//        NSLog(@"绑定社交账号接口返回😊=%@",personDic);
        NSDictionary *dic = [personDic objectForKey:@"data"];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"1003"]) {//code为1003，去绑定手机号
            MXBindingViewController *bindingVC = [[MXBindingViewController alloc] init];
            [weakSelf.navigationController pushViewController:bindingVC animated:YES];
        } else {
            if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
                MXSSToolConfig *infoModel = [MXssWodeUtils loadPersonInfo];//注意不可以 alloc
                infoModel.isBindingWechat = dic[@"isBindingWechat"];//签到
                infoModel.level = dic[@"level"];//用户等级
                infoModel.restScore = dic[@"restScore"];//剩余总积分
                infoModel.totalScore = dic[@"totalScore"];//总积分
                [MXssWodeUtils savePersonInfo:infoModel];
                //                 }else{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [SVProgressHUD showSuccessWithStatus:[personDic objectForKey:@"msg"]];
            }else {
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
            }
//            [MXssWodeUtils removePersonInfo];
            [applicationSV removeFromSuperview];
            [self setupUI];
        }
        //        }else if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
        //            //请先登录
        //            MXLoginViewController *login = [[MXLoginViewController alloc] init];
        //            login.isPageNumber = 1;
        //            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        //            [self presentViewController:nav animated:YES completion:nil];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
- (void)setupUI {
    CGFloat border = 1.0f;
    // 背景ScrollView
    applicationSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    applicationSV.showsVerticalScrollIndicator = YES;
    applicationSV.showsVerticalScrollIndicator = NO;
    applicationSV.backgroundColor = mx_Wode_backgroundColor;
    applicationSV.scrollEnabled = YES;
    [self.view addSubview:applicationSV];
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    CGFloat viewHeight = scaleWithSize(64.0f);
    
    UIView *viewComPro = [[UIView alloc] initWithFrame:CGRectMake(0, scaleWithSize(4), screen_width, viewHeight)];
    viewComPro.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewComPro];
    [self addSubDetailViews:viewComPro iconName:@"my_shouji" iconLeft:scaleWithSize(15) title:@"绑定手机" titleLeft:scaleWithSize(40) hint:userModel.telephone];
    UITapGestureRecognizer *tapViewComPro = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewHeaderClick:)];
    [viewComPro addGestureRecognizer:tapViewComPro];
    
    //    UIView *viewNickName = [[UIView alloc] initWithFrame:CGRectMake(0, viewComPro.frame.origin.y + viewComPro.frame.size.height + border, screen_width, viewHeight)];
    //    viewNickName.backgroundColor = [UIColor whiteColor];
    //    [applicationSV addSubview:viewNickName];
    //    [self addSubDetailViews:viewNickName iconName:@"my_qq" iconLeft:scaleWithSize(15) title:@"Q Q" titleLeft:scaleWithSize(40) hint:@"立即绑定"];//hint:[NSString stringWithFormat:@"%@",userModel.username ]];
    //    UITapGestureRecognizer *tapviewNickName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewQQNameClick:)];
    //    [viewNickName addGestureRecognizer:tapviewNickName];
    
    
    
    //当前时间判断显示
    
    UIView *viewGender = [[UIView alloc] initWithFrame:CGRectMake(0, viewComPro.frame.origin.y + viewComPro.frame.size.height + border, screen_width, viewHeight)];
    viewGender.backgroundColor = [UIColor whiteColor];
    
    if (userModel.isBindingWechat.intValue > 0) {
        [self addSubDetailViews:viewGender iconName:@"my_weixin" iconLeft:scaleWithSize(15) title:@"微信" titleLeft:scaleWithSize(40) hint:[NSString stringWithFormat:@"解除绑定"]];
    }else {
        [self addSubDetailViews:viewGender iconName:@"my_weixin" iconLeft:scaleWithSize(15) title:@"微信" titleLeft:scaleWithSize(40) hint:[NSString stringWithFormat:@"立即绑定"]];
        
    }
    UITapGestureRecognizer *tapViewContactus = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewWeixinClick:)];
    //当前时间判断
//    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    //判断当前时间 一天提醒一次
    if (locationString.integerValue >= 20180601) {
        [applicationSV addSubview:viewGender];
        [viewGender addGestureRecognizer:tapViewContactus];
    }
   
    applicationSV.contentSize = CGSizeMake(screen_width, viewGender.frame.origin.y + viewGender.frame.size.height + 49);
}
#pragma mark -- Event Methods 绑定手机的点击
-(void)tapViewHeaderClick:(UIButton *)sender {////
    NSLog(@"绑定手机的点击");
    MXBindingViewController *bindvC = [[MXBindingViewController alloc] init];
    bindvC.type = 1;
    [applicationSV removeFromSuperview];
    [self setupUI];
    [self.navigationController pushViewController:bindvC animated:YES];
}
//#pragma mark -- Event Methods Q Q 的点击
//-(void)tapViewQQNameClick:(UIButton *)sender {
//    NSLog(@"Q Q的点击");
//    MXBindingViewController *bindingVC = [[MXBindingViewController alloc] init];
//    [self.navigationController pushViewController:bindingVC animated:YES];
//}
#pragma mark -- Event Methods 微信的的点击
-(void)tapViewWeixinClick:(UIButton *)sender {//
    NSLog(@"微信的点击");
//    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
   
//    if (userModel.isBindingWechat.intValue > 0) {
//        NSLog(@"微信不可以点击了,已绑定了哦~");
//    }else {
        if (![WXApi isWXAppInstalled]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的设备没有安装微信" message:@"请去App Store安装微信" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:sureaction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        SendAuthReq* req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"moxi";
        [WXApi sendAuthReq:req viewController:self delegate:self];
//    }
    
}
//各条件view块添加详细内容
-(UILabel *)addSubDetailViews:(UIView *)parentView iconName:(NSString *)imageName iconLeft:(CGFloat)iconX title:(NSString*)titleName titleLeft:(CGFloat)titleX hint:(NSString*)hintText{
    //开头图标
    UIImageView *viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 0, scaleWithSize(40), scaleWithSize(40))];
    [parentView addSubview:viewIcon];
    viewIcon.center = CGPointMake(viewIcon.center.x, parentView.frame.size.height/2);
    [viewIcon setImage:[UIImage imageNamed:imageName]];
    
    //标题
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX + scaleWithSize(30), 0, 164, 32)];
    [parentView addSubview:lblTitle];
    lblTitle.center = CGPointMake(lblTitle.center.x, parentView.frame.size.height/2);
    lblTitle.numberOfLines = 1;
    lblTitle.text = titleName;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    //lblTitle.textColor = [UIColor colorWithRed:167.0/255 green:167.0/255 blue:167.0/255 alpha:1];
    [lblTitle setTextColor:mx_Wode_color333333];
    lblTitle.backgroundColor =[UIColor clearColor];
    lblTitle.font = fontSize(scaleWithSize(15));
    //右箭头  15*15，距离右边也是15
    UIImageView *viewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(parentView.frame.size.width- scaleWithSize(13)- scaleWithSize(15), 0, scaleWithSize(8), scaleWithSize(13))];
    
    viewArrow.center = CGPointMake(viewArrow.center.x, parentView.frame.size.height/2);
    [viewArrow setImage:[UIImage imageNamed:@""]];//不显示右边的箭头
    
    //内容，初始化时为提示文字
    
//    if ([titleName isEqualToString:@"绑定手机"]) {
//        zhanghuPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2, 0, screen_width/2 - scaleWithSize(25), 22 + 8)];//55---25
//        zhanghuPhoneLabel.text = hintText;
//        zhanghuPhoneLabel.textColor = mx_Wode_color666666;
//        zhanghuPhoneLabel.backgroundColor =[UIColor clearColor];
//        zhanghuPhoneLabel.textAlignment = 2;
//        zhanghuPhoneLabel.center = CGPointMake(zhanghuPhoneLabel.center.x, parentView.frame.size.height/2);
//        zhanghuPhoneLabel.font = fontSize(scaleWithSize(14));
//        [parentView addSubview:zhanghuPhoneLabel];
//    }
//    [parentView addSubview:viewArrow];
    if ([titleName isEqualToString:@"绑定手机"]) {
        zhanghuPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width/2 - scaleWithSize(30), 0, screen_width/2 - scaleWithSize(45), 22 + 8)];
        zhanghuPhoneLabel.text = hintText;
        zhanghuPhoneLabel.textColor = mx_Wode_color666666;
        zhanghuPhoneLabel.backgroundColor =[UIColor clearColor];
        zhanghuPhoneLabel.textAlignment = 2;
        zhanghuPhoneLabel.center = CGPointMake(zhanghuPhoneLabel.center.x, parentView.frame.size.height/2);
        zhanghuPhoneLabel.font = fontSize(scaleWithSize(14));
        [parentView addSubview:zhanghuPhoneLabel];
    }
    [parentView addSubview:viewArrow];
    
    if ([titleName isEqualToString:@"Q Q"]) {
    }
    /*微信*/
    if ([titleName isEqualToString:@"微信"]) {
        
    }
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(120), 0, scaleWithSize(100), 22 + 8)];
    [parentView addSubview:lblContent];
    lblContent.center = CGPointMake(lblContent.center.x, parentView.frame.size.height/2);
    if ([titleName isEqualToString:@"绑定手机"]) {
         lblContent.text = @"修改绑定";
    }else {
        
        lblContent.text = hintText;
    }
    if ([hintText isEqualToString:@"已绑定"]) {
        lblContent.textColor = mx_Wode_color333333;
    }else{
        lblContent.textColor = mx_Wode_colorBlue2374e4;
    }
    lblContent.backgroundColor =[UIColor clearColor];
    lblContent.textAlignment = 2;
    //    lblContent.font = [UIFont fontWithName:@"Arial" size:15];//fontSize(scaleWithSize(14))
    lblContent.font = fontSize(scaleWithSize(12));
    return lblContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"账户绑定"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    [applicationSV removeFromSuperview];
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechat" object:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
