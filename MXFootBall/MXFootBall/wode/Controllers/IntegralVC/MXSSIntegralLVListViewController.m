//
//  MXSSIntegralLVListViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/13.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSIntegralLVListViewController.h"
#import "IntegralDetailView.h"
#import "MXssFindPermissionModel.h"//获取权限列表model
#import "MXssLevelBouncedView.h"//积分等级弹框显示

@interface MXSSIntegralLVListViewController ()

@property (nonatomic,strong)UIView *listLvView;//显示
@property (nonatomic, strong) NSMutableArray *modelArr;
@end

@implementation MXSSIntegralLVListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modelArr = [NSMutableArray array];
    [self FindPermissionData];//权限列表请求数据
    
}
#pragma mark ----等级弹框显示
//任务积分 等级弹框
- (void)levelBouncedListWithImage:(NSString *)image withShowPermissionName:(NSString *)permissionName withPersonContent:(NSString *)content{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MXssLevelBouncedView *levelView = [[MXssLevelBouncedView alloc]initWithFrame:window.frame withImage:image withShowPermissionName:permissionName withPersonContent:content];
    //    levelView.numberimg =  numimage;
    [window addSubview:levelView];
}
#pragma mark ---FindPermissionData权限列表请求数据
-(void)FindPermissionData{
    //    bigCaiPiaoArrHome= [NSMutableArray array];
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMyFindPermission_PATH;//请求权限列表接口
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    mx_weakify(self);
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"权限列表==%@",personDic);
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            NSDictionary *quanxianDict = personDic[@"data"];
            weakSelf.modelArr = [MXssFindPermissionModel mj_objectArrayWithKeyValuesArray:quanxianDict];
            [self UIPageData];
             NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < self.modelArr.count; i++) {
                MXssFindPermissionModel *modeFind = self.modelArr[i];
                if (modeFind.hasPermission.intValue == 1) {
                    [arr addObject:modeFind];
                }
                if ([modeFind.hasPermission isEqualToString:@"1"] && (userModel.IntegralLVNumberID.intValue < modeFind.levelId.intValue)) {
                    userModel.IntegralLVNumberID = modeFind.levelId;
                    [MXssWodeUtils savePersonInfo:userModel];
//                    //当前时间判断
//                    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
//                    NSDate *  senddate=[NSDate date];
//                    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//                    [dateformatter setDateFormat:@"YYYYMMdd"];
//                    NSString *  locationString=[dateformatter stringFromDate:senddate];
//                    判断当前时间 一天提醒一次
//                    if (![locationString isEqualToString:[NSString stringWithFormat:@"%@",[MXssWodeUtils loadPersonInfo].homeTimeNumber]]) {
//                     [self levelBouncedListWithImage:modeFind.imgUrl withShowPermissionName:modeFind.permissionName withPersonContent:modeFind.content];//等级弹框显示
//                        userModel.homeTimeNumber = locationString;//
//                        [MXssWodeUtils savePersonInfo:userModel];
//                    }
                }
            }
                MXssFindPermissionModel *modeFinds = arr[arr.count-1];
            if (userModel.IntegralLVNumberID.intValue>userModel.homeTimeNumber.intValue) {//判断今天是否弹框等级特权

            if (userModel.IntegralLVNumberID.intValue >= modeFinds.levelId.intValue) {//之弹框显示最高的等级特权

                [self levelBouncedListWithImage:modeFinds.imgUrl withShowPermissionName:modeFinds.permissionName withPersonContent:modeFinds.content];//等级弹框显示
            }
                userModel.homeTimeNumber = userModel.IntegralLVNumberID;
                [MXssWodeUtils savePersonInfo:userModel];
            }
        }else {
            [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)UIPageData{//等级特权铺页面
    if (self.modelArr.count % 4 == 0) {
        NSInteger numberCount = 0;
        NSInteger heightNumber = screen_width/3 + scaleWithSize(20);
        
        for (int j = 0; j < self.modelArr.count/4; j++) {
            _listLvView = [[UIView alloc] initWithFrame:CGRectMake(0, 10+(j*heightNumber), screen_width, screen_width/3 + scaleWithSize(20))];
            _listLvView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_listLvView];
        for (int i = 0; i < 4; i++) {
            MXssFindPermissionModel *model = self.modelArr[numberCount];
            UIButton *butLv = [UIButton buttonWithType:UIButtonTypeCustom];
            butLv.frame = CGRectMake(i*(screen_width /4), 10, screen_width /4,screen_width/4);
            butLv.backgroundColor = [UIColor clearColor];
            butLv.tag = numberCount+1;
            [butLv addTarget:self action:@selector(buttonListClick:) forControlEvents:UIControlEventTouchUpInside];//等级特权的点击查看详情
            [_listLvView addSubview:butLv];
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, screen_width/4- scaleWithSize(20), screen_width/4- scaleWithSize(30))];
//            NSString *str = [NSString stringWithFormat:@"my_dengjitequan_xiao%ld",numberCount+1];//my_dengjitequan_xiao1_hui
//            if (model.hasPermission.integerValue == 0) {
//                str = [NSString stringWithFormat:@"my_dengjitequan_xiao%ld_hui",numberCount+1];
//            } else {
//                str = [NSString stringWithFormat:@"my_dengjitequan_xiao%ld",numberCount+1];
//            }
//            imageV.image = [UIImage imageNamed:str];
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.imgUrl]] placeholderImage:[UIImage imageNamed:@"my_dengjitequan_xiao1_hui"]];
            [butLv addSubview:imageV];
            
            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + screen_width/4- scaleWithSize(20), screen_width/4- scaleWithSize(20), scaleWithSize(20))];
            labelName.text = model.permissionName;
            labelName.textAlignment = 1;
            labelName.backgroundColor = [UIColor clearColor];
            labelName.font = fontSize(11);
            [butLv addSubview:labelName];
            numberCount ++;
        }
    }
    }else {
        NSInteger numberCount = 0;
        NSInteger heightNumber = screen_width/3 + scaleWithSize(20);
        int listNum = 4;
        for (int j = 0; j < self.modelArr.count/4+1; j++) {
            _listLvView = [[UIView alloc] initWithFrame:CGRectMake(0, 10+(j*heightNumber), screen_width, screen_width/3 + scaleWithSize(20))];
            _listLvView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_listLvView];
            if (j == self.modelArr.count/4) {
                listNum = self.modelArr.count%4;
            }else {
                listNum = 4;
            }
            for (int i = 0; i < listNum; i++) {
                MXssFindPermissionModel *model = self.modelArr[numberCount];
                UIButton *butLv = [UIButton buttonWithType:UIButtonTypeCustom];
                butLv.frame = CGRectMake(i*(screen_width /4), 10, screen_width /4,screen_width/4);
                butLv.backgroundColor = [UIColor clearColor];
                butLv.tag = numberCount+1;
                [butLv addTarget:self action:@selector(buttonListClick:) forControlEvents:UIControlEventTouchUpInside];//等级特权的点击查看详情
                [_listLvView addSubview:butLv];
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, screen_width/4- scaleWithSize(20), screen_width/4- scaleWithSize(30))];
//                NSString *str = [NSString stringWithFormat:@"my_dengjitequan_xiao%ld",numberCount+1];//my_dengjitequan_xiao1_hui
//                if (model.hasPermission.integerValue == 0) {
//                    str = [NSString stringWithFormat:@"my_dengjitequan_xiao%ld_hui",numberCount+1];
//                } else {
//                    str = [NSString stringWithFormat:@"my_dengjitequan_xiao%ld",numberCount+1];
//                }
//                imageV.image = [UIImage imageNamed:str];
                [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.imgUrl]] placeholderImage:[UIImage imageNamed:@"my_dengjitequan_xiao1_hui"]];
                [butLv addSubview:imageV];
                
                UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + screen_width/4- scaleWithSize(20), screen_width/4- scaleWithSize(20), scaleWithSize(20))];
                labelName.text = model.permissionName;
                labelName.textAlignment = 1;
                labelName.backgroundColor = [UIColor clearColor];
                labelName.font = fontSize(11);
                [butLv addSubview:labelName];
                numberCount ++;
            }
        }
    }
}

