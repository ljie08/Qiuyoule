//
//  MXPersonalInformationViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface MXPersonalInformationViewController : ViewController
@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) UILabel *hysNickName;//昵称
@property (nonatomic, strong) UILabel *hysXingbie;//性别
@property (nonatomic, strong) UILabel *hysQianmingName;//签名
@end
