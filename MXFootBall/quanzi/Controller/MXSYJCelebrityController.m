//
//  MXSYJCelebrityController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/23.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCelebrityController.h"
#import "MXSYJCellView.h"
#import "MXSYJCelebrityCell.h"
#import "MXSYJDIYButton.h"
#import "MXSYJWebViewController.h"
#import "MXSYJHallModel.h"
#import "MXSYJPersonController.h"

#define KviewWidth (screen_width - 60) / 3

static NSString *CelebrityID = @"CelebrityID";

@interface MXSYJCelebrityController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
/** 自定义view */
@property (nonatomic, strong) UIView *customeView;

@property (nonatomic, strong) MXSYJHallModel *hallModel;
@property (nonatomic , assign)BOOL isHeaderRefresh;
@end

@implementation MXSYJCelebrityController

- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    //    [UBT logTrace:@"residenceTimeOut"; content:@"{\"VC\":\"\u9996\u9875\"}";
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"名人堂界面\"}"];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"名人堂界面\"}"];

    
    //设置返回按钮是否显示
    [self setBackButton:YES];
    //设置标题
    [self initTitleViewWithTitle:@"名人堂"];
    //设置背景图片
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"163"]];
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imagesTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(163))];
    imagesTop.image = [UIImage imageNamed:@"163"];
    [self.view addSubview:imagesTop];
    self.view.backgroundColor = mx_luntan_mingrentang_colore7180e;//名人堂颜色等待UI给色值
    
    //加载tableView
    [self setTableView];
    
    //加载按钮
    [self setBtn];
    
    //加载网络
    [self getNetWork];
    
    //上拉下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        self.isHeaderRefresh = YES;
        //加载网络
        [self getNetWork];
    }];
}

- (void)getNetWork{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
//    [params setObject:[MXssWodeUtils loadPersonInfo].token forKey:@"token"];
//    [params setObject:[MXssWodeUtils loadPersonInfo].userId forKey:@"userId"];
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:params];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:[NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemFameHallPATH] WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        if ([dic[@"code"] isEqualToString:@"0"]) {
            NSLog(@"%@",dic);
            //加载处理
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
            if (self.isHeaderRefresh == YES) {
//            [weakSelf.modelArr removeAllObjects];
            }
            self.hallModel = [MXSYJHallModel mj_objectWithKeyValues:dic[@"data"]];
            if (self.hallModel.hitTable.count > 3) {
                self.tableView.tableHeaderView = self.customeView;
                [self.tableView reloadData];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:dic[@"msg"]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        
        [SVProgressHUD showSuccessWithStatus:@"请求错误"];
    }];
}

#pragma mark - set UI
- (void)setBtn{
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:btn];
//    btn.titleLabel.textAlignment = NSTextAlignmentRight;
//    [btn setImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
//    [btn.titleLabel setFont:fontBoldSize(12)];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitle:@"达人等级说明" forState:UIControlStateNormal];
////    btn.sd_layout.leftSpaceToView(self.view, 30).bottomSpaceToView(self.view, 20).heightIs(40).widthIs(160);
//    btn.tag = 1;
//    [btn addTarget:self action:@selector(clcik:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn1];
    btn1.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn1 setImage:[UIImage imageNamed:@"wenhao"] forState:UIControlStateNormal];
    [btn1.titleLabel setFont:fontBoldSize(12)];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"排名计算公式" forState:UIControlStateNormal];
    btn1.sd_layout.rightSpaceToView(self.view, 30).bottomSpaceToView(self.view, 20).widthIs(160).heightIs(40);
    btn1.tag = 2;
    [btn1 addTarget:self action:@selector(clcik:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clcik:(UIButton *)sender{
    
    if (sender.tag == 1) {
        NSLog(@"达人等级说明");
        MXSYJWebViewController *webVC = [MXSYJWebViewController new];
        if (self.hallModel.illustrates.count > 0) {
            Illustrates *model = self.hallModel.illustrates[0];
            webVC.url = model.targetUrl;
        }
        [self.navigationController pushViewController:webVC animated:YES];
        
    }else{
        NSLog(@"排名计算公式");
        MXSYJWebViewController *webVC = [MXSYJWebViewController new];
        if (self.hallModel.illustrates.count > 0) {
            Illustrates *model = self.hallModel.illustrates[1];
            webVC.url = model.targetUrl;
        }
        [self.navigationController pushViewController:webVC animated:YES];
    }
    
}



- (void)setTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 35, screen_width - 60, screen_height-200) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sd_cornerRadius = @5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 5;
    [self.tableView registerClass:[MXSYJCelebrityCell class] forCellReuseIdentifier:CelebrityID];
    
}

