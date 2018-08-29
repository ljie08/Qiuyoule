//
//  MXSYJPersonController.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "ViewController.h"

@class MXssPersonViewTopTwo;

@interface MXSYJPersonController : ViewController

@property (nonatomic, strong) NSString *ownerId;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, strong) MXssPersonViewTopTwo *personTwoTableview;

@end
