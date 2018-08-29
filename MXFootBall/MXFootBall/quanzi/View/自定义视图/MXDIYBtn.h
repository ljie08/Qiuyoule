//
//  MXDIYBtn.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClick) (UIControl *control);


@interface MXDIYBtn : UIControl

/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 图片 */
@property (nonatomic, strong) UIView *line;

@property (nonatomic, copy) btnClick click;


@end
