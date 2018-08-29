//
//  XWShouYeTableViewCell.h
//  MXFootBall
//
//  Created by wxw on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 cell点击回调

 @param bId 区分按钮类型的ID
 @param indexPath 第几个
 */
typedef void(^FirstCellSelectedBlock)(NSString *bId, NSIndexPath *indexPath);

@interface XWShouYeFirstCell : UITableViewCell

@property (copy, nonatomic) FirstCellSelectedBlock block;

@end
