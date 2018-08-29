//
//  MXWorldCupTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXWorldCupTableViewCell.h"

@implementation MXWorldCupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setWorldCupModel:(MXWorldCupModel *)worldCupModel {
    
    _worldCupModel = worldCupModel ;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init] ;
    //    NSTimeZone * tz = [NSTimeZone timeZoneWithAbbreviation:@"GMT"] ;
    //    [dateFormatter setTimeZone:tz] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"] ;
    NSDate * date = [dateFormatter dateFromString:worldCupModel.matchTime] ;
    
//    battleDetails.matchStartTime = [NSString stringWithFormat:@"%.0f",[date timeIntervalSince1970]] ;
    //设定时间格式,这里可以设置成自己需要的格式yyyy.MM.dd HH:mm
    [dateFormatter setDateFormat:@"MM/dd HH:mm:ss"];
    
    self.timeLabel.text = [dateFormatter stringFromDate: date] ;
    
    self.countryLabel.text = worldCupModel.homeTeam ;
    
    self.awayTeamLabel.text = worldCupModel.awayTeam ;
    
    [self.homeImgV sd_setImageWithURL:[NSURL URLWithString:worldCupModel.homeLogo] placeholderImage:Image(@"saishi_huilogo")] ;
    
    [self.awayImgV sd_setImageWithURL:[NSURL URLWithString:worldCupModel.awayLogo] placeholderImage:Image(@"saishi_huilogo")] ;
    
}


- (void)layoutSubviews {
    
    _timeLabel.frame = CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(44)) ;
    _timeLabel.font = fontSize(scaleWithSize(13)) ;
    
    
    _horizontalLabel.frame = CGRectMake(0, 0, scaleWithSize(60), scaleWithSize(44)) ;
    _horizontalLabel.center = CGPointMake(3 * screen_width/4.f - scaleWithSize(20), scaleWithSize(22)) ;
    _horizontalLabel.text = @"VS" ;
    _horizontalLabel.font = fontSize(scaleWithSize(13)) ;
    
    _homeImgV.frame = CGRectMake(0, 0, scaleWithSize(20), scaleWithSize(20)) ;
    _homeImgV.center = CGPointMake(CGRectGetMinX(self.horizontalLabel.frame), scaleWithSize(22)) ;
//    _homeImgV.image = Image(@"saishi_huilogo") ;
    
    _awayImgV.frame = CGRectMake(0, 0, scaleWithSize(20), scaleWithSize(20)) ;
    _awayImgV.center = CGPointMake(CGRectGetMaxX(self.horizontalLabel.frame), scaleWithSize(22));
//    _awayImgV.image = Image(@"saishi_huilogo") ;
    
    _awayTeamLabel.frame = CGRectMake(0 , 0, screen_width/6.f, scaleWithSize(44)) ;
    _awayTeamLabel.center = CGPointMake(CGRectGetMaxX(self.awayImgV.frame) + scaleWithSize(10) + screen_width/12.f, scaleWithSize(22)) ;
    _awayTeamLabel.font = fontSize(scaleWithSize(13)) ;
    
    _countryLabel.frame = CGRectMake(0, 0, screen_width/6.f, scaleWithSize(44)) ;
    _countryLabel.center = CGPointMake(CGRectGetMinX(self.homeImgV.frame) - scaleWithSize(10) - screen_width/12.f, scaleWithSize(22)) ;
    _countryLabel.font = fontSize(scaleWithSize(13)) ;
    _countryLabel.textAlignment = 2 ;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
