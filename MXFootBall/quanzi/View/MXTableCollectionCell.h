//
//  MXTableCollectionCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJChannelModel.h"

@protocol btnClickDelegte <NSObject>
@optional
- (void)index:(NSInteger)index;

@end

@interface MXTableCollectionCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,weak) id<btnClickDelegte> delegate;

@property (nonatomic, strong) NSMutableArray *arrModle;


@end
