//
//  MXHomeScrollCell.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaomdDelegate <NSObject>

/**
 点击label事件
 
 @param tag 第几个label
 */
- (void)clickLabelWithTag:(NSInteger)tag;

@end

@interface MXHomeScrollCell : UITableViewCell

@property (nonatomic, assign)id<PaomdDelegate> delegate;

+ (instancetype)myCellWithTableview:(UITableView *)tableview;

- (void)setDataWithArray:(NSArray *)arr;

@end
