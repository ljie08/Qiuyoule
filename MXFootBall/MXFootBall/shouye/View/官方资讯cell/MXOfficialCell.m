//
//  MXOfficialCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOfficialCell.h"
#import <UIImage+GIF.h>

@interface MXOfficialCell()

@property (weak, nonatomic) IBOutlet UIImageView *picView;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//标题
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UILabel *readLab;//阅读数
@property (weak, nonatomic) IBOutlet UILabel *commentLab;//评论数
@property (weak, nonatomic) IBOutlet UILabel *timeLab;//时间数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picWidth;

@end

@implementation MXOfficialCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MXOfficialCell";
    MXOfficialCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MXOfficialCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(MXSYJFocusOnModel *)model {
    
    if (model.imgUrl.length) {
        self.picView.hidden = NO;
        self.picWidth.constant = 79;
        if ([model.imgUrl containsString:@"gif"]) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imgUrl]];
            self.picView.image = [UIImage sd_animatedGIFWithData:data];
        }else{
            [self.picView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
        }
        
        self.picView.contentMode =  UIViewContentModeScaleAspectFill;
        self.picView.clipsToBounds = YES;

    } else {
        self.picView.hidden = YES;
        self.picWidth.constant = 0;
    }
    
    self.titleLab.text = model.title;
    self.contentLab.text = model.subContent;
    
    self.readLab.text = [NSString stringWithFormat:@"%ld", model.view];
    self.commentLab.text = [NSString stringWithFormat:@"%ld", model.comments];
    NSString *date = [model.createTime substringWithRange:NSMakeRange(5, 5)];
    date = [date stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.timeLab.text = date;
}

+ (CGFloat)cellHeightWithString:(NSString *)string {
    CGFloat height = [MXLJUtil initWithSize:CGSizeMake(screen_width-30, CGFLOAT_MAX) string:string font:12].height;
    return height;
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
