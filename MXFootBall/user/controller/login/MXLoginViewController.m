//
//  MXLoginViewController.m
//  MXFootBall
//
//  Created by zt on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXLoginViewController.h"
#import "MXRegisterViewController.h"//注册
#import "MXBindingViewController.h"//绑定手机号
#import "MXLJJudgeVM.h"
#import "AppDelegate.h"
#import "MXTabBarController.h"
#import "MXNavigationController.h"
#import "MXForgetPasswdViewController.h"//忘记密码
#import "MXWodeViewController.h"

@interface MXLoginViewController ()<UITextFieldDelegate, WXApiDelegate> {
    MXLJJudgeVM *_judgeVM;
}

@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;//头像
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *passwdTF;//密码
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;//logo距顶部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputHeight;//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherTop;//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wxTop;//
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;//微信登录按钮

@property (weak, nonatomic) IBOutlet UIView *whiteView;//用来隐藏其他登录方式

@end

@implementation MXLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.btnHeight.constant = 55*Height_Scale;
    self.inputHeight.constant = self.otherTop.constant = 40*Height_Scale;
    self.wxTop.constant = 30*Height_Scale;
    
    if (![WXApi isWXAppInstalled]) {
        self.wechatBtn.hidden = YES;
        self.whiteView.hidden = NO;
    } else {
        self.wechatBtn.hidden = NO;
        self.whiteView.hidden = YES;
    }
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"登录界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"登录界面\"}"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeChatLoginCode:) name:@"wechat" object:nil];
}

#pragma mark -- data
- (void)initVMBinding {
    _judgeVM = [[MXLJJudgeVM alloc] init];
}

