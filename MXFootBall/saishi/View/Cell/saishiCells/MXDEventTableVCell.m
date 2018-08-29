//
//  MXDEventTableVCell.m
//  MXFootBall
//
//  Created by dai on 2018/4/27.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXDEventTableVCell.h"

@implementation MXDEventTableVCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        [self.contentView addSubview:self.titleLabel] ;
//        [self.contentView addSubview:self.viewsLabel] ;
//        [self.contentView addSubview:self.oddsLabel] ;
        [self.contentView addSubview:self.backView] ;
        
        [self.contentView addSubview:self.selectButton] ;
        
        [self.backView addSubview:self.matchTime] ;
        [self.backView addSubview:self.matchStatusLabel] ;
        [self.backView addSubview:self.blackView] ;
        [self.backView addSubview:self.timeLabel] ;
        [self.backView addSubview:self.collectButton] ;
        
        [self.backView addSubview:self.homeNameLabel] ;
        [self.backView addSubview:self.homeLogoImgView] ;
        [self.backView addSubview:self.homeScore] ;
        
        [self.backView addSubview:self.awayNameLabel] ;
        [self.backView addSubview:self.awayLogoImgView] ;
        [self.backView addSubview:self.awayScore] ;
        
        
        [self.backView addSubview:self.matchStatusImgView] ;
    }
    return self ;
}

- (void)setEventModel:(MXDEventModel *)eventModel {
    
    _eventModel = eventModel ;
    
//    self.titleLabel.text = @"xxxxx期 052" ;
//    self.viewsLabel.text = @"xxx观点" ;
//    NSLog(@"%@",eventModel.TeeTime) ;
    
    if (eventModel.matchStatus == 2 ||
        eventModel.matchStatus == 3 ||
        eventModel.matchStatus == 4 ||
        eventModel.matchStatus == 5 ||
        eventModel.matchStatus == 6 ||
        eventModel.matchStatus == 7 ) {
        
        int matchStartTime = [[MXLJUtil getNowDateTimeString] doubleValue] - [eventModel.startBallTime doubleValue] ;

        NSString * startTime = @"" ;
            if (matchStartTime/3600) {
                startTime = [NSString stringWithFormat:@"%d:%02d:%02d",matchStartTime/3600,matchStartTime%3600/60,matchStartTime%60] ;
            } else if (matchStartTime/60) {
                startTime = [NSString stringWithFormat:@"%d:%02d",matchStartTime/60,matchStartTime%60] ;
            } else {
                startTime = [NSString stringWithFormat:@"%d",matchStartTime] ;
                
            }
            
            NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc]init] ;
            paragraph.alignment = NSTextAlignmentCenter ;
                    NSMutableAttributedString *
            matchTimeAttributedString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",eventModel.eventShortName,startTime]] ;
            [matchTimeAttributedString addAttributes:@{NSFontAttributeName : fontSize(scaleWithSize(12)),NSForegroundColorAttributeName:mx_redColor,NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(eventModel.eventShortName.length + 1, startTime.length)];
            
            self.matchTime.attributedText = matchTimeAttributedString ;
        
        self.matchStatusLabel.text = @"文字、动画直播中" ;
        self.matchStatusLabel.textColor = mx_BlueColor ;
        self.timeLabel.text = @"" ;
            
    } else {
        
        self.matchStatusLabel.text = @"文字、动画即将开始" ;
        self.matchStatusLabel.textColor = mx_FontLightGreyColor ;
        
        self.matchTime.text = [NSString stringWithFormat:@"%@",eventModel.eventShortName] ;
        self.timeLabel.text = [self timeInterverlToDateStr:eventModel.startGameTime] ;
        
        
    }
    
    [self.homeLogoImgView sd_setImageWithURL:[NSURL URLWithString:eventModel.homeTeamLogo] placeholderImage:Image(@"saishi_huilogo")];
    self.homeScore.text = [NSString stringWithFormat:@"%ld",eventModel.homeTeamScore ] ;
    self.homeNameLabel.text = eventModel.homeTeamName ;
    
    [self.awayLogoImgView sd_setImageWithURL:[NSURL URLWithString:eventModel.visitTeamLogo] placeholderImage:Image(@"saishi_huilogo")];
    self.awayScore.text = [NSString stringWithFormat:@"%ld",eventModel.visitTeamScore] ;
    self.awayNameLabel.text = eventModel.visitTeamName ;
    
//    NSArray * array = [eventModel.odds componentsSeparatedByString:@","] ;
//    NSLog(@"%@",array) ;
//    NSString * oddsString = @"" ;
//    for (NSString * string in array) {
//        oddsString = [NSString stringWithFormat:@"%@  %@",oddsString,string] ;
//    }
//    self.oddsLabel.text = oddsString ;
    
