//
//  MXSYJFriendsCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJFocusOnModel.h"
//#import "MXSYJProjectListModel.h"

typedef void(^IconClick)(void);

typedef void(^btnClickAction)(UIButton *btn);


@interface MXSYJFriendsCell : UITableViewCell

@property (nonatomic, copy) IconClick tapClick;

@property (nonatomic, copy) btnClickAction btnAction;

/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
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
/** 来源 */
@property (nonatomic, strong) UILabel *formLab;
/** 阅读数 */
@property (nonatomic, strong) UILabel *readNumLab;
/** 图片 */
@property (nonatomic, strong) NSMutableArray *imgArr;

@property (nonatomic, strong) UIView *superViews;

@property (nonatomic, strong) UIView *line;


@property (nonatomic, strong) MXSYJFocusOnModel *model;



@end
