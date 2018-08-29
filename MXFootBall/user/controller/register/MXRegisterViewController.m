//
//  MXRegisterViewController.m
//  MXFootBall
//
//  Created by zt on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXRegisterViewController.h"
#import "MXLJJudgeVM.h"//判断输入数据是否正确或完整
//#import "MXAgreementViewController.h"//协议
#import "WKViewController.h"//协议

@interface MXRegisterViewController ()<UITextFieldDelegate> {
    NSTimer *_timer;//定时器
    NSInteger _num;//定时倒计数
    MXLJJudgeVM *_judgeVM;
}

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;//

@property (weak, nonatomic) IBOutlet UITextField *passwdTF;//密码输入框
@property (weak, nonatomic) IBOutlet UITextField *passwdAgainTF;//再次输入密码
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;//选中
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;//协议

@property (nonatomic, assign) NSTimeInterval backTime;//进入后台的时间
@property (nonatomic, assign) NSTimeInterval foregroundTime;//进入前台的时间

@end

@implementation MXRegisterViewController

#pragma mark -- life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];//进入前台，定时器开启
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];//进入后台，定时器停掉
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.borderColor = mx_BlueColor.CGColor;
    self.codeBtn.layer.borderWidth = 1;
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"注册界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resetTimer];
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"注册界面\"}"];
}

#pragma mark -- 前台、后台通知
//进入前台
- (void)enterForeground {
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
- (void)enterBackground {
    self.backTime = [NSDate date].timeIntervalSince1970;
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
}

#pragma mark -- data
- (void)initVMBinding {
    _judgeVM = [[MXLJJudgeVM alloc] init];
}

//注册
- (void)registerUser {
    @weakSelf(self);
    [SVProgressHUD show];
    [_judgeVM registerWithPhoneNum:_judgeVM.login.registerPhoneNum code:_judgeVM.login.code passwd:_judgeVM.login.registerPasswd1 success:^(NSString *msg){
        [SVProgressHUD dismiss];
        if (msg.length) {
            [SVProgressHUD showErrorWithStatus:msg];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

#pragma mark -- IBAction
//发送验证码
- (IBAction)sendCodeAction:(id)sender {
    
    if (!self.phoneNumTF.text || !_judgeVM.login.registerPhoneNum) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    
    @weakSelf(self);
    //判断手机号是否注册过或绑定过
    [SVProgressHUD show];
    [_judgeVM checkPhoneBindWithPhoneNum:_judgeVM.login.registerPhoneNum success:^(NSString *msg, NSString *code) {
        [SVProgressHUD dismiss];
        if ([code isEqualToString:@"0"]) {//既没注册也没绑定
            [weakSelf getCode];
//        } else if ([code isEqualToString:@"1021"] || [code isEqualToString:@"1023"]) {//绑定过，表示已经注册了
        } else {
            //1023注册过，没绑定过
            //1021绑定过(表示已经注册了)
            //其他错误情况
            [weakSelf setAlertViewWithTitle:msg message:nil];
        }
        
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

//获取验证码
- (void)getCode {
    [self setBtn];
    [self setTimer];
    
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
- (IBAction)nextAction:(id)sender {
    @weakSelf(self);
    [_judgeVM isRegisterCompleteWithTextAndButtonIsSelected:self.selectBtn.selected success:^(BOOL isCorrect) {
        if (isCorrect) {
            [weakSelf registerUser];
        }
    } failure:^(NSString *errorString) {
        [SVProgressHUD showErrorWithStatus:errorString];
    }];
}

//勾选同意并阅读
- (IBAction)selectAction:(UIButton *)button {
    button.selected = !button.selected;
    self.selectBtn.selected = button.selected;
    if (button.selected) {
        button.backgroundColor = mx_redColor;//根据需要修改
    } else {
        button.backgroundColor = mx_Wode_color666666;//根据需要修改
    }
}

//查看注册协议
- (IBAction)seeAgreementAction:(id)sender {
    @weakSelf(self);
    [SVProgressHUD show];
    [_judgeVM protocolWithSuccess:^(BOOL isCorrect) {
        [SVProgressHUD dismiss];
        if (isCorrect) {
            WKViewController *wk = [[WKViewController alloc] init];
            wk.url = _judgeVM.protocol.targetUrl;
            wk.wktitle = _judgeVM.protocol.title;
            [weakSelf.navigationController pushViewController:wk animated:YES];
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

- (void)setBtn {
    self.codeBtn.enabled = NO;
    self.codeBtn.layer.borderWidth = 0;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds后重试",_num] forState:UIControlStateNormal];
}

- (void)setTimer {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timechang:) userInfo:nil repeats:YES];
}

- (void)resetBtn {
    self.codeBtn.enabled = YES;
    _num = 59;
    [self.codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.codeBtn.layer.borderWidth = 1;
}

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
    [self.passwdTF resignFirstResponder];
    [self.passwdAgainTF resignFirstResponder];
}

#pragma mark -- textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 100:
            _judgeVM.login.registerPhoneNum = textField.text;
            break;
        case 101:
            _judgeVM.login.code = textField.text;
            break;
        case 102:
            _judgeVM.login.registerPasswd1 = textField.text;
            break;
        case 103:
            _judgeVM.login.registerPasswd2 = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (textField.tag == 100) {
        return (newString.length <= 11);
    } else if (textField.tag == 101) {
        return (newString.length <= 6);
    } else if (textField.tag == 102 || textField.tag == 103) {
        return (newString.length <= 12);
    } else {
        return NO;
    }
}

#pragma mark -- UI
- (void)initUIView {
    [self initTitleViewWithTitle:@"注册"];
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
 */
- (void)setAlertViewWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureaction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alert addAction:sureaction];
    [self presentViewController:alert animated:YES completion:nil];
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