- (void)login {
    @weakSelf(self);
    [SVProgressHUD show];
    [_judgeVM loginWithPhoneNum:_judgeVM.login.registerPhoneNum passwd:_judgeVM.login.registerPasswd1 success:^(NSString *msg){
        [SVProgressHUD dismiss];
        if (msg.length) {
            [SVProgressHUD showErrorWithStatus:msg];
        } else {
            
            NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
            NSString *listPath = [listFile stringByAppendingPathComponent:MXUSER_DATA];
            
            MXLJUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
            NSLog(@"---user--- %@", user);
            
            if (_delegate && [_delegate respondsToSelector:@selector(loginSuccessCalled)]) {
                [_delegate loginSuccessCalled];//登录成功跳转回去后可调用这个方法
            }
            
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                NSLog(@"00000");
                if (_judgeVM.isShowScore) {
                    //显示获得积分的提示框
                    [weakSelf setAlertViewWithTitle:@"登录成功" message:@"获得注册积分"];
                } else {
//                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                }
            }];
        }
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark -- IBActions
//登录
- (IBAction)loginAction:(id)sender {
    @weakSelf(self);
    [_judgeVM isLoginCompleteWithTextWithSuccess:^(BOOL isCorrect) {
        if (isCorrect) {
            [weakSelf login];
        }
    } failure:^(NSString *errorString) {
        [SVProgressHUD showErrorWithStatus:errorString];
    }];
}

//手机注册
- (IBAction)registerAction:(id)sender {
    MXRegisterViewController *registerVC = [[MXRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//忘记密码
- (IBAction)forgetAction:(id)sender {
//#warning -- 周一给接口（4.16号）
//    [SVProgressHUD showErrorWithStatus:@"暂无接口"];
    MXForgetPasswdViewController *forgetVC = [[MXForgetPasswdViewController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

//微信登录
- (IBAction)wechatAction:(id)sender {
//    if (![WXApi isWXAppInstalled]) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您的设备没有安装微信" message:@"请去App Store安装微信" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alert addAction:sureaction];
//        [self presentViewController:alert animated:YES completion:nil];
//        return;
//    }
    //没有安装微信的时候跳转网页登录
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = [NSString stringWithFormat:@"%dmoxi", rand()/1000000];
    [WXApi sendAuthReq:req viewController:self delegate:self];
}

//第三方登录
- (void)thirdLoginWithData:(MXLJThirdData *)data {
    [SVProgressHUD show];
    @weakSelf(self);
    [_judgeVM thirdLoginWithOpenid:data.openid userName:data.nickname headerPic:data.headimgurl userType:data.userType sex:data.sex success:^(NSString *msg) {
        [SVProgressHUD dismiss];
        NSLog(@"微信登录 ？ %@", msg);
        if (!msg.length) {//code为1003，去绑定手机号
            MXBindingViewController *bindingVC = [[MXBindingViewController alloc] init];
            [weakSelf.navigationController pushViewController:bindingVC animated:YES];
        } else {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [SVProgressHUD showSuccessWithStatus:msg];
        }
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.phoneTF resignFirstResponder];
    [self.passwdTF resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 500) {
        _judgeVM.login.registerPhoneNum = textField.text;
    }
    if (textField.tag == 501) {
        _judgeVM.login.registerPasswd1 = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (textField.tag == 500) {
        return (newString.length <= 11);
    } else if (textField.tag == 501) {
        return (newString.length <= 12);
    } else {
        return NO;
    }
}

#pragma mark -- 微信
- (void)getWeChatLoginCode:(NSNotification *)notification {
    NSString *weChatCode = [[notification userInfo] objectForKey:@"code"];
//    [_judgeVM getWXDataWithCode:weChatCode success:^(NSString *msg) {
//
//        NSLog(@"...");
//    } failture:^(NSString *error) {
//        [SVProgressHUD showErrorWithStatus:error];
//    }];
    
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
        NSLog(@"🐷信息  %@", dic);

        [weakSelf requestUserInfoByToken:[dic valueForKey:@"access_token"] openId:[dic valueForKey:@"openid"]];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"🐽失败  error:%@", error.localizedDescription);
    }];
    
//    [[WebManager sharedManager] requestWithMethod:GET WithUrl:url WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
////        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"信息  %@", dic);
//
//        [weakSelf requestUserInfoByToken:[dic valueForKey:@"access_token"] openId:[dic valueForKey:@"openid"]];
//    } WithFailureBlock:^(NSError *error) {
//        NSLog(@"失败  error:%@", error.localizedDescription);
//    }];
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
        NSLog(@"🐷登录成功啦啦啦啦 dic %@", dic);
        //invalid credential, access_token is invalid or not latest
        //access_token无效或不是最新
        //可能两次登录时间间隔比较短，access_token没有更新，会出错
        /*
         dic {
         errcode = 40001;
         errmsg = "invalid credential, access_token is invalid or not latest, hints: [ req_id:resf290807s153]";
         }
         */
        if ([dic objectForKey:@"errcode"]) {
            [SVProgressHUD showErrorWithStatus:@"登录失败，请重新登录"];
            return;
        }

//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:[dic objectForKey:@"openid"] forKey:@"openid"];
//        [defaults setObject:[dic objectForKey:@"nickname"] forKey:@"username"];
//        NSString *header = [dic objectForKey:@"headimgurl"];
//        NSLog(@"💔%@", header);
//        [defaults setObject:header forKey:@"headerPic"];
//        [defaults setObject:@2 forKey:@"userType"];
//        NSInteger sex = [[dic objectForKey:@"sex"] integerValue];
//        if (sex == 1) {
//            [defaults setObject:@"男" forKey:@"sex"];
//        } else if (sex == 2) {
//            [defaults setObject:@"女" forKey:@"sex"];
//        }

        //将微信用户信息存到本地
        MXLJThirdData *data = [MXLJThirdData mj_objectWithKeyValues:dic];
        data.userType = 2;
        NSLog(@"🐷我的微信 ：%@， %@", data, data.sex);
        if ([data.sex isEqualToString:@"2"]) {
            data.sex = @"女";
        }
        if ([data.sex isEqualToString:@"1"]) {
            data.sex = @"男";
        }
        NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *listPath = [listFile stringByAppendingPathComponent:@"wechat.plist"];
        [NSKeyedArchiver archiveRootObject:data toFile:listPath];

        //第三方登录接口
        [weakSelf thirdLoginWithData:data];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        NSLog(@"🐽失败啊啊啊 error:%@", error.localizedDescription);
    }];
    
//    [[WebManager sharedManager] requestWithMethod:GET WithUrl:url WithParams:nil WithSuccessBlock:^(NSDictionary *dic) {
//        NSLog(@"登录成功啦啦啦啦 dic %@", dic);
//
//        MXLJThirdData *data = [MXLJThirdData mj_objectWithKeyValues:dic];
//        data.userType = 2;
//        NSLog(@"我的微信 ：%@", data);
//
//    } WithFailureBlock:^(NSError *error) {
//        NSLog(@"失败啊啊啊 error:%@", error.localizedDescription);
//    }];
}

- (void)goBack{
    
    NSLog(@"xxxxxxxxx");
    
//    if (self.isAttention == YES) {
    
    if (self.isPageNumber != 0) {
        
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        appdelegate.count = self.isPageNumber - 1;
        
//        MXTabBarController *tab = (MXTabBarController *)appdelegate.window.rootViewController;
//        tab.selectedIndex = 2;
//        [self presentViewController:tab animated:YES completion:nil];
        
    } else {
        if (self.navigationController.viewControllers.count > 1) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (self.navigationController) {
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    
                }];
            } else {
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }
        }
    }
}

#pragma mark -- UI
- (void)initUIView {
    self.phoneTF.delegate = self;
    self.passwdTF.delegate = self;
//    if ([self.yesOrNoStrBack isEqualToString:@"不显示"]) {
//        self.navigationItem.hidesBackButton = YES;//不显示返回按钮
//    }else {
    [self setBackButton:YES];
//    }
    [self initTitleViewWithTitle:@"登录"];
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

/**
 提示框
 
 @param title 标题
 @param message 副标题
 */
- (void)setAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
//    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
    
    [alert addAction:sureaction];
    
    [CurrentKeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark ---
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wechat" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
