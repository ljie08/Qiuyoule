//
//  JF_CalendarView.m
//  JF_Calendar
//
//  Created by 孙建飞 on 16/5/16.
//  Copyright © 2016年 sjf. All rights reserved.
//

#import "JF_CalendarView.h"
#import "MXssSinginRiliModel.h"//日历返回model


@implementation JF_CalendarView

-(NSMutableArray*)registerArr{
    if (!_registerArr) {
#pragma arguments-初始化应该加载本地或者服务器端签到日期，敲到完成上传或者本地存储；
        _registerArr=[[NSMutableArray alloc]init];
    }
    return _registerArr;
    
}
- (NSMutableArray *)preArr {//之前的月存储数组
    if (!_preArr) {
        _preArr = [NSMutableArray array];
    }
    return _preArr;
}
- (void)setArrayNumberTime:(NSMutableArray *)arrayNumberTime {
    _arrayNumberTime = arrayNumberTime;//当前月的签到存储数组
    [self reloadData];
}
//- (void)setModelData:(MXssSinginRiliModel *)modelData {
//    _modelData = modelData;
//    [self reloadData];
//}
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self=[super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        [self registerClass:[JF_CalendarCell class] forCellWithReuseIdentifier:@"cell"];
        self.scrollEnabled=NO;
       // UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        //layout.minimumInteritemSpacing=0;
        self.delegate=self;
        self.backgroundColor=[UIColor clearColor];
        self.dataSource=self;
        //[self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.year=[JF_CalendarTools getYear];
        self.searchYear=self.year;
        
        self.month=[JF_CalendarTools getMonth];
        self.searchMonth=self.month;
        
        self.day=[JF_CalendarTools getDay];
        self.searchDay=self.day;
        //
        [self.registerArr addObject:[NSString stringWithFormat:@"%.4d%.2d%.2d",self.year,self.month,self.day]];
        
        self.daysOfMonth=[JF_CalendarTools getDaysOfMonthWithYear:self.year withMonth:self.month];
        self.searchDaysOfMonth=self.daysOfMonth;
        self.cellWidth=(frame.size.width-8*5)/7;
        [self setHeaderViewWithWidth:frame.size.width];
     //  NSLog(@"%d",[JF_CalendarTools getWeekOfFirstDayOfMonthWithYear:self.year withMonth:self.month]);
    }
    return self;
}
-(void)setHeaderViewWithWidth:(CGFloat)width{
    NSArray *a=[NSArray arrayWithObjects:@"日", @"一",@"二",@"三",@"四",@"五",@"六",nil];
    [self.headerView removeFromSuperview];
    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 80)];
    //self.headerView.backgroundColor=[UIColor blueColor];
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setFrame:CGRectMake(width-90, 10, 20, 20)];
    [nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"my_you_jiantou.png"] forState:UIControlStateNormal];
   // nextButton.backgroundColor=[UIColor blackColor];
    [self.headerView addSubview:nextButton];
    UIButton *preButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [preButton setFrame:CGRectMake(70, 10, 20, 20)];
    [preButton addTarget:self action:@selector(pre:) forControlEvents:UIControlEventTouchUpInside];
    [preButton setImage:[UIImage imageNamed:@"my_zuo_jiantou.png"] forState:UIControlStateNormal];
   // preButton.backgroundColor=[UIColor blackColor];
    [self.headerView addSubview:preButton];
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 16, 100, 30)];
    dateLabel.textAlignment=1;
    dateLabel.center=CGPointMake(width/2, 20);
    dateLabel.text=[NSString stringWithFormat:@"%d-%.2d",self.searchYear,self.searchMonth];
    dateLabel.textColor = mx_Wode_colorBlue2374e4;
    [self.headerView addSubview:dateLabel];
    UIView *blueView=[[UIView alloc]initWithFrame:CGRectMake(10, 40, width-20, 35)];
//    blueView.backgroundColor=mx_Wode_colorBlue2374e4;//Blue_textColor
    [self.headerView addSubview:blueView];
    CGFloat labelWidth=(width-35)/7;
    for (int i=0; i<7; i++) {
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(i*labelWidth+3, 0, labelWidth, 30)];
        label.text=[a objectAtIndex:i];
        label.textAlignment=1;
