//
//  MXAgreementViewController.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

//弃用
#import "MXAgreementViewController.h"

@interface MXAgreementViewController ()

@end

@implementation MXAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"协议界面\"}"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"协议界面\"}"];
}

#pragma mark -- UI
- (void)initUIView {
    [self initTitleViewWithTitle:@"协议"];
    [self setBackButton:YES];
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
