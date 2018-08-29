//
//  MXssWodeUtils.m
//  MXFootBall
//
//  Created by Mac on 2018/3/29.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXssWodeUtils.h"

@implementation MXssWodeUtils

+(BOOL)savePersonInfo:(MXSSToolConfig *)model{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:model forKey:@"MXSSToolConfigKey"];
    [archiver finishEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:data forKey:kMXSSToolConfigModelKey];
    return [userDefaults synchronize];
}

+(MXSSToolConfig *)loadPersonInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:kMXSSToolConfigModelKey];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    MXSSToolConfig *infoMoedl = [unarchiver decodeObjectForKey:@"MXSSToolConfigKey"];
    [unarchiver finishDecoding];
    return infoMoedl;
}

+(BOOL)removePersonInfo{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kMXSSToolConfigModelKey];
    return [userDefaults synchronize];
}
@end
