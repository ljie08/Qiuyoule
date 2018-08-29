//
//  MXssDashangListModel.m
//  MXFootBall
//
//  Created by Mac on 2018/5/11.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXssDashangListModel.h"
@implementation rewardListModel

- (instancetype)initWithDictionary:(NSDictionary*)dic{
    if (self = [self init]) {
        _rewardId = [dic objectForKey:@"rewardId"];//打赏ID
         _score = [dic objectForKey:@"score"];//打赏积分数
    }
    return self;
}
@end

@implementation MXssDashangListModel
@synthesize rewardCount;//当前论坛被打赏数

-(id) initWithDict:(NSDictionary *) dict{
    self=[super init];
    if (self) {
        rewardCount = [dict objectForKey:@"rewardCount"];//当前论坛被打赏数
        
    }
    return self;
}
@end