- (void)buttonListClick:(UIButton *)sender {
    NSLog(@"等级特权的点击查看详情==%ld",sender.tag);
     MXssFindPermissionModel *model = self.modelArr[sender.tag-1];
     [self addIntegralDetailView:self.modelArr[sender.tag-1] NSStringImage:model.imgUrl NSStringTitle:model.permissionName NSStringContentStr:model.content];
//    if (model.hasPermission.integerValue == 0) {
//         [self addIntegralDetailView:self.modelArr[sender.tag-1] NSStringImage:[NSString stringWithFormat:@"my_dengjitequan_xiao%ld_hui",sender.tag] NSStringTitle:model.permissionName NSStringContentStr:model.content];
//    } else {
//
//         [self addIntegralDetailView:self.modelArr[sender.tag-1] NSStringImage:[NSString stringWithFormat:@"my_dengjitequan_xiao%ld",sender.tag] NSStringTitle:model.permissionName NSStringContentStr:model.content];
//    }
}

//增加一个弹窗
- (void)addIntegralDetailView:(UIImage *)showImage NSStringImage:(NSString *)numimage NSStringTitle:(NSString *)titleStr NSStringContentStr:(NSString *)content{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    IntegralDetailView *detailView = [[IntegralDetailView alloc]initWithFrame:window.frame withImage:showImage];
    detailView.numberimg =  numimage;
    detailView.contentLabelStr = content;
    detailView.titleLabelStr = titleStr;
    [window addSubview:detailView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
