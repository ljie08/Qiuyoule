//
//  MXSYJCommentModel.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/11.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MXSYJFollowCommentModel.h"

@interface MXSYJCommentModel : NSObject

@property (nonatomic, copy) NSString *headerPic;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *hit;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *commentId;

@property (nonatomic, strong) NSMutableArray *followCommentList;

@end
