//
//  MXSSSettingYijianFankuiViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/5/16.
//  Copyright © 2018年 zt. All rights reserved.
//意见反馈

#import "MXSSSettingYijianFankuiViewController.h"
#define YijianTextViewHeight   105   //意见反馈输入框高度
#define contactTextViewHeight   32    //联系方式输入框高度
#define WordCount                 200    //字数限制
@interface MXSSSettingYijianFankuiViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic)UITextView *textView;//意见
@property (strong, nonatomic)UITextView *contacttextView;//联系方式
@property (strong, nonatomic)UIButton *submitBut;//提交按钮
@property (strong, nonatomic)UITextField *textField1;//联系方式field
@property (strong, nonatomic)UILabel *countLabel;
@end

@implementation MXSSSettingYijianFankuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self upUIView];//铺页面
}


- (void)upUIView{
    UILabel *titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(15), screen_width - scaleWithSize(15*2), scaleWithSize(30))];
    titleNameLabel.text = @"问题及意见";
    titleNameLabel.textColor = mx_Wode_color333333;
    titleNameLabel.font = fontSize(scaleWithSize(16.0f));
    [self.view addSubview:titleNameLabel];
    
    //输入框
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(scaleWithSize(15), scaleWithSize(10) + scaleWithSize(45), screen_width- scaleWithSize(15*2), YijianTextViewHeight)];
    self.textView.backgroundColor = mx_Wode_colorf2f2f2;
    self.textView.text = @"请简要描述反馈的问题或意见";
    self.textView.delegate = self;
    self.textView.textColor = mx_Wode_colorc2c2c2;
    self.textView.font = fontSize(scaleWithSize(14.0f));
    //设置字体样式
//    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize: 14],NSForegroundColorAttributeName:[UIColor darkGrayColor]};
//    self.textView.attributedText = [[NSAttributedString alloc]initWithString:self.textView.text attributes:dic];
//    CGFloat contentInsetRight = self.isNameVC ? (NameInputTextViewHeight - 20) / 2 : 8;
//    CGFloat contentInsetRight = 8;
//    self.textView.textContainerInset = UIEdgeInsetsMake(contentInsetRight, 16, contentInsetRight, 16);
    [self.view addSubview:self.textView];
    //添加字数数量 - 签名
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - 75, self.textView.maxY - 16, 60, 15)];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.textColor = mx_Wode_color666666;
    self.countLabel.text = [NSString stringWithFormat:@"0/%d",WordCount];
    self.countLabel.font = fontSize(scaleWithSize(13.0f));
    self.countLabel.hidden = NO;
    
    [self.view addSubview:self.countLabel];
    
    UILabel *contactLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), self.textView.maxY + scaleWithSize(15), screen_width - scaleWithSize(15*2), scaleWithSize(30))];
    contactLabel.text = @"联系方式";
    contactLabel.textColor = mx_Wode_color333333;
    contactLabel.font = fontSize(scaleWithSize(16.0f));
    [self.view addSubview:contactLabel];
    
    UILabel *listLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(15), self.textView.maxY +scaleWithSize(45)+scaleWithSize(10), screen_width- scaleWithSize(15*2),  contactTextViewHeight)];
    listLabel.backgroundColor = mx_Wode_colorf2f2f2;
    [self.view addSubview:listLabel];
//    创建对象
    self.textField1 = [[UITextField alloc] initWithFrame:CGRectMake(scaleWithSize(20), self.textView.maxY +scaleWithSize(45)+scaleWithSize(10), screen_width- scaleWithSize(15*2+ 5),  contactTextViewHeight)];
//    背景颜色
//    self.textField1.backgroundColor = mx_Wode_colorf2f2f2;
//    输入框的文本
    self.textField1.text = @"";
//    占位符
    self.textField1.placeholder = @"请留下手机号或邮箱：方便我们与您联系";
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
    
    
    self.submitBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitBut.frame = CGRectMake(scaleWithSize(30), self.textField1.maxY + scaleWithSize(50), screen_width - scaleWithSize(30*2), scaleWithSize(50));
    [self.submitBut setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBut.backgroundColor = mx_Wode_colorcccccc;
    [self.submitBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBut addTarget:self action:@selector(submitButClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitBut];
}

-(void)submitButClick:(UIButton*)sender {
    NSLog(@"提交按钮点击判断🚗=%@,%@",self.textField1.text,self.textView.text);
    if([self.textView.text isEqualToString:@"请简要描述反馈的问题或意见"]||self.textView.text.length <= 0){
        [SVProgressHUD showErrorWithStatus:@"请简要描述反馈的问题或意见"];
    }else if (self.textField1.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入联系方式~"];
    }else {
        //NSLog(@"提交反馈调用接口");
        [self saveSuggestMoreData];
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.markedTextRange == nil) {
        NSLog(@"text:%@", textField.text);
    }
    if (self.textView.text.length == 0) {
        self.textView.text=@"请简要描述反馈的问题或意见";
         self.textView.textColor = mx_Wode_colorc2c2c2;
//        _textView.textColor = [UIColor grayColor];
    }
    if (self.textView.text.length>0&&(![self.textView.text isEqualToString:@"请简要描述反馈的问题或意见"])&& self.textField1.text.length>0) {
        self.submitBut.backgroundColor = mx_Wode_colorBlue2374e4;
    }else {
        self.submitBut.backgroundColor = mx_Wode_colorcccccc;
    }
}

//如果开始编辑状态，则将文本信息设置为空，颜色变为黑色：
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.textView.text.length == 13||[self.textView.text isEqualToString:@"请简要描述反馈的问题或意见"]) {
        _textView.text=@"";
        _textView.textColor = [UIColor grayColor];
    }
