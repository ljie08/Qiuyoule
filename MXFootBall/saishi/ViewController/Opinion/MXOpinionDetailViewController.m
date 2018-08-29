//
//  MXOpinionDetailViewController.m
//  MXFootBall
//
//  Created by YY on 2018/3/28.
//  Copyright © 2018年 zt. All rights reserved.
//
#import "MXSYJPersonController.h"
#import "UITapGestureRecognizer+Category.h"
#import "MXOpinionDetailViewController.h"

@interface MXOpinionDetailViewController ()
{
    NSString *betScore;
    NSString *consumeScore;
}
@property (strong, nonatomic)UIImageView *headImgView;
@property (strong, nonatomic)UILabel *userName;
@property (strong, nonatomic)UILabel *dateLabel;
@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UILabel *sourceLabel;
@property (strong, nonatomic)UIButton *supportBtn;
@property (strong, nonatomic)UILabel *readNumbers;
@property (strong, nonatomic)UIImageView *leftTeamView;
@property (strong, nonatomic)UIImageView *rightTeamView;
@property (strong, nonatomic)UILabel *gameTimeLabel;
@property (strong, nonatomic)UILabel *gameStatusLabel;
@property (strong, nonatomic)UIImageView *gameBackgroudImgView;
@property (strong, nonatomic)UILabel *viewsLabel;
@property (strong, nonatomic)UILabel *lockedCanSeeLabel;
@property (strong, nonatomic)UILabel *usedIntegralLockedLabel;
@property (strong, nonatomic)UIButton *lockedImageView;
@property (strong, nonatomic)UILabel *leftTeamLabel;
@property (strong, nonatomic)UILabel *rightTeamLabel;
@property (nonatomic,strong)UIImageView *leftTeamIcon;
@property (nonatomic,strong)UIImageView *rightTeamIcon;
@property (nonatomic,strong)UIImageView *midImageView;
@property (nonatomic,strong)UIView *bottomView;

@property (nonatomic,assign)NSInteger matchStatus;
@property (nonatomic,strong)UILabel *formLabel;
@end

