//
//  MXSSMyOpinionNOSettledViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssSupotOrPostModel.h"//个人投票/观点model

@class MXSSMyOpinionNOSettledViewController;
@protocol MXSSMyOpinionNOSettledViewControllerDelegate <NSObject>
-(void)goMyOpinionNOSettledViewController:(MXSSMyOpinionNOSettledViewController*)VC withResult:(NSDictionary*)result andArticleModel:(MXssSupotOrPostModel *)model;//个人投票 待结算
@end
@interface MXSSMyOpinionNOSettledViewController : UIViewController
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic,strong) NSMutableArray *OpinionNoArr;//观点待结算数组
@property (nonatomic,assign) id<MXSSMyOpinionNOSettledViewControllerDelegate>delegate;
@end
