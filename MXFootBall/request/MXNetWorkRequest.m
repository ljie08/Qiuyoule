//
//  MXNetWorkRequest.m
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXNetWorkRequest.h"
#import <objc/runtime.h>

static AFNetworkReachabilityManager *netStatus = nil;

@interface MXNetWorkRequest()

@property (nonatomic, copy) NSMutableArray *objectsArr;

@end

@implementation MXNetWorkRequest

- (NSMutableArray *)objectsArr{
    if (!_objectsArr) {
        _objectsArr = [NSMutableArray array];
    }
    return _objectsArr;
}

- (void)getNetWorkState:(void (^)(AFNetworkReachabilityStatus))success isNot:(BOOL)isNot{
    
    netStatus = [AFNetworkReachabilityManager sharedManager];
    [netStatus startMonitoring];
    [netStatus setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (success) {
            success(status);
        }
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [SVProgressHUD showErrorWithStatus:@"当前未连接网络"];
        }
        
        if (isNot) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NETWORK_STATUS_CHANGE_NOT" object:@(status)];
        }
        
        /*if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
         //[self tishiWithTitle:@"提示" message:@"当前网络为WWAN" title2:@"返回"];
         }
         
         if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
         //[self tishiWithTitle:@"提示" message:@"当前网络为WiFi" title2:@"返回"];
         }
         if (status == AFNetworkReachabilityStatusUnknown) {
         //[self tishiWithTitle:@"提示" message:@"当前为未知网" title2:@"返回"];
         }*/
    }];
    
}

- (void)CurrentNetWorkState:(void (^)(AFNetworkReachabilityStatus))success{
    int type = self.netWorkState;
    if (type == 0) {
        success(AFNetworkReachabilityStatusNotReachable);
    }else if (type == 1){
        success(AFNetworkReachabilityStatusReachableViaWWAN);
    }else if (type == 2){
        success(AFNetworkReachabilityStatusReachableViaWWAN);
    }else if (type == 3){
        success(AFNetworkReachabilityStatusReachableViaWWAN);
    }else if (type == 5){
        success(AFNetworkReachabilityStatusReachableViaWiFi);
    }
}

- (int)netWorkState{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    return type;
}

+ (MXNetWorkRequest *)sharedClient
{
    static MXNetWorkRequest *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedClient = [[MXNetWorkRequest alloc] init];
        if (!netStatus) {
            [_sharedClient getNetWorkState:nil isNot:YES];
        }
    });
    return _sharedClient;
}

- (void)get:(NSString *)url parame:(NSDictionary *)parame
    success:(void (^)(id object))success
    failure:(void (^)(NSError *err))failure{
    
    //    url = [CPNetWorkRequest requestWithAddress:url];
    
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //
    ////    NSString *token = [CDAccount getAccoutModel].token ? [CDAccount getAccoutModel].token : @"";
    //    //设置请求的参数为json格式
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"x-requested-with"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain", nil];
    //请求头
    //    [manager.requestSerializer setValue:token forHTTPHeaderField:@"API-Token"];
    
    [manager GET:url parameters:parame progress:^(NSProgress * _Nonnull downloadProgress) {
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             success(responseObject);
             
         }
     
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
             
             
             failure(error);//这里打印错误信息
             
         }];
}


- (void)post:(NSString *)url parame:(NSDictionary *)parame
     success:(void (^)(id object))success
     failure:(void (^)(NSError *err))failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    //    NSString *token = [CDAccount getAccoutModel].token ? [CDAccount getAccoutModel].token : @"";
    
    //    设置请求的参数为json格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"x-requested-with"];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain",@"charset=UTF-8", nil];
    
    // 设置请求头
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    //请求头
    //    [manager.requestSerializer setValue:token forHTTPHeaderField:@"API-Token"];
    
    
    [manager POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}
#pragma mark 上传图片
- (void)uploadImages: (NSArray *)imagesArr
           urlString: (NSString *) urlString
              params: (NSDictionary *)params
             success: (void(^)(id responseObject))success
             failure: (void(^)(NSError *error))failure{
    //1.拼接服务器地址
    NSString *url = [SERVER_HOST stringByAppendingString:urlString];
    //2.发起网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.objectsArr removeAllObjects];
    
    //上传多张图片
    
        [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
           
            for (int i = 0; i < imagesArr.count; i++) {
                if ([imagesArr[i] isMemberOfClass:[UIImage class]]) {
                    UIImage *newImage = imagesArr[i];
//                    UIImage *oldImage = imagesArr[i];
                    if (newImage.size.width > 640) {
                        
                        newImage = [newImage resizeImage:640];
                        
                    }
                    NSData *data = UIImageJPEGRepresentation(newImage, 0.9);
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    //设置时间格式
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    
                    NSString *str = [formatter stringFromDate:[NSDate date]];
                    
                    NSString *fileName = [NSString stringWithFormat:@"%d%@.jpg", i, str];
                    [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"image/jpeg"];
                }else{
                    NSData *data = imagesArr[i];
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    //设置时间格式
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    
                    NSString *str = [formatter stringFromDate:[NSDate date]];
                    
                    NSString *fileName = [NSString stringWithFormat:@"%d%@.gif", i, str];
                    [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"image/gif"];
                }
                
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            success(responseObject);

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    
}

#pragma mark 修改头像
- (void)uploadModifyUHeaderImages: (NSArray *)imagesArr
                        urlString: (NSString *) urlString
                           params: (NSDictionary *)params
                          success: (void(^)(id responseObject))success
                          failure: (void(^)(NSError *error))failure{
    //1.拼接服务器地址
    NSString *url = [SERVER_HOST stringByAppendingString:urlString];
    //2.发起网络请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.objectsArr removeAllObjects];
    
    //上传头像图片
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (UIImage *image in imagesArr) {
            
            UIImage *newImage = image;
            if (image.size.width > 640) {
                
                newImage = [image resizeImage:640];
                
            }
            NSData *data = UIImageJPEGRepresentation(newImage, 0.9);
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            //设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
@end
