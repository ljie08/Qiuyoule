//
//  WebManager.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/7/27.
//  Copyright © 2017年 ljie. All rights reserved.
//

#import "WebManager.h"

@implementation WebManager

+ (instancetype)sharedManager {
    static WebManager *manager = nil;
    static dispatch_once_t pred;

        dispatch_once(&pred, ^{
            manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:SERVER_HOST]];
        });
    
    
    return manager;
}

-(instancetype)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
//        if (SERVER_HOST == [NSString stringWithFormat:@"https://api.qiuyoule.com/"]) {
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"*.qiuyoule.com" ofType:@".cer"];
            NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
            NSSet *cerSet = [NSSet setWithObjects:cerData, nil];
            
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
            
            // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
            // 如果是需要验证自建证书，需要设置为YES
            securityPolicy.allowInvalidCertificates = YES;
            //设置是否需要验证域名
            securityPolicy.validatesDomainName = YES;
            
            securityPolicy.pinnedCertificates = cerSet;
//        }
        
        
        // 请求超时设定
//        self.securityPolicy = securityPolicy;
        self.requestSerializer.timeoutInterval = 15;
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        
    }
    return self;
}

#pragma mark - Data

#pragma mark ----
#pragma mark - request
- (void)requestWithMethod:(HTTPMethod)method
                  WithUrl:(NSString *)url
               WithParams:(NSDictionary*)params
         WithSuccessBlock:(requestSuccessBlock)success
         WithFailureBlock:(requestFailureBlock)failure {
    
//    url = [NSString stringWithFormat:@"%@%@", BaseURL, url];
//    NSLog(@"url --> %@", url);
    
    switch (method) {
        case GET:{
            [self GET:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
//                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                failure(error);
            }];
            break;
        }
        case POST:{
            [self POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                NSLog(@"JSON: %@", responseObject);
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                failure(error);
            }];
            break;
        }
        default:
            break;
    }
}

@end


