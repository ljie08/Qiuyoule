//
//  MXSSIntegralTaskListViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSIntegralTaskListViewController.h"
#import "MXssFindTaskAndLevelModel.h"//积分任务model
#import "MXssIntegralBouncedView.h"//积分任务弹框显示

@interface MXSSIntegralTaskListViewController ()

@end

@implementation MXSSIntegralTaskListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupUISetting];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(scaleWithSize(25.0f), 0, screen_width - scaleWithSize(25.0f) * 2, scaleWithSize(36.0f))];
    topLabel.text = @"每日完成积分任务，最多可以获得";
    topLabel.font = fontSize(scaleWithSize(13.0f));
    topLabel.textColor = [UIColor grayColor];
    [self.view addSubview:topLabel];
    
}
- (void)setFindTaskLevelArr:(NSMutableArray *)findTaskLevelArr {
    if (!_findTaskLevelArr) {
         _findTaskLevelArr = findTaskLevelArr;
    }
   
    if (_findTaskLevelArr.count>0) {
        CGFloat spaingSmall = scaleWithSize(10.0f);
        UIScrollView *applicationSV = [[UIScrollView alloc] initWithFrame:CGRectMake(scaleWithSize(15.0f), scaleWithSize(36.0f), screen_width - scaleWithSize(15.0f) * 2, self.view.frame.size.height - scaleWithSize(60.0f))];
        
        applicationSV.showsVerticalScrollIndicator = YES;
        applicationSV.showsVerticalScrollIndicator = NO;
        applicationSV.backgroundColor = mx_Wode_backgroundColor;
        //    applicationSV.delegate = self;
        applicationSV.scrollEnabled = YES;
        [self.view addSubview:applicationSV];
        CGFloat border = 1.0f;

         MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
        for (int i = 0; i < _findTaskLevelArr.count; i++) {
            MXssFindTaskAndLevelModel *models = _findTaskLevelArr[i];
            NSString *str = [NSString stringWithFormat:@"积分+%@ 每日上限%@",models.scoreValue,models.scoreUpperValue];
            CGFloat viewHeight = scaleWithSize(55.0f);
            UIView *viewmyInsure = [[UIView alloc] initWithFrame:CGRectMake(0, i*(viewHeight+border), applicationSV.frame.size.width, viewHeight)];
            viewmyInsure.backgroundColor = [UIColor whiteColor];
            [applicationSV addSubview:viewmyInsure];

                 [self addSubDetailViews:viewmyInsure iconName:models.imgUrl iconLeft:spaingSmall title:models.scoreRuleContent titleLeft:20 hint:str finishedFlg:models.isFinished];
            
            //当前时间判断
//            MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
            NSDate *  senddate=[NSDate date];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYYMMdd"];
            NSString *  locationString=[dateformatter stringFromDate:senddate];
            NSLog(@"判断当前时间 一天提醒一次=🚗=%@,%@,",locationString,[NSString stringWithFormat:@"%@",[MXssWodeUtils loadPersonInfo].homeTimeNumber]);
            //判断当前时间 一天提醒一次
            if (![locationString isEqualToString:[NSString stringWithFormat:@"%@",[MXssWodeUtils loadPersonInfo].homeTimeNumber]]) {
                //        [self levelBouncedList];//等级弹框显示
                 userModel.JifenRenwuLVNumberID = @"1";
                userModel.homeTimeNumber = locationString;
                userModel.JifenRenwuLVNumberIDStr = @"1";
                [MXssWodeUtils savePersonInfo:userModel];
                 NSLog(@"??????一次=🚗");
                    }
           
            NSArray *chunks = [userModel.JifenRenwuLVNumberIDStr componentsSeparatedByString:@","];
            NSString *yesOrNoStr = chunks[chunks.count-1];
            NSLog(@"一次=🚗=%@,%@,%@",yesOrNoStr,userModel.JifenRenwuLVNumberID,models.ruleId);

           //积分任务的弹框显示
//            if ([models.isFinished isEqualToString:@"1"] && (userModel.JifenRenwuLVNumberID.intValue < models.ruleId.intValue)) {
//                userModel.JifenRenwuLVNumberID = @"1";
                 NSLog(@"一次=🚗=🍎🍎📷📷");
            if ([models.isFinished isEqualToString:@"1"] && ![yesOrNoStr isEqualToString:models.ruleId]&& (userModel.JifenRenwuLVNumberID.intValue < models.ruleId.intValue)) {
                userModel.JifenRenwuLVNumberIDStr = [NSString stringWithFormat:@"%@,%@",userModel.JifenRenwuLVNumberIDStr,models.ruleId];//放到数组里面判断是否显示弹框
                userModel.JifenRenwuLVNumberID = models.ruleId;
                [MXssWodeUtils savePersonInfo:userModel];
                [self integralBouncedListWithImage:models.imgUrl withShowPermissionName:models.scoreRuleContent withPersonContent:models.scoreUpperValue];//积分任务弹框显
                NSLog(@"一次=🚗=🍎🍎");
            }
//            }
        }
        
        applicationSV.contentSize = CGSizeMake(screen_width - scaleWithSize(15.0f)*2, _findTaskLevelArr.count * 55 + 49);
        
    }else {
        [self setupUISetting];
    }
}
#pragma mark --- 积分任务弹框显示
- (void)integralBouncedListWithImage:(NSString *)image withShowPermissionName:(NSString *)scoreRuleContent withPersonContent:(NSString *)scoreUpperValue{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MXssIntegralBouncedView *levelView = [[MXssIntegralBouncedView alloc]initWithFrame:window.frame withImage:nil withShowPermissionName:scoreRuleContent withPersonContent:scoreUpperValue];
    //    levelView.numberimg =  numimage;
    [window addSubview:levelView];
}
- (void)setupUISetting {
    CGFloat border = 1.0f;
    CGFloat spaingSmall = scaleWithSize(10.0f);

    UIScrollView *applicationSV = [[UIScrollView alloc] initWithFrame:CGRectMake(scaleWithSize(15.0f), scaleWithSize(36.0f), screen_width - scaleWithSize(15.0f) * 2, self.view.frame.size.height - scaleWithSize(200.0f))];
    
    applicationSV.showsVerticalScrollIndicator = YES;
    applicationSV.showsVerticalScrollIndicator = NO;
    applicationSV.backgroundColor = [UIColor clearColor];
    //    applicationSV.delegate = self;
    applicationSV.scrollEnabled = YES;
    [self.view addSubview:applicationSV];
    
    CGFloat viewHeight = scaleWithSize(55.0f);
    UIView *viewmyInsure = [[UIView alloc] initWithFrame:CGRectMake(0, 0, applicationSV.frame.size.width, viewHeight)];
    viewmyInsure.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewmyInsure];
    [self addSubDetailViews:viewmyInsure iconName:@"my_Integral_qiandao" iconLeft:spaingSmall title:@"签到" titleLeft:20 hint:@"积分+15 每日上限15" finishedFlg:@"1"];
    
    UIView *viewArticleCollection = [[UIView alloc] initWithFrame:CGRectMake(0, viewmyInsure.frame.origin.y + viewmyInsure.frame.size.height + border, applicationSV.frame.size.width, viewHeight)];
    viewArticleCollection.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewArticleCollection];
    [self addSubDetailViews:viewArticleCollection iconName:@"my_Integral_zhuce" iconLeft:spaingSmall title:@"注册" titleLeft:20 hint:@"积分+100 每日上限100" finishedFlg:@"1"];
    
    UIView *viewAboutUs = [[UIView alloc] initWithFrame:CGRectMake(0, viewArticleCollection.frame.origin.y + viewArticleCollection.frame.size.height + border, applicationSV.frame.size.width, viewHeight)];
    viewAboutUs.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewAboutUs];
    [self addSubDetailViews:viewAboutUs iconName:@"my_Integral_wanshanxinxi" iconLeft:spaingSmall title:@"完善信息" titleLeft:20 hint:@"积分+100 每日上限100" finishedFlg:@"0"];
    
    UIView *viewComPro = [[UIView alloc] initWithFrame:CGRectMake(0, viewAboutUs.frame.origin.y + viewAboutUs.frame.size.height + border, applicationSV.frame.size.width, viewHeight)];
    viewComPro.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewComPro];
    [self addSubDetailViews:viewComPro iconName:@"my_Integral_fabuwenzhang" iconLeft:spaingSmall title:@"发布文章" titleLeft:20 hint:@"积分+15 每日上限15" finishedFlg:@"0"];
    
    UIView *viewAboutus = [[UIView alloc] initWithFrame:CGRectMake(0, viewComPro.frame.origin.y + viewComPro.frame.size.height + border, applicationSV.frame.size.width, viewHeight)];
    viewAboutus.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewAboutus];
    [self addSubDetailViews:viewAboutus iconName:@"my_Integral_fenxiangtiezi" iconLeft:spaingSmall title:@"分享帖子" titleLeft:20 hint:@"积分+15 每日上限15" finishedFlg:@"0"];
    
    UIView *viewZan = [[UIView alloc] initWithFrame:CGRectMake(0, viewAboutus.frame.origin.y + viewAboutus.frame.size.height + border, applicationSV.frame.size.width, viewHeight)];
    viewZan.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewZan];
    [self addSubDetailViews:viewZan iconName:@"my_Integral_dianzan" iconLeft:spaingSmall title:@"点赞" titleLeft:20 hint:@"积分+100 每日上限100" finishedFlg:@"0"];
    
    UIView *viewPinglun= [[UIView alloc] initWithFrame:CGRectMake(0, viewZan.frame.origin.y + viewZan.frame.size.height + border, applicationSV.frame.size.width, viewHeight)];
    viewPinglun.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewPinglun];
    [self addSubDetailViews:viewPinglun iconName:@"my_Integral_pinglun" iconLeft:spaingSmall title:@"评论" titleLeft:20 hint:@"积分+15 每日上限15" finishedFlg:@"0"];
    
    applicationSV.contentSize = CGSizeMake(screen_width - scaleWithSize(15.0f)*2, viewPinglun.frame.origin.y + viewPinglun.frame.size.height + 49);
}
//各条件view块添加详细内容
-(UILabel *)addSubDetailViews:(UIView *)parentView iconName:(NSString *)imageName iconLeft:(CGFloat)iconX title:(NSString*)titleName titleLeft:(CGFloat)titleX hint:(NSString*)hintText finishedFlg:(NSString*)finishedFlg{
    //开头图标
    UIImageView *viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 0,scaleWithSize(30), scaleWithSize(30))];
    [parentView addSubview:viewIcon];
    viewIcon.center = CGPointMake(viewIcon.center.x, parentView.frame.size.height/2);
