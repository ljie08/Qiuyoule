//
//  MXGoalViewController.m
//  MXFootBall
//
//  Created by YY on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXGoalModel.h"
#import "MXSeasonView.h"
#import "MXGoalViewController.h"

@interface MXGoalViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *bgScrollView;

@property (nonatomic,strong)MXSeasonView *seasonView;

@end

@implementation MXGoalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [SVProgressHUD showWithStatus:@"正在加载"];
    [self.view addSubview:self.bgScrollView];
   NSMutableDictionary *para=[NSMutableDictionary dictionaryWithDictionary:@{@"matchId":self.matchID,@"time":[MXLJUtil getNowDateTimeString]}];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:MXGoalPATH] WithParams:[MXLJUtil sortedDictionary:para] WithSuccessBlock:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
//         YYLog(@"+++%@+++",dic);
        if ([[dic objectForKey:@"code"] integerValue]==1013) {
            [SVProgressHUD showInfoWithStatus:[dic objectForKey:@"msg"]];
        }else if ([[dic objectForKey:@"code"] integerValue]==0){
            MXSeasonView *theSeasonView=[[MXSeasonView alloc] initWithFrame:CGRectMake(0, 10, screen_width, scaleWithSize(355))];
            [self.bgScrollView addSubview:theSeasonView];
            MXGoalModel *model=[[MXGoalModel alloc] init];
            NSMutableArray *mainScoreArr=[NSMutableArray array];
            NSMutableArray *guestScoreArr=[NSMutableArray array];
            NSMutableArray *mainScoreRate=[NSMutableArray array];
            NSMutableArray *guestScoreRate=[NSMutableArray array];
            for (NSInteger i=1; i<[[[dic objectForKey:@"data"] objectForKey:@"homelist"] count]; i++) {
                NSDictionary *mainScoreDict=[[dic objectForKey:@"data"] objectForKey:@"homelist"][i];
                NSArray *mainArr=[mainScoreDict objectForKey:[NSString stringWithFormat:@"%li",15*i]];
                [mainScoreArr addObject:[mainArr firstObject]];
                [mainScoreRate addObject:[mainArr objectAtIndex:1]];
                NSDictionary *guestScoreDict=[[dic objectForKey:@"data"] objectForKey:@"awaylist"][i];
                NSArray *guestArr=[guestScoreDict objectForKey:[NSString stringWithFormat:@"%li",15*i]];
                [guestScoreArr addObject:[guestArr firstObject]];
                [guestScoreRate addObject:[guestArr objectAtIndex:1]];
            }
            model.mainTeamScoreArr=mainScoreArr;
            model.guestTeamScoreArr=guestScoreArr;
            model.mainTeamScoreRate=mainScoreRate;
            model.guestTeamScoreRate=guestScoreRate;
            model.mainTeamTotalMatches=[[[[dic objectForKey:@"data"]objectForKey:@"homelist"] firstObject] objectForKey:@"matches"];
            model.guestTeamTotalMatches=[[[[dic objectForKey:@"data"]objectForKey:@"awaylist"] firstObject] objectForKey:@"matches"];
            theSeasonView.model=model;
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
       
    } WithFailureBlock:^(NSError *error) {
        
    }];
    
}
-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height-STATUS_AND_NAVIGATION_HEIGHT-scaleWithSize(260)-TABBAR_FRAME-40 - self.adHeight)];
        _bgScrollView.userInteractionEnabled=YES;
        _bgScrollView.delegate=self;
        _bgScrollView.directionalLockEnabled=YES;
        _bgScrollView.showsHorizontalScrollIndicator=NO;
        _bgScrollView.contentSize=CGSizeMake(screen_width, scaleWithSize(370));
    }
    return _bgScrollView;
}
-(void)viewWillAppear:(BOOL)animated{
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"进球分布界面\"}"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"进球分布界面\"}"];
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

