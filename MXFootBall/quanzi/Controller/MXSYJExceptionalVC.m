//
//  MXSYJExceptionalVC.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJExceptionalVC.h"
#import "YZTagList.h"
#import "MXssDashangListModel.h"//打赏列表model

#define KW (screen_width - 65) / 4

@interface MXSYJExceptionalVC ()

@property (nonatomic, strong) UIImageView *iconImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *exceptionalLab;

@property (nonatomic, strong) YZTagList *tagList;
@property (nonatomic, strong) NSMutableArray *listArrs;//列表展示
@property (nonatomic, strong) NSMutableArray *tagNumber;
@end

@implementation MXSYJExceptionalVC
static NSString *numPeople;

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"打赏界面\"}"];
    [self setBackButton:YES];
    [self initTitleViewWithTitle:@"打赏"];
}
- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"打赏界面\"}"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listArrs = [NSMutableArray array];
    self.tagNumber = [NSMutableArray array];
    numPeople = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self listScore];//打赏列表数据请求
    [self setUpView];
}

- (void)setUpView{
    
    //头像
    self.iconImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"luntan_dashangjifen_touxiang"]];
    [self.view addSubview:self.iconImg];
//    if (isIPhone5s) {
//    NSLog(@"?????==%f,%f",[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
    if ([[UIScreen mainScreen] bounds].size.height <= 568.0f) {
        self.iconImg.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, scaleWithSize(20)).heightIs(100).widthIs(100);
    }else if ([[UIScreen mainScreen] bounds].size.height <= 667.0) {
        self.iconImg.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, scaleWithSize(50)).heightIs(100).widthIs(100);
    }else {
        self.iconImg.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.view, scaleWithSize(80)).heightIs(100).widthIs(100);
    }
   
    self.iconImg.sd_cornerRadius = @50;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:self.heaerUrl] placeholderImage:[UIImage imageNamed:@"luntan_dashangjifen_touxiang"]];
    
    //名称
    self.nameLab = [[UILabel alloc]init];
    [self.view addSubview:self.nameLab];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    self.nameLab.textColor = mx_FontBalckColor;
    self.nameLab.font = fontBoldSize(16);
    self.nameLab.text = self.userName;
self.nameLab.sd_layout.centerXEqualToView(self.iconImg).topSpaceToView(self.iconImg, 15).heightIs(20);
    [self.nameLab setSingleLineAutoResizeWithMaxWidth:200];
    
    //打赏金额
//    NSArray *tags = @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80"];
    self.tagList = [[YZTagList alloc]init];
    [self.view addSubview:self.tagList];
//    self.tagList.backgroundColor = mx_Wode_colorBlue2374e4;
//    self.tagList.frame = CGRectMake(scaleWithSize(10), self.nameLab.maxY+scaleWithSize(15), screen_width - scaleWithSize(10*2), scaleWithSize(100));
self.tagList.sd_layout.centerXEqualToView(self.view).centerYEqualToView(self.view).heightIs(120).widthIs(screen_width - 20);
    // 高度可以设置为0，会自动跟随标题计算
    // 需要排序
    self.tagList.isSort = NO;
    // 标签尺寸
    self.tagList.tagSize = CGSizeMake(KW, 40);
    // 不需要自适应标签列表高度
    self.tagList.isFitTagListH = NO;
    // 设置标签背景色
    self.tagList.tagBackgroundColor = [UIColor whiteColor];
    // 设置标签颜色
    self.tagList.borderColor = mx_GreenColor;
    self.tagList.borderWidth = 1.0;
    self.tagList.tagColor = mx_GreenColor;
    self.tagList.tagFont = fontBoldSize(15);
    
    self.tagList.tagSelectColor = [UIColor whiteColor];
    self.tagList.tagSelectBackgroundColor = mx_GreenColor;
    self.tagList.tagSelectFont = fontBoldSize(15);
    
    mx_weakify(self);
    self.tagList.clickTagBlock = ^(UIButton *btn) {
        NSLog(@"%ld",btn.tag);
        
        if ([MXssWodeUtils loadPersonInfo].userId) {
            
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确认打赏？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf reward:btn.titleLabel.text];
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertVc addAction:confirmAction];
            [alertVc addAction:cancelAction];
            [weakSelf presentViewController:alertVc animated:YES completion:nil];

        }else{
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }
    };

    /**
     *  这里一定先设置标签列表属性，然后最后去添加标签
     */
    [self.tagList addTags:self.tagNumber];
    
    UIImageView *dashang = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"luntan_dashang"]];
    [self.view addSubview:dashang];
    dashang.sd_layout.bottomSpaceToView(self.nameLab, -scaleWithSize(60)).leftSpaceToView(self.view, 10).heightIs(20).widthIs(20);
