//
//  MXHomeCountdownCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/18.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeCountdownCell.h"

@interface MXHomeCountdownCell()

@property (weak, nonatomic) IBOutlet UIImageView *picView;//背景图
@property (weak, nonatomic) IBOutlet UIView *bgView;//倒计时bg
@property (weak, nonatomic) IBOutlet UILabel *dayLab;//天数
@property (weak, nonatomic) IBOutlet UILabel *dayTextLab;//天
@property (weak, nonatomic) IBOutlet UILabel *hourLab;//小时
@property (weak, nonatomic) IBOutlet UILabel *hourTextLab;//时
@property (weak, nonatomic) IBOutlet UILabel *minuteLab;//分钟
@property (weak, nonatomic) IBOutlet UILabel *minuteTextLab;//分
@property (weak, nonatomic) IBOutlet UILabel *secondLab;//秒数
//6.14当天，显示时、分、秒，6.14之前显示天、时、分、秒

@end

@implementation MXHomeCountdownCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MXHomeCountdownCell";
    MXHomeCountdownCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MXHomeCountdownCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
//    cell.bgView.hidden = YES;
    
    return cell;
}

/**
 设置倒计时的时间

 @param countdown 倒计时
 */
- (void)setTimeWithCountDown:(MXLJCountDown *)countdown pic:(NSString *)pic {
//    NSLog(@"类型%ld🚗%@天-%@时-%@分-%@秒-%@毫秒", countdown.showType, countdown.day, countdown.hour, countdown.minute, countdown.second, countdown.millisecond);
    //如果day=0显示时分秒，day>0显示天时分秒
    if (countdown.showType == 1) {//比赛开始前，6月14之前
        self.dayLab.text = countdown.day ? countdown.day : @"00";
        self.hourLab.text = countdown.hour ? countdown.hour : @"00";
        self.minuteLab.text = countdown.minute ? countdown.minute : @"00";
        self.secondLab.hidden = NO;
        self.secondLab.text = countdown.second ? countdown.second : @"00";
        self.dayTextLab.text = @"天";
        self.hourTextLab.text = @"时";
        self.minuteTextLab.text = @"分";
        self.picView.image = Image(@"time_lan");
        self.bgView.hidden = NO;
    }
    if (countdown.showType == 2) {//比赛开始前当天，6月14当天
        self.dayLab.text = countdown.hour ? countdown.hour : @"00";
        self.hourLab.text = countdown.minute ? countdown.minute : @"00";
        self.minuteLab.text = countdown.second ? countdown.second : @"00";
        self.dayTextLab.text = @"时";
        self.hourTextLab.text = @"分";
        self.minuteTextLab.text = @"秒";
        self.secondLab.hidden = NO;
        self.secondLab.text = countdown.millisecond;
        self.picView.image = Image(@"time_cheng");
        self.bgView.hidden = NO;
    }
    if (countdown.showType == 3)  {//比赛开始后
        self.bgView.hidden = YES;
        [self.picView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:Image(@"bannerPlace") options:SDWebImageAllowInvalidSSLCertificates];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
