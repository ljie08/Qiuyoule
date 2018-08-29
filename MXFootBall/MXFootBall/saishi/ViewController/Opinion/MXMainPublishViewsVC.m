//
//  MXMainPublishViewsVC.m
//  MXFootBall
//
//  Created by YY on 2018/5/25.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXMainPublishViewsVC.h"

@interface MXMainPublishViewsVC ()

@end

@implementation MXMainPublishViewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate=self;
    self.dataSource=self;
    self.titleSizeNormal=15;
    self.titleSizeSelected=15;
    self.titleColorSelected=[UIColor whiteColor];
    self.titleColorNormal=[UIColor lightGrayColor];
    self.menuViewLayoutMode=WMMenuViewLayoutModeCenter;
    self.showOnNavigationBar=YES;
//    self.selectIndex=1;
}
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    return self.tabs.count;
}
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    if (self.tabs.count==1) {
        switch (index) {
            case 0:
                return [[[self.infoDict objectForKey:@"tabs"] objectAtIndex:index] objectForKey:@"tabRemark"];
                break;
            default:
                break;
        };
    }else if (self.tabs.count==2){
        switch (index) {
            case 0:
                return [[[self.infoDict objectForKey:@"tabs"] objectAtIndex:index] objectForKey:@"tabRemark"];
                break;
            case 1:
                return [[[self.infoDict objectForKey:@"tabs"] objectAtIndex:index] objectForKey:@"tabRemark"];
            default:
                break;
        };
    }
    return @"";
}
- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width + 60;
}
-(UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    if (self.tabs.count==1) {
        if ([[[self.tabs firstObject] objectForKey:@"typeId"] integerValue]==1) {
            MXPublishOpinionViewController *publishVC=[MXPublishOpinionViewController new];
            publishVC.matchID=self.matchID;
            return publishVC;
        }else{
            MXTwoOpinionViewController *twoVC=[MXTwoOpinionViewController new];
            twoVC.matchID=self.matchID;
            return twoVC;
        }
    }else if (self.tabs.count==2){
        switch (index) {
            case 0:
            {
                MXPublishOpinionViewController *publishVC=[MXPublishOpinionViewController new];
                publishVC.matchID=self.matchID;
                return publishVC;
                break;
            }
            case 1:{
                    MXTwoOpinionViewController *twoVC=[MXTwoOpinionViewController new];
                    twoVC.matchID=self.matchID;
                    return twoVC;
                break;
            }
            default:
                break;
        }
    }
    
    return nil;
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = self.showOnNavigationBar ? 50 : 0;
    CGFloat originY = self.showOnNavigationBar ? 0 : self.view.frame.size.height;
    return CGRectMake(leftMargin, originY, self.view.frame.size.width - 2*leftMargin, 40);
}
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
//    CGFloat originY = CGRectGetMaxY([self pageController:pageController preferredFrameForMenuView:self.menuView]);
    return CGRectMake(0,0 , self.view.frame.size.width, self.view.frame.size.height);
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
