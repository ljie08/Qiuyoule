//
//  UIViewController+matchID.m
//  MXFootBall
//
//  Created by YY on 2018/4/16.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "UIViewController+matchID.h"
#import <objc/runtime.h>

@implementation UIViewController (matchID)

-(NSString *)matchID{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setMatchID:(NSString *)matchID{
    objc_setAssociatedObject(self, @selector(matchID),matchID , OBJC_ASSOCIATION_COPY);
}

-(NSString *)eventID{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setEventID:(NSString *)eventID{
    objc_setAssociatedObject(self, @selector(eventID), eventID, OBJC_ASSOCIATION_RETAIN);
}

-(NSString *)startTime{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setStartTime:(NSString *)startTime{
    objc_setAssociatedObject(self, @selector(startTime), startTime, OBJC_ASSOCIATION_COPY);
}
-(BOOL)flag{
    return objc_getAssociatedObject(self, _cmd);
}
-(void)setFlag:(BOOL)flag{
    objc_setAssociatedObject(self, @selector(flag), @(flag), OBJC_ASSOCIATION_ASSIGN);
}

-(void)setBulletCsmScore:(NSString *)bulletCsmScore{
    objc_setAssociatedObject(self, @selector(bulletCsmScore), bulletCsmScore, OBJC_ASSOCIATION_COPY);
}
-(NSString *)bulletCsmScore{
    return objc_getAssociatedObject(self, _cmd);
}

-(NSInteger)chatMinLv{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(void)setChatMinLv:(NSInteger)chatMinLv{
    objc_setAssociatedObject(self, @selector(chatMinLv), @(chatMinLv), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)bulletMinLv{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
-(void)setBulletMinLv:(NSInteger)bulletMinLv{
    objc_setAssociatedObject(self, @selector(bulletMinLv), @(bulletMinLv), OBJC_ASSOCIATION_ASSIGN);
}

-(NSInteger)adHeight {
    return [objc_getAssociatedObject(self, _cmd) integerValue] ;
}
-(void)setAdHeight:(NSInteger)adHeight {
    objc_setAssociatedObject(self, @selector(adHeight), @(adHeight), OBJC_ASSOCIATION_ASSIGN);
}


@end