//        label.textColor=[UIColor whiteColor];
        label.textColor=[UIColor blackColor];
        [blueView addSubview:label];
    }
    [self addSubview:self.headerView];
}
-(void)next:(UIButton*)sender{
//    NSLog(@"next📷");
    if (self.searchMonth==12) {
        self.searchMonth=1;
        self.searchYear++;
    }else{
        self.searchMonth++;
    }
    // self.searchDay=[JF_CalendarTools getDay]
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timeStr = [NSString stringWithFormat:@"%d-%.2d-%.2d",self.searchYear,self.searchMonth,[JF_CalendarTools getDay]];
//    NSLog(@"🚗🍎=%@",timeStr);
    NSDate * now2 = [dateformatter dateFromString:timeStr];
    //转成时间戳
    NSString *timeSp2 = [NSString stringWithFormat:@"%ld", (long)[now2 timeIntervalSince1970]];
//    NSLog(@"🍎uuuuu= %@",timeSp2);
    self.preArr = [NSMutableArray array];
    [self signInTimeMoreData:timeSp2];
    [self setHeaderViewWithWidth:self.frame.size.width];
    [self reloadData];
}
-(void)pre:(UIButton*)sender{
//    NSLog(@"pre🍎");
    if (self.searchMonth==1) {
        self.searchMonth=12;
        self.searchYear--;
        
    }else{
        self.searchMonth--;
    }
    // self.searchDay=[JF_CalendarTools getDay]
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *timeStr = [NSString stringWithFormat:@"%d-%.2d-%.2d",self.searchYear,self.searchMonth,[JF_CalendarTools getDay]];
    NSDate * now2 = [dateformatter dateFromString:timeStr];
    //转成时间戳
    NSString *timeSp2 = [NSString stringWithFormat:@"%ld", (long)[now2 timeIntervalSince1970]];
self.preArr = [NSMutableArray array];
    [self signInTimeMoreData:timeSp2];
    self.searchDaysOfMonth=[JF_CalendarTools getDaysOfMonthWithYear:self.searchYear withMonth:self.searchMonth];
    [self setHeaderViewWithWidth:self.frame.size.width];
    [self reloadData];
}

