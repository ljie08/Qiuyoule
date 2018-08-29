//
//  MXDTeamInfoModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/10.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDTeamInfoModel : NSObject

@property (nonatomic, assign) NSInteger  ID ;

@property (nonatomic, copy) NSString * nameZh ;

@property (nonatomic, copy) NSString * logo ;

//赛事名简称
@property (nonatomic , copy) NSString * shortNameZh ;

@end
