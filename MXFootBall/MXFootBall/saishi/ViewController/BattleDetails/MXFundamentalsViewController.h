//
//  MXFundamentalsViewController.h
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ViewController.h"

#import "MXEventBasicPanelModel.h"

typedef void(^DataRefreshing)(MXEventBasicPanelModel * model);

@interface MXFundamentalsViewController : ViewController

@property (nonatomic, assign) NSInteger matchId ;


@property (nonatomic , strong) DataRefreshing dataRefreshing ;

@end
