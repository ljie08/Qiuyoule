//
//  MXEventTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXEventTableViewCell.h"
#import "NSArray+ArrayBounds.h"

@implementation MXEventTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

//选择按钮 点击方法
//- (IBAction)selectedButton:(id)sender {
//
//
//}



//- (void)setMyevenListModel:(MXssMyCollectGameModel *)MyevenListModel{
//    _MyevenListModel = MyevenListModel;
//    _NumberOfPeriods.text = [NSString stringWithFormat:@"%@  %@",MyevenListModel.eventNm, [MXLJUtil timeInterverlToDateStr:MyevenListModel.matchStartTime]];
//
//    _numberL1.text = [NSString stringWithFormat:@"%@",MyevenListModel.homeScore] ;
//    _numberL2.text = [NSString stringWithFormat:@"%@",MyevenListModel.awayScore] ;
//
//    if (MyevenListModel.isCollect) {
//        _imgView.image = Image(@"saishi_naozhong_hong") ;
//    } else {
//        _imgView.image = Image(@"saishi_naozhong") ;
//    }
//- (void)setMyevenListModel:(MXssMyCollectGameModel *)MyevenListModel{
//    _MyevenListModel = MyevenListModel;
//    _NumberOfPeriods.text = [NSString stringWithFormat:@"%@  %@",MyevenListModel.eventNm, [MXLJUtil timeInterverlToDateStr:MyevenListModel.matchStartTime]];
//
//    _numberL1.text = [NSString stringWithFormat:@"%@",MyevenListModel.homeScore] ;
//    _numberL2.text = [NSString stringWithFormat:@"%@",MyevenListModel.awayScore] ;
//
//    if (MyevenListModel.isCollect) {
//        _imgView.image = Image(@"saishi_naozhong_hong") ;
//    } else {
//        _imgView.image = Image(@"saishi_naozhong") ;
//    }
//
////    } else {
////        _imgView.image = Image(@"saishi_naozhong") ;
////    }
//    _TeamNameL1.text = MyevenListModel.homeNm ;
//    _TeamNameL2.text = MyevenListModel.awayNm ;
//    _ExpertName.hidden = YES;//xxx专家解读隐藏
//    _numberL1.textColor = mx_Wode_color16a635;
//    _numberL2.textColor = mx_Wode_color16a635;
//
//    switch (MyevenListModel.matchStatus.intValue) {
//        case 0:
//            _timeLabel.text = @"异" ;
//            break;
//        case 1:
//            _timeLabel.text = @"未" ;
//            break;
//        case 8:
//            _timeLabel.text = @"完" ;
//            _imgView.hidden = YES ;
//            break;
//        case 9:
//            _timeLabel.text = @"推迟" ;
//            break;
//        case 10:
//            _timeLabel.text = @"中断" ;
//            break;
//        case 11:
//            _timeLabel.text = @"腰斩" ;
//            break;
//        case 12:
//            _timeLabel.text = @"取消" ;
//            break;
//        case 13:
//            _timeLabel.text = @"待定" ;
//            break;
//
//        default://当前时间-开始的时间 matchStartTime
//        { NSDate *senddate = [NSDate date];
////            NSLog(@"date1时间戳 = %ld",time(NULL));
//            NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
////            NSLog(@"date2时间戳 = %@",date2);
//            _timeLabel.text = [NSString stringWithFormat:@"%d'",(int)(date2.doubleValue - MyevenListModel.matchStartTime.doubleValue)/60];
//        }
//            break;
//    }   
//}
- (void)setEventModel:(MXDEventModel *)eventModel {
    
    _eventModel = eventModel ;
    
//    _NumberOfPeriods.text = [NSString stringWithFormat:@"%@  %@",eventModel.event.nameZh , [[MXLJUtil timeInterverlToDateStr:eventModel.TeeTime] componentsSeparatedByString:@" "][1]] ;
    _NumberOfPeriods.text = [NSString stringWithFormat:@"%@  %@",eventModel.eventShortName , [[MXLJUtil timeInterverlToDateStr:eventModel.startBallTime] componentsSeparatedByString:@" "][1]] ;
    _numberL1.text = [NSString stringWithFormat:@"%ld",eventModel.homeTeamScore ] ;
    _numberL2.text = [NSString stringWithFormat:@"%ld",eventModel.visitTeamScore ] ;
    
    
    
    if (eventModel.isCollect == 1) {
        _imgView.image = Image(@"saishi_naozhong_hong") ;
    } else {
        _imgView.image = Image(@"saishi_naozhong") ;
    }
    
    _TeamNameL1.text = eventModel.homeTeamName ;
    _TeamNameL2.text = eventModel.visitTeamName ;
    
    
    switch (eventModel.matchStatus) {
        case 0:
            _timeLabel.text = @"异" ;
            break;
        case 1:
            _timeLabel.text = @"未" ;
            break;
        case 8:
            _timeLabel.text = @"完" ;
            _imgView.hidden = YES ;
            break;
        case 9:
            _timeLabel.text = @"推迟" ;
            break;
        case 10:
            _timeLabel.text = @"中断" ;
            break;
        case 11:
            _timeLabel.text = @"腰斩" ;
            break;
        case 12:
            _timeLabel.text = @"取消" ;
            break;
        case 13:
            _timeLabel.text = @"待定" ;
            break;
            
        default:
//            _timeLabel.text = [NSString stringWithFormat:@"%d'",(int)([[MXLJUtil getNowDateTimeString] doubleValue] - eventModel.TeeTime.doubleValue)/60];
            break;
    }
}


