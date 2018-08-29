//
//  XWShouYeSecondCell.h
//  MXFootBall
//
//  Created by wxw on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 cell点击事件

 @param indexpath indexpath
 @param newsID 。。。
 */
typedef void(^secondCellSelectedBlock)(NSIndexPath *indexpath,NSString *newsID);

@interface XWShouYeSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainDescribeLabel;

@property (copy, nonatomic)secondCellSelectedBlock block;

@property (strong, nonatomic) NSArray *paoMaDengArray;
@end
