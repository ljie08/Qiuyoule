//
//  MXSSMyOpinionNOSettledViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/14.
//  Copyright © 2018年 zt. All rights reserved.
//观点待结算

#import "MXSSMyOpinionNOSettledViewController.h"
#import "MXSSMyOpinionNOSettledTableViewCell.h"//我的观点待结算cell
#import "MXssSupotOrPostModel.h"//个人投票/观点model
@interface MXSSMyOpinionNOSettledViewController ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation MXSSMyOpinionNOSettledViewController
- (void)setOpinionNoArr:(NSMutableArray *)OpinionNoArr {
    _OpinionNoArr = OpinionNoArr;
    [self.mainTableview reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableview];
}

#pragma mark-set/get
-(UITableView *)mainTableview{
    if (_mainTableview == nil) {
        _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME- scaleWithSize(94)) style:UITableViewStylePlain];
        _mainTableview.delegate = self;
        _mainTableview.dataSource = self;
        //        _mainTableview.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏整体cell线
        //        _mainTableview.backgroundColor = kWhiteColor;
        _mainTableview.backgroundColor = [UIColor clearColor];
        [_mainTableview registerClass:[MXSSMyOpinionNOSettledTableViewCell class] forCellReuseIdentifier:@"collectionCell"];
        _mainTableview.showsVerticalScrollIndicator = false;//上下滑动关闭滚动的显示
         _mainTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        //        _mainTableview.showsVerticalScrollIndicator = false;
        /**
         *  将tableview的分割线补满
         */
        if ([_mainTableview respondsToSelector:@selector(setSeparatorInset:)]) {
            [_mainTableview setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_mainTableview respondsToSelector:@selector(setLayoutMargins:)]) {
            [_mainTableview setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _mainTableview;
}
#pragma mark mainTableView delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.OpinionNoArr.count>0) {
        return self.OpinionNoArr.count;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return scaleWithSize(90);
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 0) {
    static NSString *CellIdentifier = @"collectionCell";//cell重用问题
    MXSSMyOpinionNOSettledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
    if (!cell) {
        cell = [[MXSSMyOpinionNOSettledTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //            cell.accessoryType = UITableViewCellSelectionStyleNone;//隐藏线cell
    cell.selectionStyle = UITableViewCellStyleDefault;//禁止选中
    //    cell.textLabel.text = @"ahsjrtr";
    //    MXssFansModel *model = bigCaiPiaoArrHome[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
//   Opinion
    if (self.OpinionNoArr.count>0) {
        MXssSupotOrPostModel *model = self.OpinionNoArr[indexPath.row]; //个人投票/观点model
        cell.myOpinionNOSettledNameLabel.text = [NSString stringWithFormat:@"%@ vs %@",model.homeNm,model.awayNm];
        cell.myOpinionNOSettledContentLabel.text = model.reason;//推荐理由
        cell.myOpinionNOSettledTitleNameLabel.text = [NSString stringWithFormat:@"%@ - %d%%",model.username,(int)(model.hitRate.doubleValue*100)];
        [cell.myOpinionNOSettledTouImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.headerPic]] placeholderImage:[UIImage imageNamed:@"saishi_morentouxiang"]];
        cell.myOpinionNOSettledNumberLabel.text = model.support;
        if (model.hit.intValue == 1) {//是否命中
            cell.myOpinionNOSettledOrNoBigImage.image = [UIImage imageNamed:@"my_mingzhong"];
        }else  if (model.hit.intValue == 0){
            cell.myOpinionNOSettledOrNoBigImage.image = [UIImage imageNamed:@"my_weizhong"];
        }else  if (model.hit.intValue == 2){
            cell.myOpinionNOSettledOrNoBigImage.image = [UIImage imageNamed:@"my_fengpan"];
        }else {
            cell.myOpinionNOSettledOrNoBigImage.image = [UIImage imageNamed:@""];
    }
        
        cell.myOpinionNOSettledOrNoBigImage.hidden = NO;//不显示
        //是否解锁🔐 isUnlock
        if (model.isUnlock.intValue == 1) {//是否命中
            cell.myOpinionNOSettledOrNoSuoImage.image = [UIImage imageNamed:@""];
        }else {
            cell.myOpinionNOSettledOrNoSuoImage.image = [UIImage imageNamed:@"saishi_suo"];
        }
    }
    return cell;
    
}
// 隐藏多余cell
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{//cell点击
    NSLog(@"观点待结算点击cell?????==%ld",indexPath.row);
    MXssSupotOrPostModel *model = self.OpinionNoArr[indexPath.row];
    [self.delegate goMyOpinionNOSettledViewController:nil withResult:nil andArticleModel:model];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
