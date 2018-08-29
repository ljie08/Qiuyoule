//
//  MXSYJFocusOnModel.h
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXSYJFocusOnModel : NSObject

@property (nonatomic , copy)   NSArray            * forumImgs;
@property (nonatomic , assign) NSInteger              comments;
@property (nonatomic , assign) NSInteger              hit;
@property (nonatomic , copy) NSString              * headerPic;
@property (nonatomic , assign) NSInteger              collects;
@property (nonatomic , copy) NSString              * newsId;
@property (nonatomic , copy) NSString              * channelName;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , assign) NSInteger              level;
@property (nonatomic , assign) NSInteger               userId;
@property (nonatomic , assign) NSInteger              view;
@property (nonatomic , copy) NSString              * createTime;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , assign)NSInteger              isTop;
@property (nonatomic , copy) NSString              * subContent;
@property (nonatomic , copy) NSString              * comeFrom;
@property (nonatomic , copy) NSString              * content;
@property (nonatomic, assign) NSInteger            isComment;
@property (nonatomic, assign) NSInteger            isCollect;
@property (nonatomic, assign) NSInteger            isAttention;
@property (nonatomic , copy) NSString              * articleNum;
@property (nonatomic , copy) NSString              * fansNum;

@property (nonatomic, copy) NSArray                *imgsHeight;
@property (nonatomic, assign) CGFloat              textHeight;
@property (nonatomic, assign) NSInteger articleType;

@property (nonatomic, copy) NSString *advertPic;
@property (nonatomic, copy) NSString *targetUrl;
@property (nonatomic, copy) NSString * advertId ;//广告id

@property (nonatomic, strong) NSMutableArray *imgHeights;

@property (nonatomic, copy) NSString *imgUrl;//资讯封面图

@end
