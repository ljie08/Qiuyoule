//
//  MXDiskTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXDiskTableViewCell.h"


#define cell_height scaleWithSize(130)


@implementation MXDiskTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.homeTeamL] ;
        [self.contentView addSubview:self.homeTeamLastSeasonOddsL];
        [self.contentView addSubview:self.homeTeamThisSeasonOddsL];
        [self.contentView addSubview:self.homeTeamLastSeasonExplanationL];
        [self.contentView addSubview:self.homeTeamThisSeasonExplanationL];
        
        [self.contentView addSubview:self.lastSeasonLabel];
        [self.contentView addSubview:self.thisSeasonLabel];
        
        [self.contentView addSubview:self.visitingTeamL];
        [self.contentView addSubview:self.visitingTeamLastSeasonOddsL];
        [self.contentView addSubview:self.visitingTeamThisSeasonOddsL];
        [self.contentView addSubview:self.visitingTeamLastSeasonExplanationL];
        [self.contentView addSubview:self.visitingTeamThisSeasonExplanationL];
        
    }
    
    return self ;
}

- (UILabel *)homeTeamL {
    if (!_homeTeamL) {
        
        _homeTeamL = [[UILabel alloc]init];
        _homeTeamL.textColor = [UIColor whiteColor];
        _homeTeamL.text = @"主队历史一赔胜率";
        _homeTeamL.font = fontSize(scaleWithSize(11));
        CGFloat labelWidth = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"主队历史一赔胜率" font:fontSize(scaleWithSize(11))];
        _homeTeamL.frame = CGRectMake(scaleWithSize(15), 0, labelWidth, scaleWithSize(30));
        
    }
    return _homeTeamL ;
}

- (UILabel *)homeTeamThisSeasonOddsL {
    
    if (!_homeTeamThisSeasonOddsL) {
        
        _homeTeamThisSeasonOddsL = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), CGRectGetMaxY(self.homeTeamL.frame) + scaleWithSize(10), self.homeTeamL.frame.size.width, scaleWithSize(23))];
        _homeTeamThisSeasonOddsL.text = @"33.3%";
        _homeTeamThisSeasonOddsL.textColor = [UIColor whiteColor];
        _homeTeamThisSeasonOddsL.textAlignment = 1;
        _homeTeamThisSeasonOddsL.font = fontSize(scaleWithSize(23));
        
    }
    
    return _homeTeamThisSeasonOddsL ;
}
-(UILabel *)homeTeamThisSeasonExplanationL {
    
    if (!_homeTeamThisSeasonExplanationL) {
        
        _homeTeamThisSeasonExplanationL = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), CGRectGetMaxY(self.homeTeamThisSeasonOddsL.frame) + scaleWithSize(6), self.homeTeamL.frame.size.width, scaleWithSize(9))];
        _homeTeamThisSeasonExplanationL.text = @"1胜1平1负";
        _homeTeamThisSeasonExplanationL.textColor = [UIColor whiteColor];
        _homeTeamThisSeasonExplanationL.textAlignment = 1;
        _homeTeamThisSeasonExplanationL.font = fontSize(scaleWithSize(9));
        
    }
    
    return _homeTeamThisSeasonExplanationL ;
}

- (UILabel *)homeTeamLastSeasonOddsL {
    
    if (!_homeTeamLastSeasonOddsL) {
        
        _homeTeamLastSeasonOddsL = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), CGRectGetMaxY(self.homeTeamThisSeasonExplanationL.frame) + scaleWithSize(10), self.homeTeamL.frame.size.width, scaleWithSize(23))];
        _homeTeamLastSeasonOddsL.text = @"33.3%";
        _homeTeamLastSeasonOddsL.textColor = [UIColor whiteColor];
        _homeTeamLastSeasonOddsL.textAlignment = 1;
        _homeTeamLastSeasonOddsL.font = fontSize(scaleWithSize(23));
        
    }
    
    return _homeTeamLastSeasonOddsL ;
    
}
- (UILabel *)homeTeamLastSeasonExplanationL {
    
    if (!_homeTeamLastSeasonExplanationL) {
        
        _homeTeamLastSeasonExplanationL = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), CGRectGetMaxY(self.homeTeamLastSeasonOddsL.frame) + scaleWithSize(6), self.homeTeamL.frame.size.width, scaleWithSize(9))];
        _homeTeamLastSeasonExplanationL.text = @"1胜1平1负";
        _homeTeamLastSeasonExplanationL.textColor = [UIColor whiteColor];
        _homeTeamLastSeasonExplanationL.textAlignment = 1;
        _homeTeamLastSeasonExplanationL.font = fontSize(scaleWithSize(9));
        
    }
    
    return _homeTeamLastSeasonExplanationL ;
    
}




