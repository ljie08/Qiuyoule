//
//  MXssDashangListModel.h
//  MXFootBall
//
//  Created by Mac on 2018/5/11.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface rewardListModel : NSObject

@property (nonatomic,copy) NSString *score;//打赏积分数
@property (nonatomic,copy) NSString *rewardId;//打赏ID

@end
@interface MXssDashangListModel : NSObject
@property (nonatomic, copy) NSString *rewardCount;//当前论坛被打赏数
@property (nonatomic, strong) NSMutableArray<rewardListModel *> *rewardList;
-(id) initWithDict:(NSDictionary *) dict;
@end
