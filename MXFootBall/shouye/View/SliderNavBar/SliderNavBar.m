//
//  SliderNavBar.m
//  SliderNavBar
//
//  Created by l on 2017/5/17.
//  Copyright © 2017年 L. All rights reserved.
//

#import "SliderNavBar.h"

#define SHORTENLINEWIDTH 20.f //短横线宽度的尺寸
#define BTNDISTANCE 10.f //按钮之间的距离
#define WIDGETTAG 20170518 //控件tag（使用日期确保不会引起重复）

@interface SliderNavBar () {
    CGFloat _lineWidth;//底部按钮宽度
    CGFloat _btnDistance;//按钮之间的距离
}

@property (nonatomic, strong) UIScrollView *buttonScorllView;//放置按钮的ScrollView
@property (nonatomic, strong) UIButton *lastBtn;//上次选中的按钮
@property (nonatomic, strong) UIView *bottomLine;//按钮下方的标记横线


@end

@implementation SliderNavBar

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setupViews];
    [self setupScrollView];
}

- (void)dealloc {
    
}

#pragma mark - UI

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];//背景颜色设为透明，这样用户将ScrollView滑出边界的时候出现的是自己项目中的视图
    
    BottomLineMode mode = BottomLineModeShorten;//默认底部横线为短尺寸
    _mode = mode;
    
    CGFloat fontSize = 14;//默认字体大小14
    _fontSize = fontSize;
    
    UIColor *selectedColor = [UIColor blackColor];//默认选中的按钮字体颜色为黑色
    _selectedColor = selectedColor;
    
    UIColor *unSelectedColor = [UIColor greenColor];//默认未选中的按钮字体颜色为绿色
    _unSelectedColor = unSelectedColor;
    
    UIColor *bottomLineColor = [UIColor blackColor];//默认底部按钮横线颜色为黑色
    _bottomLineColor = bottomLineColor;
    
    BOOL canScrollOrTap = YES;//默认可滑动可点击
    _canScrollOrTap = canScrollOrTap;
    
    self.lastBtn = [[UIButton alloc] init];
}

//初始化UIScrollVIew
- (void)setupScrollView {
    self.buttonScorllView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.buttonScorllView.backgroundColor = [UIColor clearColor];
    self.buttonScorllView.showsHorizontalScrollIndicator = NO;
    self.buttonScorllView.showsVerticalScrollIndicator = NO;
    self.buttonScorllView.scrollsToTop = NO;
    self.buttonScorllView.scrollEnabled = _canScrollOrTap;
    [self addSubview:self.buttonScorllView];
}

