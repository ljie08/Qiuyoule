//
//  MXFilterModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/12.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXFilterModel : NSObject

//@property (nonatomic, copy) NSString * initials ;//组名

@property (nonatomic, assign) NSInteger count ;//赛事统计数

@property (nonatomic, assign) NSInteger ID ;//赛事Id
@property (nonatomic, copy) NSString * shortNameZh ;//赛事简称

@property (nonatomic, assign) NSInteger isSelect ;//选中



@end