- (UIView *)customeView{
    
    
    if (_customeView == nil ) {
        _customeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width - 60, 200)];
        _customeView.backgroundColor = [UIColor clearColor];
        
        UIView *backgroud = [[UIView alloc]init];
        [_customeView addSubview:backgroud];
        backgroud.backgroundColor = [UIColor whiteColor];
        backgroud.frame = CGRectMake(0, 80, screen_width - 60 , 120);
        
        UIBezierPath *fieldPath = [UIBezierPath bezierPathWithRoundedRect:backgroud.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
        CAShapeLayer *fieldLayer = [[CAShapeLayer alloc] init];

        fieldLayer.frame = backgroud.bounds;

        fieldLayer.path = fieldPath.CGPath;

        backgroud.layer.mask = fieldLayer;
        
        mx_weakify(self);
        
        MXSYJCellView *cellView1 = [[MXSYJCellView alloc]init];
        [_customeView addSubview:cellView1];
        cellView1.sd_layout.topSpaceToView(_customeView, 40).centerXEqualToView(backgroud).heightIs(120).widthIs(KviewWidth);
        cellView1.click = ^{
            NSLog(@"click事件");
            MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
            HitTable *hitModel1 = self.hallModel.hitTable[0];
            vc.ownerId = hitModel1.userId;
            vc.ownerName = hitModel1.username;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cellView1.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = cellView1.bounds;
            maskLayer.path = maskPath.CGPath;
            cellView1.layer.mask = maskLayer;
        
        
        /// 线的路径
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
        [bezierPath addLineToPoint:CGPointMake(0.0, cellView1.frame.size.height - 30)];
        [bezierPath moveToPoint:CGPointMake(cellView1.frame.size.width, 0.0f)];
        [bezierPath addLineToPoint:CGPointMake(cellView1.frame.size.width, cellView1.frame.size.height - 30)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.strokeColor = mx_LineColor.CGColor;
        shapeLayer.fillColor  = [UIColor clearColor].CGColor;
        ///添加路径
        shapeLayer.path = bezierPath.CGPath;
        /// 线宽度
        shapeLayer.lineWidth = 1.0;
        [cellView1.layer addSublayer:shapeLayer];
        
        HitTable *hitModel1 = self.hallModel.hitTable[0];
        [cellView1.iconImg sd_setImageWithURL:[NSURL URLWithString:hitModel1.headerPic] placeholderImage:[UIImage imageNamed:@"tu1"]];
        cellView1.nameLab.text = hitModel1.username;
        cellView1.descLab.text = [NSString stringWithFormat:@"命中率%.2f%@",hitModel1.hitRate * 100,@"%"];
        cellView1.rankingLab.hidden = YES;
        cellView1.rankingImg.hidden = NO;


        MXSYJCellView *cellView2 = [[MXSYJCellView alloc]init];
        [backgroud addSubview:cellView2]; cellView2.sd_layout.centerYEqualToView(backgroud).heightIs(120).widthIs(KviewWidth).rightSpaceToView(cellView1, 0);

        cellView2.click = ^{
            NSLog(@"click事件");
            MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
            HitTable *hitModel1 = self.hallModel.hitTable[1];
            vc.ownerId = hitModel1.userId;
            vc.ownerName = hitModel1.username;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };

        UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:cellView2.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(7, 7)];
        CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
        maskLayer1.frame = cellView2.bounds;
        maskLayer1.path = maskPath1.CGPath;
        cellView2.layer.mask = maskLayer1;
        
        HitTable *hitModel2 = self.hallModel.hitTable[1];
        [cellView2.iconImg sd_setImageWithURL:[NSURL URLWithString:hitModel2.headerPic] placeholderImage:[UIImage imageNamed:@"tu1"]];
        cellView2.nameLab.text = hitModel2.username;
        cellView2.descLab.text = [NSString stringWithFormat:@"命中率%.2f%@",hitModel1.hitRate * 100,@"%"];
        cellView2.rankingLab.text = @"2";
        


        MXSYJCellView *cellView3 = [[MXSYJCellView alloc]init];
        [backgroud addSubview:cellView3];
        cellView3.sd_layout.centerYEqualToView(backgroud).heightIs(120).widthIs(KviewWidth).leftSpaceToView(cellView1, 0);
        cellView3.click = ^{
            NSLog(@"click事件");
            MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
            HitTable *hitModel1 = self.hallModel.hitTable[2];
            vc.ownerId = hitModel1.userId;
            vc.ownerName = hitModel1.username;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };

        UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:cellView3.bounds byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(7, 7)];
        CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
        maskLayer2.frame = cellView3.bounds;
        maskLayer2.path = maskPath2.CGPath;
        cellView3.layer.mask = maskLayer2;
        
        HitTable *hitModel3 = self.hallModel.hitTable[2];
        [cellView3.iconImg sd_setImageWithURL:[NSURL URLWithString:hitModel3.headerPic] placeholderImage:[UIImage imageNamed:@"tu1"]];
        cellView3.nameLab.text = hitModel3.username;
        cellView3.descLab.text = [NSString stringWithFormat:@"命中率%.2f%@",hitModel1.hitRate * 100,@"%"];
        cellView3.rankingLab.text = @"3";
        
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = mx_LineColor;
        [backgroud addSubview:line];
        line.sd_layout.leftSpaceToView(backgroud, 0).rightSpaceToView(backgroud, 0).bottomSpaceToView(backgroud, 0.5).heightIs(0.5);
        
    }
    
    return _customeView;
    
    
    
}


#pragma mark - table view dataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hallModel.hitTable.count - 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MXSYJCelebrityCell *cell = [tableView dequeueReusableCellWithIdentifier:CelebrityID];
    if (self.hallModel.hitTable.count > 0) {
        HitTable *model = self.hallModel.hitTable[indexPath.row + 3];
        model.num = indexPath.row + 4;
        cell.model = model;
    }
    
    

    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"点击了第%ld个",(long)indexPath.row);
    MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
    HitTable *hitModel1 = self.hallModel.hitTable[indexPath.row + 3];
    vc.ownerId = hitModel1.userId;
    vc.ownerName = hitModel1.username;
    [self.navigationController pushViewController:vc animated:YES];
    
}




@end
