//
//  MXOddsHotAndColdViewController.m
//  MXFootBall
//
//  Created by dai on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOddsHotAndColdViewController.h"

#import "MXOuZhiTitleTableViewCell.h"

#import "MXOddsTableViewCell.h"

@interface MXOddsHotAndColdViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isBetfairTrading ; //是否必发交易
}

@property (nonatomic , strong) UIButton * betfairTradingBtn ;

@property (nonatomic , strong) UIButton * largeTransactionBtn ;

@property (nonatomic , strong) UITableView * mainTableView ;


@end

@implementation MXOddsHotAndColdViewController


- (UIButton *)betfairTradingBtn {
    if (!_betfairTradingBtn) {
        _betfairTradingBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _betfairTradingBtn.backgroundColor = [UIColor whiteColor];
        _betfairTradingBtn.titleLabel.font = fontSize(scaleWithSize(13));
        [_betfairTradingBtn setTitle:@"必发交易" forState:UIControlStateNormal];
        [_betfairTradingBtn setSelected:YES];
        [_betfairTradingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_betfairTradingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _betfairTradingBtn.selected = YES ;
        _betfairTradingBtn.tag = 201;
        [_betfairTradingBtn addTarget:self action:@selector(TransactionBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _betfairTradingBtn ;
}
- (UIButton *)largeTransactionBtn {
    if (!_largeTransactionBtn) {
        _largeTransactionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _largeTransactionBtn.backgroundColor = [UIColor whiteColor];
        _largeTransactionBtn.titleLabel.font = fontSize(scaleWithSize(13));
        [_largeTransactionBtn setTitle:@"大额交易" forState:UIControlStateNormal];
        [_largeTransactionBtn setSelected:YES];
        [_largeTransactionBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_largeTransactionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        _largeTransactionBtn.selected = NO ;
        _largeTransactionBtn.tag = 202;
        [_largeTransactionBtn addTarget:self action:@selector(TransactionBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _largeTransactionBtn ;
}

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - (STATUS_AND_NAVIGATION_HEIGHT)  - scaleWithSize(100 + 44 + 30)) style:(UITableViewStyleGrouped)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = mx_Wode_backgroundColor;
        
        [_mainTableView registerClass:[MXOddsTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@",[MXOddsTableViewCell class]]];
        [_mainTableView registerClass:[MXOuZhiTitleTableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"%@1",[MXOuZhiTitleTableViewCell class]]];
        
        /**
         *  将tableview的分割线补满
         */
        if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    return _mainTableView ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mx_Wode_backgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO ;
    
    isBetfairTrading = NO ;
    
    [self.view addSubview:self.mainTableView];
    
}


- (void)TransactionBtn:(UIButton *)button {
    _largeTransactionBtn.selected = NO;
    _betfairTradingBtn.selected = NO;
    if (button.tag == 201) {
        _betfairTradingBtn.selected = YES ;
        isBetfairTrading = NO;
    } else {
        _largeTransactionBtn.selected = YES;
        isBetfairTrading = YES;
    }
    
    [self.mainTableView reloadData];
}


#pragma mark TableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (! isBetfairTrading) {
            return 4;
        }
        return 10 ;
    }
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return scaleWithSize(30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {

        static NSString *CellIdentifier = @"MXOddsTableViewCell";//cell重用问题
        MXOddsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell) {
            cell = [[MXOddsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        

        if (!isBetfairTrading) {
            if (indexPath.row == 0) {
                cell.companyLabel.text = @"选项" ;
                cell.firstInitialLabel.text = @"成交价" ;
                cell.secondInitialLabel.text = @"成交量" ;
                cell.thirdInitialLabel.text = @"庄家盈亏" ;
                cell.fourthInitialLabel.text = @"冷热指数" ;
            } else {
                cell.companyLabel.text = @"主胜" ;
                cell.firstInitialLabel.text = @"1.40" ;
                cell.secondInitialLabel.text = @"99,483" ;
                cell.thirdInitialLabel.text = @"-6,720" ;
                cell.fourthInitialLabel.text = @"9" ;
            }
        } else {
            
            cell.companyLabel.frame = CGRectMake(scaleWithSize(15), 0, scaleWithSize(70), scaleWithSize(30)) ;
            cell.firstInitialLabel.frame = CGRectMake(CGRectGetMaxX(cell.companyLabel.frame), 0, scaleWithSize(50), scaleWithSize(30)) ;
            cell.secondInitialLabel.frame = CGRectMake(CGRectGetMaxX(cell.firstInitialLabel.frame), 0, scaleWithSize(50), scaleWithSize(30)) ;
            cell.thirdInitialLabel.frame = CGRectMake(CGRectGetMaxX(cell.secondInitialLabel.frame), 0, scaleWithSize(50), scaleWithSize(30)) ;
            cell.fourthInitialLabel.frame = CGRectMake(CGRectGetMaxX(cell.thirdInitialLabel.frame), 0,screen_width - CGRectGetMaxX(cell.thirdInitialLabel.frame), scaleWithSize(30)) ;
            
            if (indexPath.row == 0) {
                cell.companyLabel.text = @"成交量" ;
                cell.firstInitialLabel.text = @"选项" ;
                cell.secondInitialLabel.text = @"买卖" ;
                cell.thirdInitialLabel.text = @"占比" ;
                cell.fourthInitialLabel.text = @"时间" ;
            } else {
                cell.companyLabel.text = @"13,155" ;
                cell.firstInitialLabel.text = @"主胜" ;
                cell.secondInitialLabel.text = @"未知" ;
                cell.thirdInitialLabel.text = @"76.1%" ;
                cell.fourthInitialLabel.text = @"18-03-22 19:13" ;
            }
//            cell.firstLeLabel.hidden = YES ;
//            cell.secondLeLabel.hidden = YES ;
//            cell.thirdLeLabel.hidden = YES ;
//            cell.fourthLeLabel.hidden = YES ;
        }
        
        return cell ;

    }
    
    
    static NSString *CellIdentifier1 = @"MXOuZhiTitleTableViewCell1";//cell重用问题
    MXOuZhiTitleTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell1) {
        cell1 = [[MXOuZhiTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier1];
    }
    
    
    if (indexPath.row == 0) {
        cell1.companyLabel.text = @"选项";
        cell1.oddsLabel.text = @"百家欧赔";
        cell1.returnRateLabel.text = @"必发";
        cell1.kellyLabel.text = @"竞彩";
    } else {
        cell1.companyLabel.text = @"主胜";
        cell1.oddsLabel.text = @"68.78%";
        cell1.returnRateLabel.text = @"75.05%";
        cell1.kellyLabel.text = @"0.00%";
    }
    
    
    return cell1 ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return scaleWithSize(200) ;
    }
    return scaleWithSize(30) ;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(200))] ;
        headerView.backgroundColor = [UIColor redColor];
        
        return headerView ;
    } else {
        UIView * titleView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(30))] ;
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(30))];
        titleLabel.text = @"交易分布分布对比";
        titleLabel.textColor = kColorWithRGBF(0x2374e4);
        [titleView1 addSubview:titleLabel];
        
        return titleView1 ;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return scaleWithSize(30) ;
    }
    return scaleWithSize(60) ;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(30))] ;
        footerView.backgroundColor = [UIColor whiteColor];
        
        self.betfairTradingBtn.frame = CGRectMake(0, 0, scaleWithSize(60), scaleWithSize(30));
        self.largeTransactionBtn.frame = CGRectMake(CGRectGetMaxX(self.betfairTradingBtn.frame), 0, scaleWithSize(60), scaleWithSize(30));
        [footerView addSubview:self.betfairTradingBtn];
        [footerView addSubview:self.largeTransactionBtn];
        
        return footerView ;
    } else {
        UIView * footerView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, scaleWithSize(60))] ;
        footerView1.backgroundColor = [UIColor whiteColor];
        UILabel * footerLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(60))];
        footerLabel.text = @"本期比赛必发交易规模适中\n交易量倾向主胜，与百家欧赔平均概率倾向相差较大";
        footerLabel.numberOfLines = 0 ;
        footerLabel.textColor = kColorWithRGBF(0x2374e4);
        [footerView1 addSubview:footerLabel];
        
        return footerView1 ;
    }
    
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
