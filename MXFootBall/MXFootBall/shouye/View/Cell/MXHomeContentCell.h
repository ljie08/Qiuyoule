//
//  MXHomeContentCell.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeContentDelegate <NSObject>

/**
 跳转到内容详情界面
 
 @param tag 第几个cell
 */
- (void)lookContentWithTag:(NSInteger)tag;

@end

@interface MXHomeContentCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableView withContentsArr:(NSArray *)contentsArr;

@property (nonatomic, strong) UICollectionView *contentsCollectionview;

@property (nonatomic, strong) NSArray *contentsArr;//内容数组

@property (nonatomic, assign) id <HomeContentDelegate> delegate;

//collectionview相关
- (void)setCollectionviewLayout;


@end
