//
//  MXTextLiveCell.m
//  MXFootBall
//
//  Created by YY on 2018/4/12.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXTextLiveCell.h"
@interface MXTextLiveCell ()
@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UILabel *teamTypeLabel;

@property (nonatomic,strong)UILabel *textContentLabel;

@end

@implementation MXTextLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return  self;
}
-(void)setupViews{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.timeLabel=[[UILabel alloc] init];
    self.timeLabel.font=fontSize(scaleWithSize(14));
    self.timeLabel.textColor=[UIColor whiteColor];
    self.timeLabel.textAlignment=NSTextAlignmentCenter;
    self.teamTypeLabel=[UILabel new];
    self.textContentLabel=[UILabel new];
    [self.contentView sd_addSubviews:@[self.timeLabel,self.teamTypeLabel,self.textContentLabel]];
    self.timeLabel.backgroundColor=[[UIColor blueColor] colorWithAlphaComponent:0.3];
    self.teamTypeLabel.backgroundColor=[[UIColor redColor] colorWithAlphaComponent:0.5];
    self.textContentLabel.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.teamTypeLabel.textColor=[UIColor whiteColor];
    self.textContentLabel.textColor=[UIColor whiteColor];
    self.textContentLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 70)
    .autoHeightRatio(0);
    self.timeLabel.sd_layout
    .topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .heightRatioToView(self.textContentLabel, 1)
    .widthIs(40);
    self.teamTypeLabel.sd_layout
    .topEqualToView(self.timeLabel)
    .leftSpaceToView(self.timeLabel, 0)
    .heightRatioToView(self.timeLabel, 1)
    .widthIs(20);
    [self.textContentLabel setSingleLineAutoResizeWithMaxWidth:screen_width-100];
    
}
-(void)setModel:(MXTextLiveModel *)model{
    _model=model;
    self.timeLabel.text=model.timeInt;
    switch ([model.type integerValue]) {
        case 1:
            self.teamTypeLabel.text=@"主";
            break;
        case 2:
            self.teamTypeLabel.text=@"客";
            break;
        case 3:
            self.teamTypeLabel.text=@"";
            break;
        default:
            break;
    }
    
    self.textContentLabel.text=model.data;
    [self setupAutoHeightWithBottomView:self.textContentLabel bottomMargin:10];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
