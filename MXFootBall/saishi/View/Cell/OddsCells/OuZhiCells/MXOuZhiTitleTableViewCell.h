//
//  MXOuZhiTitleTableViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXDEuModels.h"

@interface MXOuZhiTitleTableViewCell : UITableViewCell


@property (nonatomic,strong)UILabel * companyLabel ;//公司
@property (nonatomic,strong)UILabel * oddsLabel ;//赔率
@property (nonatomic,strong)UILabel * returnRateLabel ;//返还率
@property (nonatomic,strong)UILabel * kellyLabel ;//凯利

@property (nonatomic , strong) MXDEuModels * euModel ;


@end