//添加可滑动的按钮(动态长度)
- (void)addSlideBtnDynamic:(NSArray *)buttonArray {
    //设置UIScrollVIew是否可以滑动（根据按钮标题数量以及长度）
    CGFloat totalX  = 0.0;//已经添加过的按钮的长度
    CGFloat totalW  = 0.0;//已经添加过的按钮的总宽度
    for (int i = 0; i < buttonArray.count; i++) {
        CGFloat btnWidth = [self boundingRectWithText:(NSString *)buttonArray[i] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:_fontSize]].width;
        totalX += btnWidth + BTNDISTANCE;
        totalW += btnWidth;
    }
    if (totalX < self.frame.size.width) {//如果按钮排列后没有View的宽度长
        self.buttonScorllView.scrollEnabled = NO;//那么按钮不可滑动
        self.buttonScorllView.contentSize   = self.frame.size;
        self.buttonScorllView.pagingEnabled = YES;
        _btnDistance = (self.frame.size.width - totalW)/buttonArray.count;//改变按钮之间的间距来适应屏幕
    } else {
        self.buttonScorllView.contentSize = CGSizeMake(totalX, self.frame.size.height);
        _btnDistance = BTNDISTANCE;
    }
    if (@available(iOS 11.0, *)) {
        self.buttonScorllView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    //    self.buttonScorllView.alwaysBounceVertical = NO;
    //    self.buttonScorllView.alwaysBounceHorizontal = NO;
    
    //添加按钮
    totalX = 0.0;//重置添加过的按钮的长度
    totalW = 0.0;//重置添加过的按钮的总宽度
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:buttonArray[i] forState:UIControlStateNormal];
        [button setTitle:buttonArray[i] forState:UIControlStateHighlighted];
        [button setTitle:buttonArray[i] forState:UIControlStateSelected];
        [button setTitleColor:_unSelectedColor forState:UIControlStateNormal];
        [button setTitleColor:_selectedColor forState:UIControlStateHighlighted];
        [button setTitleColor:_selectedColor forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor clearColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        CGFloat btnWidth = [self boundingRectWithText:(NSString *)buttonArray[i] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:button.titleLabel.font].width;
        CGFloat btnX = totalX + _btnDistance / 2.0;
        totalX += btnWidth + _btnDistance;
        button.frame = CGRectMake(btnX, .0, btnWidth, self.frame.size.height);
        [button addTarget:self action:@selector(btnTapAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = WIDGETTAG + i;
        [self.buttonScorllView addSubview:button];
        
        //设置选中的按钮
        if (i == 0) {
            self.currentIndex = i;
            button.selected = YES;
            //            button.highlighted = YES;//如果不设置高亮状态，第一次默认虽然为选中状态，但字体颜色还是未选中时的颜色
            
            self.lastBtn = button;
            if (_mode == BottomLineModeShorten) {
                _lineWidth = SHORTENLINEWIDTH;
            } else if (_mode == BottomLineModeEqualBtn) {
                _lineWidth = [self boundingRectWithText:self.lastBtn.titleLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:self.lastBtn.titleLabel.font].width;
            } else {
                _lineWidth = self.lastBtn.frame.size.width + BTNDISTANCE;
            }
        }
    }
    [self setupBottomLine];//初始化设置底部的移动横线
}

//初始化底部横线
- (void)setupBottomLine {
    self.bottomLine = [UIView new];
    self.bottomLine.backgroundColor = _selectedColor;
    CGRect frame = self.bottomLine.frame;
    frame.size.width = _lineWidth;
    frame.size.height = 2;
    self.bottomLine.frame = frame;
    CGPoint center = self.bottomLine.center;
    center.x = self.lastBtn.center.x;
    center.y = self.lastBtn.center.y + self.lastBtn.frame.size.height/2.0 - 1;
    self.bottomLine.center = center;
    [self.buttonScorllView addSubview:self.bottomLine];
}

#pragma mark - Update View

//更新按钮的文字字体大小
- (void)updateBtnFontSize {
    for (UIButton *btn in self.buttonScorllView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
        }
    }
}

//更新按钮未选中时的文字颜色
- (void)updateBtnUnSelectedColor {
    for (UIButton *btn in self.buttonScorllView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitleColor:_unSelectedColor forState:UIControlStateNormal];
        }
    }
}

//更新按钮选中时文字颜色
- (void)updateBtnSelectedColor {
    for (UIButton *btn in self.buttonScorllView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn setTitleColor:_selectedColor forState:UIControlStateHighlighted];
            [btn setTitleColor:_selectedColor forState:UIControlStateSelected];
        }
    }
}

//更新底部横线的宽度
- (void)updateBottomLine {
    if (_mode == BottomLineModeShorten) {
        _lineWidth = SHORTENLINEWIDTH;
    } else if (_mode == BottomLineModeEqualBtn) {
        _lineWidth = [self boundingRectWithText:self.lastBtn.titleLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:self.lastBtn.titleLabel.font].width;
    } else {
        _lineWidth = self.lastBtn.frame.size.width + BTNDISTANCE;
    }
    CGRect frame = self.bottomLine.frame;
    frame.size.width = _lineWidth;
    self.bottomLine.frame = frame;
    CGPoint center = self.bottomLine.center;
    center.x = self.lastBtn.center.x;
    self.bottomLine.center = center;
}

//更新底部横线颜色
- (void)updateBottomLineColor {
    self.bottomLine.backgroundColor = _bottomLineColor;
}

//更新是否可以滑动或点击
- (void)updateCanScrollOrTap {
    self.buttonScorllView.scrollEnabled = _canScrollOrTap;
    for (UIButton *btn in self.buttonScorllView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.enabled = _canScrollOrTap;
        }
    }
}

#pragma mark - Properties

- (void)setMode:(BottomLineMode)mode {
    if (mode != _mode) {
        _mode = mode;
        [self updateBottomLine];
    }
}

