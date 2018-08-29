//
//  MXDAsiaModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MXDAsiaOddsModel.h"

@interface MXDAsiaModel : NSObject

@property (nonatomic , copy) NSString * companyNm ;

@property (nonatomic , strong) MXDAsiaOddsModel * immedOdds ;

@property (nonatomic , strong) MXDAsiaOddsModel * initalOdds ;


@end
