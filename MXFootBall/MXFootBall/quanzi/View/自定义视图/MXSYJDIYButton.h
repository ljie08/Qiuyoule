//
//  MXSYJDIYButton.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^btnClick) (UIControl *control);

@interface MXSYJDIYButton : UIControl
/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 图片 */
@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, copy) btnClick click;


@end
