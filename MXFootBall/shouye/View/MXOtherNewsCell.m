//
//  MXOtherNewsCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/6/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOtherNewsCell.h"

@interface MXOtherNewsCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *viewLab;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation MXOtherNewsCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MXOtherNewsCell";
    MXOtherNewsCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MXOtherNewsCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(MXNews *)model {
    self.titleLab.text = model.title;
    self.viewLab.text = [NSString stringWithFormat:@"%ld", model.view];
    self.commentLab.text = [NSString stringWithFormat:@"%ld", model.comments];
    NSString *time = model.createTime;
    time = [time substringFromIndex:5];
    time = [time substringToIndex:5];
    time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.timeLab.text = time;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
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
