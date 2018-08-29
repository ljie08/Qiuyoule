//
//  MXSYJTagView.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZTagList.h"

@interface MXSYJTagView : UIView

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) YZTagList *tagList;

@property (nonatomic, strong) NSMutableArray *arr;

@end
