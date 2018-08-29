//
//  NSString+base64.h
//  MXFootBall
//
//  Created by YY on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end


@interface NSString (Base64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
//加密
- (NSString *)base64EncodedString;
//解密
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end
