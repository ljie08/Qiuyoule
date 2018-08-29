//
//  XWThreeCell.m
//  MXFootBall
//
//  Created by wxw on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "XWShouYeThreeCell.h"

@interface XWShouYeThreeCell()

//@property (weak, nonatomic) IBOutlet MarqueeLabel *tuijianLab;//滚动推荐语
@property (weak, nonatomic) IBOutlet UIImageView *mainLogo;//主队logo
@property (weak, nonatomic) IBOutlet UILabel *mainName;//主队名
@property (weak, nonatomic) IBOutlet UILabel *matchLab;//比赛名和时间
@property (weak, nonatomic) IBOutlet UILabel *mainScoreLab;//主队比分
@property (weak, nonatomic) IBOutlet UILabel *guestScoreLab;//客队比分
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;//比赛状态
@property (weak, nonatomic) IBOutlet UIImageView *guestLogo;//客队logo
@property (weak, nonatomic) IBOutlet UILabel *guestName;//客队名
@property (weak, nonatomic) IBOutlet UILabel *line;//比分中间的横线


@end

@implementation XWShouYeThreeCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"XWShouYeThreeCell";
    XWShouYeThreeCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"XWShouYeThreeCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //[cell.tuijianLab restartLabel];//设置label开始滚动。不添加的话，刚运行这个label不会滚动，只有去别的界面再回来的时候才会滚动。
    
    return cell;
}

- (void)setDataWithModel:(MXHomeSaishi *)model {
//    self.tuijianLab.text = model.reason;
    [self.mainLogo sd_setImageWithURL:[NSURL URLWithString:model.homeLogo] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.mainName.text = model.homeNm;
    self.mainScoreLab.text = [NSString stringWithFormat:@"%ld", model.homeScore];
    
    self.mainScoreLab.text = [NSString stringWithFormat:@"%ld", model.homeScore];
    self.guestScoreLab.text = [NSString stringWithFormat:@"%ld", model.awayScore];
    [self.guestLogo sd_setImageWithURL:[NSURL URLWithString:model.awayLogo] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.guestName.text = model.awayNm;
    self.matchLab.text = model.eventNm;
    self.line.text = @"－";
    if (model.matchStatus == 8) {//完场。结束
        self.mainScoreLab.textColor = mx_Wode_color333333;
        self.guestScoreLab.textColor = mx_Wode_color333333;
        self.statusImg.image = Image(@"home_end");
        return;
    }
    if (model.matchStatus == 1) {//未开始
        self.statusImg.image = Image(@"home_notbegin");
        NSString *time = [MXLJUtil timeInterverlToDateStr:model.matchStartTime];
        NSString *string = [NSString stringWithFormat:@"%@ %@", model.eventNm, time];
        self.matchLab.text = string;
        self.mainScoreLab.text = nil;
        self.guestScoreLab.text = nil;
        self.line.text = nil;
        return;
    }
    if (model.matchStatus == 2 || model.matchStatus == 3 || model.matchStatus == 4 || model.matchStatus == 5 || model.matchStatus == 6 || model.matchStatus == 7 || model.matchStatus == 13) {//已开始
        
        self.statusImg.image = Image(@"home_begin");
        return;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.tuijianLab.scrollDuration = 25.0;
//    self.tuijianLab.fadeLength = 15.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
