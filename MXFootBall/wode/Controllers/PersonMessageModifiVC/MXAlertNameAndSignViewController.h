//
//  MXAlertNameAndSignViewController.h
//  MXFootBall
//
//  Created by wxw on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface MXAlertNameAndSignViewController : ViewController

//判断是否是修改姓名界面
@property (assign, nonatomic)BOOL isNameVC;
//信息
@property (copy, nonatomic)NSString *infoString;

@end
