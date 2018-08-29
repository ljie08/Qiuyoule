//
//  MXSSMyVoteNOSettledViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssSupotOrPostModel.h"//个人投票/观点model

@class MXSSMyVoteNOSettledViewController;
@protocol MXSSMyVoteNOSettledViewControllerDelegate <NSObject>
-(void)goMyVoteNOSettledViewController:(MXSSMyVoteNOSettledViewController*)VC withResult:(NSDictionary*)result andArticleModel:(MXssSupotOrPostModel *)model;//个人投票 待结算
@end

@interface MXSSMyVoteNOSettledViewController : UIViewController
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic,strong) NSMutableArray *voteNoArr;//待结算数组
@property (nonatomic,assign) id<MXSSMyVoteNOSettledViewControllerDelegate>delegate;
@end
