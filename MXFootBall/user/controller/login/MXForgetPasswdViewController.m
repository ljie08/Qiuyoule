//
//  MXForgetPasswdViewController.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/4/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXForgetPasswdViewController.h"
#import "MXLJJudgeVM.h"
//#import "MXResetPasswdViewController.h"//重置密码

@interface MXForgetPasswdViewController ()<UITextFieldDelegate>{
    MXLJJudgeVM *_judgeVM;
    NSTimer *_timer;//定时器
    NSInteger _num;//定时倒计数
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//验证码按钮
@property (weak, nonatomic) IBOutlet UITextField *passwdTF1;
@property (weak, nonatomic) IBOutlet UITextField *passwdTF2;

@property (nonatomic, assign) NSTimeInterval backTime;//进入后台的时间
@property (nonatomic, assign) NSTimeInterval foregroundTime;//进入前台的时间

@end

@implementation MXForgetPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwdForeground) name:UIApplicationWillEnterForegroundNotification object:nil];//进入前台，定时器开启
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(passwdBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];//进入后台，定时器停掉
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.borderColor = mx_BlueColor.CGColor;
    self.codeBtn.layer.borderWidth = 1;

    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"忘记密码界面\"}"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self resetBtn];
    [self resetTimer];
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"忘记密码界面\"}"];
}

#pragma mark -- 前台、后台通知
//进入前台
- (void)passwdForeground {
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
- (void)passwdBackground {
    self.backTime = [NSDate date].timeIntervalSince1970;
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark -- data
- (void)initVMBinding {
    _judgeVM = [[MXLJJudgeVM alloc] init];
}

//发送验证码
//发送前先判断手机号输入是否正确
- (IBAction)sendCodeAction:(id)sender {
    
    if (!self.phoneTF.text || !_judgeVM.login.registerPhoneNum ) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (self.phoneTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"手机号有误"];
        return;
    }
    
    @weakSelf(self);
    [SVProgressHUD show];
    //判断手机号是否注册过或绑定过
    [_judgeVM checkPhoneBindWithPhoneNum:_judgeVM.login.registerPhoneNum success:^(NSString *msg, NSString *code) {
        [SVProgressHUD dismiss];
        if ([code isEqualToString:@"0"] || [code isEqualToString:@"1021"] || [code isEqualToString:@"1022"] || [code isEqualToString:@"1023"]) {//手机号正常，可收取验证码
            [weakSelf getCode];
        } else {
            [SVProgressHUD showErrorWithStatus:msg];
        }
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

//获取验证码
- (void)getCode {
    @weakSelf(self);
    [SVProgressHUD show];
    [_judgeVM getCodeWithPhoneNum:_judgeVM.login.registerPhoneNum success:^(NSString *msg){
        [SVProgressHUD dismiss];
        if (msg.length) {
            [SVProgressHUD showErrorWithStatus:msg];
        } else {
            [weakSelf setBtn];
            
            [SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
        }
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
        [weakSelf resetBtn];
        [weakSelf resetTimer];
    }];
}

//密码设置完成。提交。先判断输入是否正确
- (IBAction)nextAction:(id)sender {
    @weakSelf(self);
    [SVProgressHUD show];
    //type已弃用，忘记和重置合并了一个界面
    [_judgeVM isForgetWithType:1 success:^(BOOL isCorrect) {
        [SVProgressHUD dismiss];
        if (isCorrect) {
            [weakSelf resetPasswd];
        }
    } failure:^(NSString *errorString) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:errorString];
    }];
}

//重置密码
- (void)resetPasswd {
    @weakSelf(self);
    [SVProgressHUD show];
    [_judgeVM forgetPasswdWithLogin:_judgeVM.login success:^(NSString *msg, NSString *code) {
        [SVProgressHUD dismiss];
        if ([code isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:msg];
            [weakSelf goRootBack];
        } else {
            [SVProgressHUD showErrorWithStatus:msg];
        }
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
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

//设置button和开启定时器
- (void)setBtn {
    self.codeBtn.enabled = NO;
    self.codeBtn.layer.borderWidth = 0;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechang:) userInfo:nil repeats:YES];
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
    [self.phoneTF resignFirstResponder];
    [self.codeTF resignFirstResponder];
    [self.passwdTF1 resignFirstResponder];
    [self.passwdTF2 resignFirstResponder];
}

#pragma mark -- textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 200:
            _judgeVM.login.registerPhoneNum = textField.text;
            break;
        case 201:
            _judgeVM.login.code = textField.text;
            break;
        case 202:
            _judgeVM.login.registerPasswd1 = textField.text;
            break;
        case 203:
            _judgeVM.login.registerPasswd2 = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (textField.tag == 200) {
        return (newString.length <= 11);
    } else if (textField.tag == 201) {
        return (newString.length <= 6);
    } else if (textField.tag == 202) {
        return (newString.length <= 12);
    } else if (textField.tag == 203) {
        return (newString.length <= 12);
    } else {
        return NO;
    }
}

#pragma mark -- UI
- (void)initUIView {
    [self initTitleViewWithTitle:@"忘记密码"];
    [self setBackButton:YES];
    
    _num = 59;
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
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



@end