- (void)setFontSize:(CGFloat)fontSize {
    if (fontSize != _fontSize) {
        _fontSize = fontSize;
        [self updateBtnFontSize];
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    if (selectedColor != _selectedColor) {
        _selectedColor = selectedColor;
        [self updateBtnSelectedColor];
    }
}

- (void)setUnSelectedColor:(UIColor *)unSelectedColor {
    if (unSelectedColor != _unSelectedColor) {
        _unSelectedColor = unSelectedColor;
        [self updateBtnUnSelectedColor];
    }
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor {
    if (bottomLineColor != _bottomLineColor) {
        _bottomLineColor = bottomLineColor;
        [self updateBottomLineColor];
    }
}

- (void)setButtonTitleArr:(NSArray *)buttonTitleArr {
    if (buttonTitleArr != _buttonTitleArr) {
        _buttonTitleArr = buttonTitleArr;
        [self addSlideBtnDynamic:_buttonTitleArr];
    }
}

- (void)setCanScrollOrTap:(BOOL)canScrollOrTap {
    if (canScrollOrTap != _canScrollOrTap) {
        _canScrollOrTap = canScrollOrTap;
        [self updateCanScrollOrTap];
    }
}

#pragma mark - event

//按钮点击事件
- (void)btnTapAction:(UIButton *)button {
    //    self.lastBtn.highlighted = NO;//第一次运行，第一个按钮设置默认为高亮状态，如果这里不设置上一个按钮高亮状态为NO，第一次点击按钮的时候，第一个还是高亮状态，第二次点击后才是正常状态
    //    if (self.lastBtn == button) {//如果点击已选中的按钮，那么直接return
    //        return;
    //    }
    [self changeSelectedBtn:button];
    [self moveBottomLineWithAnimation:YES];
    [self changeScrollOffSet];
}

//手动改变选中的按钮
- (void)moveToIndex:(NSInteger)index {
    for (UIButton *button in self.buttonScorllView.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (index + WIDGETTAG == button.tag) {//选中的按钮
                [self changeSelectedBtn:button];
                [self moveBottomLineWithAnimation:YES];
                [self changeScrollOffSet];
            }
        }
    }
}

//手动改变选择的按钮（供其他调用）
- (void)changeSelectedBtn:(UIButton *)button {
    button.selected = YES;//点击的按钮被选中
    if (button.tag != self.lastBtn.tag) {
        self.lastBtn.selected = NO;//之前选中的按钮恢复未被选中状态
    }
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;//设置默认的滑动方向为从右往左
    if (button.tag - self.lastBtn.tag < 0) {
        direction = UIPageViewControllerNavigationDirectionReverse;//从左往右
    }
    self.lastBtn = button;
    if (self.navBarTapBlock){
        _navBarTapBlock(self.lastBtn.tag - WIDGETTAG, direction);
    }
    self.currentIndex = button.tag - WIDGETTAG;//改变选中的index
}

/**
 移动底部横线的位置
 
 @param animation 是否需要动画
 */
- (void)moveBottomLineWithAnimation:(BOOL)animation {
    if (animation) {
        [UIView animateWithDuration:0.35f animations:^{
            if (_mode == BottomLineModeShorten) {
                _lineWidth = SHORTENLINEWIDTH;
            } else if (_mode == BottomLineModeEqualBtn) {
                _lineWidth = [self boundingRectWithText:self.lastBtn.titleLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:self.lastBtn.titleLabel.font].width;
            } else {
                _lineWidth = self.lastBtn.frame.size.width + BTNDISTANCE;
            }
            CGRect frame = self.bottomLine.frame;
            frame.size.width = _lineWidth;
            self.bottomLine.frame = frame;
            CGPoint center = self.bottomLine.center;
            center.x = self.lastBtn.center.x;
            self.bottomLine.center = center;
        }];
    } else {
        if (_mode == BottomLineModeShorten) {
            _lineWidth = SHORTENLINEWIDTH;
        } else if (_mode == BottomLineModeEqualBtn) {
            _lineWidth = [self boundingRectWithText:self.lastBtn.titleLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:self.lastBtn.titleLabel.font].width;
        } else {
            _lineWidth = self.lastBtn.frame.size.width + BTNDISTANCE;
        }
        CGRect frame = self.bottomLine.frame;
        frame.size.width = _lineWidth;
        self.bottomLine.frame = frame;
        CGPoint center = self.bottomLine.center;
        center.x = self.lastBtn.center.x;
        self.bottomLine.center = center;
    }
}

//改变ScrollView偏移量(滑动View的核心)
- (void)changeScrollOffSet {
    CGFloat leftSpace = self.lastBtn.center.x - self.frame.size.width/2.0;
    if (leftSpace < 0) {
        leftSpace = 0;
    } else if (leftSpace > self.buttonScorllView.contentSize.width - self.frame.size.width) {
        leftSpace = self.buttonScorllView.contentSize.width - self.frame.size.width;
    }
    [self.buttonScorllView setContentOffset:CGPointMake(leftSpace, 0) animated:YES];
}

#pragma mark - private method

- (CGSize)boundingRectWithText:(NSString *)text maxSize:(CGSize)size font:(UIFont *)font {
    NSDictionary *attribute = @{NSFontAttributeName : font};
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

@end


