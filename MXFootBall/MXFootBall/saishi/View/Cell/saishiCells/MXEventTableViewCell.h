//
//  MXEventTableViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXDEventModel.h"
//#import "MXssMyCollectGameModel.h"///我的收藏球赛的model
typedef void(^EventCollectMatcheBlock)(void);
@interface MXEventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BackView; // 赛事信息背景View
@property (weak, nonatomic) IBOutlet UIButton *selctButton; //选择按钮

@property (weak, nonatomic) IBOutlet UILabel *NumberOfPeriods;
@property (weak, nonatomic) IBOutlet UILabel *ExpertName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *view1;

@property (weak, nonatomic) IBOutlet UILabel *numberL1;
@property (weak, nonatomic) IBOutlet UILabel *numberL2;

@property (weak, nonatomic) IBOutlet UILabel *TeamNameL1;
@property (weak, nonatomic) IBOutlet UILabel *TeamNameL2;

@property (weak, nonatomic) IBOutlet UILabel *OddsL1;
@property (weak, nonatomic) IBOutlet UILabel *OddsL2;

@property (weak, nonatomic) IBOutlet UILabel *RatioLabel;
@property (weak, nonatomic) IBOutlet UILabel *RatioLabel2;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (nonatomic , strong) EventCollectMatcheBlock eventCollectMatcheBlock ;

@property (nonatomic , strong) MXDEventModel * eventModel ;
//@property (nonatomic, strong) MXssMyCollectGameModel *MyevenListModel;//我的收藏球赛的model

@end
