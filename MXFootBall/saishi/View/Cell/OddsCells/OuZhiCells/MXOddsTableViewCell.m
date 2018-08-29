//
//  MXOddsTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOddsTableViewCell.h"

@implementation MXOddsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.companyLabel];
        
        [self.contentView addSubview:self.firstInitialLabel];
        [self.contentView addSubview:self.firstLeLabel];
        
        [self.contentView addSubview:self.secondInitialLabel];
        [self.contentView addSubview:self.secondLeLabel];
        
        [self.contentView addSubview:self.thirdInitialLabel];
        [self.contentView addSubview:self.thirdLeLabel];
        
        [self.contentView addSubview:self.fourthInitialLabel];
        [self.contentView addSubview:self.fourthLeLabel];
        
    }
    return self ;
}

- (void)setAsiaModel:(MXDAsiaModel *)asiaModel {
    
    _asiaModel = asiaModel ;
    
    self.companyLabel.text = asiaModel.companyNm ;
    
    self.firstInitialLabel.text = [NSString stringWithFormat:@"%g", asiaModel.initalOdds.homeOdds] ;
    self.firstLeLabel.text = [NSString stringWithFormat:@"%g", asiaModel.immedOdds.homeOdds] ;
    if (asiaModel.immedOdds.homeFluct > 0) {
        self.firstLeLabel.textColor = mx_redColor ;
    } else if (asiaModel.immedOdds.homeFluct == 0) {
        self.firstLeLabel.textColor = [UIColor blackColor] ;
    } else {
        self.firstLeLabel.textColor = mx_GreenColor ;
    }
    
    NSString * hadpFluctString = @" " ;
    switch (asiaModel.immedOdds.hadpFluct) {
        case -1:
            hadpFluctString = @"降" ;
            break;
        case 0:
            hadpFluctString = @" " ;//不变
            break;
        case 1:
            hadpFluctString = @"升" ;
            break;
        default:
            break;
    }
    
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init] ;
    paragraph.alignment = NSTextAlignmentCenter ;
    
    self.secondInitialLabel.text = asiaModel.initalOdds.giveBall ;
    
    NSMutableAttributedString * immedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",asiaModel.immedOdds.giveBall,hadpFluctString]] ;
    switch (asiaModel.immedOdds.hadpFluct) {
        case -1:
            hadpFluctString = @"降" ;
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(9)),NSForegroundColorAttributeName:mx_GreenColor,NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(asiaModel.immedOdds.giveBall.length, 1)];
            break;
        case 1:
            hadpFluctString = @"升" ;
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(9)),NSForegroundColorAttributeName:mx_redColor,NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(asiaModel.immedOdds.giveBall.length, 1)];
            break;
        default:
            break;
    }
    
    self.secondLeLabel.attributedText = immedString ;
    
    

    
    self.thirdInitialLabel.text = [NSString stringWithFormat:@"%g", asiaModel.initalOdds.awayOdds]  ;
    self.thirdLeLabel.text = [NSString stringWithFormat:@"%g", asiaModel.immedOdds.awayOdds] ;
    if (asiaModel.immedOdds.awayFluct > 0) {
        self.thirdLeLabel.textColor = mx_redColor ;
    } else if (asiaModel.immedOdds.awayFluct == 0) {
        self.thirdLeLabel.textColor = [UIColor blackColor] ;
    } else {
        self.thirdLeLabel.textColor = mx_GreenColor ;
    }
    
    self.fourthInitialLabel.text = [NSString stringWithFormat:@"%.2f%%",asiaModel.initalOdds.rtnRt.doubleValue * 100] ;
    self.fourthLeLabel.text = [NSString stringWithFormat:@"%.2f%%",asiaModel.immedOdds.rtnRt.doubleValue * 100] ;
}

- (void)setBsModel:(MXDBsModel *)bsModel {
    
    _bsModel = bsModel ;
    
    self.companyLabel.text = bsModel.companyNm ;
    
    self.firstInitialLabel.text = bsModel.initalOdds.ball ;
    self.firstLeLabel.text = bsModel.immedOdds.ball ;
//    NSLog(@"---%@",bsModel.immedOdds.smallFluct) ;
//    NSLog(@"---%@",bsModel.immedOdds.bigFluct) ;
    if ([bsModel.immedOdds.bigFluct isEqualToString:@"1"]) {
        self.firstLeLabel.textColor = mx_redColor ;
    } else if ([bsModel.immedOdds.bigFluct isEqualToString:@"0"]) {
        self.firstLeLabel.textColor = [UIColor blackColor] ;
    } else {
        self.firstLeLabel.textColor = mx_GreenColor ;
    }
    
    NSString * hadpFluctString = @" " ;

    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init] ;
    paragraph.alignment = NSTextAlignmentCenter ;
    
    switch ([bsModel.immedOdds.hadpFluct integerValue]) {
        case -1:
            hadpFluctString = @"降" ;
            break;
        case 0:
            hadpFluctString = @" " ;
            break;
        case 1:
            hadpFluctString = @"升" ;
            break;
        default:
            break;
    }
    
    self.secondInitialLabel.text = bsModel.initalOdds.ball ;
    
    NSMutableAttributedString * immedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",bsModel.immedOdds.ball,hadpFluctString]] ;
    switch ([bsModel.immedOdds.hadpFluct integerValue]) {
        case -1:
            hadpFluctString = @"降" ;
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(9)),NSForegroundColorAttributeName:mx_GreenColor,NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(bsModel.immedOdds.ball.length, 1)];
            break;
        case 1:
            hadpFluctString = @"升" ;
            [immedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(9)),NSForegroundColorAttributeName:mx_redColor,NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(bsModel.immedOdds.ball.length, 1)];
            break;
        default:
            break;
    }
    
    self.secondLeLabel.attributedText = immedString ;