//    if (self.textView.text.length == 0) {
//        self.textView.text=@"请简要描述反馈的问题或意见";
//        self.textView.textColor = mx_Wode_colorc2c2c2;
//        //        _textView.textColor = [UIColor grayColor];
//    }
//    _textView.textColor = [UIColor grayColor];
    if (self.textView.text.length>0&&(![self.textView.text isEqualToString:@"请简要描述反馈的问题或意见"])&& self.textField1.text.length>0) {
        self.submitBut.backgroundColor = mx_Wode_colorBlue2374e4;
    }else {
        self.submitBut.backgroundColor = mx_Wode_colorcccccc;
    }
    return YES;
}

#pragma mark -- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{//修改字数限制
    self.textView.font = [UIFont systemFontOfSize:14];
    NSLog(@"%@",self.textView.text);
    if (self.textView.text.length>0&&(![self.textView.text isEqualToString:@"请简要描述反馈的问题或意见"])&& self.textField1.text.length>0) {
        self.submitBut.backgroundColor = mx_Wode_colorBlue2374e4;
    }else {
        self.submitBut.backgroundColor = mx_Wode_colorcccccc;
    }
        if (textView.text.length < WordCount) {
            self.countLabel.text = [NSString stringWithFormat:@"%lu/%d",(unsigned long)textView.text.length,WordCount];
        }else{
            self.countLabel.text = [NSString stringWithFormat:@"%d/%d",WordCount,WordCount];
//                     [self.textView resignFirstResponder];//收起键盘
            if (textView.markedTextRange == nil && textView.text.length > WordCount)  //加上 textView.markedTextRange == nil判断，当此属性为nil时，代表不在这种联想输入等待确定状态。
            {
            self.textView.text = [textView.text substringWithRange:NSMakeRange(0, WordCount)];
            }
            [SVProgressHUD showInfoWithStatus:@"字数超出范围了~"];
            return;
        }
}
//点击空白处，收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
    NSLog(@"收回键盘打印？：🍎=%@,%@",self.textField1.text,self.textView.text);
    if (self.textView.text.length == 0) {
        self.textView.text=@"请简要描述反馈的问题或意见";
         self.textView.textColor = mx_Wode_colorc2c2c2;
        //        _textView.textColor = [UIColor grayColor];
    }
    if (self.textView.text.length>0&&(![self.textView.text isEqualToString:@"请简要描述反馈的问题或意见"])&& self.textField1.text.length>0) {
        self.submitBut.backgroundColor = mx_Wode_colorBlue2374e4;
    }else {
        self.submitBut.backgroundColor = mx_Wode_colorcccccc;
    }
}
- (void)viewWillAppear:(BOOL)animated {//界面即将显示
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"意见反馈"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
    self.tabBarController.tabBar.hidden=YES;//不显示下面的tabbar
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"意见反馈界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"意见反馈界面\"}"];
    [[MXNotDataAlertView shareInstance] hideNotDataAlertView];
}
#pragma mark ---saveSuggestMoreData 意见反馈数据
-(void)saveSuggestMoreData{
    
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMySettingSaveSuggest_PATH;//请求意见反馈接口
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
//    [paraDic setObject:self.textField1.text forKey:@"telephone"];//用户有效手机号
    [paraDic setObject:self.textField1.text forKey:@"contact"];//用户联系方式（手机号或邮箱)
    [paraDic setObject:self.textView.text forKey:@"suggest"];//用户意见（不超过200个文字）
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
//    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
                NSLog(@"意见反馈返回接口数据==%@",personDic);
//        [weakSelf.mainTableview.mj_header endRefreshing];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            //加载处理
//            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:[personDic objectForKey:@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];//修改成功返回上一页
        }else {
            if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
                //请先登录
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                login.isPageNumber = 1;
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [self presentViewController:nav animated:YES completion:nil];
                [self removeFromParentViewController];
            }else {
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
            }
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        //        [self.mainTableview.mj_header endRefreshing];
        //        [self.mainTableview.mj_footer endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
