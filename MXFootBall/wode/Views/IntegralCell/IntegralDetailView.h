//
//  IntegralDetailView.h
//  MXFootBall
//
//  Created by wxw on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralDetailView : UIView

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image;
@property (nonatomic,copy) NSString *numberimg;//点击那个图片
@property (nonatomic,copy) NSString *titleLabelStr;//信息标题
@property (nonatomic,copy) NSString *contentLabelStr;//权限描述
@end
