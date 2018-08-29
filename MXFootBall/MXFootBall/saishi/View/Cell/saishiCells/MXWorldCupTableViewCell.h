//
//  MXWorldCupTableViewCell.h
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MXWorldCupModel.h"

@interface MXWorldCupTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *homeImgV;

@property (weak, nonatomic) IBOutlet UILabel *horizontalLabel;
@property (weak, nonatomic) IBOutlet UIImageView *awayImgV;

@property (weak, nonatomic) IBOutlet UILabel *awayTeamLabel;

@property (nonatomic, strong) MXWorldCupModel * worldCupModel ;

@end