//    [viewIcon setImage:[UIImage imageNamed:imageName]];
    [viewIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageName]] placeholderImage:[UIImage imageNamed:@"my_Integral_qiandao"]];//[UIImage imageNamed:@"pro_up_img"]
//} else {
    
    //标题
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX + scaleWithSize(30), scaleWithSize(10), 204, scaleWithSize(20))];
    [parentView addSubview:lblTitle];
    //    lblTitle.center = CGPointMake(lblTitle.center.x, parentView.frame.size.height/2);
    lblTitle.numberOfLines = 1;
    lblTitle.text = titleName;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [lblTitle setTextColor:mx_Wode_color666666];
    lblTitle.backgroundColor =[UIColor clearColor];
    //    lblTitle.font = [UIFont fontWithName:@"Arial" size:16];
    lblTitle.font = fontSize(scaleWithSize(14.0f));
    
    //右箭头  15*15，距离右边也是15
    UIImageView *viewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(21.0f)*2 - scaleWithSize(30), 0, scaleWithSize(20), scaleWithSize(13.5))];
    viewArrow.center = CGPointMake(viewArrow.center.x, parentView.frame.size.height/2);
//    if ([titleName isEqualToString:@"发布文章"]||[titleName isEqualToString:@"分享帖子"]) {
//    NSLog(@"🚗🚗🍎==%d",finishedFlg.intValue);
    if (finishedFlg.integerValue >= 1) {
        
        [viewArrow setImage:[UIImage imageNamed:@"my_Integral_dagou"]];
    }else {
        [viewArrow setImage:[UIImage imageNamed:@""]];//不显示右边的箭头
        UILabel *weiLabel = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - scaleWithSize(20.0f)*2 - scaleWithSize(50), scaleWithSize(55.0f)/2 - scaleWithSize(15), scaleWithSize(50), scaleWithSize(30))];
        weiLabel.textColor = mx_Wode_color666666;
        weiLabel.text = @"未完成";
        weiLabel.font = fontSize(scaleWithSize(14.0f));
        [parentView addSubview:weiLabel];
    }
    [parentView addSubview:viewArrow];
    UILabel *lblContent = [[UILabel alloc] init];
    lblContent.frame =CGRectMake(titleX + scaleWithSize(30), parentView.frame.size.height - scaleWithSize(25.0f), screen_width - (titleX + scaleWithSize(30))*2 - scaleWithSize(30), scaleWithSize(15));
    
    [parentView addSubview:lblContent];
    //    lblContent.center = CGPointMake(lblContent.center.x, parentView.frame.size.height/2);
    lblContent.text = hintText;
    lblContent.textColor = mx_Wode_color999999;
    lblContent.backgroundColor =[UIColor clearColor];
    //    lblContent.textAlignment = NSTextAlignmentRight;
    //    lblContent.font = [UIFont fontWithName:@"Arial" size:12.0f];
    lblContent.font = fontSize(scaleWithSize(11.0f));
    
    return lblContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
