//
//  MXCircleIntroductionVC.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/3.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXCircleIntroductionVC.h"

@interface MXCircleIntroductionVC (){
    
    NSString *str;
}

/** 头像 */
@property (nonatomic, strong) UIImageView *iconView;
/** 名称 */
@property (nonatomic, strong) UILabel *nameLab;
/** 帖子数 */
@property (nonatomic, strong) UILabel *postLab;
/** 粉丝数 */
@property (nonatomic, strong) UILabel *fansLab;
/** 等级 */
@property (nonatomic, strong) UILabel *levelLab;
/** 圈子说明 */
@property (nonatomic, strong) UILabel *contentLab;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MXCircleIntroductionVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UBT logTrace:@"residenceTimeIn" content:@"{\"VC\":\"圈子详情界面\"}"];
    [self initTitleViewWithTitle:@"圈子简介"];
    [self setBackButton:YES];
}


- (void)viewWillDisappear:(BOOL)animated {//界面即将消失
    [super viewWillDisappear:animated];
    //    [UBT logTrace:@"residenceTimeOut"; content:@"{\"VC\":\"\u9996\u9875\"}";
    [UBT logTrace:@"residenceTimeOut" content:@"{\"VC\":\"圈子详情界面\"}"];
}



- (UIScrollView *)scrollView{
    
    if (_scrollView == nil) {
        
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - STATUS_AND_NAVIGATION_HEIGHT - TABBAR_FRAME)];
       
        _scrollView.backgroundColor = mx_Wode_bordColor;
        _scrollView.pagingEnabled = NO;
        _scrollView.scrollEnabled = YES;//关闭滑动
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        //        _scrollView.delegate = self;
//        _scrollView.contentSize = CGSizeMake(screen_width, screen_height + 200);
        
    }
    return _scrollView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
//    str = self.model.desc;

    [self.view addSubview:self.scrollView];
    
    [self setUpView];
    
    [self getNetWork];
    
}

- (void)setUpView{
    
    self.iconView = [[UIImageView alloc]init];
    [self.scrollView addSubview:self.iconView];
    self.iconView.sd_layout.leftSpaceToView(self, 10).topSpaceToView(self, 10).heightIs(60).widthIs(60);
    self.iconView.sd_cornerRadius = @30;
    
    self.nameLab = [[UILabel alloc]init];
    [self.scrollView addSubview:self.nameLab];
    self.nameLab.textColor = mx_FontBalckColor;
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.nameLab.font = fontBoldSize(14);
    self.nameLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self, 20).heightIs(20);
    [self.nameLab setSingleLineAutoResizeWithMaxWidth:200];
    
    self.levelLab = [[UILabel alloc]init];
//    [self.scrollView addSubview:self.levelLab];
    self.levelLab.textColor = mx_FontGreyColor;
    self.levelLab.textAlignment = NSTextAlignmentCenter;
    self.levelLab.font = fontSize(12);
    self.levelLab.text = @"LV-";
    self.levelLab.sd_layout.leftSpaceToView(self.nameLab, 10).topSpaceToView(self, 25).heightIs(15).widthIs(30);
    self.levelLab.layer.masksToBounds = YES;
    self.levelLab.layer.cornerRadius = 5;
    self.levelLab.layer.borderColor = mx_FontLightGreyColor.CGColor;
    self.levelLab.layer.borderWidth = 1.0;
    
    self.postLab = [[UILabel alloc]init];
    [self.scrollView addSubview:self.postLab];
    self.postLab.textColor = mx_FontGreyColor;
    self.postLab.textAlignment = NSTextAlignmentLeft;
    self.postLab.font = fontSize(12);
//    self.postLab.text = @"帖子 10";
    self.postLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.nameLab, 10).heightIs(15);
    [self.postLab setSingleLineAutoResizeWithMaxWidth:200];
    
    self.fansLab = [[UILabel alloc]init];
    [self.scrollView addSubview:self.fansLab];
    self.fansLab.textColor = mx_FontGreyColor;
    self.fansLab.textAlignment = NSTextAlignmentLeft;
    self.fansLab.font = fontSize(12);
//    self.fansLab.text = @"粉丝 9673";
    self.fansLab.sd_layout.leftSpaceToView(self.postLab, 5).topSpaceToView(self.nameLab, 10).heightIs(15);
    [self.fansLab setSingleLineAutoResizeWithMaxWidth:200];
    
    UILabel *circleName = [[UILabel alloc]init];
    [self.scrollView addSubview:circleName];
    circleName.textColor = mx_FontBalckColor;
    circleName.text = @"圈子说明";
    circleName.font = fontBoldSize(15);
    circleName.sd_layout.leftSpaceToView(self.scrollView, 10).topSpaceToView(self.iconView, 10).heightIs(20).rightSpaceToView(self.scrollView, 10);
    
    self.contentLab = [[UILabel alloc]init];
    [self.scrollView addSubview:self.contentLab];
    self.contentLab.textColor = mx_FontBalckColor;
    self.contentLab.textAlignment = NSTextAlignmentLeft;
    self.contentLab.font = fontSize(14);
    self.contentLab.sd_layout.leftSpaceToView(self.scrollView, 10).topSpaceToView(circleName, 10).rightSpaceToView(self.scrollView, 10).autoHeightRatio(0);
    self.contentLab.isAttributedContent = YES;

    
    
}

#pragma mark - network
- (void)getNetWork{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:self.ID forKey:@"channelId"];
    
    
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemChannelDetailPATH];
    mx_weakify(self);
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            NSLog(@"%@",dic);
            
            [SVProgressHUD dismiss];
            
//            [SVProgressHUD showSuccessWithStatus:@"请求成功"];
            [weakSelf.iconView sd_setImageWithURL:[NSURL URLWithString:dic[@"data"][@"channelInfo"][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
            weakSelf.nameLab.text = dic[@"data"][@"channelInfo"][@"channelName"];
            NSString *str = dic[@"data"][@"channelInfo"][@"description"];
            self.contentLab.attributedText = [self cellTextAttributed:str];
            self.postLab.text = [NSString stringWithFormat:@"帖子数 %@",dic[@"data"][@"forumCount"]];
            self.contentLab.isAttributedContent = YES;
            CGFloat height = [self cellHegith:str];
            
            self.scrollView.contentSize = CGSizeMake(screen_width, 120 + height);
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:@"请求错误"];
            
        }
        
        NSLog(@"%@",dic);
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
    }];
    
    
}


- (CGFloat)cellHegith:(NSString *)text
{
    return [[self cellTextAttributed:text] boundingRectWithSize:CGSizeMake(screen_width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}


- (NSAttributedString *)cellTextAttributed:(NSString *)text
{
    //加载html文本
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    //富文本设置文字行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 4;
    //    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
    NSDictionary *att = @{NSFontAttributeName:fontSize(14), NSParagraphStyleAttributeName:paragraphStyle};
    
    [attrStr addAttributes:att range:NSMakeRange(0, [attrStr length])];
    
    return attrStr;
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
