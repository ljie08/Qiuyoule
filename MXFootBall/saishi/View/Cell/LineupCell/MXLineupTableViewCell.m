//
//  MXLineupTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/21.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXLineupTableViewCell.h"

@implementation MXLineupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.playerLabel];
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.reasonLabel];
        [self.contentView addSubview:self.frequencyLabel];
        
    }
    return self ;
}

- (void)setInjuredModel:(MXDInjuredPlayerModel *)injuredModel {
    _injuredModel = injuredModel ;
    
    self.playerLabel.text = injuredModel.name ;
    
    
    switch ([injuredModel.position characterAtIndex:0] - 'A') {
        case ('F' - 'A'):
            self.positionLabel.text = @"前锋" ;
            break;
        case ('M' - 'A'):
            self.positionLabel.text = @"中锋" ;
            break;
        case ('D' - 'A'):
            self.positionLabel.text = @"后卫" ;
            break;
        case ('G' - 'A'):
            self.positionLabel.text = @"守门员" ;
            break;
            
        default:
            break;
    }
    
    self.reasonLabel.text = injuredModel.reason ;
    
//    [injuredModel.endTime isEqualToString:@""]
    if (![injuredModel.endTime isEqualToString:@"(null)"] && ![injuredModel.endTime isEqualToString:@"null"] && injuredModel.endTime != NULL && ![injuredModel.endTime isEqualToString:@""] && injuredModel.endTime != nil &&![injuredModel.endTime isEqualToString:@"0"]) {
        
        self.frequencyLabel.text = [self timeInterverlToDateStr:injuredModel.endTime];
    } else {
        
        self.frequencyLabel.text = @"未知" ;
    }
    
}





- (UILabel *)playerLabel {
    
    if (!_playerLabel) {
        _playerLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width/4 + scaleWithSize(40), scaleWithSize(30))];
//        _playerLabel.text = @"球员";
//        _playerLabel.backgroundColor = [UIColor redColor] ;
    }
    
    return _playerLabel ;
}

- (UILabel *)positionLabel {
    
    if (!_positionLabel) {
        _positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/4 + + scaleWithSize(30), 0, screen_width/4, scaleWithSize(30))];
//        _positionLabel.text = @"位置";
        _positionLabel.textAlignment = 1 ;
    }
    
    return _positionLabel ;
}

- (UILabel *)reasonLabel {
    
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/2 + scaleWithSize(20), 0, screen_width/4, scaleWithSize(30))];
//        _reasonLabel.text = @"原因";
        _reasonLabel.textAlignment = 1 ;
    }
    
    return _reasonLabel ;
}

- (UILabel *)frequencyLabel {
    
    if (!_frequencyLabel) {
        _frequencyLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width * 3/4 - scaleWithSize(15), 0, screen_width/4, scaleWithSize(30))];
//        _frequencyLabel.text = @"频率";
        _frequencyLabel.textAlignment = 2 ;
        
    }
    
    return _frequencyLabel ;
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
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
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
