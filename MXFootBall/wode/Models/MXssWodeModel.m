//
//  MXssWodeModel.m
//  MXFootBall
//
//  Created by Mac on 2018/3/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXssWodeModel.h"

@implementation levelListModel

- (instancetype)initWithDictionary:(NSDictionary*)dic{
    if (self = [self init]) {
        _levelIcon      = [dic objectForKey:@"levelIcon"];//等级图标
        _levelName      = [NSString stringWithFormat:@"%@",[dic objectForKey:@"levelName"]];//等级名称
        _level  = 0;//等级ID
    }
    return self;
}
@end

@implementation MXssWodeModel
-(id) initWithDict:(NSDictionary *) dict{
    if (self = [self init]) {
//        _levelIcon      = [dict objectForKey:@"levelIcon"];//等级图标
//        _levelName        = [NSString stringWithFormat:@"%@",[dict objectForKey:@"levelName"]];//等级名称
        _attentionNum=0;//关注数
        _fansNum=0;//粉丝数
        _articleNum=0;//发帖数
    }
    return self;
}
@end
