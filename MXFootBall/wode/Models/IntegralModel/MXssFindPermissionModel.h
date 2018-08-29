//
//  MXssFindPermissionModel.h
//  MXFootBall
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 zt. All rights reserved.
//获取权限列表model

#import <Foundation/Foundation.h>

@interface MXssFindPermissionModel : NSObject
@property (nonatomic,copy) NSString *imgUrl;//icon图
@property (nonatomic,copy) NSString *levelId;//权限ID levelId permissionId
@property (nonatomic,copy) NSString *permissionName;//权限名
@property (nonatomic,copy) NSString *content;//权限描述
@property (nonatomic,copy) NSString *hasPermission;//是否拥有该权限（0：无，1：有）

@end
