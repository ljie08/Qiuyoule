//
//  SliderNavBar.h
//  SliderNavBar
//
//  Created by l on 2017/5/17.
//  Copyright © 2017年 L. All rights reserved.
//
//  滑动按钮菜单

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, BottomLineMode) {
    ///短尺寸
    BottomLineModeShorten,
    ///和按钮文字等宽
    BottomLineModeEqualBtn,
    ///满尺寸
    BottomLineModeFull,
};

typedef void (^SliderNavBarTapBlock)(NSInteger index, UIPageViewControllerNavigationDirection direction);

@interface SliderNavBar : UIView

//按钮调用的Block
@property (nonatomic, copy) SliderNavBarTapBlock navBarTapBlock;

//当前选中的index
@property (nonatomic, assign) NSInteger currentIndex;

/**
 * 底部横线的样式
 * default BottomLineShorten短尺寸
 */
@property (nonatomic, assign) BottomLineMode mode;

/**
 * 按钮标题数组
 * default可以为空
 */
@property (nonatomic, strong) NSArray *buttonTitleArr;

/**
 * 按钮文字的字体大小
 * default is 14
 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 * 被选中按钮的文字颜色
 * default is black
 */
@property (nonatomic, strong) UIColor *selectedColor;

/**
 * 未被选中按钮的文字颜色
 * default is green
 */
@property (nonatomic, strong) UIColor *unSelectedColor;

/**
 * 底部横线按钮颜色
 * default is green
 */
@property (nonatomic, strong) UIColor *bottomLineColor;

/**
 * 可否点击
 * default is YES
 */
@property (nonatomic, assign) BOOL canScrollOrTap;

/**
 手动改变选择的按钮（供其他调用）

 @param index 次序
 */
- (void)moveToIndex:(NSInteger)index;

@end
