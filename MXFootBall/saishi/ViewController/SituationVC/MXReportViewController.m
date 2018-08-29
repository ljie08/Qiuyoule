//
//  MXReportViewController.m
//  MXFootBall
//
//  Created by YY on 2018/5/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXReportViewController.h"

@interface MXReportViewController ()
{
    UIButton *_lastBtn;
    NSInteger selectedIndex;
}
@property (nonatomic,strong)NSMutableArray *descriptionArr;

@end

@implementation MXReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title=@"举报";
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor=[UIColor whiteColor];
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    NSMutableDictionary *paras=[NSMutableDictionary dictionaryWithDictionary:@{@"userId":config.userId,@"token":config.token,@"time":[MXLJUtil getNowDateTimeString]}];
    [SVProgressHUD showWithStatus:@"正在加载"];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:@"api/user/complaintType"] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {

        if ([[dic objectForKey:@"code"] integerValue]==0) {
            [SVProgressHUD dismiss];
            for (NSDictionary *dict in [dic objectForKey:@"data"]) {
                [self.descriptionArr addObject:[dict objectForKey:@"description"]];
            }
            [self setUpUI];
        }
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}
-(NSMutableArray *)descriptionArr{
    if (!_descriptionArr) {
        _descriptionArr=[NSMutableArray array];
    }
    return _descriptionArr;
}
-(void)setUpUI{
    
    UILabel *reporterLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, scaleWithSize(20), 200, scaleWithSize(20))];
    reporterLabel.text=[NSString stringWithFormat:@"举报%@:",self.reportUerName];
    [self.view addSubview:reporterLabel];
    NSInteger count=self.descriptionArr.count%2==0?self.descriptionArr.count/2:self.descriptionArr.count/2+1;
    CGFloat betweenW=scaleWithSize(30);
    CGFloat margin=20;
    CGFloat btnW=scaleWithSize(140);
    CGFloat btnH=30;
    CGFloat marginH=scaleWithSize(40);
    for (NSInteger i=0; i<count; i++) {
        for (NSInteger j=0; j<2; j++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(margin+(margin+btnW+betweenW)*j, scaleWithSize(80)+(btnH+marginH)*i, btnW, btnH);
            [btn setTitle:self.descriptionArr[i*2+j] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"my_jubao"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"my_jubao_xuanzhong"] forState:UIControlStateSelected];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(5, 15, 5, 0)];
            btn.titleLabel.font=fontSize(scaleWithSize(16));
            btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            if (i==0&&j==0) {
                [btn setSelected:YES];
                _lastBtn=btn;
                selectedIndex=1;
            }
            [btn addActionHandler:^(UIButton *btn) {
                if (_lastBtn!=btn) {
                    btn.selected=!btn.selected;
                    if (btn.selected) {
                        selectedIndex=i*2+j+1;
                    }
                    [btn setImage:[UIImage imageNamed:@"my_jubao_xuanzhong"] forState:UIControlStateSelected];
                    _lastBtn.selected=!_lastBtn.selected;
                    [_lastBtn setImage:[UIImage imageNamed:@"my_jubao"] forState:UIControlStateNormal];
                    _lastBtn=btn;
                }
            }];
            [self.view addSubview:btn];
        }
    }
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(25, (btnH+marginH)*count+scaleWithSize(140), screen_width-50, 40);
    [btn setTitle:@"举报" forState:UIControlStateNormal];
    btn.backgroundColor=mx_Wode_colorBlue2374e4;
    [self.view addSubview:btn];
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    [btn addActionHandler:^(UIButton *btn) {
        NSMutableDictionary *paras=[NSMutableDictionary dictionaryWithDictionary:@{@"ownerId":self.ownerId,@"userId":config.userId,@"token":config.token,@"type":[NSString stringWithFormat:@"%li",selectedIndex],@"time":[MXLJUtil getNowDateTimeString]}];
        [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:@"api/user/complaint"] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {
            if ([[dic objectForKey:@"code"] integerValue]==0) {
                [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
            }
        } WithFailureBlock:^(NSError *error) {
            
        }];
    }];
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
