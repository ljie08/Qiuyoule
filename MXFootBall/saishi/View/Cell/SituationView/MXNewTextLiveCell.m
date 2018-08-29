//
//  MXNewTextLiveCell.m
//  MXFootBall
//
//  Created by YY on 2018/5/16.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXNewTextLiveCell.h"
@interface MXNewTextLiveCell ()
@property (nonatomic,strong)UIView *circularView;

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UILabel *textContent;

@property (nonatomic,strong)UIView *line;

@property (nonatomic,strong)UIView *containerView;

@end
@implementation MXNewTextLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
-(void)setupUI{
    self.backgroundColor=[MXLJUtil hexStringToColor:@"0x342828"];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.line=[UILabel new];
    self.line.backgroundColor=[UIColor lightGrayColor];
    [self.contentView addSubview:self.line];
    self.containerView=[UIView new];
    [self.contentView addSubview:self.containerView];
    
//    self.timeLabel=[UILabel new];
//    [self.containerView addSubview:self.timeLabel];
    self.circularView=[UIView new];
    self.circularView.backgroundColor=[UIColor lightGrayColor];
    self.circularView.layer.cornerRadius=10;
    [self.containerView addSubview:self.circularView];
    self.iconImageView=[UIImageView new];
    [self.containerView addSubview:self.iconImageView];
    self.textContent=[UILabel new];
    self.textContent.numberOfLines=0;
     self.textContent.textColor=[UIColor whiteColor];
    [self.containerView addSubview:self.textContent];
    
    self.line.sd_layout
    .topEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(1)
    .bottomEqualToView(self.contentView);
    
    self.circularView.sd_layout
    .topSpaceToView(self.containerView, 5)
    .leftSpaceToView(self.containerView, -5)
    .heightIs(20)
    .widthIs(20);
    
    self.iconImageView.sd_layout
    .topSpaceToView(self.containerView, 8)
    .leftSpaceToView(self.containerView, -2)
    .heightIs(15)
    .widthIs(15);
    
//    self.timeLabel.sd_layout
//    .topEqualToView(self.circularView)
//    .leftSpaceToView(self.iconImageView, 10)
//    .widthIs(25)
//    .heightIs(20);
    
    self.textContent.sd_layout
    .topEqualToView(self.circularView)
    .leftSpaceToView(self.circularView, 10)
    .autoHeightRatio(0);
    
    self.containerView.sd_layout
    .leftSpaceToView(self.contentView,15)
    .topSpaceToView(self.contentView, 5)
    .autoHeightRatio(0);
    [self.textContent setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width-scaleWithSize(50)];
    
    [self.containerView setupAutoHeightWithBottomView:self.textContent bottomMargin:5];
    [self.containerView setupAutoWidthWithRightView:self.textContent rightMargin:2];
}
-(void)setModel:(MXTextLiveModel *)model{
    _model=model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.eventLogo]];
    self.timeLabel.text=model.time;
    self.textContent.text=model.data;
    if ([model.position integerValue]==0||[model.type integerValue]==1) {
       self.containerView.backgroundColor=[MXLJUtil hexStringToColor:@"0xCFCFCD"];
        self.textContent.textColor=[UIColor blackColor];
    }else{
        self.containerView.backgroundColor=[UIColor clearColor];
        self.textContent.textColor=[UIColor whiteColor];
    }
    [self setupAutoHeightWithBottomView:self.containerView bottomMargin:5];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
