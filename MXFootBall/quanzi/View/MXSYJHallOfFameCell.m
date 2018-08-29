//
//  MXSYJHallOfFameCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJHallOfFameCell.h"

@implementation MXSYJHallOfFameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
      
        self.imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guangchangtubiao"]];
        [self.contentView addSubview:self.imgView];
        self.imgView.sd_layout.leftSpaceToView(self.contentView, 18).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10).widthIs(60);
        self.imgView.sd_cornerRadius = @2;
        
        self.hallNameLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.hallNameLab];
        self.hallNameLab.textColor = [UIColor blackColor];
        self.hallNameLab.textAlignment = NSTextAlignmentLeft;
        self.hallNameLab.font = fontBoldSize(15);
        self.hallNameLab.sd_layout.leftSpaceToView(self.imgView, 6).topSpaceToView(self.contentView, 20).heightIs(20);
        //        限定最大宽度，单行Label的视图,如下，在文本单行在160范围内时按文本大小显示宽度，在大于160时只显示160宽度，其他的省略
        [self.hallNameLab setSingleLineAutoResizeWithMaxWidth:160];
        self.hallNameLab.text = @"球球名人堂";
        
        self.hallDescLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.hallDescLab];
        self.hallDescLab.textColor = mx_Wode_darkGreyFontColor;
        self.hallDescLab.textAlignment = NSTextAlignmentLeft;
        self.hallDescLab.font = fontSize(14);
        self.hallDescLab.sd_layout.leftSpaceToView(self.imgView, 6).topSpaceToView(self.hallNameLab, 5).heightIs(20);
//        限定最大宽度，单行Label的视图,如下，在文本单行在160范围内时按文本大小显示宽度，在大于160时只显示160宽度，其他的省略
        [self.hallDescLab setSingleLineAutoResizeWithMaxWidth:160];
        self.hallDescLab.text = @"最牛逼的描述";
        
        self.isNewHall = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"NEW"]];
        [self.contentView addSubview:self.isNewHall];
        self.isNewHall.sd_layout.leftSpaceToView(self.hallNameLab, 18).centerYEqualToView(self.hallNameLab).heightIs(16).widthIs(32);
        self.isNewHall.sd_cornerRadius = @2;
        
        self.howManyHallLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.howManyHallLab];
        self.howManyHallLab.textColor = [UIColor blackColor];
        self.howManyHallLab.textAlignment = NSTextAlignmentCenter;
        self.howManyHallLab.font = fontBoldSize(16);
        self.howManyHallLab.sd_layout.rightSpaceToView(self.contentView, 18).centerYEqualToView(self.contentView).heightIs(40).widthIs(40);
        self.howManyHallLab.text = @"6";
        self.howManyHallLab.sd_cornerRadius = @5;
        self.howManyHallLab.layer.masksToBounds = YES;
        self.howManyHallLab.layer.borderColor = [UIColor blackColor].CGColor;
        self.howManyHallLab.layer.borderWidth = 2;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = mx_Wode_backgroundColor;
        [self.contentView addSubview:line];
        line.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0.5).heightIs(0.5);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }
    
    return self;
    
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
