//
//  MXDBsModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/24.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXDBsOddsModel.h"

@interface MXDBsModel : NSObject

@property (nonatomic , copy) NSString * companyNm ;

@property (nonatomic , strong) MXDBsOddsModel * immedOdds ;

@property (nonatomic , strong) MXDBsOddsModel * initalOdds ;


@end