//    NSLog(@"---%ld",eventModel.isCollect) ;
    if (eventModel.isCollect == 1) {
        [self.collectButton setImage:Image(@"saishi_weishoucang") forState:(UIControlStateNormal)];
        //        _imgView.image = Image(@"saishi_naozhong_hong") ;
    } else {
        [self.collectButton setImage:Image(@"saishi_yishoucang") forState:(UIControlStateNormal)];
        //        _imgView.image = Image(@"saishi_naozhong") ;
    }
    
    if (eventModel.matchStatus == 2 ||
        eventModel.matchStatus == 3 ||
        eventModel.matchStatus == 4 ||
        eventModel.matchStatus == 5 ||
        eventModel.matchStatus == 6 ||
        eventModel.matchStatus == 7 ||
        eventModel.matchStatus == 8) {
        self.homeScore.hidden = NO ;
        self.awayScore.hidden = NO ;
        self.blackView.hidden = NO ;
//        self.matchTime.frame = CGRectMake(0, scaleWithSize(10), screen_width, scaleWithSize(30));
//        self.collectButton.center = CGPointMake(screen_width/2, scaleWithSize(85)) ;
        
    } else {
        self.homeScore.hidden = YES ;
        self.awayScore.hidden = YES ;
        self.blackView.hidden = YES ;
//        self.matchTime.frame = CGRectMake(0, scaleWithSize(25), screen_width, scaleWithSize(30));
//        self.collectButton.center = CGPointMake(screen_width/2, scaleWithSize(70)) ;
    }
    
    if (eventModel.matchStatus == 8) {
        self.homeScore.textColor = [UIColor blackColor] ;
        self.awayScore.textColor = [UIColor blackColor] ;
        self.timeLabel.text = @"" ;
        self.matchStatusLabel.text = @"" ;
        self.matchTime.text = [NSString stringWithFormat:@"%@ %@",eventModel.eventShortName ,[self timeInterverlToDateStr:eventModel.startGameTime]] ;
        self.matchTime.frame = CGRectMake(0, scaleWithSize(10), screen_width, scaleWithSize(20)) ;
    } else {
        self.homeScore.textColor = mx_redColor ;
        self.awayScore.textColor = mx_BlueColor ;
        
        self.matchTime.frame = CGRectMake(0, scaleWithSize(5), screen_width, scaleWithSize(20)) ;
    }
    
}
- (NSString *)timeInterverlToDateStr:(NSString *)timeStr {
    //timeStr时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
//    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式yyyy.MM.dd HH:mm
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init] ;
        _titleLabel.frame = CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(30)) ;
        _titleLabel.textColor = mx_FontLightGreyColor ;
        _titleLabel.font = fontSize(scaleWithSize(11)) ;
    }
    return _titleLabel ;
}
- (UILabel *)viewsLabel {//观点
    if (!_viewsLabel) {
        _viewsLabel = [[UILabel alloc]init] ;
        _viewsLabel.frame = CGRectMake(0, 0, screen_width - scaleWithSize(15), scaleWithSize(30)) ;
        _viewsLabel.textAlignment = 2 ;
        _viewsLabel.textColor = mx_FontLightGreyColor ;
        _viewsLabel.font = fontSize(scaleWithSize(11)) ;
    }
    return _viewsLabel ;
}
- (UIView *)backView {//赛事信息背景View
    if (!_backView) {
        _backView = [[UIView alloc]init] ;
        _backView.frame = CGRectMake(0, 0, screen_width, scaleWithSize(98));
    }
    return _backView ;
    
}
- (UIButton *)selectButton {//多选按钮
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:(UIButtonTypeCustom)] ;
        _selectButton.frame = CGRectMake(0, 0, scaleWithSize(40), scaleWithSize(40)) ;
        _selectButton.center = CGPointMake(scaleWithSize(20), CGRectGetMidY(self.backView.frame)) ;
    }
    return _selectButton ;
}

- (UILabel *)oddsLabel {//赔率
    if (!_oddsLabel) {
        _oddsLabel = [[UILabel alloc]init] ;
        _oddsLabel.frame = CGRectMake(scaleWithSize(15), CGRectGetMaxY(self.backView.frame), screen_width, scaleWithSize(30)) ;
        _oddsLabel.textColor = mx_FontLightGreyColor ;
        _oddsLabel.font = fontSize(scaleWithSize(11)) ;
    }
    return _oddsLabel ;
}

