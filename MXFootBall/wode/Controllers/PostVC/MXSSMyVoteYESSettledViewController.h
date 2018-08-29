//
//  MXSSMyVoteYESSettledViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssSupotOrPostModel.h"//个人投票/观点model

@class MXSSMyVoteYESSettledViewController;
@protocol MXSSMyVoteYESSettledViewControllerDelegate <NSObject>
-(void)goMyVoteYESSettledViewController:(MXSSMyVoteYESSettledViewController*)VC withResult:(NSDictionary*)result andArticleModel:(MXssSupotOrPostModel *)model;//个人投票 已结算
@end
@interface MXSSMyVoteYESSettledViewController : UIViewController
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic,strong) NSMutableArray *voteYesArr;//已结算数组
@property (nonatomic,assign) id<MXSSMyVoteYESSettledViewControllerDelegate>delegate;
@end
