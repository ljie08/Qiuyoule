//
//  MXNetWorkRequest.h
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface MXNetWorkRequest : NSObject

+ (MXNetWorkRequest *)sharedClient;

- (void)getNetWorkState: (void (^)(AFNetworkReachabilityStatus state)) success isNot: (BOOL)isNot;
- (void)CurrentNetWorkState: (void (^)(AFNetworkReachabilityStatus state)) success;
@property (nonatomic, assign) int netWorkState;

- (void)get:(NSString *)url parame:(NSDictionary *)parame
    success:(void (^)(id object))success
    failure:(void (^)(NSError *err))failure;

- (void)post:(NSString *)url parame:(NSDictionary *)parame
     success:(void (^)(id object))success
     failure:(void (^)(NSError *err))failure;

- (void)put:(NSString *)url parame:(NSDictionary *)parame
    success:(void (^)(id object))success
    failure:(void (^)(NSError *err))failure;

//- (void)deletes:(NSString *)url parame:(NSDictionary *)parame
//        success:(void (^)(id object))success
//        failure:(void (^)(NSError *err))failure;
#pragma mark 上传图片
- (void)uploadImages: (NSArray *)imagesArr
           urlString: (NSString *) urlString
              params: (NSDictionary *)params
             success: (void(^)(id responseObject))success
             failure: (void(^)(NSError *error))failure;
#pragma mark 修改头像
- (void)uploadModifyUHeaderImages: (NSArray *)imagesArr
           urlString: (NSString *) urlString
              params: (NSDictionary *)params
             success: (void(^)(id responseObject))success
             failure: (void(^)(NSError *error))failure;
@end
