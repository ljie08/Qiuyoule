//
//  MXChatModel.h
//  MXFootBall
//
//  Created by YY on 2018/4/11.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,MessageFormType){
    MessageFormOther = 0 ,
    MessageFormMe =1,
};
@interface MXChatModel : NSObject

@property (nonatomic,strong)NSString *chatMsg;

@property (nonatomic,strong)NSString *headerPic;

@property (nonatomic,strong)NSString *username;

@property (nonatomic,strong)NSString *level;

@property (nonatomic,strong)NSString *userId;

@property (nonatomic,assign)MessageFormType formType;
@end
