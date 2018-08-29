 //
//  MXChatRoomViewController.m
//  MXFootBall
//
//  Created by YY on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//
#import "MXReportViewController.h"
//随机颜色
#define KRandomColor                    [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#import "MXChatRoomViewController.h"
#import "MXChatContentCell.h"
#import "MXChatModel.h"
#import "UITextView+placeHolder.h"
@interface MXChatRoomViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UILabel *tipLabel;

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,strong)UIView *containerView;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UITextView *inputTextView;

@property (nonatomic,copy)NSMutableArray *pingbiArr;
@end

@implementation MXChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    [self setupContainerViews];
    [MXNotificationDefaultCenter addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [MXNotificationDefaultCenter addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [MXNotificationDefaultCenter addObserver:self selector:@selector(receivedNoti:) name:@"chatInfoNotification" object:nil];

    AFNetworkReachabilityManager *networkManager=[AFNetworkReachabilityManager sharedManager];
    [networkManager startMonitoring];
}

-(void)receivedNoti:(NSNotification *)noti{
    NSDictionary *message=noti.userInfo;
    if ([[message objectForKey:@"msgType"] isEqualToString:@"chatmsg"]) {
        if (message[@"messageModel"]!=[NSNull null]&& message[@"messageModel"][@"chatInfoList"]!=[NSNull null]) {
            NSArray *chatInfoList= message[@"messageModel"][@"chatInfoList"];
            for (NSDictionary *dict in chatInfoList) {
                MXChatModel *model=[[[MXChatModel alloc] init] mj_setKeyValues:dict];
                [self.chaInfo addObject:model];
            };
        }
        if (message[@"messageModel"]!=[NSNull null]&& message[@"messageModel"][@"chatInfo"]!=[NSNull null]) {
            NSDictionary *dict=message[@"messageModel"][@"chatInfo"];
            MXChatModel *model=[MXChatModel mj_objectWithKeyValues:dict];
            if (![self.pingbiArr containsObject:model.userId]) {
                [self.chaInfo addObject:model];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chaInfo.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                });
            }
            
        }else if([[message objectForKey:@"msgType"] isEqualToString:@"sysprompt"]){
            [SVProgressHUD showErrorWithStatus:[message[@"messageModel"][@"chatInfo"] objectForKey:@"chatMsg"]];
        }
    }
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(NSMutableArray *)pingbiArr{
    if (!_pingbiArr) {
        _pingbiArr=[NSMutableArray array];
    }
    return _pingbiArr;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] init];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.frame=CGRectMake(0, 0, screen_width,screen_height-scaleWithSize(260)-44-STATUS_AND_NAVIGATION_HEIGHT-scaleWithSize(50)-TABBAR_FRAME- self.adHeight);
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chaInfo.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MXChatContentCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MXChatContentCell class])];
    if (!cell) {
        cell=[[MXChatContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([MXChatContentCell class])];
    }
    mx_weakify(self);
    cell.backgroundColor=[UIColor groupTableViewBackgroundColor];
    MXChatModel *model=self.chaInfo[indexPath.row];
    cell.CallBack = ^{
        MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
        if (config.userId&&[model.userId integerValue]!=[config.userId integerValue]) {
            [self.containerView removeFromSuperview];
            UIAlertController *alertCon=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否举报或屏蔽该用户" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1=[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MXReportViewController *reportVC=[[MXReportViewController alloc] init];
                reportVC.ownerId=model.userId;
                reportVC.reportUerName=[model.username base64DecodedString];
                [reportVC setBackButton:YES];
                [weakSelf.navigationController pushViewController:reportVC animated:YES];
                
            }];
            [alertCon addAction:action1];
            if ([self.pingbiArr containsObject:model.userId]) {
                UIAlertAction *action2=[UIAlertAction actionWithTitle:@"取消屏蔽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[[UIApplication sharedApplication] keyWindow] addSubview:self.containerView];
                    [self.pingbiArr removeObject:model.userId];
                    [SVProgressHUD showSuccessWithStatus:@"取消屏蔽成功"];
                }];
                [alertCon addAction:action2];
            }else{
                UIAlertAction *action2=[UIAlertAction actionWithTitle:@"屏蔽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[[UIApplication sharedApplication] keyWindow] addSubview:self.containerView];
                    [SVProgressHUD showSuccessWithStatus:@"屏蔽成功"];
                    [self.pingbiArr addObject:model.userId];
                }];
                [alertCon addAction:action2];
            }
            
            UIAlertAction *action3=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[[UIApplication sharedApplication] keyWindow] addSubview:self.containerView];
            }];
            [alertCon addAction:action3];
            [self presentViewController:alertCon animated:YES completion:nil];
        }else if(!config.userId){
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:nil];
        }
        
        
    };
    cell.chatModel=model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableView cellHeightForIndexPath:indexPath model:self.chaInfo[indexPath.row] keyPath:@"chatModel" cellClass:[MXChatContentCell class] contentViewWidth:screen_width];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    if ([config.level integerValue]>=self.chatMinLv) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.containerView];
    }else{
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.tipLabel];
    }
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"聊天室界面\"}"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.containerView removeFromSuperview];
    [self.tipLabel removeFromSuperview];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"聊天室界面\"}"];
}
-(void)setupContainerViews{
    self.containerView=[[UIView alloc] initWithFrame:CGRectMake(0, screen_height-TABBAR_FRAME-scaleWithSize(50), screen_width, scaleWithSize(50))];
    self.containerView.backgroundColor=[UIColor whiteColor];
    UIButton *leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.containerView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font=fontSize(scaleWithSize(14));
    [leftButton setImage:[UIImage imageNamed:@"saishi_zuqiu_hui"] forState:UIControlStateNormal];
    [leftButton setTitle:@"弹幕" forState:UIControlStateNormal];
    leftButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
    leftButton.layer.borderWidth=0.5;
    [leftButton setImagePosition:ImagePositionLeft spacing:3];
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    [leftButton addActionHandler:^(UIButton *btn) {
        btn.selected=!btn.selected;
        if (btn.selected) {
            btn.layer.borderColor=[MXLJUtil hexStringToColor:@"0x1D5BE1"].CGColor;
            [btn setTitleColor:[MXLJUtil hexStringToColor:@"0x1D5BE1"] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"saishi_zuqiu_lan"] forState:UIControlStateSelected];
            _inputTextView.placeholder=@"发送弹幕";
            _inputTextView.yy_placeHolderColor=[MXLJUtil hexStringToColor:@"0x1D5BE1"];
            _inputTextView.layer.borderColor=[UIColor blueColor].CGColor;
            if ([config.level integerValue]<self.bulletMinLv) {
                [_inputTextView setEditable:NO];
            }
        }else{
            
            [_inputTextView setEditable:YES];
            _inputTextView.placeholder=@"发送聊天";
            _inputTextView.yy_placeHolderColor=[UIColor lightGrayColor];
            btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
            [btn setImage:[UIImage imageNamed:@"saishi_zuqiu_hui"] forState:UIControlStateSelected];
            _inputTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
            
        }
    }];
    _inputTextView=[[UITextView alloc] init];
    [self.containerView addSubview:self.inputTextView];
    [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftButton);
        make.left.mas_equalTo(leftButton.mas_right).offset(-1);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(screen_width-140);
    }];
    _inputTextView.placeholder=@"发表评论";
    _inputTextView.yy_placeHolderColor=[UIColor lightGrayColor];
    
    _inputTextView.layer.borderWidth=0.5;
    _inputTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.containerView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftButton);
        make.left.mas_equalTo(_inputTextView.mas_right).offset(10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addActionHandler:^(UIButton *btn) {
        if (_inputTextView.text!=nil&&_inputTextView.text.length!=0) {
            if ([leftButton titleColorForState:UIControlStateSelected]==[UIColor lightGrayColor]) {
                [self sendMessageWithMessageType:MXChatMessage];
            }else{
                [self alertPromptBox];
            }
        }
    }];
    sendBtn.backgroundColor=[MXLJUtil hexStringToColor:@"0x1C5CDF"];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, screen_height-TABBAR_FRAME-scaleWithSize(40), screen_width, scaleWithSize(40))];
        _tipLabel.text=[NSString stringWithFormat:@"   会员及lv%ld才能发言",(long)self.chatMinLv];
        _tipLabel.textColor=[UIColor lightGrayColor];
        _tipLabel.backgroundColor=[UIColor whiteColor];
    }
    return _tipLabel;
}
-(void)alertPromptBox{
    mx_weakify(self);
    UIAlertController *alertCon=[UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"是否确定消息以弹幕的形式发送将扣除%@积分",self.bulletCsmScore] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction=[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
        NSMutableDictionary *paras=[NSMutableDictionary dictionaryWithDictionary:@{@"userId":config.userId,@"token":config.token,@"time":[MXLJUtil getNowDateTimeString]}];
        [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:@"api/event/bulletComment"] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {
            if ([[dic objectForKey:@"code"] integerValue]==0) {
                [weakSelf sendMessageWithMessageType:MXBarrageMessage];
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            }
        } WithFailureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"发送失败"];
        }];
        
    }];
    [alertCon addAction:yesAction];
    UIAlertAction *noAction=[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertCon addAction:noAction];
    [self presentViewController:alertCon animated:YES completion:nil];
}
-(void)sendMessageWithMessageType:(MXSendMessageType)type{
    MXSocketManager *manager= [MXSocketManager manager];
    if ([[AFNetworkReachabilityManager sharedManager] isReachable]) {
        [manager sendMsg:self.inputTextView.text andMessageType:type];
        _inputTextView.text=@"";
        [_inputTextView resignFirstResponder];
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前网络不可达"];
    }
    self.inputTextView.text = [self.inputTextView.text filterSensitiveString];
}
-(void)keyboardWillShow:(NSNotification *)notification{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.containerView.frame=CGRectMake(0, screen_height-height-scaleWithSize(50), screen_width, scaleWithSize(50));
        }];
}
-(void)keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame=CGRectMake(0, screen_height-TABBAR_FRAME-scaleWithSize(50), screen_width, scaleWithSize(50));
    }];
}
- (void)scrollsToBottomAnimated:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chaInfo.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];//这里一定要设置为NO，动画可能会影响到scrollerView，导致增加数据源之后，tableView到处乱跳
    }
}
@end
