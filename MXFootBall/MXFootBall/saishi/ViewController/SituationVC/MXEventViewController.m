//
//  MXEventViewController.m
//  MXFootBall
//
//  Created by YY on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//
#import "MXEventModel.h"
#import "MXEventTableFootView.h"
#import "MXEventCell.h"
#import "MXEventViewController.h"
@interface MXEventViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation MXEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MXEventCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MXEventCell class])];
    self.tableView.placeHolderView=[[YYTableViewNoDataView alloc] initWithFrame:self.tableView.bounds titleInfo:@"暂无数据" viewClick:^{
        
    } andTitleColor:[UIColor blackColor]];
    MXEventTableFootView *footView=[[MXEventTableFootView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 80)];
    footView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableFooterView=footView;
    self.tableView.tableFooterView.hidden=YES;
    [MXNotificationDefaultCenter addObserver:self selector:@selector(receivedNoti:) name:@"chatInfoNotification" object:nil];
}
-(void)receivedNoti:(NSNotification *)noti{
    NSDictionary *message=noti.userInfo;
    if ([[message objectForKey:@"msgType"] isEqualToString:@"allmsg"]) {
        if (message[@"messageModel"]!=[NSNull null]&& message[@"messageModel"][@"matchInfoList"]!=[NSNull null]) {
            NSArray *matchInfoList= message[@"messageModel"][@"matchInfoList"];
            self.dataArr=[MXEventModel mj_objectArrayWithKeyValuesArray:matchInfoList];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                self.tableView.tableFooterView.hidden=NO;
            });
        }
        if (message[@"messageModel"]!=[NSNull null]&& message[@"messageModel"][@"matchInfo"]!=[NSNull null]) {
            NSDictionary *matchInfo=message[@"messageModel"][@"matchInfo"];
            MXEventModel *model=[MXEventModel mj_objectWithKeyValues:matchInfo];
            [self.dataArr addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                self.tableView.tableFooterView.hidden=NO;
            });
        }
    }
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width,screen_height-scaleWithSize(260)-44-STATUS_AND_NAVIGATION_HEIGHT-TABBAR_FRAME - self.adHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MXEventCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MXEventCell class])];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.model=self.dataArr[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
//    [self receivedNoti:<#(NSNotification *)#>] ;
    [MXNotificationDefaultCenter addObserver:self selector:@selector(receivedNoti:) name:@"chatInfoNotification" object:nil];
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"事件统计界面\"}"];
}
-(void)viewWillDisappear:(BOOL)animated{
//    [[MXSocketManager manager] disConnect];
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"事件统计界面\"}"];
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
