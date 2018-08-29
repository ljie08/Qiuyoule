//
//  UIViewController+matchID.h
//  MXFootBall
//
//  Created by YY on 2018/4/16.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (matchID)

@property (nonatomic,strong)NSString *matchID;

@property (nonatomic,strong)NSString *eventID;

@property (nonatomic,strong)NSString *startTime;

@property (nonatomic,assign)BOOL flag;

@property (nonatomic,strong)NSString *bulletCsmScore;

@property (nonatomic,assign)NSInteger chatMinLv;

@property (nonatomic,assign)NSInteger bulletMinLv;


@property (nonatomic, assign) NSInteger adHeight ;

@end
