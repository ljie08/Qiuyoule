//
//  MXSYJTopCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/2.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJTopCell.h"

@implementation MXSYJTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        self.topLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.topLab];
        self.topLab.backgroundColor = mx_redColor;
        self.topLab.textAlignment = NSTextAlignmentCenter;
        self.topLab.font = fontBoldSize(15);
        self.topLab.textColor = [UIColor whiteColor];
        self.topLab.text = @"置顶"; self.topLab.sd_layout.centerYEqualToView(self.contentView).heightIs(25).widthIs(60).leftSpaceToView(self.contentView, 10);
        self.topLab.sd_cornerRadius = @3;
        
        self.descLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.descLab];
//        self.descLab.textAlignment = NSTextAlignmentCenter;
        self.descLab.font = fontBoldSize(15);
        self.descLab.textColor = mx_FontBalckColor;
        self.descLab.text = @"[2场] 罗马诱盘概率大!";
        
//        [self.descLab setSingleLineAutoResizeWithMaxWidth:240];
//        [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.topLab.mas_right).offset(10);
//            make.centerY.mas_equalTo(self.contentView);
//            make.right.mas_equalTo(self.isNew.mas_left).offset(-5);
//        }];
        
        self.isNew = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NEW"]];
        [self.contentView addSubview:self.isNew];
        self.isNew.sd_layout.centerYEqualToView(self.contentView).heightIs(20).widthIs(40).rightSpaceToView(self.contentView, 10);
        self.descLab.sd_layout.centerYEqualToView(self.contentView).heightIs(25).leftSpaceToView(self.topLab, 10).rightSpaceToView(self.isNew, 10);
        UIView *line = [[UIView alloc]init];
//        [self.contentView addSubview:line];
        line.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 1.0).heightIs(1.0);
        line.backgroundColor = mx_LineColor;
        
    }
    
    return self;
    
}

- (void)setModel:(MXSYJIsTopModel *)model{
    
    _model = model;
    self.descLab.text = model.title;


}


@end
