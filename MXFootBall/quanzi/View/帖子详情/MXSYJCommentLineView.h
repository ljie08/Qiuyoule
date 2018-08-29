//
//  MXSYJCommentLineView.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXSYJFollowCommentModel;
@protocol MXSYJCommentLineViewDelegate <NSObject>

- (void)replyClick: (NSInteger)index commentModel: (MXSYJFollowCommentModel *)model indexPath: (NSIndexPath *)indexPath;

@end

@interface MXSYJCommentLineView : UIView

- (void)commentItemsArray:(NSArray *)commentItemsArray;

@property (nonatomic, weak) id<MXSYJCommentLineViewDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
