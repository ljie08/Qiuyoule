//
//  MXSYJCommentsCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJCommentModel.h"

typedef void(^CommentBlcok)(NSString *userId, NSString *userName);

@protocol MXSYJCommentsCellDelegate <NSObject>

- (void)replyChildComment: (NSInteger)index commentModel: (MXSYJFollowCommentModel *)followCommentmodel indexPath: (NSIndexPath *)indexPath;

- (void)pushToUserInfoClick: (NSString *)userId;

@end

@interface MXSYJCommentsCell : UITableViewCell

/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 楼层 */
@property (nonatomic, strong) UILabel *floorLab;
/** 时间 */
@property (nonatomic, strong) UILabel *timeLab;
/** 等级 */
@property (nonatomic, strong) UILabel *levelLab;
/** 收藏 */
@property (nonatomic, strong) UIButton *collectionBtn;
/** 评论 */
@property (nonatomic, strong) UIButton *commentsBtn;
/** 标题 */
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) MXSYJCommentModel *model;

@property (nonatomic, copy) CommentBlcok commentClick;

@property (nonatomic, weak) id<MXSYJCommentsCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;


- (CGFloat)cellHegith:(NSString *)text;

@end
