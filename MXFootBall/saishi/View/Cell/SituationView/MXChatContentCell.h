//
//  MXCahtContentCell.h
//  MXFootBall
//
//  Created by YY on 2018/4/10.
//  Copyright © 2018年 zt. All rights reserved.
//
#import "MXChatModel.h"
#import <UIKit/UIKit.h>
typedef void (^ClickedHeadImageHandler)(void);
@interface MXChatContentCell : UITableViewCell

@property (nonatomic,strong)MXChatModel *chatModel;

@property (nonatomic,copy)ClickedHeadImageHandler CallBack;

@end
