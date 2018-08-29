//
//  MXHomeNewsCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/6/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeNewsCell.h"

@interface MXHomeNewsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *picOne;
@property (weak, nonatomic) IBOutlet UIImageView *picTwo;
@property (weak, nonatomic) IBOutlet UIImageView *picThree;
@property (weak, nonatomic) IBOutlet UILabel *readLab;
@property (weak, nonatomic) IBOutlet UILabel *commentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation MXHomeNewsCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MXHomeNewsCell";
    MXHomeNewsCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MXHomeNewsCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)setDataWithModel:(MXNews *)model {
    self.titleLab.text = model.title;
    self.readLab.text = [NSString stringWithFormat:@"%ld", model.view];
    self.commentLab.text = [NSString stringWithFormat:@"%ld", model.comments];
    NSString *time = model.createTime;
    time = [time substringFromIndex:5];
    time = [time substringToIndex:5];
    time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    self.timeLab.text = time;
    
    NSInteger count = model.forumImgs.count;
    if (count>=3) {
        MXForumImg *image1 = model.forumImgs[0];
        MXForumImg *image2 = model.forumImgs[1];
        MXForumImg *image3 = model.forumImgs[2];
        [self.picOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", image1.imgUrl]] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
        [self.picTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", image2.imgUrl]] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
        [self.picThree sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", image3.imgUrl]] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
    }
    if (count == 2) {
        MXForumImg *image1 = model.forumImgs[0];
        MXForumImg *image2 = model.forumImgs[1];
        [self.picOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", image1.imgUrl]] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
        [self.picTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", image2.imgUrl]] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
        self.picThree.image = nil;
    }
    if (count == 1) {
        MXForumImg *image1 = model.forumImgs[0];
        [self.picOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", image1.imgUrl]] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
        self.picTwo.image = nil;
        self.picThree.image = nil;
    }
    self.picOne.contentMode =  UIViewContentModeScaleAspectFill;
    self.picOne.clipsToBounds = YES;
    self.picTwo.contentMode =  UIViewContentModeScaleAspectFill;
    self.picTwo.clipsToBounds = YES;
    self.picThree.contentMode =  UIViewContentModeScaleAspectFill;
    self.picThree.clipsToBounds = YES;
}

+ (CGFloat)cellHeightWithString:(NSString *)string {
    CGFloat height = [MXLJUtil initWithSize:CGSizeMake(screen_width-30, CGFLOAT_MAX) string:string font:14].height;
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

