//
//  MXTeamTitleTableViewCell.m
//  MXFootBall
//
//  Created by dai on 2018/3/20.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXTeamTitleTableViewCell.h"

@implementation MXTeamTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        [self.contentView addSubview:self.rankLabel];
        [self.contentView addSubview:self.teamLabel];
        [self.contentView addSubview:self.winFlatNegativeLabel];
        [self.contentView addSubview:self.inOutLabel];
        [self.contentView addSubview:self.integralLabel];
    }
    return self ;
}

- (void)setScoreModel:(MXDScoreModel *)scoreModel {
    _scoreModel = scoreModel ;
    
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",scoreModel.rank] ;
    self.teamLabel.text = scoreModel.teamNm ;
    self.winFlatNegativeLabel.text = [NSString stringWithFormat:@"%ld/%ld/%ld",scoreModel.won,scoreModel.drawn,scoreModel.lost] ;
    self.inOutLabel.text = [NSString stringWithFormat:@"%ld/%ld",scoreModel.goals,scoreModel.against] ;
    self.integralLabel.text = [NSString stringWithFormat:@"%ld",scoreModel.pts] ;
}

- (UILabel *)rankLabel {
    
    if(!_rankLabel){
        
        _rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(10), 0, scaleWithSize(25), scaleWithSize(30))];
        _rankLabel.text = @"排名";
        _rankLabel.font = fontSize(scaleWithSize(11));
        
    }
    return _rankLabel;
}
- (UILabel *)teamLabel {
    
    if(!_teamLabel){
        
        _teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(40), 0, screen_width / 2, scaleWithSize(30))];
        _teamLabel.text = @"球队";
        _teamLabel.font = fontSize(scaleWithSize(11));
        
    }
    return _teamLabel;
    
}
- (UILabel *)winFlatNegativeLabel {
    
    if(!_winFlatNegativeLabel){
        
        _winFlatNegativeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width/2, 0, scaleWithSize(50), scaleWithSize(30))];
        _winFlatNegativeLabel.text = @"胜/平/负";
        _winFlatNegativeLabel.font = fontSize(scaleWithSize(11));
        
    }
    return _winFlatNegativeLabel;
}

- (UILabel *)inOutLabel {
    
    if(!_inOutLabel){
        
        _inOutLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - scaleWithSize(110), 0, scaleWithSize(40), scaleWithSize(30))];
        _inOutLabel.text = @"进/失";
        _inOutLabel.font = fontSize(scaleWithSize(11));
        
    }
    return _inOutLabel;
    
}
- (UILabel *)integralLabel {
    
    if(!_integralLabel){
        
        _integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(screen_width - scaleWithSize(40), 0, scaleWithSize(25), scaleWithSize(30))];
        _integralLabel.text = @"积分";
        _integralLabel.font = fontSize(scaleWithSize(11));
        
    }
    return _integralLabel;
    
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
