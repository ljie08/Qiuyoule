//
//  MXHomeNewsCell.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/6/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXHomeNewsCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithModel:(MXNews *)model;
+ (CGFloat)cellHeightWithString:(NSString *)string;

@end

