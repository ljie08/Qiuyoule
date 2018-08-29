//
//  MXCahtContentCell.m
//  MXFootBall
//
//  Created by YY on 2018/4/10.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXChatContentCell.h"
@interface MXChatContentCell ()
@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UILabel *userName;

@property (nonatomic,strong)UILabel *VIPGradeLabel;

@property (nonatomic,strong)UILabel *contentText;

@property (nonatomic,strong)UIView *containerView;
@end
@implementation MXChatContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupViews];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}
-(void)setupViews{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.headImageView=[[UIImageView alloc] init];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] init];
    [self.headImageView addGestureRecognizer:tap];
    self.headImageView.userInteractionEnabled=YES;
    mx_weakify(self);
    [tap addActionBlock:^(UITapGestureRecognizer *tap) {
        weakSelf.CallBack();
    }];
    [self.headImageView yy_cornerRadiusRoundingRect];
    self.userName=[UILabel new];
    self.userName.font=[UIFont systemFontOfSize:14];
    self.userName.textColor=[UIColor lightGrayColor];
    self.VIPGradeLabel=[UILabel new];
    self.VIPGradeLabel.textColor=[UIColor lightGrayColor];
    self.VIPGradeLabel.font=fontSize(scaleWithSize(8));
    self.containerView=[[UIView alloc] init];
    self.contentText=[UILabel new];
    self.contentText.layer.cornerRadius=5;
    self.contentText.layer.masksToBounds=YES;
    [self.contentView sd_addSubviews:@[self.headImageView,self.userName,self.VIPGradeLabel,self.containerView]];
    [self.containerView addSubview:self.contentText];
}
-(void)setChatModel:(MXChatModel *)chatModel{
    _chatModel=chatModel;
   MXSSToolConfig *config=[MXssWodeUtils loadPersonInfo];
    if ([chatModel.userId integerValue]==[config.userId integerValue]) {
        self.headImageView.sd_resetNewLayout
        .topSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .widthIs(50)
        .heightIs(50);
        
        self.userName.sd_resetNewLayout
        .topEqualToView(self.headImageView)
        .rightSpaceToView(self.headImageView ,5)
        .heightIs(16);
        [self.userName setSingleLineAutoResizeWithMaxWidth:200];
        
        self.VIPGradeLabel.sd_resetNewLayout
        .topEqualToView(self.userName).offset(3)
        .rightSpaceToView(self.userName, 5)
        .heightIs(12)
        .widthIs(25);
        
        self.containerView.sd_resetNewLayout
        .topSpaceToView(self.userName, 4)
        .rightEqualToView(self.userName);
        
        self.contentText.sd_resetNewLayout
        .topSpaceToView(self.containerView, 5)
        .leftSpaceToView(self.containerView, 5)
        .autoHeightRatio(0);
        self.VIPGradeLabel.text=[NSString stringWithFormat:@"LV%@",config.level];
        NSURL *headUrl=[NSURL URLWithString:config.headerPic];
        if ([headUrl.scheme isEqualToString:@"https"]) {
            [self.headImageView sd_setImageWithURL:headUrl];
        }else{
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[config.headerPic base64DecodedString]] placeholderImage:[UIImage imageNamed:@"4"]];
        }
       self.containerView.backgroundColor=[MXLJUtil hexStringToColor:@"0x1D5BE1"];
        self.contentText.textColor=[UIColor whiteColor];
    }else{
        self.headImageView.sd_resetNewLayout
        .topSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.contentView, 10)
        .widthIs(50)
        .heightIs(50);
        
        self.userName.sd_resetNewLayout
        .topEqualToView(self.headImageView)
        .leftSpaceToView(self.headImageView ,5)
        .heightIs(16);
        [self.userName setSingleLineAutoResizeWithMaxWidth:200];
        
        self.VIPGradeLabel.sd_resetNewLayout
        .topEqualToView(self.userName).offset(3)
        .leftSpaceToView(self.userName, 5)
        .heightIs(12)
        .widthIs(25);
        
        self.containerView.sd_resetNewLayout
        .topSpaceToView(self.userName, 4)
        .leftEqualToView(self.userName);
        
        self.contentText.sd_resetNewLayout
        .topSpaceToView(self.containerView, 5)
        .leftSpaceToView(self.containerView, 5)
        .autoHeightRatio(0);
        NSURL *headUrl=[NSURL URLWithString:chatModel.headerPic];
        if ([headUrl.scheme isEqualToString:@"https"]) {
            [self.headImageView sd_setImageWithURL:headUrl];
        }else{
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[chatModel.headerPic base64DecodedString]] placeholderImage:[UIImage imageNamed:@"4"]];
        }
        self.containerView.backgroundColor=[UIColor whiteColor];
        self.contentText.textColor=[UIColor lightGrayColor];
    }
    [self.contentText setSingleLineAutoResizeWithMaxWidth:screen_width-100];
    [self.containerView setupAutoWidthWithRightView:self.contentText rightMargin:5];
    [self.containerView setupAutoHeightWithBottomView:self.contentText bottomMargin:5];
    [self setupAutoHeightWithBottomView:self.containerView bottomMargin:10];
    self.containerView.sd_cornerRadius=@5;
    self.userName.text=[chatModel.username base64DecodedString];
    if (chatModel.level!=nil) {
        [self.VIPGradeLabel yy_setCornerRadius:10 borderColor:[UIColor lightGrayColor] AndBorderWidth:1];
        self.VIPGradeLabel.textAlignment=NSTextAlignmentCenter;
        self.VIPGradeLabel.text=[NSString stringWithFormat:@"LV%@",chatModel.level];
    }else{
        self.VIPGradeLabel.hidden=YES;
    }
    self.contentText.text=chatModel.chatMsg;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
