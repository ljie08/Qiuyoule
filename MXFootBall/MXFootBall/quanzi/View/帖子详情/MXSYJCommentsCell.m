//
//  MXSYJCommentsCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/28.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCommentsCell.h"
#import "MXSYJCommentLineView.h"
#import "UIButton+ImagePosition.h"

@interface MXSYJCommentsCell() <MXSYJCommentLineViewDelegate>



@end

@implementation MXSYJCommentsCell
{
    
    MXSYJCommentLineView *_commentView;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToUserInfo)];
        
        self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerPlace"]];
        [self.iconView addGestureRecognizer:tap];
        self.iconView.userInteractionEnabled = YES;
        self.iconView.sd_cornerRadius = @20;
        
        self.nameLab = [[UILabel alloc]init];
        self.nameLab.textColor = mx_FontBalckColor;
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = fontBoldSize(14);
        self.nameLab.text = @"这是名字";
        
        self.floorLab = [[UILabel alloc]init];
        self.floorLab.textColor = mx_FontLightGreyColor;
        self.floorLab.textAlignment = NSTextAlignmentCenter;
        self.floorLab.font = fontSize(12);
        self.floorLab.text = @"3楼";
        
        
        self.timeLab = [[UILabel alloc]init];
        self.timeLab.textColor = mx_FontLightGreyColor;
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        self.timeLab.font = fontSize(12);
        self.timeLab.text = @"1小时前";
        
        self.levelLab = [[UILabel alloc]init];
        self.levelLab.textColor = mx_FontLightGreyColor;
        self.levelLab.textAlignment = NSTextAlignmentCenter;
        self.levelLab.font = fontSize(12);
        self.levelLab.text = @"LV2";
        self.levelLab.sd_cornerRadius = @5;
        self.levelLab.layer.masksToBounds = YES;
        self.levelLab.layer.borderColor = mx_FontLightGreyColor.CGColor;
        self.levelLab.layer.borderWidth = 1.0;
        
        self.commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.commentsBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
        [self.commentsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.commentsBtn.titleLabel.font = fontSize(12);
//        [self.commentsBtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
        [self.commentsBtn setImagePosition:ImagePositionLeft spacing:5];
      
        
        self.titleLab = [[UILabel alloc]init];
        self.titleLab.textColor = mx_FontBalckColor;
        self.titleLab.font = fontSize(14);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.isAttributedContent = YES;

        UIView *line = [[UIView alloc]init];
        line.backgroundColor = mx_Wode_bordColor;
        
        _commentView = [MXSYJCommentLineView new];
        _commentView.delegate = self;

        NSArray *views = @[line,self.iconView, self.nameLab, self.floorLab, self.timeLab, self.levelLab, self.titleLab, self.commentsBtn,_commentView];
        
        [self.contentView sd_addSubviews:views];
        
        self.iconView.sd_layout.leftSpaceToView(self.contentView, 18).topSpaceToView(self.contentView, 10).heightIs(40).widthIs(40);
        self.nameLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.contentView, 13).heightIs(16);
        [self.nameLab setSingleLineAutoResizeWithMaxWidth:160];
        self.floorLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.nameLab, 5).heightIs(16).widthIs(40);
        self.timeLab.sd_layout.leftSpaceToView(self.floorLab, 5).topSpaceToView(self.nameLab, 5).heightIs(16);
        [self.timeLab setSingleLineAutoResizeWithMaxWidth:160];
        self.levelLab.sd_layout.leftSpaceToView(self.nameLab, 5).topSpaceToView(self.contentView, 12).heightIs(18).widthIs(40);
        self.commentsBtn.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 12).heightIs(20).widthIs(50);
        self.titleLab.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).topSpaceToView(self.iconView, 8).autoHeightRatio(0);
        _commentView.sd_layout
        .leftEqualToView(self.titleLab)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.titleLab, 10); // 已经在内部实现高度自适应所以不需要再设置高度
        line.sd_layout.topSpaceToView(self.contentView, 1).leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1);

    }
    
    return self;
    
}

#pragma mark - 按钮点击
- (void)pushToUserInfo{
    
    if (self.commentClick) {
        self.commentClick(_model.userId, _model.username);
    }
}


#pragma mark - 数据源
- (void)setModel:(MXSYJCommentModel *)model{
    _model = model;
    _commentView.indexPath = self.indexPath;
    [_commentView commentItemsArray:model.followCommentList];
    [_commentsBtn setTitle:[NSString stringWithFormat:@"%d", _model.followCommentList.count] forState:UIControlStateNormal];

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headerPic] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
    self.nameLab.text = model.username;
    self.levelLab.text = [NSString stringWithFormat:@"LV%@",model.level];
    self.floorLab.text = [NSString stringWithFormat:@"%ld楼",model.floor];
    self.timeLab.text = model.createTime;
    self.titleLab.attributedText = [self cellTextAttributed:model.content];
    
    UIView *bottomView;
    
    if (!model.followCommentList.count) {
        bottomView = self.titleLab;
    } else {
        bottomView = _commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:5];
    
//    [self updateLayoutWithCellContentView:self.titleLab];
//    [self clearAutoHeigtSettings];
    
    [self.titleLab updateLayout];
    
    
    
}

- (CGFloat)cellHegith:(NSString *)text
{
    return [[self cellTextAttributed:text] boundingRectWithSize:CGSizeMake(screen_width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}


- (NSAttributedString *)cellTextAttributed:(NSString *)text
{
    //富文本设置文字行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 4;
    NSDictionary *attributes = @{NSFontAttributeName:fontSize(14), NSParagraphStyleAttributeName:paragraphStyle};
    return [[NSAttributedString alloc]initWithString:text attributes:attributes];
}

- (void)replyClick:(NSInteger)index commentModel:(MXSYJFollowCommentModel *)model indexPath:(NSIndexPath *)indexPath{
    
    if ([self.delegate respondsToSelector:@selector(replyChildComment: commentModel:indexPath:)]) {
        [self.delegate replyChildComment:index commentModel:model indexPath: indexPath];
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
