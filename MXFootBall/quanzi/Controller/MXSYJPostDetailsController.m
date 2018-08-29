//
//  MXSYJPostDetailsController.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJPostDetailsController.h"
#import "MXSYJArticleView.h"
#import "MXSYJArticleModel.h"
#import "MXSYJCommentModel.h"
#import "MXDIYBtn.h"
#import "MXSYJCommentsCell.h"
#import "MXSYJExceptionalVC.h"
#import "MXSYJFocusOnModel.h"
#import "MXSYJCommentModel.h"
#import "MXSYJCommentView.h"
#import "UITextView+placeHolder.h"
#import "MXSYJPostVM.h"
#import "NSString+MXMD5.h"
#import "MXSYJAdModel.h"
#import "MXSYJWebViewController.h"
#import "MXSYJPersonController.h"

//#import "MXOfficialDetailCell.h"//资讯详情header

static NSString * const CommentsCell = @"CommentsCell";


@interface MXSYJPostDetailsController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate, MXSYJCommentsCellDelegate, MXHeaderViewDelegate>{
    MXDIYBtn *btn1;
    MXDIYBtn *btn2;
    NSInteger isClick;
    MXSYJFocusOnModel *_model;
    NSIndexPath *_currentEditingIndexthPath;
//    UITextView  *_textViewKeyBord;
    CGFloat _totalKeybordHeight;
    
    BOOL isFinsh;
    BOOL isCommentOrReply;
    NSInteger page;
    NSInteger limit;
}


@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MXSYJArticleView *headerView;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) NSMutableArray *arrList;//所有评论列表
@property (nonatomic, strong) NSMutableArray *arrOnlyPoster;//只看楼主列表
@property (nonatomic, strong) MXSYJCommentView *commentView;

@property (nonatomic, assign, getter=isMark) BOOL mark;

@property (nonatomic, copy) NSString *postAuthor;//帖子作者
@property (nonatomic, copy) NSString *userName;//帖子作者
@property (nonatomic, copy) NSString *headerUrl;

@property (nonatomic, strong) UIButton *upDataButton;

@property (nonatomic, strong) MXSYJCommentModel *currentModel;
//需要缓存的文章信息
@property (nonatomic, strong) NSMutableDictionary *articleCacheDic;
//缓存的总dic
@property (nonatomic, strong) NSMutableDictionary *cacheDics;

@property (nonatomic, strong) UIView *loadingView;

//@property (nonatomic, assign) CGFloat webHeight;//资讯详情高度

@end

@implementation MXSYJPostDetailsController

- (NSMutableDictionary *)articleCacheDic{
    if (!_articleCacheDic) {
        _articleCacheDic = [NSMutableDictionary dictionary];
    }
    return _articleCacheDic;
}

- (NSMutableDictionary *)cacheDics{
    if (!_cacheDics) {
        _cacheDics = [NSMutableDictionary dictionary];
    }
    return _cacheDics;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //监听评论自适应
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:UITextViewTextDidChangeNotification object:self.commentView.textView];
    
    [self setBackButton:YES];
    if (self.articleType) {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"帖子详情界面\"}"];
        [self initTitleViewWithTitle:@"帖子详情"];
    } else {
        [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"资讯详情界面\"}"];
        [self initTitleViewWithTitle:@"资讯详情"];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}
- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self.commentView.textView];
    
    if (self.type == 200) {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"资讯详情界面\"}"];
    } else {
        [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"帖子详情界面\"}"];
    }
}

