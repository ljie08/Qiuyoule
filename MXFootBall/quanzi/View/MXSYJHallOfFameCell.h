//
//  MXSYJHallOfFameCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXSYJHallOfFameCell : UITableViewCell

/** 名人堂头像 */
@property (nonatomic, strong) UIImageView *imgView;
/** 名人堂名称 */
@property (nonatomic, strong) UILabel *hallNameLab;
/** 名人堂描述 */
@property (nonatomic, strong) UILabel *hallDescLab;
/** 是否有更新 */
@property (nonatomic, strong) UIImageView *isNewHall;
/** 共有几个名人 */
@property (nonatomic, strong) UILabel *howManyHallLab;


@end