//    dashang.sd_layout.centerXEqualToView(self.nameLab).topSpaceToView(self.nameLab, 15).heightIs(20);
    
//    self.nameLab.sd_layout.centerXEqualToView(self.iconImg).topSpaceToView(self.iconImg, 15).heightIs(20);
//    [self.nameLab setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UILabel *dL = [[UILabel alloc]init];
    [self.view addSubview:dL];
    dL.text = @"打赏鼓励一下";
    dL.textAlignment = NSTextAlignmentLeft;
    dL.textColor = mx_FontLightGreyColor;
    dL.font = fontSize(14);
    dL.sd_layout.leftSpaceToView(dashang, 15).centerYEqualToView(dashang).widthIs(150).heightIs(20);
    
    
    //打赏人数
    self.exceptionalLab = [[UILabel alloc]init];
    [self.view addSubview:self.exceptionalLab];
    self.exceptionalLab.textAlignment = NSTextAlignmentCenter;
    self.exceptionalLab.font = fontSize(13);
    self.exceptionalLab.textColor = mx_FontLightGreyColor;
    if (numPeople) {
         self.exceptionalLab.text =[NSString stringWithFormat:@"%@人打赏",numPeople];
    }else {
         self.exceptionalLab.text =[NSString stringWithFormat:@"0人打赏"];
    }
   
self.exceptionalLab.sd_layout.centerXEqualToView(self.view).heightIs(15).topSpaceToView(self.tagList, 80);
    [self.exceptionalLab setSingleLineAutoResizeWithMaxWidth:200];
    
    UIView *leftLine = [[UIView alloc]init];
    [self.view addSubview:leftLine];
    leftLine.backgroundColor = mx_LineColor;
leftLine.sd_layout.centerYEqualToView(self.exceptionalLab).rightSpaceToView(self.exceptionalLab, 10).leftSpaceToView(self.view, 10).heightIs(1.0);
    
    UIView *rightLine = [[UIView alloc]init];
    [self.view addSubview:rightLine];
    rightLine.backgroundColor = mx_LineColor;
rightLine.sd_layout.centerYEqualToView(self.exceptionalLab).leftSpaceToView(self.exceptionalLab, 10).leftSpaceToView(self.exceptionalLab, 10).heightIs(1.0);
}
-(void)listScore{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:self.newsId forKey:@"newsId"];
    [parmet setObject:[MXssWodeUtils loadPersonInfo].token forKey:@"token"];
    NSLog(@"%@",parmet);
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemRewardInfoPATH];
    mx_weakify(self);
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        if ([dic[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            NSMutableArray *listScore = dic[@"data"][@"rewardList"];
//            MXssDashangListModel *postModel = [MXssDashangListModel modelWithDictionary:dic];
//            postModel.rewardCount = dic[@"data"][@"rewardCount"];
            numPeople =  dic[@"data"][@"rewardCount"];
            for (NSDictionary *dicttImage in listScore) {
                rewardListModel *rlistModel = [rewardListModel modelWithDictionary:dicttImage];
                [self.tagNumber addObject:rlistModel.score];
                [weakSelf.listArrs addObject:rlistModel];
            }
            [self.exceptionalLab removeFromSuperview];
            [self setUpView];
//            [SVProgressHUD showSuccessWithStatus:@"打赏成功~~~"];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"刷新数据失败"];
    }];
}

- (void)reward:(NSString *)score{
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:self.newsId forKey:@"newsId"];
    [parmet setObject:[MXssWodeUtils loadPersonInfo].userId forKey:@"userId"];
    [parmet setObject:[MXssWodeUtils loadPersonInfo].token forKey:@"token"];
    [parmet setObject:self.ownerID forKey:@"ownerId"];
    [parmet setObject:score forKey:@"score"];
    
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXEventRewardUserPATH];
    mx_weakify(self);
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
//        NSLog(@"?????打赏==%@",dic);
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"打赏成功~~~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"打赏失败"];
    }];    
}

@end
