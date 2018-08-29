//
//  MXSSMyOpinionYESSettledViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssSupotOrPostModel.h"//个人投票/观点model

@class MXSSMyOpinionYESSettledViewController;
@protocol MXSSMyOpinionYESSettledViewControllerDelegate <NSObject>
-(void)goMyOpinionYESSettledViewController:(MXSSMyOpinionYESSettledViewController*)VC withResult:(NSDictionary*)result andArticleModel:(MXssSupotOrPostModel *)model;//个人投票 待结算
@end
@interface MXSSMyOpinionYESSettledViewController : UIViewController
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic,strong) NSMutableArray *OpinionYesArr;//观点已结算数组
@property (nonatomic,assign) id<MXSSMyOpinionYESSettledViewControllerDelegate>delegate;
@end
