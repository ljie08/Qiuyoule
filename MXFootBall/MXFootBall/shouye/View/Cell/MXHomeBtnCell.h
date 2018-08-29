//
//  MXHomeBtnCell.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FastAccessDelegate <NSObject>

/**
 跳转到相应界面
 */
- (void)fastAccessWithTag:(NSInteger)tag;

@end

@interface MXHomeBtnCell : UITableViewCell

+ (instancetype)myCellWithTableview:(UITableView *)tableView withBtnArr:(NSArray *)btnArr;

@property (nonatomic, strong) UICollectionView *btnsCollectionview;
@property (nonatomic, strong) NSArray *btnsArr;//快速通道数组

@property (nonatomic, assign) id <FastAccessDelegate> delegate;

//collectionview相关
- (void)setCollectionviewLayout;

@end
