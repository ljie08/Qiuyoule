//
//  MXVerificationViewController.h
//  MXFootBall
//
//  Created by lee🎀 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "BaseViewController.h"

@interface MXVerificationViewController : BaseViewController

@property (nonatomic, strong) MXLJLogin *login;//注册手机号、密码等
@property (nonatomic, strong) NSString *phoneNum;//绑定手机号时该手机号还未注册

@end
