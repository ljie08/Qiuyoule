//
//  MXOddsTableViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXDAsiaModel.h"

#import "MXDBsModel.h"

@interface MXOddsTableViewCell : UITableViewCell


@property (nonatomic,strong)UILabel * companyLabel ;//公司

/*
 1. 主胜/大球
 2. 盘口
 3. 客胜/小球
 4. 返还率
 分为初始和即时
 */
@property (nonatomic,strong)UILabel * firstInitialLabel ;//初始
@property (nonatomic,strong)UILabel * firstLeLabel ;//即时

@property (nonatomic,strong)UILabel * secondInitialLabel ;
@property (nonatomic,strong)UILabel * secondLeLabel ;

@property (nonatomic,strong)UILabel * thirdInitialLabel ;
@property (nonatomic,strong)UILabel * thirdLeLabel ;

@property (nonatomic,strong)UILabel * fourthInitialLabel ;
@property (nonatomic,strong)UILabel * fourthLeLabel ;


@property (nonatomic , strong) MXDAsiaModel * asiaModel ;

@property (nonatomic , strong) MXDBsModel * bsModel ;

@end
