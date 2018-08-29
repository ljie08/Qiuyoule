//
//  MXBindingViewController.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXBindingViewController.h"
#import "MXLJJudgeVM.h"

@interface MXBindingViewController ()<UITextFieldDelegate>{
    NSTimer *_timer;//定时器
    NSInteger _num;//定时倒计数
    MXLJJudgeVM *_judgeVM;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (nonatomic, strong) MXLJThirdData *third;

@property (nonatomic, assign) NSTimeInterval backTime;//进入后台的时间
@property (nonatomic, assign) NSTimeInterval foregroundTime;//进入前台的时间

@end

@implementation MXBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"wechat.plist"];
    
    self.third = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindForeground) name:UIApplicationWillEnterForegroundNotification object:nil];//进入前台，定时器开启
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];//进入后台，定时器停掉
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"绑定手机号界面\"}"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.borderColor = mx_BlueColor.CGColor;
    self.codeBtn.layer.borderWidth = 1;
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"绑定手机号界面\"}"];
}

#pragma mark -- 前台、后台通知
//进入前台
- (void)bindForeground {
    self.foregroundTime = [NSDate date].timeIntervalSince1970;
    NSTimeInterval time = self.foregroundTime - self.backTime;//进入后台的时间和现在的时间差
    NSTimeInterval current = _num - time;//如果时间差和倒计时所剩的时间相比较
    if (current > 0) {
        _num = current;
        //开启定时器
        [_timer setFireDate:[NSDate distantPast]];
    } else {
        [self resetBtn];
        [self resetTimer];
    }
}

