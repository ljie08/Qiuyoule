//
//  MXDScoreModel.h
//  MXFootBall
//
//  Created by dai on 2018/5/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDScoreModel : NSObject

@property (nonatomic , assign) NSInteger against ;
@property (nonatomic , assign) NSInteger drawn ;
@property (nonatomic , assign) NSInteger goals ;
@property (nonatomic , assign) NSInteger lost ;
@property (nonatomic , assign) NSInteger pts ;
@property (nonatomic , assign) NSInteger rank ;
@property (nonatomic , assign) NSInteger teamId ;
@property (nonatomic , copy) NSString * teamNm ;
@property (nonatomic , assign) NSInteger won ;

@end
