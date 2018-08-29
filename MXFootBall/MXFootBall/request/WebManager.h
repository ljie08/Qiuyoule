//
//  WebManager.h
//  MoxiLjieApp
//
//  Created by ljie on 2018/2/6.
//  Copyright © 2018年 ljie. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

//请求成功回调block
typedef void (^requestSuccessBlock)(NSDictionary *dic);

//请求失败回调block
typedef void (^requestFailureBlock)(NSError *error);

//请求方法define
typedef enum {
    GET,
    POST,
    PUT,
    DELETE,
    HEAD
} HTTPMethod;

@interface WebManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

#pragma mark - Data


#pragma mark -----
#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
WithUrl:(NSString *)url
WithParams:(NSDictionary*)params
WithSuccessBlock:(requestSuccessBlock)success
WithFailureBlock:(requestFailureBlock)failure;

@end