//懒加载
- (UIView *)sectionView{
    
    if (_sectionView == nil) {
        _sectionView = [[UIView alloc]init];
        _sectionView.backgroundColor = mx_Wode_bordColor;
        btn1 = [[MXDIYBtn alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
        [_sectionView addSubview:btn1];
        btn1.nameLab.text = @"全部跟帖";
        btn1.nameLab.textColor = mx_redColor;
        btn1.line.backgroundColor = mx_redColor;
        btn1.tag = 11;
        btn1.selected = YES;
        mx_weakify(self);
        btn1.click = ^(UIControl *control) {
            [weakSelf clcikSlider:control];
        };
        
        btn2 = [[MXDIYBtn alloc]initWithFrame:CGRectMake(80, 0, 70, 40)];
        [_sectionView addSubview:btn2];
        btn2.selected = NO;
        btn2.nameLab.text = @"只看楼主";
        btn2.nameLab.textColor = mx_FontLightGreyColor;
        btn2.line.backgroundColor = [UIColor clearColor];
        btn2.tag = 12;
        btn2.click = ^(UIControl *control) {
            [weakSelf clcikSlider:control];
        };
    }
    
    return _sectionView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"正在加载..."];
    self.arrList = [NSMutableArray array];
    self.arrOnlyPoster = [NSMutableArray array];
    self.currentModel = [[MXSYJCommentModel alloc] init];
   
    [self setTableView];
    
    [self setUpView];
    
    isCommentOrReply = NO;
    
    isClick = 11;
    
//    SVProgressHUD show
#pragma mark -- 资讯详情页修改
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHeight:) name:@"webview_height" object:nil];
}

- (void)updateHeight:(NSNotification *)notification {
//    NSDictionary *dic = notification.userInfo;
//    self.webHeight = [[dic objectForKey:@"webheight"] floatValue];
//
//    [self.tableView reloadData];
}

- (void)setTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME - 65) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = mx_Wode_bordColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.tableView registerClass:[MXSYJCommentsCell class] forCellReuseIdentifier:CommentsCell];
    
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreComments)];
    self.tableView.mj_footer = footer;
    
    mx_weakify(self);
    
    #pragma mark -- 资讯详情页修改
//    if (self.type == 200) {//资讯详情
//        self.tableView.tableHeaderView = [UIView new];
//        return;
//    }
    
    //圈子详情
    self.headerView = [[MXSYJArticleView alloc]init];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableHeaderView.userInteractionEnabled = YES;
    self.headerView.frame = CGRectMake(0, 0, screen_width, 230);
    self.headerView.delegate = self;
    
    self.headerView.click = ^(UIButton *btn) {
        
        if (btn.tag == 1) {
            MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
            if (userModel.userId) {
                
                MXSYJExceptionalVC *vc = [[MXSYJExceptionalVC alloc]init];
                vc.newsId = weakSelf.newsID;
                vc.ownerID = weakSelf.postAuthor;
                vc.userName = weakSelf.userName;
                vc.heaerUrl = weakSelf.headerUrl;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
            }else{
                //请先登录
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
//                login.isPageNumber = 1;
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }
            
        }else if (btn.tag == 2){
            
            if ([MXssWodeUtils loadPersonInfo].userId) {
                [weakSelf sendCollect];
                
            }else{
                MXLoginViewController *login = [[MXLoginViewController alloc] init];
                MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
                [weakSelf presentViewController:nav animated:YES completion:nil];
            }
            
        }else{
            btn.enabled = NO;
            //关注
            [weakSelf getAttention:btn];
            
        }
        
    };
    [self getNetWork];
}


#pragma mark - 加载视图
- (void)setUpView{
    
    //加载评论页面
    self.commentView = [[MXSYJCommentView alloc]initWithFrame:CGRectMake(0, screen_height - 65 - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME, screen_width, 65)];
    [self.view addSubview:self.commentView];
    self.commentView.textView.delegate = self;
    self.commentView.backgroundColor = mx_Wode_backgroundColor;
    
    self.loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    self.loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loadingView];
    
    mx_weakify(self);
    self.commentView.strBlock = ^(NSString *textStr) {
        
    if (textStr.length > 0) {
        
        [weakSelf.commentView.textView endEditing:YES];
        
        if ([MXssWodeUtils loadPersonInfo].userId) {
            
            if (isCommentOrReply == NO) {
                [weakSelf sendComment:textStr];
            }else{
                isCommentOrReply = NO;
                [weakSelf sendCommentEachother:textStr];
            }
            
        }else{
            MXLoginViewController *login = [[MXLoginViewController alloc] init];
            MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }
        
        
    }else{
        [SVProgressHUD showInfoWithStatus:@"传入内容为空!"];
    }
    
};
    
   
}

