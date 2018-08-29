//
//  MXSSBallGameCollectionViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MXssMyCollectGameModel.h"//收藏球赛model

@class MXSSBallGameCollectionViewController;
@protocol MXSSBallGameCollectionViewControllerDelegate <NSObject>
-(void)buyBallGameCollectionViewController:(MXSSBallGameCollectionViewController*)VC withResult:(NSDictionary*)result andBallGameModel:(MXssMyCollectGameModel*)model;//球赛收藏
- (void)BallGameCollectionNewDeleUpdateViewController;//收藏球赛的多选删除后的刷新返回
@end
@interface MXSSBallGameCollectionViewController : ViewController
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic , strong) NSMutableArray * ballGameDataArray;
@property (nonatomic,assign) id<MXSSBallGameCollectionViewControllerDelegate>delegate;
@property (nonatomic,assign) BOOL yesCell;//多选删除的判断
@property (nonatomic,strong) NSMutableArray *dataArraySum;//多选数组

@end
