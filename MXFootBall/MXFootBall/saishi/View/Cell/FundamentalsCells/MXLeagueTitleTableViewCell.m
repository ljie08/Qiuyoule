//
//  MXLeagueTitleTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXLeagueTitleTableViewCell.h"

@implementation MXLeagueTitleTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.timeLabel] ;
        [self.contentView addSubview:self.leagueLabel] ;
        [self.contentView addSubview:self.resultsLabel] ;
        [self.contentView addSubview:self.gameLabel] ;
        [self.contentView addSubview:self.homeNameLabel] ;
        [self.contentView addSubview:self.awayNameLabel] ;
        [self.contentView addSubview:self.resultsContentLabel] ;
        
    }
    
    
    
    return self;
}

- (UILabel *)timeLabel {
    
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, scaleWithSize(79), scaleWithSize(30))];
        _timeLabel.text = @"2018-03-08";
        _timeLabel.font = fontSize(scaleWithSize(11));
    }
    return _timeLabel;
}
- (UILabel *)leagueLabel {
    
    if (!_leagueLabel) {
        _leagueLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(90), 0, scaleWithSize(50), scaleWithSize(30))];
        _leagueLabel.text = @"亚特兰";
        _leagueLabel.font = fontSize(scaleWithSize(11));
    }
    return _leagueLabel;
    
}

- (UILabel *)resultsLabel {
    
    if (!_resultsLabel) {
        _resultsLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - scaleWithSize(55), 0, scaleWithSize(40), scaleWithSize(30))];
        _resultsLabel.text = @"赛果";
        _resultsLabel.textAlignment = 1 ;
        _resultsLabel.font = fontSize(scaleWithSize(11));
    }
    return _resultsLabel;
    
}
- (UILabel *)resultsContentLabel {
    
    if (!_resultsContentLabel) {
        _resultsContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - scaleWithSize(55), scaleWithSize(10), scaleWithSize(40), scaleWithSize(10))];
        _resultsContentLabel.text = @"胜";
        _resultsContentLabel.textAlignment = 1;
        _resultsContentLabel.textColor = [UIColor whiteColor];
        _resultsContentLabel.backgroundColor = [UIColor redColor];
        _resultsContentLabel.font = fontSize(scaleWithSize(9));
    }
    return _resultsContentLabel;
}

- (UILabel *)gameLabel {
    
    if (!_gameLabel) {
        _gameLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(218), 0, scaleWithSize(30), scaleWithSize(30))];
//        _gameLabel.text = @"亚特兰   2-1   亚特兰";
        _gameLabel.textAlignment = 1;
        _gameLabel.font = fontSize(scaleWithSize(11));
    }
    return _gameLabel;
}

- (UILabel *)homeNameLabel {
    if (!_homeNameLabel) {
        
        CGFloat width = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"亚特兰亚特" font:fontSize(scaleWithSize(11))] ;
        _homeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(151), 0, width, scaleWithSize(30))] ;
        _homeNameLabel.textAlignment = 2 ;
        _homeNameLabel.font = fontSize(scaleWithSize(11)) ;
        _homeNameLabel.numberOfLines = 2 ;
        _homeNameLabel.adjustsFontSizeToFitWidth = YES ;
        _homeNameLabel.lineBreakMode = NSLineBreakByCharWrapping ;
//        _homeNameLabel.backgroundColor = [UIColor redColor] ;
    }
    return _homeNameLabel ;
}
- (UILabel *)awayNameLabel {
    if (!_awayNameLabel) {
        CGFloat width = [MXwodeUnitObject getWodeUILabelWidthWithTitle:@"亚特兰亚特" font:fontSize(scaleWithSize(11))] ;
        _awayNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - scaleWithSize(60) - width, 0, width, scaleWithSize(30))] ;
        _awayNameLabel.font = fontSize(scaleWithSize(11)) ;
        _awayNameLabel.adjustsFontSizeToFitWidth = YES ;
        _awayNameLabel.numberOfLines = 2 ;
        _awayNameLabel.lineBreakMode = NSLineBreakByCharWrapping ;
//        _awayNameLabel.backgroundColor = [UIColor redColor] ;
    }
    return _awayNameLabel ;
}


- (void)setBattleModel:(MXBattleModel *)battleModel {
    
    _battleModel = battleModel ;
    
    _timeLabel.text = [self timeInterverlToDateStr:battleModel.matchStartTime] ;
    
    _leagueLabel.text = battleModel.eventNm ;
    
    _gameLabel.text = [NSString stringWithFormat:@"%ld-%ld",battleModel.homeScore,battleModel.awayScore] ;
    _homeNameLabel.text = battleModel.homeNm ;
    _awayNameLabel.text = battleModel.awayNm ;
    
    if (battleModel.homeNm.length > 5) {
        _homeNameLabel.textAlignment = 1 ;
    } else {
        _homeNameLabel.textAlignment = 2 ;
    }
    if (battleModel.awayNm.length > 5) {
        _awayNameLabel.textAlignment = 1 ;
    } else {
        _awayNameLabel.textAlignment = 0 ;
    }
    
    switch (battleModel.matchRst) {
        case -1:
            _resultsContentLabel.text = @"负" ;
            _resultsContentLabel.backgroundColor = Color(35, 117, 229, 1) ;
            break;
        case 0:
            _resultsContentLabel.text = @"平" ;
            _resultsContentLabel.backgroundColor = Color(22, 166, 53, 1) ;
            break;
        case 1:
            _resultsContentLabel.text = @"胜" ;
            _resultsContentLabel.backgroundColor = Color(214, 18, 19, 1) ;
            break;
            
        default:
            break;
    }
    
}


//时间戳转为时间字符串
- (NSString *)timeInterverlToDateStr:(NSString *)timeStr {
    //timeStr时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
//    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式yyyy.MM.dd HH:mm
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
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
