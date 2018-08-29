//
//  MXSYJFollowCommentModel.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXSYJFollowCommentModel : NSObject

@property (nonatomic, copy) NSString *followerId;
@property (nonatomic, copy) NSString *followerName;
@property (nonatomic, copy) NSString *ownerName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, copy) NSString *ownerId;

@property (nonatomic, copy) NSAttributedString *attributedContent;


@end