#pragma mark ---signInTimeData签到明细(签到时间)
-(void)signInTimeMoreData:(NSString*)nowDate {//签到明细(签到时间)
    [SVProgressHUD showWithStatus:@"正在加载..."];
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    NSString *userid =[NSString stringWithFormat:@"%@",userModel.userId];
    NSString *token = userModel.token;
    NSString *timeStr = [MXLJUtil getNowDateTimeString];
    NSString *url = MXWodeMySignInTime_PATH;//签到明细(签到时间)
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
    [paraDic setObject:userid forKey:@"userId"];//用户ID
    [paraDic setObject:token forKey:@"token"];//用户token
    [paraDic setObject:timeStr forKey:@"time"];//当前Unix时间戳
    [paraDic setObject:nowDate forKey:@"nowDate"];//时间戳
    MXNetWorkConfig *config = [[MXNetWorkConfig alloc] init];
    //    mx_weakify(self);
    [config sMessageCenterWithDic:paraDic urlStr:url success:^(NSDictionary *personDic) {
        NSLog(@"签到明细(签到时间)列表==%@",personDic);
        //        NSDictionary *dic = [personDic objectForKey:@"data"];
        if ([[personDic objectForKey:@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD dismiss];
            // [self.mainTableview.mj_header endRefreshing];
            NSDictionary *riliDict = personDic[@"data"];
            MXssSinginRiliModel *model = [MXssSinginRiliModel modelWithDictionary:riliDict];
            self.preArr = model.signDays.copy;
            if (self.preArr.count > 0) {
                [self reloadData];
            }
        }
        else{
            if ([[personDic objectForKey:@"code"] isEqualToString:@"1005"]) {
//            //请先登录
//            MXLoginViewController *login = [[MXLoginViewController alloc] init];
//            login.isPageNumber = 1;
//            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
//            [self presentViewController:nav animated:YES completion:nil];
                [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
        }else {
            [SVProgressHUD showErrorWithStatus:[personDic objectForKey:@"msg"]];
        }
        }
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   // return _datasourceArr.count;
    return 42;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//定义每个UICollectionCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.cellWidth, self.cellWidth-10);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(80, 17.5, 1, 17.5);
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JF_CalendarCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    int dateNum=(int)indexPath.row-[JF_CalendarTools getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth]+1;
/*
统一日期设置
*/
        //月内
        if (dateNum>=1&&(indexPath.row<self.searchDaysOfMonth+[JF_CalendarTools getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth])) {
            cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum];
//            cell.numLabel.textColor=[UIColor blackColor];
            cell.numLabel.textColor = mx_Wode_color666666;
        }
        //前一个月
        if (dateNum<1) {
           // cell.numLabel.text=@"";
//            cell.numLabel.textColor=[UIColor grayColor];
            cell.numLabel.textColor = mx_Wode_colord9d9d9;
            int days;
            if (self.searchMonth != 1) {
                days=[JF_CalendarTools getDaysOfMonthWithYear:self.searchYear withMonth:self.searchMonth-1];
            }else if(self.searchMonth == 1){
                days=[JF_CalendarTools getDaysOfMonthWithYear:self.searchYear-1 withMonth:12];
            }
             cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum+days];
        }
        //后一个月
        if (dateNum>self.searchDaysOfMonth) {
            cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum-self.searchDaysOfMonth];
//            cell.numLabel.textColor=[UIColor grayColor];
            cell.numLabel.textColor = mx_Wode_colord9d9d9;
        }
/*
背景颜色设置
*/
    //当前月
    if ([NSString stringWithFormat:@"%d%.2d",self.year,self.month].intValue==[NSString stringWithFormat:@"%d%.2d",self.searchYear,self.searchMonth].intValue) {
        cell.numLabel.backgroundColor=[UIColor whiteColor];
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
//        NSString *string1 = [NSString stringWithFormat:@"%d-%.2d-%.2d",self.searchYear,self.searchMonth,dateNum];
        for (int i = 0; i < self.arrayNumberTime.count; i++) {
            NSString *string3 = [NSString stringWithFormat:@"%@",self.arrayNumberTime[i]];//从字符串的开头截取到指定位置，但是切记标记是从0开始，不包括5位置的字符
//            NSString *string1 = [NSString stringWithFormat:@"%d-%.2d-%.2d",self.searchYear,self.searchMonth,dateNum];
//           NSLog(@"签到颜色🍎???=%@,%@",string3,string1);
            if (string3.intValue==dateNum) {
//            NSLog(@"签到颜色🍎???=%@,%ld",string1,self.arrayNumberTime.count);
                //月内
                if (dateNum>=1&&(dateNum<=self.searchDay)) {
                    //            cell.numLabel.backgroundColor=Gray_textColor;
                    cell.numLabel.layer.borderColor = mx_Wode_colorBlue2374e4.CGColor;
                    cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum];
                    cell.numLabel.textColor = mx_Wode_colorBlue2374e4;
                    cell.numLabel.layer.borderWidth=1;
                }
            }
        }
    }
    //之后的月
    if ([NSString stringWithFormat:@"%d%.2d",self.year,self.month].intValue<[NSString stringWithFormat:@"%d%.2d",self.searchYear,self.searchMonth].intValue) {
//        NSLog(@"大于🍌");
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
         cell.numLabel.backgroundColor=[UIColor whiteColor];
    }
    //之前的月
    if ([NSString stringWithFormat:@"%d%.2d",self.year,self.month].intValue>[NSString stringWithFormat:@"%d%.2d",self.searchYear,self.searchMonth].intValue) {
//        NSLog(@"小于🍊");
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
        cell.numLabel.backgroundColor=[UIColor whiteColor];
        //月内
        if (dateNum>=1&&(indexPath.row<self.searchDaysOfMonth+[JF_CalendarTools getWeekOfFirstDayOfMonthWithYear:self.searchYear withMonth:self.searchMonth])) {
//            cell.numLabel.backgroundColor=Gray_textColor;
            
            for (int i = 0; i < self.preArr.count; i++) {
//                MXssSinginRiliModel *modelRili = self.preArr[i];
//                NSString *string3 = [modelRili.createTime substringToIndex:10];//从字符串的开头截取到指定位置，但是切记标记是从0开始，不包括5位置的字符
                NSString *string3 = [NSString stringWithFormat:@"%@",self.preArr[i]];
//                NSString *string1 = [NSString stringWithFormat:@"%d-%.2d-%.2d",self.searchYear,self.searchMonth,dateNum];
                if (string3.intValue==dateNum) {
//                    NSLog(@"签到颜色🍎???=%@,%.2d",string3,dateNum);
            cell.numLabel.layer.borderColor = mx_Wode_colorBlue2374e4.CGColor;
            cell.numLabel.textColor = mx_Wode_colorBlue2374e4;//之前的月份日期颜色显示
            cell.numLabel.text=[NSString stringWithFormat:@"%d",dateNum];
            cell.numLabel.layer.borderWidth=1;
                }
            }
        }
    }
/*
设置签到颜色
*/
    
#pragma arguments-数组内包含当前日期则说明此日期签到了，设置颜色为蓝色；
    if([self.registerArr containsObject:[NSString stringWithFormat:@"%.4d%.2d%.2d",self.searchYear,self.searchMonth,dateNum]]){
        //NSLog(@"blue");
        cell.numLabel.backgroundColor=mx_Wode_colorBlue2374e4;//Blue_textColor
        cell.numLabel.textColor=[UIColor whiteColor];
        cell.numLabel.layer.masksToBounds=YES;
        cell.numLabel.layer.borderColor=[UIColor grayColor].CGColor;
        cell.numLabel.layer.borderWidth=0;
    }

    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"🍉=%ld",indexPath.row);
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
