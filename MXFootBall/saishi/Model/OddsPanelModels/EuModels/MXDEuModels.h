//
//  MXDEuModels.h
//  MXFootBall
//
//  Created by dai on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXDInitalOddsModel.h"

@interface MXDEuModels : NSObject

@property (nonatomic , copy) NSString * companyNm ;

@property (nonatomic , strong) MXDInitalOddsModel * immedOdds ;

@property (nonatomic , strong) MXDInitalOddsModel * initalOdds ;

@end
