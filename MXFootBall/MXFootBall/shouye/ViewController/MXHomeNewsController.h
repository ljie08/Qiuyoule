//
//  MXHomeNewsController.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/6/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "BaseViewController.h"

@protocol NewsRefreshDelegate <NSObject>

- (void)refreshNewsData;

- (void)loadMoreNewsData;

@end

@interface MXHomeNewsController : BaseViewController

@property (nonatomic, assign) NSInteger type;//tag
@property (nonatomic, strong) NSMutableArray *newsArr;//资讯数组
@property (nonatomic, assign) id <NewsRefreshDelegate> delegate;

@end
