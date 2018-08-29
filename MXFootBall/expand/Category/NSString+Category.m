//
//  NSString+Category.m
//  MXFootBall
//
//  Created by zt on 2018/5/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

- (NSString *)filterSensitiveString{
    __block NSString *newStr = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"sensitive" ofType:@"txt"];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *contentsArray = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    dispatch_apply(contentsArray.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        if ([self containsString:contentsArray[index]]) {
            newStr = [self stringByReplacingOccurrencesOfString:contentsArray[index] withString:@"***"];
        }
    });
    return newStr;
}

@end