#pragma mark - 添加到 backView
- (UILabel *)matchTime {//比赛时间/联赛
    if (!_matchTime) {
        _matchTime = [[UILabel alloc]init] ;
        _matchTime.frame = CGRectMake(0, scaleWithSize(5), screen_width, scaleWithSize(20));
        _matchTime.textAlignment = 1 ;
//        _matchTime.textColor = mx_FontLightGreyColor ;
        _matchTime.font = fontSize(scaleWithSize(12)) ;
    }
    return _matchTime ;
}
- (UILabel *)matchStatusLabel {
    if (!_matchStatusLabel) {
        _matchStatusLabel = [[UILabel alloc]init] ;
        _matchStatusLabel.frame = CGRectMake(0, CGRectGetMaxY(self.matchTime.frame), screen_width, scaleWithSize(10)) ;
        _matchStatusLabel.textAlignment = 1 ;
        _matchStatusLabel.font = fontSize(scaleWithSize(8)) ;
    }
    return _matchStatusLabel ;
}
- (UIView *)blackView {
    if (!_blackView) {
        _blackView = [[UIView alloc]init] ;
        _blackView.frame = CGRectMake(0, 0, scaleWithSize(15), scaleWithSize(2)) ;
        _blackView.center = CGPointMake(screen_width/2, CGRectGetMidY(self.homeScore.frame)) ;
        _blackView.backgroundColor = [UIColor blackColor] ;
    }
    return _blackView ;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init] ;
        _timeLabel.frame = CGRectMake(0, 0, screen_width, scaleWithSize(30)) ;
        _timeLabel.center = self.blackView.center ;
        _timeLabel.textAlignment = 1 ;
        _timeLabel.font = fontSize(scaleWithSize(12)) ;
        _timeLabel.textColor = mx_FontLightGreyColor ;
    }
    return _timeLabel ;
}
- (UILabel *)homeScore {//主队比分
    if (!_homeScore) {
        _homeScore = [[UILabel alloc]init] ;
        _homeScore.frame = CGRectMake(0, scaleWithSize(25), screen_width/2 - scaleWithSize(24), scaleWithSize(50));
        _homeScore.textAlignment = 2 ;
        _homeScore.textColor = mx_redColor ;
        _homeScore.font = fontSize(scaleWithSize(18)) ;
    }
    return _homeScore ;
}
- (UILabel *)awayScore {//客队比分
    if (!_awayScore) {
        _awayScore = [[UILabel alloc]init] ;
        _awayScore.frame = CGRectMake(screen_width/2 + scaleWithSize(24), scaleWithSize(25), screen_width/2, scaleWithSize(50));
        _awayScore.textColor = mx_BlueColor ;
        _awayScore.textAlignment = 0 ;
        _awayScore.font = fontSize(scaleWithSize(18)) ;
    }
    return _awayScore ;
}

- (UIButton *)collectButton {//收藏按钮
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:(UIButtonTypeCustom)] ;
        _collectButton.frame = CGRectMake(0, 0, scaleWithSize(25.f/32*27), scaleWithSize(25)) ;
        _collectButton.center = CGPointMake(screen_width/2, scaleWithSize(75)) ;
        _collectButton.contentMode = UIViewContentModeScaleAspectFit ;
        [_collectButton addTarget:self action:@selector(selectorEventCollectMatche) forControlEvents:(UIControlEventTouchDown)];
    }
    return _collectButton ;
}

- (UIImageView *)matchStatusImgView{//比赛状态
    if (!_matchStatusImgView) {
        _matchStatusImgView = [[UIImageView alloc]init] ;
        _matchStatusImgView.frame = CGRectMake(0, 0, scaleWithSize(80), scaleWithSize(27)) ;
        _matchStatusImgView.center = CGPointMake(screen_width/2, scaleWithSize(85)) ;
//        _matchStatusImgView.backgroundColor = [UIColor redColor] ;
    }
    return _matchStatusImgView ;
}


- (UIImageView *)homeLogoImgView {//主队logo
    if (!_homeLogoImgView) {
        _homeLogoImgView = [[UIImageView alloc]init] ;
        _homeLogoImgView.frame = CGRectMake(scaleWithSize(46), scaleWithSize(19), scaleWithSize(49), scaleWithSize(49));
        _homeLogoImgView.contentMode = UIViewContentModeScaleAspectFit ;
    }
    return _homeLogoImgView ;
}
- (UILabel *)homeNameLabel {//主队名
    if (!_homeNameLabel) {
        _homeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, scaleWithSize(148), scaleWithSize(30))] ;
        _homeNameLabel.textAlignment = 1;
        _homeNameLabel.center = CGPointMake(self.homeLogoImgView.center.x, self.backView.frame.size.height - scaleWithSize(20)) ;
        _homeNameLabel.font = fontSize(scaleWithSize(10)) ;
    }
    return _homeNameLabel ;
}
- (UIImageView *)awayLogoImgView {//客队logo
    if (!_awayLogoImgView) {
        _awayLogoImgView = [[UIImageView alloc]init] ;
        _awayLogoImgView.frame = CGRectMake(screen_width - scaleWithSize(55 + 46), scaleWithSize(17), scaleWithSize(49), scaleWithSize(49));
        _awayLogoImgView.contentMode = UIViewContentModeScaleAspectFit ;
    }
    return _awayLogoImgView ;
}
- (UILabel *)awayNameLabel {//客队名
    if (!_awayNameLabel) {
        _awayNameLabel = [[UILabel alloc]init] ;
        _awayNameLabel.frame = CGRectMake(0, 0, scaleWithSize(148), scaleWithSize(30));
        _awayNameLabel.center =  CGPointMake(self.awayLogoImgView.center.x, self.backView.frame.size.height - scaleWithSize(20));
        _awayNameLabel.textAlignment = 1 ;
        _awayNameLabel.font = fontSize(scaleWithSize(10)) ;
    }
    return _awayNameLabel ;
}



- (void)selectorEventCollectMatche {
    
    if (self.eventCollectMatcheBlock != nil) {
        
        self.eventCollectMatcheBlock() ;
        
        //        _imgView.image = Image(@"saishi_naozhong_hong") ;
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
