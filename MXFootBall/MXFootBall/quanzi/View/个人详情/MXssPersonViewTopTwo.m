//
//  MXssPersonViewTopTwo.m
//  MXFootBall
//
//  Created by Mac on 2018/5/18.
//  Copyright © 2018年 zt. All rights reserved.
//个人详情 圈子话题

#import "MXssPersonViewTopTwo.h"
#import "MXSYJQuanziCell.h"
#import "MXSYJPostDetailsController.h"
#import "MXSYJPostVM.h"
#import "MXSYJFriendsCell.h"
#define kImgWidth (screen_width - 45) / 4
static NSString * const FriendsCell = @"MXSYJFriendsCell";
static NSString * const QuanziCell = @"QuanziCel";
@interface MXssPersonViewTopTwo () <UITableViewDelegate,UITableViewDataSource>{
    
//    NSInteger sengmentSecletIndex;
//    NSInteger isAttention;
//    NSInteger page;
}
//@property (nonatomic, strong) NSMutableArray *circleArr;

@end
@implementation MXssPersonViewTopTwo

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.circleArr = [NSMutableArray array];
//        NSLog(@"🎈🎈%@==",self.ownerId);
        [self mainTabelview];
        [self addSubview:self.mainTabelview];
//        page = 1;
//        self.isHeaderRefresh = YES;
       
    }
    return self;
}
-(void)setCircleArrTwos:(NSMutableArray *)circleArrTwos{
    _circleArrTwos = circleArrTwos;
    [self.mainTabelview reloadData];
}

#pragma mark - 加载tableView
- (UITableView *)mainTabelview{
    if (!_mainTabelview) {
        
    self.mainTabelview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - 170) style:UITableViewStylePlain];
    [self addSubview:self.mainTabelview];
        self.mainTabelview.backgroundColor = mx_Wode_bordColor;
    self.mainTabelview.delegate = self;
    self.mainTabelview.dataSource = self;
    self.mainTabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    [self.tableView registerClass:[MXSYJPersonCell class] forCellReuseIdentifier:personCell];//MXSSMyVoteYESSettledTableViewCell
//    [self.mainTabelview registerClass:[MXSSMyVoteYESSettledTableViewCell class] forCellReuseIdentifier:personCell];
    [self.mainTabelview registerClass:[MXSYJQuanziCell class] forCellReuseIdentifier:QuanziCell];
    [self.mainTabelview registerClass:[MXSYJFriendsCell class] forCellReuseIdentifier:FriendsCell];

    }
    return _mainTabelview;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        
        if (self.circleArrTwos.count > 0) {
            MXSYJFocusOnModel *model = self.circleArrTwos[indexPath.row];
            
            if (model.forumImgs.count > 0) {
                return [self.mainTabelview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width] + kImgWidth;
            }else{
                return [self.mainTabelview cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[MXSYJFriendsCell class] contentViewWidth:screen_width] + 10;
            }
            
        }else{
            return 0;
        }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.circleArrTwos.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

        MXSYJFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendsCell];
        if (self.circleArrTwos.count > 0) {
            cell.model = self.circleArrTwos[indexPath.row];
        }
        return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//cell点击
        MXSYJFocusOnModel *model = self.circleArrTwos[indexPath.row];
//        MXSYJPostDetailsController *vc = [[MXSYJPostDetailsController alloc]init];
//        vc.newsID = model.newsId;
//        vc.userId = [NSString stringWithFormat:@"%d", model.userId];
//        [self.navigationController pushViewController:vc animated:YES];
//    MXssCollectionModel *mdoel = self.collectDataArr[indexPath.row];
    [self.delegate PersonViewTopTwocellClickNext:model];
    
    model.view = model.view + 1 ;
    [self.circleArrTwos replaceObjectAtIndex:indexPath.row withObject:model] ;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:(UITableViewRowAnimationNone)] ;
    
}

@end
