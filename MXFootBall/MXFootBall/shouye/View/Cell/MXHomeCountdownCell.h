//
//  MXHomeCountdownCell.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/18.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXHomeCountdownCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

/**
 设置倒计时的时间
 
 @param countdown 倒计时
 */
- (void)setTimeWithCountDown:(MXLJCountDown *)countdown pic:(NSString *)pic;

@end
