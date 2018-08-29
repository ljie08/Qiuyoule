//
//  MXLoginViewController.h
//  MXFootBall
//
//  Created by zt on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "BaseViewController.h"

@protocol MXLoginViewControllerDelegate <NSObject>
-(void)loginSuccessCalled;
@end

@interface MXLoginViewController : BaseViewController
//@property (nonatomic,copy) NSString *yesOrNoStrBack;
@property (nonatomic,assign) id<MXLoginViewControllerDelegate>delegate;

@property (nonatomic, assign) NSInteger isPageNumber;//是否是关注页面

@end
