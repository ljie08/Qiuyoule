//
//  MXSYJHallModel.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/24.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Illustrates :NSObject
@property (nonatomic , copy) NSString              * targetUrl;
@property (nonatomic , copy) NSString              * imgUrl;
@property (nonatomic , copy) NSString              * desc;

@end

@interface HitTable :NSObject
@property (nonatomic , assign) CGFloat              hitRate;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , copy) NSString              * userId;
@property (nonatomic , copy) NSString              * headerPic;
@property (nonatomic, assign) NSInteger              num;
@end

@interface MXSYJHallModel : NSObject

@property (nonatomic , copy) NSArray<Illustrates *>  * illustrates;
@property (nonatomic , copy) NSArray<HitTable *>     * hitTable;

@end
