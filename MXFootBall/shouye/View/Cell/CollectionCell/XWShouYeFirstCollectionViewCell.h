//
//  XWShouYeFirstCollectionViewCell.h
//  MXFootBall
//
//  Created by wxw on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWShouYeFirstCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;    //默认隐藏
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *describeLabelHeight;  //约束高度

@end
