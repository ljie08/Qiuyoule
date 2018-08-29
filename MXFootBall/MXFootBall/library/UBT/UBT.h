//
//  UBT.h
//  UBTLib
//
//  Created by vincent on 2018/4/2.
//  Copyright © 2018年 vincent. All rights reserved.
//


#ifndef UBT_h
#define UBT_h


#endif /* UBT_h */

#import <Foundation/Foundation.h>



@interface UBT : NSObject

+(void) sync:(void(^)(void))block;

+(void) logTrace:(NSString *)key content:(NSString *)dic;

+(void) logMetric:(NSString *)key content:(NSString *)dic;

+(void) logCode:(NSString *)key content:(NSString *)dic;

+(void) logPage:(NSString *)pageCode;

+(NSString *) getHost;

+(NSDictionary *) getSDKInfo;

+(void) logIP;

@end
