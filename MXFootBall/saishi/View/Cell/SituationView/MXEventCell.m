//
//  MXEventCell.m
//  MXFootBall
//
//  Created by YY on 2018/4/10.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXEventCell.h"
@interface MXEventCell ()
@property (weak, nonatomic) IBOutlet UIImageView *mainTeamEventLogo;

@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UIImageView *guestTeamEventLogo;
@property (weak, nonatomic) IBOutlet UILabel *guestTeamEventContent;
@property (weak, nonatomic) IBOutlet UILabel *mainTeamEventContent;

@end
@implementation MXEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(MXEventModel *)model{
    if ([model.position integerValue]==0) {
        self.eventTime.text=model.time;
       
        self.mainTeamEventContent.text=model.minData;
        
        self.guestTeamEventContent.text=@"";
        self.guestTeamEventLogo.image=[UIImage imageNamed:@"Color"];
        
    }else if ([model.position integerValue]==1){
        [self.mainTeamEventLogo sd_setImageWithURL:[NSURL URLWithString:model.eventLogo] placeholderImage:[UIImage imageNamed:@"1"]];
        self.mainTeamEventContent.text=model.minData;
        self.eventTime.text=model.time;
        self.guestTeamEventContent.text=@"";
        self.guestTeamEventLogo.image=[UIImage imageNamed:@"Color"];
    }else{
        [self.guestTeamEventLogo sd_setImageWithURL:[NSURL URLWithString:model.eventLogo] placeholderImage:[UIImage imageNamed:@"1"]];
        self.guestTeamEventContent.text=model.minData;
        self.eventTime.text=model.time;
        self.mainTeamEventContent.text=@"";
        self.mainTeamEventLogo.image=[UIImage imageNamed:@"Color"];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
