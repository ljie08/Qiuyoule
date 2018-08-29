//
//  MXSYJPostDetailsController.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "ViewController.h"
#import "MXSYJFocusOnModel.h"

@interface MXSYJPostDetailsController : ViewController

@property (nonatomic, copy) NSString *newsID;

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) NSInteger type;//type为200是官方资讯跳转来的

@property (nonatomic, strong) MXSYJFocusOnModel *model;

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) NSInteger articleType;

@end
