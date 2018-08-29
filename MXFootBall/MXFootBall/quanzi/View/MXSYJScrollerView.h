//
//  MXSYJScrollerView.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonPushAction)(NSInteger tag);

@interface MXSYJScrollerView : UIScrollView

@property (nonatomic, strong) NSMutableArray *arrImg;

@property (nonatomic, copy) ButtonPushAction pushAction;


@end
