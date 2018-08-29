//
//  MXAlertNameAndSignViewController.m
//  MXFootBall
//
//  Created by wxw on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXAlertNameAndSignViewController.h"

#define NameInputTextViewHeight   60    //姓名输入框高度
#define SignInputTextViewHeight   200   //签名输入框高度
#define WordCount                 30    //字数限制

@interface MXAlertNameAndSignViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic)UITextView *textView;
@property (strong, nonatomic)UILabel *countLabel;
@property (strong, nonatomic)UITextField *textField1;//昵称修改

@end

@implementation MXAlertNameAndSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUIForViewController];
    [self addRightItem];
}

//创建UI
- (void)createUIForViewController{
    
    if (self.isNameVC) {
        UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, scaleWithSize(10), screen_width, NameInputTextViewHeight)];
        listLabel.backgroundColor = mx_Wode_colorf2f2f2;
        [self.view addSubview:listLabel];
        //    创建对象
        self.textField1 = [[UITextField alloc] initWithFrame:CGRectMake(scaleWithSize(18), scaleWithSize(10), screen_width - scaleWithSize(18), NameInputTextViewHeight)];
        //    背景颜色
        //    self.textField1.backgroundColor = mx_Wode_colorf2f2f2;
        //    输入框的文本
        self.textField1.text = self.infoString;
        //    占位符
//        self.textField1.placeholder = @"请留下手机号或邮箱：方便我们与您联系";
        //    文本颜色
        self.textField1.textColor = [UIColor grayColor];
        //    文字样式
        self.textField1.font = fontSize(scaleWithSize(14.0f));
        //    对齐方式
        self.textField1.textAlignment = 0;
        self.textField1.delegate = self;
        //    输入框边框样式，和背景无法同时存在
        //    textField1.borderStyle=UITextBorderStyleRoundedRect;
        //    输入框背景图
        //    textField1.background = [UIImage imageNamed:@""];
        //    是否允许用户输入
        self.textField1.enabled = YES;
        //    开始编辑文本时，清空内容（和清空按钮二选一
        self.textField1.clearsOnBeginEditing = YES;
        //    输入安全
        //    textField1.secureTextEntry = YES;
        [self.textField1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.textField1];
    }else {
    
    //输入框
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(0, scaleWithSize(10), screen_width, self.isNameVC ?  NameInputTextViewHeight : SignInputTextViewHeight)];
    self.textView.backgroundColor = mx_Wode_colorf2f2f2;
    self.textView.text = self.infoString;
    self.textView.delegate = self;
    self.textView.textColor = mx_Wode_color666666;
    self.textView.font = [UIFont systemFontOfSize:14];
    //设置字体样式
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:self.isNameVC ? 14 : 14],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    self.textView.attributedText = [[NSAttributedString alloc]initWithString:self.textView.text attributes:dic];
    CGFloat contentInsetRight = self.isNameVC ? (NameInputTextViewHeight - 20) / 2 : 8;
    self.textView.textContainerInset = UIEdgeInsetsMake(contentInsetRight, 16, contentInsetRight, 16);
    
    [self.view addSubview:self.textView];
    
    //添加字数数量 - 签名
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 70, SignInputTextViewHeight - 20, 60, 20)];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.textColor = mx_Wode_color666666;
    self.countLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)self.textView.text.length,WordCount];
    self.countLabel.font = [UIFont systemFontOfSize:14];
    self.countLabel.hidden = self.isNameVC;
    
    [self.view addSubview:self.countLabel];
    }
}

