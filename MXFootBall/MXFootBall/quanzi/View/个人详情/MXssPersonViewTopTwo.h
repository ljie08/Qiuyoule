//
//  MXssPersonViewTopTwo.h
//  MXFootBall
//
//  Created by Mac on 2018/5/18.
//  Copyright © 2018年 zt. All rights reserved.
//个人详情 圈子话题

#import <UIKit/UIKit.h>
@class MXSYJFocusOnModel;

@protocol MXssPersonViewTopTwoDelegate <NSObject>
-(void)PersonViewTopTwocellClickNext:(MXSYJFocusOnModel*)model;//传值model跳转
@end
@interface MXssPersonViewTopTwo : UIView
//- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic,strong) UITableView *mainTabelview;
@property (nonatomic, strong) NSMutableArray *circleArrTwos;
@property (nonatomic,assign) id<MXssPersonViewTopTwoDelegate>delegate;
@end
