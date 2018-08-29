//
//  MXSYJCustomNavitagionView.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^btnBlock)(NSUInteger tags);

@interface MXSYJCustomNavitagionView : UIView

/** btnBlcok */
@property (nonatomic, copy) btnBlock clickBtnBlock;

/** 广场按钮 */
@property (nonatomic, strong) UIButton *squareBtn;
/** 关注按钮 */
@property (nonatomic, strong) UIButton *focusBtn;
/** 发布文章按钮 */
@property (nonatomic, strong) UIButton *publishBtn;
/** 搜索按钮 */
@property (nonatomic, strong) UIButton *serachBtn;

//- (MXSYJCustomNavitagionView *)viewWithFrame:(CGRect)frame;

@end