- (void)layoutSubviews{
    
    _NumberOfPeriods.frame = CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(30));
    _NumberOfPeriods.font = fontSize(scaleWithSize(11));
    
    _ExpertName.frame = CGRectMake(0, 0, screen_width - scaleWithSize(15) , scaleWithSize(30));
    _ExpertName.font = fontSize(scaleWithSize(11));
    
    if (_selctButton.hidden) {
        _BackView.frame = CGRectMake(0, 0, screen_width - scaleWithSize(55), scaleWithSize(84)) ;
    } else {
        _BackView.frame = CGRectMake(scaleWithSize(25), 0, screen_width - scaleWithSize(55), scaleWithSize(84)) ;
    }
    
    
    _selctButton.frame = CGRectMake(scaleWithSize(5), scaleWithSize(37), scaleWithSize(40), scaleWithSize(40)) ;
    
    _timeLabel.frame = CGRectMake(scaleWithSize(15), scaleWithSize(30), scaleWithSize(30), scaleWithSize(54));
    _timeLabel.font = fontSize(scaleWithSize(13));
    
    _view1.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame), scaleWithSize(40), 1, scaleWithSize(34)) ;
    
    _numberL1.frame = CGRectMake(CGRectGetMaxX(_view1.frame) + scaleWithSize(10), CGRectGetMinY(_view1.frame), scaleWithSize(20), scaleWithSize(14)) ;
    _numberL1.font = fontSize(scaleWithSize(14)) ;
    _numberL1.textColor = mx_GreenColor ;
    
    _numberL2.frame = CGRectMake(CGRectGetMinX(_numberL1.frame), CGRectGetMaxY(_numberL1.frame) + scaleWithSize(9), scaleWithSize(20), scaleWithSize(14)) ;
    _numberL2.font = fontSize(scaleWithSize(14)) ;
    _numberL2.textColor = mx_GreenColor ;
    
    
    _TeamNameL1.frame = CGRectMake(CGRectGetMaxX(_numberL1.frame) + scaleWithSize(10), CGRectGetMinY(_numberL1.frame), 200, scaleWithSize(15)) ;
    _TeamNameL1.font = fontSize(scaleWithSize(14)) ;
    
    _TeamNameL2.frame = CGRectMake(CGRectGetMaxX(_numberL2.frame) + scaleWithSize(10), CGRectGetMinY(_numberL2.frame), 200, scaleWithSize(15)) ;
    _TeamNameL2.font = fontSize(scaleWithSize(14)) ;
    
    _imgView.frame = CGRectMake(screen_width - scaleWithSize(55), scaleWithSize(45), scaleWithSize(35), scaleWithSize(35));
//    _imgView.backgroundColor = [UIColor redColor];
//    _imgView.image = Image(@"saishi_naozhong") ;
    _imgView.contentMode = UIViewContentModeScaleAspectFit ;
    _imgView.userInteractionEnabled = YES ;
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectorEventCollectMatche)] ;
    [_imgView addGestureRecognizer:tapGesture];
    
   
    _OddsL1.frame = CGRectMake(CGRectGetMinX(_imgView.frame) - scaleWithSize(40), scaleWithSize(45), scaleWithSize(30), scaleWithSize(9));
    _OddsL1.textAlignment = 2 ;
    _OddsL1.font = fontSize(scaleWithSize(9));
    
    _OddsL2.frame = CGRectMake(CGRectGetMinX(_imgView.frame) - scaleWithSize(40), scaleWithSize(70), scaleWithSize(30), scaleWithSize(9));
    _OddsL2.textAlignment = 2 ;
    _OddsL2.font = fontSize(scaleWithSize(9));
    
    _RatioLabel.frame = CGRectMake(CGRectGetMinX(_OddsL1.frame) - scaleWithSize(40), scaleWithSize(45), scaleWithSize(40), scaleWithSize(9));
    _RatioLabel.textAlignment = 2 ;
    _RatioLabel.font = fontSize(scaleWithSize(9));
    
    _RatioLabel2.frame = CGRectMake(CGRectGetMinX(_OddsL2.frame) - scaleWithSize(40), scaleWithSize(70), scaleWithSize(40), scaleWithSize(9));
    _RatioLabel2.textAlignment = 2 ;
    _RatioLabel.font = fontSize(scaleWithSize(9));
    
}

- (void)selectorEventCollectMatche {
    
    if (self.eventCollectMatcheBlock != nil) {
        
        self.eventCollectMatcheBlock() ;
        
//        _imgView.image = Image(@"saishi_naozhong_hong") ;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
