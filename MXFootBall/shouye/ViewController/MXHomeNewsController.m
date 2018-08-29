//
//  MXHomeNewsController.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/6/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeNewsController.h"
#import "MXHomeNewsCell.h"//三张图片的cell
#import "MXOtherNewsCell.h"//一张图片的cell
#import "MXHomeVM.h"
#import "MXSYJPostDetailsController.h"
#import "MXADTableViewCell.h"//广告cell
#import "WKViewController.h"

@interface MXHomeNewsController ()<UITableViewDelegate, UITableViewDataSource, RefreshTableViewDelegate> {
    MXHomeVM *_homeVM;
}

@property (weak, nonatomic) IBOutlet JJRefreshTabView *newsTab;

@end

@implementation MXHomeNewsController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadNewsDataWithRefresh:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -- data
- (void)initVMBinding {
    _homeVM = [[MXHomeVM alloc] init];
    [self loadNewsDataWithRefresh:YES];
}

- (void)loadNewsDataWithRefresh:(BOOL)isRefresh {
    [SVProgressHUD showWithStatus:@"正在加载"];
    @weakSelf(self);
    [_homeVM getHomeNewsWithRefresh:isRefresh type:self.type success:^(BOOL result) {
        [SVProgressHUD dismiss];
        
        if (_homeVM.dataArr.count) {
            weakSelf.newsTab.isShowMore = YES;
        }
        //加载更多的时候，新请求到的数据和之前的数据条数一样且不为0或者没有数据，则是没有更多数据了，不显示加载更多
        if ((!isRefresh && _homeVM.dataArr.count%10 != 0) || !_homeVM.dataArr.count) {
            weakSelf.newsTab.isShowMore = NO;
        }
        
        [weakSelf.newsTab reloadData];
    } failture:^(NSString *error) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"请求失败"];
    }];
}

#pragma mark - refresh
- (void)refreshTableViewHeader {
//    if ([self.delegate respondsToSelector:@selector(refreshNewsData)]) {
//        [self.delegate refreshNewsData];
//    }
    [self loadNewsDataWithRefresh:YES];
}

- (void)refreshTableViewFooter {
//    if ([self.delegate respondsToSelector:@selector(loadMoreNewsData)]) {
//        [self.delegate loadMoreNewsData];
//    }
    [self loadNewsDataWithRefresh:NO];
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _homeVM.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MXNews *news = _homeVM.dataArr[indexPath.row];
    if (!news.forumImgs.count) {
        if (news.advertPic) {//广告cell
            return screen_width*5/32;
        }
        return 100;//一张图片cell
    }
    CGFloat height = [MXHomeNewsCell cellHeightWithString:news.title]+130;
    return height;//三张图片cell
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UITableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ADView"];
//    UIImageView *adView = [UIImageView new];
//    if (!footer) {
//        footer = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"ADView"];
//        adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width*5/32)];
//        [footer addSubview:adView];
//        //320:100 = 375:x
//        //375*100/320
//    }
//    MXAdvert *ad = _homeVM.advertsArr[section];
//    [adView sd_setImageWithURL:[NSURL URLWithString:ad.advertPic] placeholderImage:Image(@"adPlace") options:SDWebImageAllowInvalidSSLCertificates];
//    return footer;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MXNews *news = _homeVM.dataArr[indexPath.row];
    if (news.forumImgs.count) {
        MXHomeNewsCell *cell = [MXHomeNewsCell myCellWithTableview:tableView];
        [cell setDataWithModel:news];
        return cell;
    } else {
        if (news.advertPic) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"adcell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"adcell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            UIImageView *adview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_width*5/32)];
            [adview sd_setImageWithURL:[NSURL URLWithString:news.advertPic] placeholderImage:Image(@"adPlace") options:SDWebImageAllowInvalidSSLCertificates];
            [cell.contentView addSubview:adview];
            return cell;
        }
        MXOtherNewsCell *cell = [MXOtherNewsCell myCellWithTableview:tableView];

        [cell setDataWithModel:news];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MXNews *model = _homeVM.dataArr[indexPath.row];
    if (model.advertPic) {
        NSString *idStr = [NSString stringWithFormat:@"%ld", model.advertId];
        NSDictionary *jsondic = [NSDictionary dictionaryWithObjectsAndKeys:idStr, @"id", nil];
        NSString *content = [MXLJUtil dictionaryToJson:jsondic];
        [UBT logCode:@"ad" content:content];
        
        WKViewController *wk = [[WKViewController alloc] init];
        NSString *str = [model.targetUrl stringByReplacingOccurrencesOfString:@"https:" withString:@"http:"];
        //不知道为嘛https打不开
        wk.url = str;
//        wk.wktitle = model.title;
        [self.navigationController pushViewController:wk animated:YES];
    } else {
        MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
        if (model.articleType == 0) {
            vc.type = 200;
        }
        vc.articleType = model.articleType;
        vc.newsID = [NSString stringWithFormat:@"%ld", model.newsId];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- ui
- (void)initUIView {
    [self setupTable];
}

- (void)setupTable {
    self.newsTab.refreshDelegate = self;
    self.newsTab.CanRefresh = YES;
    self.newsTab.lastUpdateKey = NSStringFromClass([self class]);
    self.newsTab.isShowMore = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
