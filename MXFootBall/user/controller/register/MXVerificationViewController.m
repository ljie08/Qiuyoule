//
//  MXVerificationViewController.m
//  MXFootBall
//
//  Created by lee🎀 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

//弃用
#import "MXVerificationViewController.h"
#import "MXLJJudgeVM.h"
#import "MXLoginViewController.h"

@interface MXVerificationViewController ()<UITextFieldDelegate> {
    NSTimer *_timer;//定时器
    NSInteger _num;//定时倒计数
    MXLJJudgeVM *_judgeVM;
}

@property (weak, nonatomic) IBOutlet UILabel *hintLab;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;//验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationBtn;//发送按钮

@end

@implementation MXVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (MXLJLogin *)login {
    if (_login == nil) {
        _login = [[MXLJLogin alloc] init];
    }
    return _login;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    if (_timer.isValid) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)initVMBinding {
    _judgeVM = [[MXLJJudgeVM alloc] init];
}

#pragma mark -- IBAction
//发送验证码
- (IBAction)sendVerificationAction:(id)sender {
    self.sendVerificationBtn.enabled = NO;
    self.sendVerificationBtn.layer.borderWidth = 0;
    [self.sendVerificationBtn setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechang:) userInfo:nil repeats:YES];

    NSString *phoneStr = self.phoneNum.length ? self.phoneNum : self.login.registerPhoneNum;
    
    @weakSelf(self);
    [_judgeVM getCodeWithPhoneNum:phoneStr success:^(NSString *msg){
        if (msg.length) {
            weakSelf.hintLab.hidden = YES;
            [SVProgressHUD showErrorWithStatus:msg];
        } else {
            weakSelf.hintLab.hidden = NO;
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
        }
    } failture:^(NSString *error) {
        weakSelf.hintLab.hidden = YES;
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

//提交
- (IBAction)registerAction:(id)sender {
    if (!self.login.code) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    
    //判断是注册还是第三方登录后绑定手机号
    if (self.phoneNum.length) {
        [self bindPhoneWithThird];
    } else {
        [self registerUser];
    }
}

//注册
- (void)registerUser {
    @weakSelf(self);
    [_judgeVM registerWithPhoneNum:self.login.registerPhoneNum code:self.login.code passwd:self.login.registerPasswd1 success:^(NSString *msg){
        if (msg.length) {
            [SVProgressHUD showErrorWithStatus:msg];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            
            //
            MXLoginViewController *home = [[MXLoginViewController alloc] init];
            [weakSelf.navigationController pushViewController:home animated:YES];
            
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录成功" message:@"获得注册积分" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            }];
//            [alert addAction:sureaction];
//            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failture:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

//绑定手机号
- (void)bindPhoneWithThird {
//    @weakSelf(self);
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *listFile = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *listPath = [listFile stringByAppendingPathComponent:@"wechat.plist"];
    
    MXLJThirdData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:listPath];
    NSLog(@"我的微信信息wechat\n%@", data);
    
//    [_judgeVM bindPhoneWithPhone:self.phoneNum code:self.login.code passwd:@"" userName:data.nickname headerPic:data.headerimgurl userType:data.userType openid:data.openid success:^(NSString *msg) {
//
//    } failture:^(NSString *error) {
//        [SVProgressHUD showErrorWithStatus:error];
//    }];
}

//定时器执行方法
- (void)timechang:(id)sender {
    _num--;
    
    [self.sendVerificationBtn setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
    
    if (_num == 0) {
        self.hintLab.hidden = YES;
        self.sendVerificationBtn.enabled = YES;
        _num = 59;
        [self.sendVerificationBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.sendVerificationBtn.layer.borderWidth = 1;
        
        if (_timer.isValid) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

#pragma mark -- textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.login.code = textField.text;
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.verificationCodeTF resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    return (newString.length <= 6);
}

#pragma mark -- UI
- (void)initUIView {
    [self initTitleViewWithTitle:@"手机注册"];
    [self setBackButton:YES];
    
    self.sendVerificationBtn.layer.borderWidth = 1;
    self.sendVerificationBtn.layer.borderColor = mx_Register_borderColor.CGColor;
    _num = 59;
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
}

#pragma mark ---
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
