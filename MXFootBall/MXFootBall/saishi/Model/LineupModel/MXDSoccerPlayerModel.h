//
//  MXDSoccerPlayerModel.h
//  MXFootBall
//
//  Created by dai on 2018/4/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXDSoccerPlayerModel : NSObject


@property (nonatomic , copy) NSString * ID ;//球员id
@property (nonatomic , copy) NSString * name ;//球员名称
@property (nonatomic , copy) NSString * logo ;//球员logo
@property (nonatomic , copy) NSString * shirtNumber ;//球衣号
@property (nonatomic , copy) NSString * position ;//球员位置
@property (nonatomic , assign) NSInteger x ;//阵容x坐标 100（替补0）
@property (nonatomic , assign) NSInteger y ;//阵容y坐标 100（替补0）
@property (nonatomic , assign) CGFloat rating ;


@end
