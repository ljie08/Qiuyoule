//
//  MXSSArticleCollectionViewController.h
//  MXFootBall
//
//  Created by Mac on 2018/3/8.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXssCollectionModel.h"

@class MXSSArticleCollectionViewController;
@protocol MXSSArticleCollectionViewControllerDelegate <NSObject>
-(void)buyArticleCollectionViewController:(MXSSArticleCollectionViewController*)VC withResult:(NSDictionary*)result andArticleModel:(MXssCollectionModel*)model;//文章收藏
-(void)ArticleCollectionNewDeleUpdateViewController:(MXSSArticleCollectionViewController*)VC;//删除后文章收藏刷新页面
@end


@interface MXSSArticleCollectionViewController : UIViewController
@property (nonatomic,strong) UITableView *mainTableview;
@property (nonatomic,strong) NSMutableArray *collectDataArr;
@property (nonatomic,assign) id<MXSSArticleCollectionViewControllerDelegate>delegate;
@property (nonatomic,assign) BOOL yesCell;//多选删除的判断
@property (nonatomic,strong) NSMutableArray *dataArray;//多选数组
@end
