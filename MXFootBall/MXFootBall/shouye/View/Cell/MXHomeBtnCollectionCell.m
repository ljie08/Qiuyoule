//
//  MXHomeBtnCollectionCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeBtnCollectionCell.h"

@interface MXHomeBtnCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *picView;//
@property (weak, nonatomic) IBOutlet UILabel *titleLab;//

@end

@implementation MXHomeBtnCollectionCell

- (void)setBtnDataWithModel:(MXLJAccess *)access {
    [self.picView sd_setImageWithURL:[NSURL URLWithString:access.imgUrl] placeholderImage:Image(@"home-cheng") options:SDWebImageAllowInvalidSSLCertificates];
    self.titleLab.text = access.nameZh;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
