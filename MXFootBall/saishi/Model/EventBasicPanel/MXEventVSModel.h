//
//  MXEventVSModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXEventVSModel : NSObject

@property (nonatomic , assign) NSInteger tolDrawn ;
@property (nonatomic , assign) NSInteger tolLost ;
@property (nonatomic , assign) NSInteger tolWon ;

@property (nonatomic , strong) NSArray * battle ;

@end
