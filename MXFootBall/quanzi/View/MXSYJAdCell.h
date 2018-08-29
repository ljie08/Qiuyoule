//
//  MXSYJAdCell.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSYJFocusOnModel.h"

typedef void(^ADClick)(void);

@interface MXSYJAdCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) MXSYJFocusOnModel *model;

@property (nonatomic, copy) ADClick imgClick;


@end