#pragma mark -- 资讯详情页修改
#pragma mark -- 刷新评论
- (void)uploadComment {
//    if (self.type == 200) {
//        //资讯详情两个分区
//        //刷新第二分区
//        NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:0];
//        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
//    } else {
        //刷新
        [self.tableView reloadData];
//    }
}

#pragma mark - 只看楼主
- (void)onlyPoster{
    
    mx_weakify(self);
    [[MXSYJPostVM sharedInstance] onlyPosterNewsId:self.newsID ownerId:[NSString stringWithFormat:@"%ld", (long)_model.userId] success:^(NSDictionary *dic) {
        
        weakSelf.arrOnlyPoster = [MXSYJCommentModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
        
        if (weakSelf.arrOnlyPoster.count < 1) {
            [SVProgressHUD showInfoWithStatus:@"暂无内容!"];
        }
//        [weakSelf uploadComment];
        [weakSelf.tableView reloadData];
    } failture:^(NSError *error) {
        
    }];
    
}


#pragma mark - 发送评论
- (void)sendComment:(NSString *)str{
    
    self.commentView.sendBtn.userInteractionEnabled = NO;
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0) {
        [SVProgressHUD showInfoWithStatus:@"评论内容不能全为空格"];
        self.commentView.sendBtn.userInteractionEnabled = YES;
        return;
    }
//    if ([NSString stringContainsEmoji:str]) {
//        [SVProgressHUD showInfoWithStatus:@"不能包含字符"];
//        self.commentView.sendBtn.userInteractionEnabled = YES;
//        return;
//    }
    str = [str filterSensitiveString];
    mx_weakify(self);
    [[MXSYJPostVM sharedInstance] commentUserId:[MXssWodeUtils loadPersonInfo].userId newsId:self.newsID content:str success:^(NSDictionary *dic) {
        
        weakSelf.commentView.textView.text = @"";
        
        self.commentView.sendBtn.userInteractionEnabled = YES;
        
        [self.arrList removeAllObjects];
        [weakSelf getNetWork];
        
        
    } failture:^(NSError *error) {
        
        self.commentView.sendBtn.userInteractionEnabled = YES;
        
    }];

}

