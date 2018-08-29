//
//  MXSSSettingAuxiliaryFunctionViewController.m
//  MXFootBall
//
//  Created by Mac on 2018/3/12.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSSSettingAuxiliaryFunctionViewController.h"

@interface MXSSSettingAuxiliaryFunctionViewController ()
@property (nonatomic,strong)UIImageView *imageBut;
@end

@implementation MXSSSettingAuxiliaryFunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

- (void)setupUI {
    CGFloat border = 1.0f;
    // 背景ScrollView
    UIScrollView *applicationSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    applicationSV.showsVerticalScrollIndicator = YES;
    applicationSV.showsVerticalScrollIndicator = NO;
    applicationSV.backgroundColor = mx_Wode_backgroundColor;
    applicationSV.scrollEnabled = YES;
    [self.view addSubview:applicationSV];
    
    CGFloat viewHeight = 44.0f;
    
    UIView *viewComPro = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screen_width, viewHeight)];
    viewComPro.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewComPro];
    [self addSubDetailViews:viewComPro iconName:@"" iconLeft:10 title:@"仅在WIFI环境下显示图片" titleLeft:20 hint:@""];
    UITapGestureRecognizer *tapViewComPro = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewHeaderClick:)];
    [viewComPro addGestureRecognizer:tapViewComPro];
    
    UIView *viewNickName = [[UIView alloc] initWithFrame:CGRectMake(0, viewComPro.frame.origin.y + viewComPro.frame.size.height + border, screen_width, viewHeight)];
    viewNickName.backgroundColor = [UIColor whiteColor];
    [applicationSV addSubview:viewNickName];
    [self addSubDetailViews:viewNickName iconName:@"" iconLeft:10 title:@"清空缓存" titleLeft:20 hint:[NSString stringWithFormat:@"179MB"]];
    UITapGestureRecognizer *tapviewNickName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewNickNameClick:)];
    [viewNickName addGestureRecognizer:tapviewNickName];
    
    
    applicationSV.contentSize = CGSizeMake(screen_width, viewNickName.frame.origin.y + viewNickName.frame.size.height + STATUS_AND_NAVIGATION_HEIGHT);
}
#pragma mark -- Event Methods仅在WIFI环境下显示图片的点击
-(void)tapViewHeaderClick:(UIButton *)sender {
    NSLog(@"仅在WIFI环境下显示图片的点击");
}
#pragma mark -- Event Methods清空缓存的点击
-(void)tapViewNickNameClick:(UIButton *)sender {
    NSLog(@"清空缓存的点击");
}

//各条件view块添加详细内容
-(UILabel *)addSubDetailViews:(UIView *)parentView iconName:(NSString *)imageName iconLeft:(CGFloat)iconX title:(NSString*)titleName titleLeft:(CGFloat)titleX hint:(NSString*)hintText{
    //开头图标
    UIImageView *viewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, 0, 20, 20)];
    [parentView addSubview:viewIcon];
    viewIcon.center = CGPointMake(viewIcon.center.x, parentView.frame.size.height/2);
    [viewIcon setImage:[UIImage imageNamed:imageName]];
    
    //标题
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, 200, 32)];
    [parentView addSubview:lblTitle];
    lblTitle.center = CGPointMake(lblTitle.center.x, parentView.frame.size.height/2);
    lblTitle.numberOfLines = 1;
    lblTitle.text = titleName;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    //lblTitle.textColor = [UIColor colorWithRed:167.0/255 green:167.0/255 blue:167.0/255 alpha:1];
    [lblTitle setTextColor:[UIColor blackColor]];
    lblTitle.backgroundColor =[UIColor clearColor];
    lblTitle.font = [UIFont fontWithName:@"Arial" size:15];
    
    //右箭头  15*15，距离右边也是15
    UIImageView *viewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(parentView.frame.size.width-15-15, 0, 15, 15)];
    
//    viewArrow.center = CGPointMake(viewArrow.center.x, parentView.frame.size.height/2);
//    if ([titleName isEqualToString:@"我的帖子"]||[titleName isEqualToString:@""]) {
        [viewArrow setImage:[UIImage imageNamed:@""]];//不显示右边的箭头
//    }else {
//        [viewArrow setImage:[UIImage imageNamed:@"mxWodeRightArrow"]];
//    }
    //内容，初始化时为提示文字
//    CGFloat left = 62;
    if ([titleName isEqualToString:@"仅在WIFI环境下显示图片"]) {
        _imageBut = [[UIImageView alloc] initWithFrame:CGRectMake(screen_width - 60, 5, 40, 30)];
        _imageBut.backgroundColor = [UIColor grayColor];
//        _imageBut.layer.cornerRadius = 15.0f;
//        _imageBut.layer.masksToBounds = YES;
        [parentView addSubview:_imageBut];
    }
    //    if ([MXwodeUnitObject isBlankString:hintText]) {
    [parentView addSubview:viewArrow];
    //    } else {
    //        left = screen_width - 64 - 24;
    //    }
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(screen_width - 220, 0, 200, 22 + 8)];
    [parentView addSubview:lblContent];
    lblContent.center = CGPointMake(lblContent.center.x, parentView.frame.size.height/2);
    lblContent.text = hintText;
    lblContent.textColor = mx_Wode_darkGreyFontColor;
    lblContent.backgroundColor =[UIColor clearColor];
    lblContent.textAlignment = 2;
    lblContent.font = [UIFont fontWithName:@"Arial" size:15];
    return lblContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initTitleViewWithTitle:@"辅助功能"];
    //设置返回按钮是否显示
    [self setBackButton:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