@implementation MXOpinionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.navigationItem.title=@"观点";
    [self setUpUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self setBackButton:YES];
    
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    NSMutableDictionary *para=[NSMutableDictionary dictionary];
    [para setObject:self.eventID forKey:@"eventViewId"];
    [para setObject:config.userId forKey:@"userId"];
    [para setObject:config.token forKey:@"token"];
    [para setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [SVProgressHUD showWithStatus:@"正在加载中"];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:MXOpinionDetailPATH] WithParams:[MXLJUtil sortedDictionary:para] WithSuccessBlock:^(NSDictionary *dic) {
        [SVProgressHUD dismiss];
        if ([[dic objectForKey:@"code"] integerValue]==0) {
            NSDictionary *dict=[dic objectForKey:@"data"];
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[[dict objectForKey:@"evnetView"]objectForKey:@"headerPic"]] placeholderImage:[UIImage imageNamed:@"luntan_dashangjifen_touxiang"]];
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
            [self.headImgView addGestureRecognizer:tap];
            self.headImgView.userInteractionEnabled=YES;
            [tap addActionBlock:^(UITapGestureRecognizer *tap) {
                MXSYJPersonController *personVC=[[MXSYJPersonController alloc] init];
                personVC.ownerId=[[dict objectForKey:@"evnetView"]objectForKey:@"userId"];
                [self.navigationController pushViewController:personVC animated:YES];
            }];
            self.userName.text=[[dict objectForKey:@"evnetView"] objectForKey:@"username"];
            self.dateLabel.text=[MXLJUtil SpecialTimeFormatWithTimeInterval:[[dict objectForKey:@"evnetView"] objectForKey:@"createTime"]];
            self.titleLabel.text=[[dict objectForKey:@"evnetView"] objectForKey:@"title"];
            self.leftTeamLabel.text=[[dict objectForKey:@"matchInfo"] objectForKey:@"homeNm"];
            self.rightTeamLabel.text=[[dict objectForKey:@"matchInfo"] objectForKey:@"awayNm"];
            [self.leftTeamIcon sd_setImageWithURL:[NSURL URLWithString:[[dict objectForKey:@"matchInfo"] objectForKey:@"homeLogo"]] placeholderImage:nil];
            [self.rightTeamIcon sd_setImageWithURL:[NSURL URLWithString:[[dict objectForKey:@"matchInfo"] objectForKey:@"awayLogo"]] placeholderImage:nil];
            self.readNumbers.text=[NSString stringWithFormat:@"阅读 %@",[[dict objectForKey:@"evnetView"] objectForKey:@"view"]];
            NSInteger status=[[[dict objectForKey:@"matchInfo"] objectForKey:@"matchStatus"]integerValue];
            if (status==8) {
                self.gameStatusLabel.text=@"完场";
            }else if(status==1){
                self.gameStatusLabel.text=@"未开赛";
            }else if(status==0){
                self.gameStatusLabel.text=@"比赛异常";
            }else if(status==2||status==3||status==4||status==5||status==6||status==7){
                self.gameStatusLabel.text=@"比赛中";
            }
            self.gameTimeLabel.text=[MXLJUtil timeInterverlToDateStr:[[dict objectForKey:@"matchInfo"] objectForKey:@"matchStartTime"]];
            self.sourceLabel.text=@"菠菜庄园";
            NSInteger isSupport=[[[dict objectForKey:@"evnetView"] objectForKey:@"isSupport"] integerValue];
            if (isSupport==0) {
                [self.supportBtn setImage:[UIImage imageNamed:@"saishi_zhichi"] forState:UIControlStateNormal];
            }else{
                [self.supportBtn setImage:[UIImage imageNamed:@"saishi_yizhichi"] forState:UIControlStateNormal];
                self.supportBtn.enabled=NO;
            }
            NSInteger isUnlocked=[[[dict objectForKey:@"evnetView"] objectForKey:@"isUnlock"] integerValue];
            if (isUnlocked==0) {
                self.viewsLabel.hidden=YES;
                self.lockedCanSeeLabel.hidden=NO;
                self.bottomView.hidden=NO;
            }else{
                self.lockedImageView.enabled=NO;
                self.viewsLabel.hidden=NO;
                self.lockedCanSeeLabel.hidden=YES;
                self.bottomView.hidden=YES;
            }
            self.viewsLabel.text=[[dict objectForKey:@"evnetView"] objectForKey:@"reason"];
            betScore=[[dict objectForKey:@"evnetView"] objectForKey:@"betScore"];
            self.leftTeamView.image=[UIImage imageNamed:@"zuo"];
            self.rightTeamView.image=[UIImage imageNamed:@"you"];
            self.midImageView.image=[UIImage imageNamed:@"zhong"];
            self.usedIntegralLockedLabel.text=@"使用积分解锁";
            self.lockedCanSeeLabel.text=@"解锁可见";
            [self.lockedImageView setImage:[UIImage imageNamed:@"saishi_suo"] forState:UIControlStateNormal];
            MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
            if ([[[dict objectForKey:@"evnetView"] objectForKey:@"userId"] integerValue]==[config.userId integerValue]) {
                self.supportBtn.hidden=YES;
            }
            _formLabel.text=@"来自";
            self.bottomView.backgroundColor=[UIColor whiteColor];
            self.matchStatus=[[[dict objectForKey:@"matchInfo"] objectForKey:@"matchStatus"] integerValue];
        }else if ([[dic objectForKey:@"code"] integerValue]==1005){
            [SVProgressHUD showWithStatus:@"您已重复登录"];
            [self.navigationController popViewControllerAnimated:YES];
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            login.isPageNumber=1;
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [self presentViewController:nav animated:YES completion:nil];
            [MXssWodeUtils removePersonInfo];
        }
