//
//  MXHomeContentCollectionCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeContentCollectionCell.h"

@interface MXHomeContentCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *picView;//图片
@property (weak, nonatomic) IBOutlet UILabel *contentLab;//内容(其实是标题)

@end

@implementation MXHomeContentCollectionCell

- (void)setContentDataWithModel:(MXLJArticle *)model {
//    UIImage *image = [MXLJUtil cutPicWithPicUrl:model.imgUrl bigOrSmall:1 picLocationType:1 size:CGSizeMake(150, 87)];
//    self.picView.image = image;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:Image(@"topPlace") options:SDWebImageAllowInvalidSSLCertificates];
    self.picView.contentMode =  UIViewContentModeScaleAspectFill;
    self.picView.clipsToBounds = YES;
    
    self.contentLab.text = model.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