//进入后台
- (void)bindBackground {
    self.backTime = [NSDate date].timeIntervalSince1970;
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark -- init
- (void)initVMBinding {
    _judgeVM = [[MXLJJudgeVM alloc] init];
}

- (MXLJThirdData *)third {
    if (_third == nil) {
        _third = [[MXLJThirdData alloc] init];
    }
    return _third;
}

#pragma mark -- action
//发送验证码
- (IBAction)sendCodeAction:(id)sender {
    NSLog(@"%@",self.phoneNumTF.text);
    if (!self.phoneNumTF.text || !_judgeVM.login.registerPhoneNum) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    @weakSelf(self);
    [SVProgressHUD show];
    //判断手机号是否注册过或绑定过
    [_judgeVM checkPhoneBindWithPhoneNum:_judgeVM.login.registerPhoneNum success:^(NSString *msg, NSString *code) {
        [SVProgressHUD dismiss];

        if (self.type == 1) {
            if ([code isEqualToString:@"0"]) {//既没注册也没绑定
                [weakSelf getCode];
            } else{
                [SVProgressHUD showErrorWithStatus:msg];
            }
            return ;
        }
        if ([code isEqualToString:@"0"]) {//既没注册也没绑定
            [weakSelf getCode];
        } else if ([code isEqualToString:@"1021"]) {//绑定过
            [weakSelf setAlertViewWithTitle:@"该手机号码已经绑定过社交账号" message:@"如需解绑，请用手机号登陆后在设置中解绑。无法接收短信" getCode:NO isCurrentVC:YES];
        } else if ([code isEqualToString:@"1023"]) {//注册过
            [weakSelf setAlertViewWithTitle:@"该手机号码已经注册过账户，是否绑定微信" message:nil getCode:YES isCurrentVC:YES];
        }
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
}

- (void)getCode {
    self.codeBtn.enabled = NO;
    self.codeBtn.layer.borderWidth = 0;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechang:) userInfo:nil repeats:YES];
    
    @weakSelf(self);
    [SVProgressHUD show];
    [_judgeVM getCodeWithPhoneNum:_judgeVM.login.registerPhoneNum success:^(NSString *msg){
        [SVProgressHUD dismiss];
        if (msg.length) {
            [SVProgressHUD showErrorWithStatus:msg];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
        }
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [weakSelf resetTimer];
        [weakSelf resetBtn];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

//下一步
- (IBAction)bindTelAction:(id)sender {
    
//#warning --- 获取验证码应该和注册时的获取有区分
//    [SVProgressHUD showErrorWithStatus:@"接口有问题"];
//    return;
    
    if (self.phoneNumTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号有误，请重新输入"];
        return;
    }else if (!self.codeTF.text.length){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    /*判断手机号是否已注册过。
     1) 输入手机号
     2) 点击发送短信按钮
     3) 手机号未注册的情况下，等待接收短信。
     已经注册的分两个情况：
     这个手机号已经绑定过微信，直接提示：该手机号已经绑定社交账户，如需解绑，请用手机号登陆后在设置中解绑。无法接收短信。
     手机号未绑定过账户，提示：该手机号码已经注册过账户，是否绑定微信？确认/取消。确认的话，通知服务端，等待接收短信，验证短信后，服务端才能将该手机号绑定微信。如果是取消的话，同样无法接收短信
     4) 输入短信验证码，完成第三方登录。
    */
    @weakSelf(self);
    [SVProgressHUD show];
    if (self.type == 1) {
        MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
        NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
        NSString *token = userModel.token;
        NSString *timeStr = [MXLJUtil getNowDateTimeString];
        NSString *url = MXWodeModifyTel_PATH;//修改手机号码
        
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setObject:userid forKey:@"userId"];//用户ID
        [paraDic setObject:token forKey:@"token"];//用户token
        [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
        //        telephone
        //        code
        [paraDic setObject:_judgeVM.login.registerPhoneNum forKey:@"telephone"];
        [paraDic setObject:_judgeVM.login.code forKey:@"code"];
        MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
        [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
            NSLog(@"请求数据修改手机号码==%@",personDic);
            if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
                 NSDictionary *dic = [personDic objectForKey:@"data"];
                MXSSToolConfig *infoModel = [MXssWodeUtils loadPersonInfo];//注意不可以 alloc
                infoModel.telephone = dic[@"telephone"];
                [SVProgressHUD showSuccessWithStatus:[personDic objectForKey:@"msg"]];

//                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [MXssWodeUtils savePersonInfo:infoModel];
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
            [SVProgressHUD showErrorWithStatus:error];
        }];
    } else {
        [_judgeVM bindPhoneWithPhone:_judgeVM.login.registerPhoneNum code:_judgeVM.login.code userName:self.third.nickname sex:self.third.sex headerPic:self.third.headimgurl userType:self.third.userType openid:self.third.openid success:^(NSString *msg) {
            [SVProgressHUD dismiss];
            NSLog(@"微信登录绑定手机号 ？ %@", msg);
            if (msg.length) {
                [SVProgressHUD showErrorWithStatus:msg];
                return;
            }
            [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
            [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (_judgeVM.isShowScore) {
                [weakSelf setAlertViewWithTitle:@"登录成功" message:@"获得注册积分\n并获得社交账号绑定积分" getCode:NO isCurrentVC:NO];
            }
        }];
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
    }
}

//定时器执行方法
- (void)timechang:(id)sender {
    _num--;
    
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
    
    if (_num == 0) {
        [self resetBtn];
        
        [self resetTimer];
    }
}

//重置button
- (void)resetBtn {
    self.codeBtn.enabled = YES;
    _num = 59;
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.codeBtn.layer.borderWidth = 1;
}

//重置定时器
- (void)resetTimer {
    if (_timer.isValid) {
        [_timer invalidate];
    }
    _timer = nil;
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.phoneNumTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 400:
            _judgeVM.login.registerPhoneNum = textField.text;
            break;
        case 401:
            _judgeVM.login.code = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newStr = [NSString stringWithFormat:@"%@%@", textField.text, string];
    return (newStr.length <= 11);
}

#pragma mark -- UI
- (void)initUIView {
    if (self.type == 1) {
        [self initTitleViewWithTitle:@"修改手机号"];
    }else{
    [self initTitleViewWithTitle:@"绑定手机"];
    }
    [self setBackButton:YES];
    _num = 59;
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

/**
 提示框

 @param title 标题
 @param message 副标题
 @param isCurrentVC 是否当前控制器，no表示dismiss掉之后弹出弹框
 */
- (void)setAlertViewWithTitle:(NSString *)title message:(NSString *)message getCode:(BOOL)getCode isCurrentVC:(BOOL)isCurrentVC {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ((getCode)) {
            [self getCode];
        }
    }];
    UIAlertAction *cancelaction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:sureaction];
    if (!message.length) {
        [alert addAction:cancelaction];
    }
    
    if (isCurrentVC) {
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [CurrentKeyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - - dealloc
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