//    NSInteger
    self.thirdInitialLabel.text = [NSString stringWithFormat:@"%g",bsModel.initalOdds.smallOdds] ;
    self.thirdLeLabel.text = [NSString stringWithFormat:@"%g",bsModel.immedOdds.smallOdds] ;
//    NSLog(@"%g----%g",bsModel.initalOdds.smallOdds,bsModel.immedOdds.smallOdds) ;
    if ([bsModel.immedOdds.smallFluct isEqualToString:@"1"]) {
        self.thirdLeLabel.textColor = mx_redColor ;
    } else if ([bsModel.immedOdds.smallFluct isEqualToString:@"0"]) {
        self.thirdLeLabel.textColor = [UIColor blackColor] ;
    } else {
        self.thirdLeLabel.textColor = mx_GreenColor ;
    }
    
    
    self.fourthInitialLabel.text = [NSString stringWithFormat:@"%.2f%%",bsModel.initalOdds.rtnRt.doubleValue * 100] ;
    self.fourthLeLabel.text = [NSString stringWithFormat:@"%.2f%%",bsModel.immedOdds.rtnRt.doubleValue * 100] ;
    
}



- (UILabel *)companyLabel {
    if (!_companyLabel) {
        _companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width/5, scaleWithSize(30))];
        _companyLabel.text = @"公司";
        _companyLabel.textAlignment = 1 ;
        _companyLabel.numberOfLines = 0 ;
        _companyLabel.font = fontSize(scaleWithSize(13)) ;
        
    }
    return _companyLabel ;
}

- (UILabel *)firstInitialLabel {
    if (!_firstInitialLabel) {
        _firstInitialLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.companyLabel.frame), 0, screen_width/5, scaleWithSize(30))];
        _firstInitialLabel.textAlignment = 1 ;
        _firstInitialLabel.text = @"水位" ;
        _firstInitialLabel.font = fontSize(scaleWithSize(13)) ;
    }
    return _firstInitialLabel ;
}
- (UILabel *)firstLeLabel {
    if (!_firstLeLabel) {
        _firstLeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.companyLabel.frame), CGRectGetMaxY(self.firstInitialLabel.frame), screen_width/5, scaleWithSize(30))];
        _firstLeLabel.textAlignment = 1;
        _firstLeLabel.font = fontSize(scaleWithSize(13)) ;
    }
    
    return _firstLeLabel ;
}

- (UILabel *)secondInitialLabel {
    if (!_secondInitialLabel) {
        _secondInitialLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.firstInitialLabel.frame), 0, screen_width/5, scaleWithSize(30))];
        _secondInitialLabel.textAlignment = 1;
        _secondInitialLabel.text = @"盘口";
        _secondInitialLabel.font = fontSize(scaleWithSize(13)) ;
    }
    
    return _secondInitialLabel ;
}
- (UILabel *)secondLeLabel {
    if (!_secondLeLabel) {
        _secondLeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.firstInitialLabel.frame), CGRectGetMaxY(self.secondInitialLabel.frame), screen_width/5, scaleWithSize(30))];
        _secondLeLabel.textAlignment = 1 ;
        _secondLeLabel.font = fontSize(scaleWithSize(13)) ;
    }
    return _secondLeLabel ;
}

- (UILabel *)thirdInitialLabel {
    if (!_thirdInitialLabel) {
        _thirdInitialLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.secondInitialLabel.frame), 0, screen_width/5, scaleWithSize(30))];
        _thirdInitialLabel.text = @"水位";
        _thirdInitialLabel.textAlignment = 1;
        _thirdInitialLabel.font = fontSize(scaleWithSize(13)) ;
    }
    return _thirdInitialLabel ;
}
- (UILabel *)thirdLeLabel {
    if (!_thirdLeLabel) {
        _thirdLeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.secondInitialLabel.frame), CGRectGetMaxY(self.thirdInitialLabel.frame), screen_width/5, scaleWithSize(30))];
        _thirdLeLabel.textAlignment = 1 ;
        _thirdLeLabel.font = fontSize(scaleWithSize(13)) ;
    }
    return _thirdLeLabel;
}

- (UILabel *)fourthInitialLabel {
    if (!_fourthInitialLabel) {
        _fourthInitialLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.thirdInitialLabel.frame), 0, screen_width/5, scaleWithSize(30))];
        _fourthInitialLabel.text = @"返还率";
        _fourthInitialLabel.textAlignment = 1 ;
        _fourthInitialLabel.font = fontSize(scaleWithSize(13)) ;
    }
    return _fourthInitialLabel;
}
- (UILabel *)fourthLeLabel {
    if (!_fourthLeLabel) {
        _fourthLeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.thirdLeLabel.frame), CGRectGetMaxY(self.fourthInitialLabel.frame), screen_width/5, scaleWithSize(30))];
        _fourthLeLabel.textAlignment = 1 ;
        _fourthLeLabel.font = fontSize(scaleWithSize(13)) ;
    }
    return _fourthLeLabel ;
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
