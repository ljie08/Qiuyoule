//
//  MXOuZhiTitleTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOuZhiTitleTableViewCell.h"

@implementation MXOuZhiTitleTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.companyLabel];
        [self.contentView addSubview:self.oddsLabel];
        [self.contentView addSubview:self.returnRateLabel];
        [self.contentView addSubview:self.kellyLabel];
        
    }
    return self ;
}
- (UILabel *)companyLabel {
    
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scaleWithSize(80), scaleWithSize(30))];
        _companyLabel.textAlignment = 1;
        _companyLabel.text = @"公司";
        _companyLabel.numberOfLines = 0 ;
        _companyLabel.font = fontSize(scaleWithSize(13));
    }
    
    return _companyLabel ;
}

- (UILabel *)oddsLabel {
    
    if (!_oddsLabel) {
        
        CGFloat labelText = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"3.12  3.12  3.12" font:fontSize(scaleWithSize(13))] ;
        
        _oddsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.companyLabel.frame), 0, labelText, scaleWithSize(30))];
        _oddsLabel.text = @"欧赔";
        _oddsLabel.textAlignment = 1 ;
        _oddsLabel.numberOfLines = 0 ;
        _oddsLabel.font = fontSize(scaleWithSize(13));
        
    }
    
    return _oddsLabel ;
}

- (UILabel *)returnRateLabel {
    
    if (!_returnRateLabel) {
        
        CGFloat labelText1 = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"99.99%" font:fontSize(scaleWithSize(13))] ;
        
        _returnRateLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/2, 0, labelText1, scaleWithSize(30))];
        _returnRateLabel.text = @"返回率";
        _returnRateLabel.textAlignment = 1 ;
        _returnRateLabel.numberOfLines = 0 ;
        _returnRateLabel.font = fontSize(scaleWithSize(13));
    }
    
    return _returnRateLabel ;
}

- (UILabel *)kellyLabel {
    
    if (!_kellyLabel) {
        
        CGFloat labelText = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"3.12  3.12  3.12" font:fontSize(scaleWithSize(13))] ;
        
        _kellyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.returnRateLabel.frame) + scaleWithSize(23), 0, labelText, scaleWithSize(30))];
        _kellyLabel.text = @"凯利";
        _kellyLabel.textAlignment = 1 ;
        _kellyLabel.numberOfLines = 0 ;
        _kellyLabel.font = fontSize(scaleWithSize(13));
        
    }
    
    return _kellyLabel ;
}

- (void)setEuModel:(MXDEuModels *)euModel {
    
    _euModel = euModel ;
    
    self.companyLabel.text = euModel.companyNm ;
    
//    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init] ;
//    paragraph.alignment = NSTextAlignmentCenter ;
    
    NSString * oddsString = [NSString stringWithFormat:@"%.2f  %.2f  %.2f\n%.2f  %.2f  %.2f",
                           euModel.initalOdds.won.doubleValue,
                           euModel.initalOdds.drawn.doubleValue,
                           euModel.initalOdds.lost.doubleValue,
                           euModel.immedOdds.won.doubleValue,
                           euModel.immedOdds.drawn.doubleValue,
                           euModel.immedOdds.lost.doubleValue];
    
    NSMutableAttributedString * immedString = [[NSMutableAttributedString alloc]initWithString:oddsString] ;
    
    NSUInteger stringLoc = [[NSString stringWithFormat:@"%.2f  %.2f  %.2f",
                            euModel.initalOdds.won.doubleValue,
                            euModel.initalOdds.drawn.doubleValue,
                            euModel.initalOdds.lost.doubleValue
                            ] length] + 1;
    NSUInteger stringLen = [[NSString stringWithFormat:@"%.2f",euModel.immedOdds.won.doubleValue] length] ;
    
    //胜浮动
    switch (euModel.immedOdds.wonFluct) {
        case 1:
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(13)),NSForegroundColorAttributeName:mx_redColor} range:NSMakeRange(stringLoc, stringLen)];
            break;
        case -1:
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(13)),NSForegroundColorAttributeName:mx_GreenColor} range:NSMakeRange(stringLoc, stringLen)];
            break;
            
        default:
            break;
    }
    stringLoc = stringLoc + stringLen + 2 ;
    stringLen = [[NSString stringWithFormat:@"%.2f",euModel.immedOdds.drawn.doubleValue] length] ;
    //平浮动
    switch (euModel.immedOdds.drawnFluct) {
        case 1:
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(13)),NSForegroundColorAttributeName:mx_redColor} range:NSMakeRange(stringLoc, stringLen)];
            break;
        case -1:
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(13)),NSForegroundColorAttributeName:mx_GreenColor} range:NSMakeRange(stringLoc, stringLen)];
            break;
            
        default:
            break;
    }
    stringLoc = stringLoc + stringLen + 2 ;
    stringLen = [[NSString stringWithFormat:@"%.2f",euModel.immedOdds.lost.doubleValue] length] ;
    //负浮动
    switch (euModel.immedOdds.lostFluct) {
        case 1:
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(13)),NSForegroundColorAttributeName:mx_redColor} range:NSMakeRange(stringLoc, stringLen)];
            break;
        case -1:
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(13)),NSForegroundColorAttributeName:mx_GreenColor} range:NSMakeRange(stringLoc, stringLen)];
            break;
            
        default:
            break;
    }
    
    
    NSLog(@"-----%ld---%ld----%ld",self.oddsLabel.text.length,stringLoc,stringLen) ;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:scaleWithSize(6)];
    paragraphStyle.alignment = NSTextAlignmentCenter ;
    [immedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [oddsString length])];
//    [immedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [oddsString length])] ;
    
    self.oddsLabel.attributedText = immedString ;
//    [self attributedStringWihtTextString:self.oddsLabel.text lineSpacing:scaleWithSize(6)];
    
    self.returnRateLabel.attributedText = [self attributedStringWihtTextString:[NSString stringWithFormat:@"%.2f%%\n%.2f%%",euModel.initalOdds.rtnRt.doubleValue * 100 , euModel.immedOdds.rtnRt.doubleValue * 100] lineSpacing:scaleWithSize(6)];
    
    NSString * kellyString = [NSString stringWithFormat:@"%.2f  %.2f  %.2f\n%.2f  %.2f  %.2f",
                              euModel.initalOdds.wonKaiLi.doubleValue,
                              euModel.initalOdds.drawnKaiLi.doubleValue,
                              euModel.initalOdds.lostKaiLi.doubleValue,
                              euModel.immedOdds.wonKaiLi.doubleValue,
                              euModel.immedOdds.drawnKaiLi.doubleValue,
                              euModel.immedOdds.lostKaiLi.doubleValue] ;
    self.kellyLabel.attributedText = [self attributedStringWihtTextString:kellyString lineSpacing:scaleWithSize(6)];
    
    
}

- (NSMutableAttributedString *)attributedStringWihtTextString:(NSString *)textString lineSpacing:(CGFloat)lineSpacing {
    
    
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    paragraphStyle.alignment = NSTextAlignmentCenter ;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    
    
    return attributedString ;
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
