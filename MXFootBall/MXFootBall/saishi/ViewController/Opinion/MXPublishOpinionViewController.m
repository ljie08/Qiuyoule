//
//  MXPublishOpinionViewController.m
//  MXFootBall
//
//  Created by YY on 2018/3/29.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXPublishOpinionViewController.h"
#import "UITextView+placeHolder.h"
@interface MXPublishOpinionViewController ()<UITextViewDelegate>
{
    UIButton *_lastBtn;
    UIButton *_nextLastBtn;
    NSString *currentSeeViewCost;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightTwoMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reasonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTwoMargin;
@property (weak, nonatomic) IBOutlet UILabel *weekDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *upMainWinBtn;
@property (weak, nonatomic) IBOutlet UIButton *underMainWinBnt;

@property (weak, nonatomic) IBOutlet UIButton *upFlatBtn;
@property (weak, nonatomic) IBOutlet UIButton *underFlatBtn;
@property (weak, nonatomic) IBOutlet UIButton *upGuestWinBtn;
@property (weak, nonatomic) IBOutlet UIButton *underGuestWinBtn;
@property (weak, nonatomic) IBOutlet UITextView *recommendedReasonsTextView;
@property (weak, nonatomic) IBOutlet UITextView *promotetTitleTextView;
@property (nonatomic,strong)UIButton *seeViewsCostBtn;
@property (nonatomic,strong)UIButton *publishViewsCostBtn;
@property (weak, nonatomic) IBOutlet UILabel *seeViewsCostLabel;

@property (nonatomic,copy)NSMutableArray *selectedArr;
    
@property (nonatomic,copy)NSMutableArray *underSelectedArr;

@property (nonatomic,strong) UIButton *selectedBtn;

@property (weak, nonatomic) IBOutlet UILabel *euBallBtn;
@property (weak, nonatomic) IBOutlet UILabel *loBallBtn;

@end

@implementation MXPublishOpinionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = mx_Wode_backgroundColor ;
    self.promotetTitleTextView.delegate=self;
    self.promotetTitleTextView.yy_placeHolder=@"请如实称述，不可虚拟夸张，限20字";
    [self.promotetTitleTextView setTextMaxLength:20];
    self.recommendedReasonsTextView.yy_placeHolder=@"请描述您推荐此方案的理由，最少二十字";
    MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    NSMutableDictionary *paras=[NSMutableDictionary dictionaryWithDictionary:@{@"userId":config.userId,@"token":config.token,@"matchId":self.matchID,@"type":@"1",@"time":[MXLJUtil getNowDateTimeString],@"version":@"2_0"}];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingString:@"api/event/eventView"] WithParams:[MXLJUtil sortedDictionary:paras] WithSuccessBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"code"] integerValue]==0) {
            self.infoDict=[dic objectForKey:@"data"];
            self.weekDateLabel.text=[[dic objectForKey:@"data"] objectForKey:@"lottery"];
            self.leftTeamLabel.text=[[dic objectForKey:@"data"] objectForKey:@"homeNm"];
            self.rightTeamLabel.text=[[dic objectForKey:@"data"] objectForKey:@"awayNm"];
            self.gameNameLabel.text=[[dic objectForKey:@"data"] objectForKey:@"eventNm"];
            [self.upMainWinBtn setTitle:[NSString stringWithFormat:@"主胜   %@",[[dic objectForKey:@"data"] objectForKey:@"euWon"]] forState:UIControlStateNormal];
            [self.upFlatBtn setTitle:[NSString stringWithFormat:@"平    %@",[[dic objectForKey:@"data"] objectForKey:@"euDrawn"]] forState:UIControlStateNormal];
            [self.upGuestWinBtn setTitle:[NSString stringWithFormat:@"客胜   %@",[[dic objectForKey:@"data"] objectForKey:@"euLost"]] forState:UIControlStateNormal];
            [self.underMainWinBnt setTitle:[NSString stringWithFormat:@"主胜   %@",[[dic objectForKey:@"data"] objectForKey:@"loWon"]] forState:UIControlStateNormal];
            [self.underFlatBtn setTitle:[NSString stringWithFormat:@"平    %@",[[dic objectForKey:@"data"] objectForKey:@"loDrawn"]] forState:UIControlStateNormal];
            [self.underGuestWinBtn setTitle:[NSString stringWithFormat:@"客胜   %@",[[dic objectForKey:@"data"] objectForKey:@"loLost"]] forState:UIControlStateNormal];
            self.euBallBtn.text=[NSString stringWithFormat:@"%@",[[dic objectForKey:@"data"] objectForKey:@"euBall"]];
            self.loBallBtn.text=[NSString stringWithFormat:@"%@",[[dic objectForKey:@"data"] objectForKey:@"loBall"]];
            NSArray *csmScoreArr=[[dic objectForKey:@"data"] objectForKey:@"bets"];
            self.scoreLabel.text=[NSString stringWithFormat:@"%@",[[MXLJUtil timeInterverlToDateStr:[[dic objectForKey:@"data"] objectForKey:@"startTime"]]substringWithRange:NSMakeRange([MXLJUtil timeInterverlToDateStr:[[dic objectForKey:@"data"] objectForKey:@"startTime"]].length-5, 5)]];
            CGFloat margin=scaleWithSize(20);
            CGFloat width=(screen_width-(csmScoreArr.count+1)*margin)/csmScoreArr.count;
            CGFloat height=scaleWithSize(30);
            
            for (NSInteger i=0; i<csmScoreArr.count; i++) {
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame=CGRectMake(margin+(margin+width)*i,self.seeViewsCostLabel.y+25, width, height);
                
                [btn setTitle:[NSString stringWithFormat:@"%@",csmScoreArr[i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clickedCostIntegralBtn:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag=100+i;
                [self.view addSubview:btn];
                btn.backgroundColor=[UIColor whiteColor];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                if (i==0) {
                    btn.selected=YES;
                    btn.backgroundColor=mx_Wode_colorBlue2374e4;
                    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    _lastBtn=btn;
                    currentSeeViewCost=[btn titleForState:UIControlStateNormal];
                }
            }
            UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            sendBtn.frame=CGRectMake(30, self.seeViewsCostLabel.y+80, screen_width-60, 35);
            sendBtn.backgroundColor=mx_Wode_colorBlue2374e4;
            [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
            [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.view addSubview:sendBtn];
            [sendBtn addActionHandler:^(UIButton *btn) {
                [self clickedSendBtn];
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[dic objectForKey:@"msg"]];
        }
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络错误"];
    }];
}
-(NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr=[NSMutableArray array];
    }
    return  _selectedArr;
}
-(NSMutableArray *)underSelectedArr{
    if (!_underSelectedArr) {
        _underSelectedArr=[NSMutableArray array];
    }
    return  _underSelectedArr;
}
-(void)clickedSendBtn{
    if (self.recommendedReasonsTextView.text.length<20) {
        [SVProgressHUD showErrorWithStatus:@"推荐理由最少20字"];
    }else{
       
        MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
        NSString *eventViewStr=[NSString stringWithFormat:@"%i|%i|%i||%i|%i|%i",self.upMainWinBtn.selected,self.upFlatBtn.selected,self.upGuestWinBtn.selected,self.underMainWinBnt.selected,self.underFlatBtn.selected,self.underGuestWinBtn.selected];        
        NSMutableDictionary *para=[NSMutableDictionary dictionaryWithDictionary:@{@"userId":config.userId,@"token":config.token,@"matchId":self.matchID,@"popTitle":self.promotetTitleTextView.text,@"viewReason":self.recommendedReasonsTextView.text,@"betScore":currentSeeViewCost,@"eventView":eventViewStr,@"time":[MXLJUtil getNowDateTimeString],@"type":@"1",@"version":@"2_0"}];
        [[WebManager sharedManager] requestWithMethod:POST WithUrl:[SERVER_HOST stringByAppendingPathComponent:MXPublishOpinionPATH] WithParams:[MXLJUtil sortedDictionary:para] WithSuccessBlock:^(NSDictionary *dic) {
            if ([[dic objectForKey:@"code"] integerValue]==0) {
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            }else{
                [SVProgressHUD showSuccessWithStatus:[dic objectForKey:@"msg"]];
            }
            
        } WithFailureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"发布失败"];
        }];
    }
}
- (IBAction)clickedUpBtn:(UIButton *)sender {
    if(self.underSelectedArr.count==0){
        [self multiSelectWithBtn:sender AndArray:self.selectedArr];
    }
}
- (IBAction)clickedUnderBtn:(UIButton *)sender {
    if(self.selectedArr.count==0){
        [self multiSelectWithBtn:sender AndArray:self.underSelectedArr];
    }
}
-(void)multiSelectWithBtn:(UIButton *)btn AndArray:(NSMutableArray *)arr{
    btn.selected=!btn.selected;
    if (btn.selected) {
        if (arr.count<2) {
            btn.backgroundColor=[UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [arr addObject:[NSString stringWithFormat:@"%ld",btn.tag]];
        }else{
            NSString *indexStr=arr[0];
            NSInteger index=[indexStr integerValue];
            UIButton *button=[self.view viewWithTag:index];
            [button setBackgroundColor:[UIColor whiteColor]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.selected=NO;
            [arr removeObject:[NSString stringWithFormat:@"%ld",button.tag]];
            btn.backgroundColor=[UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [arr addObject:[NSString stringWithFormat:@"%ld",btn.tag]];
        }
    }else{
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if([arr containsObject:[NSString stringWithFormat:@"%ld",btn.tag]]){
            [arr removeObject:[NSString stringWithFormat:@"%ld",btn.tag]];
        }
    }
}
- (void)clickedCostIntegralBtn:(UIButton *)sender {
    
    if (_lastBtn!=sender) {
        sender.selected=!sender.selected;
        [sender setBackgroundColor:mx_Wode_colorBlue2374e4];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_lastBtn setBackgroundColor:[UIColor whiteColor]];
        _lastBtn.selected=!_lastBtn.selected;
        [_lastBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    _lastBtn=sender;
    currentSeeViewCost=[sender titleForState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"发布观点界面\"}"];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"发布观点界面\"}"];
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