- (void)textFieldDidChange:(UITextField *)textField{//昵称修改的点击
    if (textField.markedTextRange == nil) {
        NSLog(@"text:%@", textField.text);
    }
}
//如果开始编辑状态，则将文本信息设置为空，颜色变为黑色：
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    if (self.textView.text.length == 13||[self.textView.text isEqualToString:@"请简要描述反馈的问题或意见"]) {
        _textView.text=@"";
//        _textView.textColor = [UIColor grayColor];
//    }
    return YES;
}
//添加右上角按钮
- (void)addRightItem{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(savaButtonToClick)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//保存按钮点击事件
- (void)savaButtonToClick{//NSLog(@"点击了保存按钮");
     if (self.isNameVC) {
         [self dataModifyMessageButton:self.textField1.text];//保存按钮点击 数据请求修改信息
     }else {
    [self dataModifyMessageButton:self.textView.text];//保存按钮点击 数据请求修改信息
     }
    
}

#pragma mark --dataModifyMessageButton 保存按钮点击 数据请求修改信息
- (void)dataModifyMessageButton:(NSString*)stringName {//保存按钮点击 数据请求修改信息
    NSLog(@"汽车🚗🚴==%ld",self.textView.text.length);
    
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid = [NSString stringWithFormat:@"%@",userModel.userId];//用户ID
    NSString *token = userModel.token;//用户token
    NSString *timeStr = [MXLJUtil getNowDateTimeString];//当前Unix时间戳
    NSString *url = @"";//请求接口
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    //查找全部匹配的字符，并替换
    NSString *nsSTring = stringName;
    if (self.isNameVC) {
        url = MXWodemModifyUserName_PATH;
        [paraDic setObject:nsSTring forKey:@"nickname"];//修改昵称
    }else {
        url = MXWodemModifyUserSign_PATH;
        [paraDic setObject:nsSTring forKey:@"userSign"];//修改签名
    }
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    if (self.isNameVC) {
        if (self.textField1.text.length >= 1 && self.textField1.text.length <= 12) {
            [config ModifyPersonMessagesWithDIC:paraDic withUrl:url success:^(NSDictionary *personDic) {
                
                MXSSToolConfig *infoModel = [MXssWodeUtils loadPersonInfo];//注意不可以 alloc
                if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
                    if (self.isNameVC) {
                        infoModel.username = personDic[@"data"][@"newUsername"];
                        NSLog(@"newUsername=%@",personDic[@"data"][@"newUsername"]);
                    }else {
                        infoModel.userSign = personDic[@"data"][@"userSign"];
                        NSLog(@"userSign=%@",personDic[@"data"][@"userSign"]);
                    }
                    [MXssWodeUtils savePersonInfo:infoModel];//缓存修改的昵称\签名
                    [SVProgressHUD showSuccessWithStatus:[personDic objectForKey:@"msg"]];
                    [self.navigationController popViewControllerAnimated:YES];//修改成功返回上一页
                }else if ([[personDic objectForKey:@"code"] isEqualToString:@"1006"]) {
                [SVProgressHUD showErrorWithStatus:@"你并没有修改哟"];
                }else {
                    [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
                }
                
            } failure:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }else{
            if (self.textField1.text.length <=0){
                [SVProgressHUD showInfoWithStatus:@"修改不能为空哦~"];
            }else {
                [SVProgressHUD showInfoWithStatus:@"字数超出范围了~"];
            }
        }
        
    }else{
        if (self.textView.text.length >= 1 && self.textView.text.length <= WordCount) {
//        if (self.textView.text.length){
            [config ModifyPersonMessagesWithDIC:paraDic withUrl:url success:^(NSDictionary *personDic) {
                MXSSToolConfig *infoModel = [MXssWodeUtils loadPersonInfo];//注意不可以 alloc
                if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
                    if (self.isNameVC) {
                        infoModel.username = personDic[@"data"][@"newUsername"];
                        NSLog(@"newUsername=%@",personDic[@"data"][@"newUsername"]);
                    }else {
                        infoModel.userSign = personDic[@"data"][@"userSign"];
                        NSLog(@"userSign=%@",personDic[@"data"][@"userSign"]);
                    }
                    [MXssWodeUtils savePersonInfo:infoModel];//缓存修改的昵称\签名
                    [SVProgressHUD showSuccessWithStatus:[personDic objectForKey:@"msg"]];
                    [self.navigationController popViewControllerAnimated:YES];//修改成功返回上一页
                    
                }else {
                    [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
                }
                
            } failure:^(NSString *error) {
                [SVProgressHUD showErrorWithStatus:error];
            }];
        }else{
            if (self.textView.text.length <=0){
                [SVProgressHUD showInfoWithStatus:@"修改不能为空哦~"];
            }else {
                [SVProgressHUD showInfoWithStatus:@"字数超出范围了~"];
            }
        }
    }
}
    
#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{//修改字数限制
    self.textView.font = [UIFont systemFontOfSize:14];
    if (self.isNameVC) {//昵称的字数
//        if (self.textField1.text.length > 12) {
//            //         [self.textView resignFirstResponder];//收起键盘
//            if (textView.markedTextRange == nil && textView.text.length > 12)  //加上 textView.markedTextRange == nil判断，当此属性为nil时，代表不在这种联想输入等待确定状态。
//            {
//                self.textField1.text = [textField1.text substringWithRange:NSMakeRange(0, 12)];
//            }
//            [self.textField1 becomeFirstResponder];
////            [SVProgressHUD showInfoWithStatus:@"昵称字数太长了~"];
//            return;
//        }
    }else{//签名的字数限制
    
    if (textView.text.length < WordCount) {
        self.countLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length,WordCount];
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"%d/%d",WordCount,WordCount];
        if (textView.markedTextRange == nil && textView.text.length > WordCount)  //加上 textView.markedTextRange == nil判断，当此属性为nil时，代表不在这种联想输入等待确定状态。
        {
            self.textView.text = [textView.text substringWithRange:NSMakeRange(0, WordCount)];
        }
        [SVProgressHUD showInfoWithStatus:@"字数超出范围了~"];
        return;
    }
    }
}

    - (void)viewWillAppear:(BOOL)animated {//界面即将显示
        [super viewWillAppear:animated];
        //    [self initTitleViewWithTitle:@"个人信息"];
        //设置返回按钮是否显示
        [self setBackButton:YES];
        if (self.isNameVC) {
            [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"修改名字界面\"}"];
        }else {
            [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"修改签名界面\"}"];
        }
    }
    
    - (void)viewWillDisappear:(BOOL)animated {//界面即将消失
        //    [self.navigationController setNavigationBarHidden:YES animated:animated];//隐藏导航栏
        [super viewWillDisappear:animated];
        if (self.isNameVC) {
            [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"修改名字界面\"}"];
        }else{
            [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"修改签名界面\"}"];
        }
    }
    
    
    //点击空白处，收回键盘
    - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
        [self.textView resignFirstResponder];
    }
    
    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        
    }
    
    @end
