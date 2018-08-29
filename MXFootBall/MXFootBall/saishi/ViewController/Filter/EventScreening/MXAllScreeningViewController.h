//
//  MXAllScreeningViewController.h
//  MXFootBall
//
//  Created by dai on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ViewController.h"

@protocol MXAllScreeningViewControllerDelegate <NSObject>

- (void)selectNameMutDic:(NSMutableDictionary *) dictionary ;

@end

@interface MXAllScreeningViewController : ViewController

@property (nonatomic , strong) NSString * optType ;

@property (nonatomic ,weak) id<MXAllScreeningViewControllerDelegate> delegate ;

@end





