//
//  MXssIntegralBouncedView.h
//  MXFootBall
//
//  Created by Mac on 2018/4/3.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXssIntegralBouncedView : UIView
- (instancetype)initWithFrame:(CGRect)frame withImage:(NSString *)image withShowPermissionName:(NSString *)scoreRuleContent withPersonContent:(NSString *)scoreUpperValue;
@property (nonatomic,copy) NSString *numberimg;//点击那个图片
@end
