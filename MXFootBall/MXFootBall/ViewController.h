//
//  ViewController.h
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 设置暂无数据按钮
 */
typedef void(^UpdataBlock)(void);
@interface ViewController : UIViewController

- (void)setThemeImgWithPicture:(NSString *)name;

/**
 *  是否显示返回按钮
 *
 *  isShown
 */
- (void)setBackButton:(BOOL)isShown;

/**
 自定义标题字体、颜色、大小等
 
 @param title 标题
 */
- (void)initTitleViewWithTitle:(NSString *)title;

/**
 设置导航栏
 */
- (void)addNavigationWithTitle:(NSString *)title leftItem:(UIBarButtonItem  *)left rightItem:(UIBarButtonItem *)right titleView:(UIView *)view;


/**
 *  返回，默认情况下为navigationController的弹出
 */
- (void)goBack;

//返回到根视图控制器
- (void)goRootBack;


/*
 设置暂无数据按钮
 */
//-(UIButton*)addUpDataBtn ;

-(UIButton*)addUpDataBtnWithTitle:(NSString *)titleString superView:(UIView *) superView ;

@property(strong,nonatomic)UpdataBlock updataBlock;
@property(strong,nonatomic)UpdataBlock removeUpdataBlock;
@property (nonatomic , strong) UIButton * refreshButton ;


@end

