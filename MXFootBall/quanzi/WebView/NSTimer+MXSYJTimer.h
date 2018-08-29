//
//  NSTimer+MXSYJTimer.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (MXSYJTimer)

- (void)pause;
- (void)resume;
- (void)resumeWithTimeInterval:(NSTimeInterval)time;

+ (NSTimer *)syj_scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void(^)(NSTimer *timer))block;

@end