- (UILabel *)visitingTeamL {
    
    if (!_visitingTeamL) {
        
        _visitingTeamL = [[UILabel alloc]init];
        _visitingTeamL.textColor = [UIColor whiteColor];
        _visitingTeamL.text = @"客队历史一赔胜率";
        _visitingTeamL.font = fontSize(scaleWithSize(11));
        CGFloat labelWidth = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"客队历史一赔胜率" font:fontSize(scaleWithSize(11))];
        _visitingTeamL.frame = CGRectMake(screen_width - labelWidth - scaleWithSize(15), 0, labelWidth, scaleWithSize(30));
        
    }
    return _visitingTeamL ;
    
}

- (UILabel *)visitingTeamThisSeasonOddsL {
    
    if (!_visitingTeamThisSeasonOddsL) {
        
        _visitingTeamThisSeasonOddsL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.visitingTeamL.frame), CGRectGetMaxY(self.visitingTeamL.frame) + scaleWithSize(10), self.visitingTeamL.frame.size.width, scaleWithSize(23))];
        _visitingTeamThisSeasonOddsL.text = @"33.3%";
        _visitingTeamThisSeasonOddsL.textColor = [UIColor whiteColor];
        _visitingTeamThisSeasonOddsL.textAlignment = 1;
        _visitingTeamThisSeasonOddsL.font = fontSize(scaleWithSize(23));
        
    }
    
    return _visitingTeamThisSeasonOddsL ;
}

- (UILabel *)visitingTeamThisSeasonExplanationL {
    
    if (!_visitingTeamThisSeasonExplanationL) {
        
        _visitingTeamThisSeasonExplanationL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.visitingTeamL.frame), CGRectGetMaxY(self.visitingTeamThisSeasonOddsL.frame) + scaleWithSize(6), self.visitingTeamL.frame.size.width, scaleWithSize(9))];
        _visitingTeamThisSeasonExplanationL.text = @"1胜1平1负";
        _visitingTeamThisSeasonExplanationL.textColor = [UIColor whiteColor];
        _visitingTeamThisSeasonExplanationL.textAlignment = 1;
        _visitingTeamThisSeasonExplanationL.font = fontSize(scaleWithSize(9));
        
    }
    
    return _visitingTeamThisSeasonExplanationL ;

}
//
- (UILabel *)visitingTeamLastSeasonOddsL {
    
    if (!_visitingTeamLastSeasonOddsL) {
        
        _visitingTeamLastSeasonOddsL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.visitingTeamL.frame), CGRectGetMaxY(self.visitingTeamThisSeasonExplanationL.frame) + scaleWithSize(10), self.homeTeamL.frame.size.width, scaleWithSize(23))];
        _visitingTeamLastSeasonOddsL.text = @"33.3%";
        _visitingTeamLastSeasonOddsL.textColor = [UIColor whiteColor];
        _visitingTeamLastSeasonOddsL.textAlignment = 1;
        _visitingTeamLastSeasonOddsL.font = fontSize(scaleWithSize(23));
        
    }
    
    return _visitingTeamLastSeasonOddsL ;

}
//
- (UILabel *)visitingTeamLastSeasonExplanationL {
    
    if (!_visitingTeamLastSeasonExplanationL) {
        
        _visitingTeamLastSeasonExplanationL = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.visitingTeamL.frame), CGRectGetMaxY(self.visitingTeamLastSeasonOddsL.frame) + scaleWithSize(6), self.homeTeamL.frame.size.width, scaleWithSize(9))];
        _visitingTeamLastSeasonExplanationL.text = @"1胜1平1负";
        _visitingTeamLastSeasonExplanationL.textColor = [UIColor whiteColor];
        _visitingTeamLastSeasonExplanationL.textAlignment = 1;
        _visitingTeamLastSeasonExplanationL.font = fontSize(scaleWithSize(9));
        
    }
    
    return _visitingTeamLastSeasonExplanationL ;

}

- (UILabel *)thisSeasonLabel {
    if (!_thisSeasonLabel) {
        _thisSeasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width/2, scaleWithSize(20))];
        _thisSeasonLabel.textColor = [UIColor whiteColor];
        _thisSeasonLabel.textAlignment = 1 ;
        _thisSeasonLabel.text = @"本赛季";
        _thisSeasonLabel.center = CGPointMake(screen_width/2.f, (cell_height -scaleWithSize(30))/4.f + scaleWithSize(30));
        
    }
    return _thisSeasonLabel;
}
- (UILabel *)lastSeasonLabel {
    
    if (!_lastSeasonLabel) {
        _lastSeasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screen_width/2, scaleWithSize(20))];
        _lastSeasonLabel.textColor = [UIColor whiteColor];
        _lastSeasonLabel.textAlignment = 1 ;
        _lastSeasonLabel.text = @"上赛季";
        _lastSeasonLabel.center = CGPointMake(screen_width/2.f, (cell_height -scaleWithSize(30)) * 3/4.f + scaleWithSize(30));
    }
    return _lastSeasonLabel;
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
