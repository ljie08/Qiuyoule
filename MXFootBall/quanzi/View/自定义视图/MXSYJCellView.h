//
//  MXSYJCellView.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^rankingBlock)(void);

@interface MXSYJCellView : UIView

/** 头像 */
@property (nonatomic, strong) UIImageView *iconImg;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 描述 */
@property (nonatomic, strong) UILabel *descLab;
/** 名次 */
@property (nonatomic, strong) UILabel *rankingLab;
@property (nonatomic, strong) UIImageView *rankingImg;

@property (nonatomic, copy) rankingBlock click;

@end
