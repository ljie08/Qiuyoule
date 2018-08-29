//
//  MXEventScreeningViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXEventScreeningViewController.h"

#import "MXAllScreeningViewController.h"//全部
#import "MXCompetitionScreeningViewController.h"//竞彩
#import "MXSingleFieldScreeningViewController.h"//单场
#import "MXFootballLotteyScreeningViewController.h"//足彩


@interface MXEventScreeningViewController ()<MXAllScreeningViewControllerDelegate>

@property (nonatomic, strong) UIView *redView;


@property (nonatomic ,strong) UIButton * fiveLeagues ;//五大联赛
@property (nonatomic ,strong) UIButton * selectAll ;//全选
@property (nonatomic ,strong) UIButton * unselectAll ;//全不选

//@property (nonatomic ,strong) NSNotification * notification ;
//@property (nonatomic ,strong) NSNotification * notification1 ;


@end

@implementation MXEventScreeningViewController

- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectZero];
        _redView.backgroundColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
        //        _redView.backgroundColor = [UIColor blackColor];
    }
    return _redView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor ;
    self.automaticallyAdjustsScrollViewInsets = NO ;
    [self CreateSelectButton] ;
    
    
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        [self.view addSubview:self.redView];
    }
    self.menuViewStyle = WMMenuViewStyleLine ;
    self.automaticallyCalculatesItemWidths = YES ;
    self.titleSizeSelected = 16 ;
    
    
}

#pragma mark - MXAllScreeningViewControllerDelegate
- (void)selectNameMutDic:(NSMutableDictionary *)dictionary {
    
//    NSLog(@"%@",dictionary) ;
    if (_selectNameDic) {
        _selectNameDic(dictionary);
    }
}

- (void)CreateSelectButton {
    
    [self.view addSubview:self.fiveLeagues] ;
    [self.view addSubview:self.selectAll] ;
    [self.view addSubview:self.unselectAll] ;
}

- (UIButton *)fiveLeagues {
    if (!_fiveLeagues) {
        _fiveLeagues = [UIButton buttonWithType:(UIButtonTypeCustom)] ;
        _fiveLeagues.frame = CGRectMake(0, screen_height - scaleWithSize(114) - TABBAR_FRAME - STATUS_HEIGHT, screen_width / 3, scaleWithSize(54)) ;
        _fiveLeagues.backgroundColor = [UIColor whiteColor] ;
        [_fiveLeagues setTitle:@"五大联赛" forState:(UIControlStateNormal)] ;
        [_fiveLeagues setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [_fiveLeagues addTarget:self action:@selector(selectorFiveLeaguesButton:) forControlEvents:(UIControlEventTouchDown)] ;
    }
    return _fiveLeagues ;
}
- (UIButton *)selectAll {
    if (!_selectAll) {
        _selectAll = [UIButton buttonWithType:(UIButtonTypeCustom)] ;
        _selectAll.frame = CGRectMake(CGRectGetMaxX(self.fiveLeagues.frame), screen_height - scaleWithSize(114) - TABBAR_FRAME - STATUS_HEIGHT, screen_width / 3, scaleWithSize(54)) ;
        _selectAll.backgroundColor = [UIColor whiteColor] ;
        [_selectAll setTitle:@"全选" forState:(UIControlStateNormal)] ;
        [_selectAll setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)] ;
        [_selectAll addTarget:self action:@selector(selectorSelectAllButton:) forControlEvents:(UIControlEventTouchDown)];
    }
    return _selectAll ;
}
- (UIButton *)unselectAll {
    if (!_unselectAll) {
        _unselectAll = [UIButton buttonWithType:(UIButtonTypeCustom)] ;
        _unselectAll.frame = CGRectMake(CGRectGetMaxX(self.selectAll.frame), screen_height - scaleWithSize(114) - TABBAR_FRAME - STATUS_HEIGHT, screen_width / 3, scaleWithSize(54)) ;
        _unselectAll.backgroundColor = [UIColor whiteColor] ;
        [_unselectAll setTitle:@"全不选" forState:(UIControlStateNormal)] ;
        [_unselectAll setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)] ;
        [_unselectAll addTarget:self action:@selector(selectorUnSelectAllButton:) forControlEvents:(UIControlEventTouchDown)] ;
    }
    return _unselectAll ;
}

- (void)selectorFiveLeaguesButton:(UIButton *)button {
    
//    NSLog(@"%d",self.selectIndex) ;
    
    NSDictionary * dic = @{@"selectIndex":[NSString stringWithFormat:@"%d",self.selectIndex]};
    //创建通知
    NSNotification * notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
- (void)selectorSelectAllButton:(UIButton *)button {
    
    NSDictionary * dic = @{@"selectIndex":[NSString stringWithFormat:@"%d",self.selectIndex]};
    //创建通知
    NSNotification * notification1 =[NSNotification notificationWithName:@"tongzhi1" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification1];
    
}
- (void)selectorUnSelectAllButton:(UIButton *)button {
    
    NSDictionary * dic = @{@"selectIndex":[NSString stringWithFormat:@"%d",self.selectIndex]};
    //创建通知
    NSNotification * notification2 =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dic];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.redView.frame = CGRectMake(0, CGRectGetMaxY(self.menuView.frame), self.view.frame.size.width, 2.0);
    
    
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        return 2 ;
    }
    return 4 ;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        switch (index % 2) {
            case 0: return @"全部";
            
            case 1: return @"单场";
            
        }
        return @"NONE" ;
    }
    switch (index % 4) {
        case 0: return @"全部";
        case 1: return @"竞彩";
        case 2: return @"单场";
        case 3: return @"足彩";
    }
    return @"NONE" ;
}
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        switch (index % 4) {
            case 0: {MXAllScreeningViewController * viewC = [[MXAllScreeningViewController alloc] init] ;
                viewC.delegate = self ;
                viewC.optType = self.optType ;
                return  viewC;}
            
            case 1: {MXSingleFieldScreeningViewController * viewC = [[MXSingleFieldScreeningViewController alloc]init] ;
                viewC.optType = self.optType ;
                return viewC;}
                
        }
        return [[UIViewController alloc] init];
        
    }
    
    switch (index % 4) {
        case 0: {MXAllScreeningViewController * viewC = [[MXAllScreeningViewController alloc] init] ;
            viewC.delegate = self ;
//            NSLog(@"%@",self.optType) ;
            viewC.optType = self.optType ;
            return  viewC;}
        case 1: {MXCompetitionScreeningViewController * viewC = [[MXCompetitionScreeningViewController alloc]init] ;
            viewC.optType = self.optType ;
            return viewC;}
        case 2: {MXSingleFieldScreeningViewController * viewC = [[MXSingleFieldScreeningViewController alloc]init] ;
            viewC.optType = self.optType ;
            return viewC;}
//            return [[MXSingleFieldScreeningViewController alloc] init];
        case 3: {MXFootballLotteyScreeningViewController * viewC = [[MXFootballLotteyScreeningViewController alloc]init] ;
            viewC.optType = self.optType ;
            return viewC;}
//            return [[MXFootballLotteyScreeningViewController alloc] init];
    }
    return [[UIViewController alloc] init];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 20 ;
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        menuView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        return CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    }
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : CGRectGetMaxY(self.navigationController.navigationBar.frame);
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 44);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    
    if (self.menuViewPosition == WMMenuViewPositionBottom) {
        return CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 44);
    }
    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    if (self.menuViewStyle == WMMenuViewStyleTriangle) {
        originY += self.redView.frame.size.height;
    }
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
