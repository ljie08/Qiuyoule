//
//  MXOfficialCell.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXOfficialCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithModel:(MXSYJFocusOnModel *)model;
+ (CGFloat)cellHeightWithString:(NSString *)string;

@end
