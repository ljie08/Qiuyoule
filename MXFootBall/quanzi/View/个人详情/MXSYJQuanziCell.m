//
//  MXSYJQuanziCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/2.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJQuanziCell.h"

#define kImgWidth (screen_width - 45) / 4


@implementation MXSYJQuanziCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerPlace"]];
        [self.contentView addSubview:self.iconView];
        self.iconView.sd_layout.leftSpaceToView(self.contentView, 18).topSpaceToView(self.contentView, 10).heightIs(40).widthIs(40);
        self.iconView.sd_cornerRadius = @20;

        self.nameLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLab];
        self.nameLab.textColor = mx_FontBalckColor;
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = fontBoldSize(15);
        self.nameLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.contentView, 13).heightIs(16);
        [self.nameLab setSingleLineAutoResizeWithMaxWidth:160];
        self.nameLab.text = @"这是名字";
        
        self.timeLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLab];
        self.timeLab.textColor = mx_FontLightGreyColor;
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        self.timeLab.font = fontSize(12);
        self.timeLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.nameLab, 5).heightIs(16);
        [self.timeLab setSingleLineAutoResizeWithMaxWidth:160];
        self.timeLab.text = @"1小时前";
        
        self.levelLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.levelLab];
        self.levelLab.textColor = mx_FontLightGreyColor;
        self.levelLab.textAlignment = NSTextAlignmentCenter;
        self.levelLab.font = fontSize(12);
        self.levelLab.sd_layout.leftSpaceToView(self.nameLab, 5).topSpaceToView(self.contentView, 12).heightIs(18).widthIs(40);
        self.levelLab.text = @"LV2";
        self.levelLab.sd_cornerRadius = @5;
        self.levelLab.layer.masksToBounds = YES;
        self.levelLab.layer.borderColor = mx_FontLightGreyColor.CGColor;
        self.levelLab.layer.borderWidth = 1.0;
        
        self.dishLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.dishLab];
        self.dishLab.textColor = mx_BlueColor;
        self.dishLab.textAlignment = NSTextAlignmentCenter;
        self.dishLab.font = fontSize(12);
        self.dishLab.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.iconView, 15).heightIs(20).widthIs(40);
        self.dishLab.text = @"亚盘";
        self.dishLab.sd_cornerRadius = @2;
        self.dishLab.layer.masksToBounds = YES;
        self.dishLab.layer.borderColor = mx_BlueColor.CGColor;
        self.dishLab.layer.borderWidth = 1.0;
        
        self.titleLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLab];
        self.titleLab.textColor = mx_FontBalckColor;
        self.titleLab.font = fontBoldSize(15);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.isAttributedContent = YES;
        self.titleLab.sd_layout.leftSpaceToView(self.dishLab, 5).centerYEqualToView(self.dishLab).heightIs(20).rightSpaceToView(self.contentView, 15);
        
        self.contentLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.contentLab];
        self.contentLab.textColor = mx_FontGreyColor;
        self.contentLab.font = fontSize(14);
        self.contentLab.textAlignment = NSTextAlignmentLeft;
        self.contentLab.isAttributedContent = YES;
        self.contentLab.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).topSpaceToView(self.dishLab, 8).autoHeightRatio(0);
        self.contentLab.isAttributedContent = YES;
        
        self.scollView = [[UIView alloc]init];
        [self.contentView addSubview:self.scollView];
        self.scollView.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentLab, 10).heightIs(kImgWidth);

        self.imgArr = [[NSMutableArray alloc]initWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg", nil];

        if (self.imgArr) {
            
            for (int i = 0; i < self.imgArr.count; i ++) {
                
                UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[i]]]];
                [self.scollView addSubview:img];
                img.frame = CGRectMake(kImgWidth * i + 9 * (i+1), 0, kImgWidth, kImgWidth);
            }
        }

        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = mx_Wode_bordColor;
        [self.contentView addSubview:line];
        line.sd_layout.bottomSpaceToView(self.contentView, 1).leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(1);
        
    }
    
    return self;
    
}

- (void)setModel:(MXSYJQuanziModel *)model{
    
    _model = model;
    self.iconView.image = [UIImage imageNamed:model.iconUrl];
    self.nameLab.text = model.name;
    self.levelLab.text = model.level;
    self.titleLab.text = model.title;
    self.timeLab.text = model.time;
    self.dishLab.text = model.dish;
    self.contentLab.attributedText = [self cellTextAttributed:model.content];
    self.imgArr = model.arrImg;
    
    if (self.imgArr) {
        
        for (int i = 0; i < self.imgArr.count; i ++) {
            
            UIImageView *img = [[UIImageView alloc]initWithFrame: CGRectMake(kImgWidth * i + 9 * (i+1), 0, kImgWidth, kImgWidth)];
            [self.scollView addSubview:img];
            img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imgArr[i]]];
        }
    }
    
    [self setupAutoHeightWithBottomView:self.scollView bottomMargin:0];
    [self.contentLab updateLayout];
    [self.scollView updateLayout];

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
    NSDictionary *attributes = @{ NSFontAttributeName:fontSize(15), NSParagraphStyleAttributeName:paragraphStyle};
    return [[NSAttributedString alloc]initWithString:text attributes:attributes];
}



@end
