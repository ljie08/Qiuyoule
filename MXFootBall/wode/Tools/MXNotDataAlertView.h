//
//  MXNotDataAlertView.h
//  MXFootBall
//
//  Created by Mac on 2018/4/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXNotDataAlertView : UIView
+ (instancetype)shareInstance;
-(void)showNotDataAlertViewWithAlertText:(NSString*)text;
-(void)hideNotDataAlertView;
@end