//         YYLog(@"++%@++",dic);
    } WithFailureBlock:^(NSError *error) {
        
        [SVProgressHUD showInfoWithStatus:@"加载失败"];
    }];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"赛事观点界面\"}"];
}
-(void)setUpUI{
    self.headImgView=[[UIImageView alloc] initWithRoundingRectImageView];
    [self.view addSubview:self.headImgView];
    
    self.headImgView.sd_layout
    .topSpaceToView(self.view, 20)
    .leftSpaceToView(self.view, 15)
    .widthIs(50)
    .heightIs(50);
    self.userName=[UILabel new];
    [self.view addSubview:self.userName];
    self.userName.sd_layout
    .topEqualToView(self.headImgView).offset(5)
    .leftSpaceToView(self.headImgView, 10)
    .heightIs(20)
    .autoWidthRatio(0);
    [self.userName setSingleLineAutoResizeWithMaxWidth:150];
    self.dateLabel=[UILabel new];
    [self.view addSubview:self.dateLabel];
    self.dateLabel.sd_layout
    .topSpaceToView(self.userName, 5)
    .leftEqualToView(self.userName)
    .heightIs(20)
    .autoWidthRatio(0);
    [self.dateLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    self.supportBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.supportBtn];
    [self.supportBtn addTarget:self action:@selector(clickedSupportBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.supportBtn.sd_layout
    .topSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(40)
    .widthIs(40);
    
    self.titleLabel=[UILabel new];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.sd_layout
    .topSpaceToView(self.headImgView, 20)
    .leftEqualToView(self.headImgView)
    .heightIs(20)
    .autoWidthRatio(0);
    [self.titleLabel setSingleLineAutoResizeWithMaxWidth:300];
    self.formLabel=[UILabel new];
    [self.view addSubview:self.formLabel];
    
    _formLabel.font=fontSize(scaleWithSize(14));
    _formLabel.sd_layout
    .topSpaceToView(self.titleLabel, 20)
    .leftEqualToView(self.titleLabel)
    .widthIs(35)
    .heightIs(20);
    
    self.sourceLabel=[UILabel new];
    [self.view addSubview:self.sourceLabel];
    self.sourceLabel.textColor=[[UIColor blueColor] colorWithAlphaComponent:0.6];
    self.sourceLabel.sd_layout
    .topEqualToView(_formLabel)
    .leftSpaceToView(_formLabel, 5)
    .heightIs(20)
    .autoWidthRatio(0);
    [self.sourceLabel setSingleLineAutoResizeWithMaxWidth:120];
    
    self.readNumbers=[UILabel new];
    [self.view addSubview:self.readNumbers];
    self.readNumbers.textColor=[[UIColor blueColor] colorWithAlphaComponent:0.6];
    self.readNumbers.sd_layout
    .topEqualToView(_formLabel)
    .rightSpaceToView(self.view, 20)
    .heightIs(20)
    .autoWidthRatio(0);
    [self.readNumbers setSingleLineAutoResizeWithMaxWidth:100];
    
    self.leftTeamView=[UIImageView new];
    [self.view addSubview:self.leftTeamView];
    self.leftTeamView.sd_layout
    .topSpaceToView(_formLabel, scaleWithSize(20))
    .leftEqualToView(_formLabel)
    .widthIs((screen_width-60)/3)
    .heightIs(scaleWithSize(105));
    
    self.midImageView=[[UIImageView alloc] init];
    [self.view addSubview:self.midImageView];
    self.midImageView.sd_layout
    .topEqualToView(self.leftTeamView)
    .leftSpaceToView(self.leftTeamView, 0)
    .widthIs((screen_width-60)/3+20)
    .heightRatioToView(self.leftTeamView, 1);
    
    self.rightTeamView=[[UIImageView alloc] init];
    [self.view addSubview:self.rightTeamView];
    self.rightTeamView.sd_layout
    .topEqualToView(self.leftTeamView)
    .leftSpaceToView(self.midImageView, 0)
    .widthRatioToView(self.leftTeamView, 1)
    .heightRatioToView(self.leftTeamView, 1);
    self.leftTeamIcon=[UIImageView new];
    [self.leftTeamView addSubview:self.leftTeamIcon];
    self.rightTeamIcon=[UIImageView new];
    [self.rightTeamView addSubview:self.rightTeamIcon];
    self.leftTeamIcon.sd_layout
    .topSpaceToView(self.leftTeamView, scaleWithSize(15))
    .centerXEqualToView(self.leftTeamView)
    .widthIs(scaleWithSize(50))
    .autoHeightRatio(1.2);
    self.rightTeamIcon.sd_layout
    .topEqualToView(self.leftTeamIcon)
    .centerXEqualToView(self.rightTeamView)
    .widthRatioToView(self.leftTeamIcon, 1)
    .heightRatioToView(self.leftTeamIcon, 1);
    
    self.leftTeamLabel=[UILabel new];
    [self.leftTeamView addSubview:self.leftTeamLabel];
    self.leftTeamLabel.sd_layout
    .topSpaceToView(self.leftTeamIcon, 5)
    .centerXEqualToView(self.leftTeamView)
    .widthRatioToView(self.leftTeamView, 1)
    .heightIs(scaleWithSize(20));
    
    self.rightTeamLabel=[UILabel new];
    [self.rightTeamView addSubview:self.rightTeamLabel];
    self.rightTeamLabel.sd_layout
    .topEqualToView(self.leftTeamLabel)
    .centerXEqualToView(self.leftTeamLabel)
    .widthRatioToView(self.leftTeamLabel, 1)
    .heightRatioToView(self.leftTeamLabel, 1);
    self.leftTeamLabel.textAlignment=NSTextAlignmentCenter;
    self.leftTeamLabel.textColor=[UIColor redColor];
    self.rightTeamLabel.textColor=[UIColor redColor];
    self.rightTeamLabel.textAlignment=NSTextAlignmentCenter;
    
    self.gameStatusLabel=[UILabel new];
    [self.view addSubview:self.gameStatusLabel];
    self.gameStatusLabel.sd_layout
    .bottomEqualToView(self.midImageView).offset(-5)
    .widthRatioToView(self.midImageView, 1)
    .leftEqualToView(self.midImageView)
    .heightIs(20);
    self.gameTimeLabel=[UILabel new];
    [self.view addSubview:self.gameTimeLabel];
    self.gameTimeLabel.sd_layout
    .bottomSpaceToView(self.gameStatusLabel, 5)
    .widthRatioToView(self.gameStatusLabel, 1)
    .leftEqualToView(self.gameStatusLabel)
    .heightRatioToView(self.gameStatusLabel, 1);
    self.gameStatusLabel.textAlignment=NSTextAlignmentCenter;
    self.gameTimeLabel.textAlignment=NSTextAlignmentCenter;
    self.gameTimeLabel.textColor=[UIColor whiteColor];
    self.gameStatusLabel.textColor=[UIColor whiteColor];
    self.viewsLabel=[UILabel new];
    [self.view addSubview:self.viewsLabel];
    self.viewsLabel.hidden=YES;
    self.viewsLabel.sd_layout
    .topSpaceToView(self.leftTeamView, 20)
    .leftEqualToView(self.leftTeamView)
    .rightEqualToView(self.rightTeamView)
    .autoHeightRatio(0);
    
    self.lockedCanSeeLabel=[UILabel new];
    [self.view addSubview:self.lockedCanSeeLabel];
    self.lockedCanSeeLabel.sd_layout
    .topSpaceToView(self.leftTeamView, 200)
    .centerXEqualToView(self.view)
    .heightIs(20)
    .widthIs(100);
    
    self.lockedCanSeeLabel.textAlignment=NSTextAlignmentCenter;
    
    self.bottomView=[UIView new];
    [self.view addSubview:self.bottomView];
    self.bottomView.sd_layout
    .bottomEqualToView(self.view).offset(-TABBAR_FRAME-5)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(30);
    
    self.usedIntegralLockedLabel=[UILabel new];
    [self.bottomView addSubview:self.usedIntegralLockedLabel];
    self.usedIntegralLockedLabel.sd_layout
    .leftEqualToView(self.bottomView).offset(10)
    .heightIs(20)
    .topEqualToView(self.bottomView).offset(5)
    .widthIs(160);
    

    self.lockedImageView=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.lockedImageView];
    self.lockedImageView.sd_layout
    .topEqualToView(self.usedIntegralLockedLabel)
    .rightEqualToView(self.bottomView).offset(-15)
    .heightIs(20)
    .widthIs(15);
    [self.lockedImageView addTarget:self action:@selector(clickedUnlockedBtn:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)viewWillDisappear:(BOOL)animated{
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"赛事观点界面\"}"];
}

-(void)clickedSupportBtn:(UIButton *)btn{
    if (self.matchStatus==2||self.matchStatus==3||self.matchStatus==4||self.matchStatus==5||self.matchStatus==6||self.matchStatus==7||self.matchStatus==8) {
        [SVProgressHUD showInfoWithStatus:@"此操作仅限于开赛前"];
    }else{
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    NSMutableDictionary *paras=[NSMutableDictionary dictionaryWithDictionary:@{@"eventViewId":self.eventID,@"userId":config.userId,@"token":config.token,@"time":[MXLJUtil getNowDateTimeString]}];

    [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:MXSupportOpinionPATH] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"code"] integerValue]==0) {
            btn.enabled=NO;
            [btn setImage:[UIImage imageNamed:@"saishi_yizhichi"] forState:UIControlStateNormal];
            [SVProgressHUD showSuccessWithStatus:@"支持成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"支持失败"];

    }];
    }
}
-(void)clickedUnlockedBtn:(UIButton *)btn{
    
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    NSMutableDictionary *paras=[NSMutableDictionary dictionaryWithDictionary:@{@"eventViewId":self.eventID,@"userId":config.userId,@"token":config.token,@"time":[MXLJUtil getNowDateTimeString]}];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:MXUnlockedOpinionPATH] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"code"] integerValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"解锁成功"];
            self.viewsLabel.hidden=NO;
            self.lockedCanSeeLabel.hidden=YES;
            self.bottomView.hidden=YES;
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"解锁失败"];
    }];
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
