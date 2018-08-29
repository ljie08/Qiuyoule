//
//  MXOtherNewsCell.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/6/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXOtherNewsCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithModel:(MXNews *)model;

@end
