//
//  MXOfficialViewController.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

//弃用
#import "MXOfficialViewController.h"
#import "MXOfficialCell.h"

@interface MXOfficialViewController ()//<UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate>

@property (weak, nonatomic) IBOutlet JJRefreshTabView *officialTab;

@end

@implementation MXOfficialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