#pragma mark - 互评
- (void)sendCommentEachother:(NSString *)str{
    
//    if ([NSString stringContainsEmoji:str]) {
//        [SVProgressHUD showInfoWithStatus:@"不能包含字符"];
//        return;
//    }
    
    if ([MXssWodeUtils loadPersonInfo].userId) {
        mx_weakify(self);
        MXSYJCommentModel *currentModel = self.arrList[_currentEditingIndexthPath.row];
        
        [[MXSYJPostVM sharedInstance] eachOtherNewsId:self.newsID userId:[MXssWodeUtils loadPersonInfo].userId parentId:[NSString stringWithFormat:@"%ld",_model.userId] firstUserId:currentModel.commentId content:str success:^(NSDictionary *dic) {
            
            weakSelf.commentView.textView.text = @"";
            MXSYJCommentModel *model;
            
            if (isClick == 11) {
                model = self.arrList[_currentEditingIndexthPath.row];
                
            }else{
                model = self.arrOnlyPoster[_currentEditingIndexthPath.row];
            }
            
            NSMutableArray *temp = [NSMutableArray new];
            [temp addObjectsFromArray:model.followCommentList];
            
            MXSYJFollowCommentModel *commentItemModel = [MXSYJFollowCommentModel new];
            commentItemModel.followerName = [MXssWodeUtils loadPersonInfo].username;
            commentItemModel.content = str;
            commentItemModel.ownerId = [MXssWodeUtils loadPersonInfo].userId;
            [temp addObject:commentItemModel];
            
            model.followCommentList = [temp copy];
            
            [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexthPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
        } failture:^(NSError *error) {
            
        }];
    }else{
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - 收藏
- (void)sendCollect{
    
    mx_weakify(self);
    if (_model.isCollect == 1) {
        _model.isCollect = 0;
    }else{
        _model.isCollect = 1;
    }
    
    [[MXSYJPostVM sharedInstance] collectNewsId:self.newsID userId:[MXssWodeUtils loadPersonInfo].userId opid:_model.isCollect success:^(NSDictionary *dic) {

        if (_model.isCollect == 0) {
            [weakSelf.headerView.collectBtn setImage:[UIImage imageNamed:@"luntan_wujiaoxing_kong"] forState:UIControlStateNormal];
            [weakSelf.headerView.collectBtn setTitle:[NSString stringWithFormat:@"%ld",_model.collects - 1] forState:UIControlStateNormal];
            _model.collects = _model.collects - 1;

        }else{
            [weakSelf.headerView.collectBtn setImage:[UIImage imageNamed:@"luntan_wujiaoxing_shi"] forState:UIControlStateNormal];
            [weakSelf.headerView.collectBtn setTitle:[NSString stringWithFormat:@"%ld",_model.collects + 1] forState:UIControlStateNormal];
            _model.collects = _model.collects + 1;


        }
        
    } failture:^(NSError *error) {
        
    }];
}

#pragma mark - network 主内容
- (void)getNetWork{
    page = 1;
    limit = 10;
    mx_weakify(self);
    
//    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithContentsOfFile:self.fileName];
//    self.cacheDics = dic1;
//    if (dic1[self.newsID]) {
//        [SVProgressHUD dismiss];
//        [weakSelf setViewModel:dic1[self.newsID]];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            [[MXSYJPostVM sharedInstance] getPostDetail:[MXssWodeUtils loadPersonInfo].userId newsId:self.newsID page:nil limit:nil success:^(NSDictionary *dic) {
//
//                _model = [MXSYJFocusOnModel mj_objectWithKeyValues:dic[@"data"][@"forumDetail"]];
//
//                [weakSelf.articleCacheDic setObject:dic[@"data"][@"forumDetail"] forKey:@"article"];
//                [weakSelf.articleCacheDic setObject:dic[@"data"][@"commentsList"] forKey:@"comment"];
//                if (dic[@"data"][@"adverts"][0]) {
//                    [weakSelf.articleCacheDic setObject:dic[@"data"][@"adverts"][0] forKey:@"adverts"];
//                }
////                [dic1 setObject:detailDic forKey:weakSelf.newsID];
////                [dic1 writeToFile:self.fileName atomically:YES];
//                [weakSelf setViewModel:weakSelf.articleCacheDic];
//
//            } failture:^(NSError *error) {
//
//            }];
//        });
//
//    }else{
        [[MXSYJPostVM sharedInstance] getPostDetail:[MXssWodeUtils loadPersonInfo].userId newsId:self.newsID page: page limit: limit success:^(NSDictionary *dic) {

            [weakSelf.articleCacheDic setObject:dic[@"data"][@"forumDetail"] forKey:@"article"];
            [weakSelf.articleCacheDic setObject:dic[@"data"][@"commentsList"] forKey:@"comment"];
            NSArray *adsArr = dic[@"data"][@"adverts"];
            if (adsArr.count) {
                [weakSelf.articleCacheDic setObject:dic[@"data"][@"adverts"][0] forKey:@"adverts"];
            }
            //                [dic1 setObject:detailDic forKey:weakSelf.newsID];
            //                [dic1 writeToFile:self.fileName atomically:YES];
            [weakSelf setViewModel:weakSelf.articleCacheDic];
            page++;

        } failture:^(NSError *error) {

        }];
//    }
}

- (void)getMoreComments{
    [[MXSYJPostVM sharedInstance] getPostDetail:[MXssWodeUtils loadPersonInfo].userId newsId:self.newsID page:page limit:limit success:^(NSDictionary *dic) {
        NSArray *arr = dic[@"data"][@"commentsList"];
        if (arr.count) {
            [self.tableView.mj_footer endRefreshing];
            [self.arrList addObjectsFromArray:[MXSYJCommentModel mj_objectArrayWithKeyValuesArray:arr]];
            page++;
            [self.tableView reloadData];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } failture:^(NSError *error) {
        
    }];
}

//缓存
- (void)setViewModel: (NSMutableDictionary *)dic {
    
    _model = [MXSYJFocusOnModel mj_objectWithKeyValues:dic[@"article"]];
    MXSYJAdModel *adModel = [MXSYJAdModel mj_objectWithKeyValues:dic[@"adverts"]];
    self.headerView.articleType = self.articleType;
    self.headerView.adModel = adModel;
    self.headerView.model = _model;
    self.postAuthor = [NSString stringWithFormat:@"%ld", (long)_model.userId];
    self.userName = _model.username;
    self.headerUrl = _model.headerPic;
//    self.headerView.exceptionalBtn.hidden = NO;
    self.headerView.collectBtn.hidden = NO;
    self.headerView.statementLab.hidden = NO;
    self.headerView.articleFromLab.hidden = NO;
    self.arrList = [MXSYJCommentModel mj_objectArrayWithKeyValuesArray:dic[@"comment"]];
    isFinsh = YES;
    
    [self.tableView reloadData];
}

//设置headerview高度
- (void)setHeaderViewHeight:(CGFloat)height imgsHeight:(NSArray *)imgsHeight textHeight:(CGFloat)textHeight{
    if (self.articleType) {
        self.headerView.frame = CGRectMake(0, 0, screen_width, height + scaleWithSize(210));
    }else{
        self.headerView.frame = CGRectMake(0, 0, screen_width, height + scaleWithSize(140));
    }
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.loadingView.hidden = YES;
    self.loadingView.hidden = YES;
//    mx_weakify(self);
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.articleCacheDic[@"article"]];
//
//        [dic setObject:imgsHeight forKey:@"imgsHeight"];
//        [dic setObject:@(textHeight) forKey:@"textHeight"];
//        [weakSelf.articleCacheDic setObject:dic forKey:@"article"];
//        [weakSelf.cacheDics setObject:weakSelf.articleCacheDic forKey:weakSelf.newsID];
//        [weakSelf.cacheDics writeToFile:weakSelf.fileName atomically:YES];
//    });
}
//delegate跳转广告页
- (void)pushToAdsVc:(MXSYJAdModel *) adModel{
    MXSYJWebViewController *vc = [[MXSYJWebViewController alloc]init];
    vc.url = adModel.targetUrl;
    vc.adID = adModel.advertId ;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToUserInfo{
    //不跳转到个人详情
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        return;
    }

    MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
    vc.ownerId = [NSString stringWithFormat:@"%ld",  _model.userId];
    vc.ownerName = _model.username;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击关注
- (void)getAttention:(UIButton *)btn{
    
    if ([MXssWodeUtils loadPersonInfo].userId) {
        
        if (_model.isAttention == 1) {
            _model.isAttention = 0;
        }else{
            _model.isAttention = 1;
        }
        
        
        NSString *userID = [NSString stringWithFormat:@"%@",[MXssWodeUtils loadPersonInfo].userId];
        
        if ([userID isEqualToString:self.postAuthor]) {
            [SVProgressHUD showInfoWithStatus:@"不能关注自己~~"];
            btn.enabled = YES;
            return;
        }

        [[MXSYJPostVM sharedInstance] attentionType:_model.isAttention ownerId:self.postAuthor userId:[MXssWodeUtils loadPersonInfo].userId success:^(NSDictionary *dic) {
           
            btn.enabled = YES;

            if ([dic[@"code"] isEqualToString:@"0"]) {
                if (_model.isAttention == 0) {
                    [btn setBackgroundColor:mx_BlueColor];
                    [btn setTitle:@"+关注" forState:UIControlStateNormal];
                }else{
                    [btn setBackgroundColor:[UIColor grayColor]];
                    [btn setTitle:@"已关注" forState:UIControlStateNormal];
                }
            }
            
        } failture:^(NSError *error) {
            btn.enabled = YES;

        }];
}else{
        btn.enabled = YES;
        MXLoginViewController *login = [[MXLoginViewController alloc] init];
        MXNavigationController *nav = [[MXNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    
}


#pragma mark - table view dataSource

- (void)clcikSlider:(UIControl *)control{
    
    if (control.tag == 11) {
       
            isClick = control.tag;

            btn1.selected = YES;
            btn2.selected = NO;
            [self.tableView reloadData];
            btn1.nameLab.textColor = mx_redColor;
            btn1.line.backgroundColor = mx_redColor;
            btn2.nameLab.textColor = mx_FontLightGreyColor;
            btn2.line.backgroundColor = [UIColor clearColor];
        
            [self.tableView reloadData];
//        [self uploadComment];
    }else{
        
            isClick = control.tag;
            btn2.selected = YES;
            btn1.selected = NO;
            [self.tableView reloadData];
            btn2.nameLab.textColor = mx_redColor;
            btn2.line.backgroundColor = mx_redColor;
            btn1.nameLab.textColor = mx_FontLightGreyColor;
            btn1.line.backgroundColor = [UIColor clearColor];
            //只看楼主
            [self onlyPoster];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
#pragma mark -- 资讯详情页修改
//    if (self.type == 200 && !section) {
//        return [UIView new];
//    }
    return self.sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
#pragma mark -- 资讯详情页修改
//    if (self.type == 200 && !section) {
//        return CGFLOAT_MIN;
//    }
    
    if (isFinsh) {
        return 40;
    }
    
    return 0;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 60)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    label.font = fontBoldSize(16);
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(screen_width/2 - 100, 0, 200, 60);
    label.text = @"暂无数据";
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ((self.arrList.count == 0 && isClick == 11) || (self.arrOnlyPoster.count == 0 && isClick == 12)) {
        return 60;
    }else{
        return 0;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
#pragma mark -- 资讯详情页修改
//    if (self.type == 200 && !indexPath.section) {
//        if (indexPath.row) {
//        }
////        CGFloat height = [MXOfficialDetailCell cellHeightWithString:model.title];
//        return self.webHeight + 50;
////        return 50;
//    }
    
    switch (isClick) {
        case 11:
        {
            MXSYJCommentModel *userModel = self.arrList[indexPath.row];
            return [self.tableView cellHeightForIndexPath:indexPath model:userModel keyPath:@"model" cellClass:[MXSYJCommentsCell class] contentViewWidth:screen_width] + 10;
        }
            break;
            
        case 12:
        {
            MXSYJCommentModel *userModel = self.arrOnlyPoster[indexPath.row];
            return [self.tableView cellHeightForIndexPath:indexPath model:userModel keyPath:@"model" cellClass:[MXSYJCommentsCell class] contentViewWidth:screen_width] + 10;
        }
            break;
            
        default:
            return 0;
            break;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    #pragma mark -- 资讯详情页修改
//    if (self.type == 200) {
//        return 2;//分区0：内容和标题；分区1：评论
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.type == 200 && !section) {
//        return 1;
//    }
    if (isClick == 11) {
        return self.arrList.count;

    }else{
        return self.arrOnlyPoster.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma -- 资讯详情页修改
    if (self.type == 200 && !indexPath.section) {
        //分区0：内容和标题；分区1：评论
//        if (!indexPath.row) {//标题
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
//            UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_width - 30, 50)];
//            headerLab.backgroundColor = [UIColor redColor];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
//                headerLab.numberOfLines = 0;
//                headerLab.font = fontSize(17);
//                headerLab.textColor = mx_FontBalckColor;
//                [cell addSubview:headerLab];
//
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            headerLab.text = @"为啥不出来";
//
//            return cell;
//        }
        //内容html
//        MXOfficialDetailCell *cell = [MXOfficialDetailCell myCellWithTableview:tableView];
//        [cell setDataWithModel:model];
//
//        return cell;
    }
    
    MXSYJCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentsCell];
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (isClick == 11) {
        if (self.arrList.count > 0) {
            MXSYJCommentModel *userModel = self.arrList[indexPath.row];
            userModel.floor = indexPath.row + 1;
            cell.model = userModel;
        }
    }else{
        
        if (self.arrOnlyPoster.count > 0) {
            MXSYJCommentModel *userModel = self.arrOnlyPoster[indexPath.row];
            userModel.floor = indexPath.row + 1;
            cell.model = userModel;
        }
        
    }
        //按钮点击
//        mx_weakify(self);
        cell.commentClick = ^(NSString *userId, NSString *userName) {
            //不跳转到个人详情
            if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
                return;
            }

            MXSYJPersonController *vc = [[MXSYJPersonController alloc]init];
            vc.ownerId = userId;
            vc.ownerName = userName;
            [self.navigationController pushViewController:vc animated:YES];

        };
    
        [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
        return cell;

}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _currentEditingIndexthPath = indexPath;
    if (isClick == 11) {
        _currentEditingIndexthPath = indexPath;
        
        [self.commentView.textView resignFirstResponder];
        MXSYJCommentModel *userModel = self.arrList[indexPath.row];
        self.commentView.textView.text = @"";
        [self.commentView.textView becomeFirstResponder];
        self.commentView.textView.yy_placeHolder = [NSString stringWithFormat:@"回复 %@:",userModel.username];
        isCommentOrReply = YES;
        self.currentModel = self.arrList[indexPath.row];
    }else{
        _currentEditingIndexthPath = indexPath;
        
        [self.commentView.textView resignFirstResponder];
        MXSYJCommentModel *userModel = self.arrOnlyPoster[indexPath.row];
        self.commentView.textView.text = @"";
        [self.commentView.textView becomeFirstResponder];
        self.commentView.textView.yy_placeHolder = [NSString stringWithFormat:@"回复 %@:",userModel.username];
        isCommentOrReply = YES;
    }
}
#pragma mark 回复子评论
- (void)replyChildComment:(NSInteger)index commentModel:(MXSYJFollowCommentModel *)followCommentmodel indexPath:(NSIndexPath *)indexPath{
    _currentEditingIndexthPath = indexPath;
    
    [self.commentView.textView resignFirstResponder];
    [self.commentView.textView becomeFirstResponder];
    self.commentView.textView.yy_placeHolder = [NSString stringWithFormat:@"回复: %@:", followCommentmodel.followerName];
    isCommentOrReply = YES;
}

#pragma mark - textView 键盘上移(评论)

 /**
 *  设置输入超过三行（高度60）自动滚入不可见区域
 *
 *  @param notification <#notification description#>
 */
- (void)textViewTextDidChange:(NSNotification *)notification{
    CGFloat height = self.commentView.textView.contentSize.height>60?60:self.commentView.textView.contentSize.height;
    
    if (height <= 40) {
        self.commentView.textView.frame=CGRectMake(10, 10, self.commentView.textView.frame.size.width, 40);
        
    }else if(height > 40 && height < 60){
        self.commentView.textView.frame = CGRectMake(10,60 - height, self.commentView.textView.frame.size.width, height);
    }else{
        self.commentView.textView.frame = CGRectMake(10,2, self.commentView.textView.frame.size.width, height);
    }
    
    return;
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _mark=YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _mark=NO;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /**
     *  判断是否拖动来设置frame
     */
    if(!self.isMark){
        
        if(self.commentView.textView.contentSize.height>60){
            [self.commentView.textView setContentOffset:CGPointMake(0, self.commentView.textView.contentSize.height-60)];
        }else{
            [self.commentView.textView setContentOffset:CGPointMake(0, 0)];
        }
    }
}

#pragma mark - textViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    
//    self.commentView.textView.text = @"";

    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
