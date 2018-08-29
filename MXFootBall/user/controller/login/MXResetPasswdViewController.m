//
//  MXResetPasswdViewController.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/4/13.
//  Copyright © 2018年 zt. All rights reserved.
//

//弃用
#import "MXResetPasswdViewController.h"
#import "MXLJJudgeVM.h"

@interface MXResetPasswdViewController ()<UITextFieldDelegate> {
    MXLJJudgeVM *_judgeVM;
}

@property (weak, nonatomic) IBOutlet UITextField *passwdTF1;
@property (weak, nonatomic) IBOutlet UITextField *passwdTF2;

@end

@implementation MXResetPasswdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"重置密码界面\"}"];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"重置密码界面\"}"];
}

- (MXLJLogin *)login {
    if (!_login) {
        _login = [[MXLJLogin alloc] init];
    }
    return _login;
}

- (void)initVMBinding {
    _judgeVM = [[MXLJJudgeVM alloc] init];
}

#pragma mark -- action
- (void)resetPasswd {
    @weakSelf(self);
    _judgeVM.login.registerPhoneNum = self.login.registerPhoneNum;
    _judgeVM.login.code = self.login.code;
    [SVProgressHUD show];
    [_judgeVM forgetPasswdWithLogin:_judgeVM.login success:^(NSString *msg, NSString *code) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:msg];
        [weakSelf goRootBack];
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (IBAction)sureAction:(id)sender {
    @weakSelf(self);
    [_judgeVM isForgetWithType:2 success:^(BOOL isCorrect) {
        if (isCorrect) {
            [weakSelf resetPasswd];
        }
    } failure:^(NSString *errorString) {
        [SVProgressHUD showErrorWithStatus:errorString];
    }];
}

#pragma mark - 点击空白隐藏键盘
- (void)hideKeyBoard:(UITapGestureRecognizer *)tap {
    [self.passwdTF1 resignFirstResponder];
    [self.passwdTF2 resignFirstResponder];
}

#pragma mark -- textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 300:
            _judgeVM.login.registerPasswd1 = textField.text;
            break;
        case 301:
            _judgeVM.login.registerPasswd2 = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (textField.tag == 300) {
        return (newString.length <= 12);
    } else if (textField.tag == 301) {
        return (newString.length <= 12);
    } else {
        return NO;
    }
}

#pragma mark -- ui
- (void)initUIView {
    [self initTitleViewWithTitle:@"重置密码"];
    [self setBackButton:YES];
    
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard:)];
    hideTap.numberOfTapsRequired = 1;
    hideTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:hideTap];
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
