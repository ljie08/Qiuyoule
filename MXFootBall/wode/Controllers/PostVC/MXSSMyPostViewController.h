//
//  MXSSMyPostViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
//#import "MXssPostModel.h"//发帖model
@interface MXSSMyPostViewController : ViewController
@property (nonatomic, assign) NSInteger type;
//@property (nonatomic, strong) MXssPostModel *postModels;//发帖model传值
@property (nonatomic, copy) NSString *yesOrOnString;
//@property (nonatomic, copy) NSMutableArray *postArrCount;
@end
