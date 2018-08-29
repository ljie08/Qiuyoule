//
//  MXAlertView.h
//  MXAlertView
//
//  Created by YY on 2018/5/9.
//  Copyright © 2018年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MXTipType){
    MXErrorInfo  = 0,
    MXStatusInfo
};
@interface MXAlertView : UIView

@property (nonatomic,assign)MXTipType type;

-(void)showErrorInfo:(NSString *)info;

@end
