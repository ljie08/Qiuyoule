//
//  MXSYJFriendsCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJFriendsCell.h"
#import "UIButton+ImagePosition.h"

#define kImgWidth (screen_width - 45) / 4

@implementation MXSYJFriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bannerPlace"]];//saishi_morentouxiang
        [self.contentView addSubview:self.iconView];
        self.iconView.sd_layout.leftSpaceToView(self.contentView, 18).topSpaceToView(self.contentView, 10).heightIs(40).widthIs(40);
        self.iconView.sd_cornerRadius = @20;
        self.iconView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(icon)];
        [self.iconView addGestureRecognizer:tap];
        
        
        self.nameLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLab];
        self.nameLab.textColor = [UIColor blackColor];
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.font = fontBoldSize(14);
        self.nameLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.contentView, 13).heightIs(16);
        [self.nameLab setSingleLineAutoResizeWithMaxWidth:160];
        self.nameLab.text = @"这是名字";
        
        self.timeLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLab];
        self.timeLab.textColor = mx_Wode_darkGreyFontColor;
        self.timeLab.textAlignment = NSTextAlignmentLeft;
        self.timeLab.font = fontSize(12);
        self.timeLab.sd_layout.leftSpaceToView(self.iconView, 5).topSpaceToView(self.nameLab, 5).heightIs(16);
        [self.timeLab setSingleLineAutoResizeWithMaxWidth:160];
        self.timeLab.text = @"1小时前";
        
        self.levelLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.levelLab];
        self.levelLab.textColor = mx_Wode_darkGreyFontColor;
        self.levelLab.textAlignment = NSTextAlignmentCenter;
        self.levelLab.font = fontSize(12);
        self.levelLab.sd_layout.leftSpaceToView(self.nameLab, 5).topSpaceToView(self.contentView, 12).heightIs(18).widthIs(40);
//        [self.levelLab setSingleLineAutoResizeWithMaxWidth:160];
        self.levelLab.text = @"LV2";
        self.levelLab.sd_cornerRadius = @5;
        self.levelLab.layer.masksToBounds = YES;
        self.levelLab.layer.borderColor = mx_Wode_darkGreyFontColor.CGColor;
        self.levelLab.layer.borderWidth = 1.0;
        
        self.commentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.commentsBtn];
        [self.commentsBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
        [self.commentsBtn setTitle:@"12" forState:UIControlStateNormal];
        [self.commentsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.commentsBtn setImagePosition:ImagePositionLeft spacing:5];
        self.commentsBtn.titleLabel.font = fontSize(12);
        self.commentsBtn.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 12).heightIs(20).widthIs(50);
        [self.commentsBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        self.commentsBtn.tag = 101;
        
        
        self.collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.collectionBtn];
        [self.collectionBtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
        [self.collectionBtn setTitle:@"24" forState:UIControlStateNormal];
        [self.collectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.collectionBtn setImagePosition:ImagePositionLeft spacing:5];
        self.collectionBtn.titleLabel.font = fontSize(12);
        self.collectionBtn.sd_layout.rightSpaceToView(self.commentsBtn, 5).topSpaceToView(self.contentView, 12).heightIs(20).widthIs(50);
        [self.collectionBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        self.collectionBtn.tag = 102;
        
        self.titleLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLab];
        self.titleLab.textColor = [UIColor blackColor];
        self.titleLab.font = fontBoldSize(14);
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.text = @"很多人觉得用着不习惯，各种吐槽，包括系统也出现一些问题，系统界面越来越丑。而且最坑的是你更新了";
        self.titleLab.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 15).topSpaceToView(self.iconView, 8).heightIs(20);
        
        
        self.superViews = [[UIView alloc]init];
        [self.contentView addSubview:self.superViews];
        self.superViews.backgroundColor = [UIColor whiteColor];
        self.superViews.sd_layout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.titleLab, 10).rightSpaceToView(self.contentView, 0).heightIs(0);
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = mx_LineColor;
        [self.contentView addSubview:line];
        line.sd_layout.bottomSpaceToView(self.contentView, 0.5).leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).heightIs(0.5);
        
        
        self.formLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.formLab];
        self.formLab.textColor = mx_Wode_darkGreyFontColor;
        self.formLab.font = fontSize(11);
        self.formLab.textAlignment = NSTextAlignmentLeft;
        self.formLab.sd_layout.leftSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 10).bottomSpaceToView(line, 5).heightIs(15);
        self.formLab.text = @"来自 菠菜庄团";
        
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.formLab.text];
        [attStr addAttributes:@{NSForegroundColorAttributeName:mx_Wode_colorBlue2374e4} range:(NSRange){3,4}];//添加属性
        [self.formLab setAttributedText:attStr];
        
        self.readNumLab = [[UILabel alloc]init];
        [self.contentView addSubview:self.readNumLab];
        self.readNumLab.textColor = mx_Wode_darkGreyFontColor;
        self.readNumLab.font = fontSize(11);
        self.readNumLab.textAlignment = NSTextAlignmentRight;
        self.readNumLab.text = @"阅读数 10";
        self.readNumLab.sd_layout.rightSpaceToView(self.contentView, 15).rightSpaceToView(self.contentView, 10).bottomSpaceToView(line, 5).heightIs(15).widthIs(100);
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return self;
    
}

- (void)action:(UIButton *)btn{
    
    if (self.btnAction) {
        self.btnAction(btn);
    }
    
}

- (void)icon{
    
    if (self.tapClick) {
        self.tapClick();
    }
    
    
}

- (void)setModel:(MXSYJFocusOnModel *)model{
    
    _model = model;

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headerPic] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];//saishi_morentouxiang
    self.nameLab.text = model.username.length ? model.username : @" ";
    self.timeLab.text = model.createTime;
    self.titleLab.text = model.title;
    self.levelLab.text = [NSString stringWithFormat:@"LV%ld",(long)model.level];
    [self.collectionBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.collects] forState:UIControlStateNormal];
    if (model.isCollect == 1) {
    [self.collectionBtn setImage:[UIImage imageNamed:@"shoucang-2"] forState:UIControlStateNormal];
    }else{
    [self.collectionBtn setImage:[UIImage imageNamed:@"shoucang"] forState:UIControlStateNormal];
    }
    [self.commentsBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.comments] forState:UIControlStateNormal];
    if (model.isComment == 1) {
        [self.commentsBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    }else{
        [self.commentsBtn setImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    }
    self.formLab.text = [NSString stringWithFormat:@"来自 %@",model.channelName];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self.formLab.text];
    [attStr addAttributes:@{NSForegroundColorAttributeName:mx_Wode_colorBlueprogress} range:(NSRange){3,model.channelName.length}];//添加属性
    [self.formLab setAttributedText:attStr];
    self.readNumLab.text = [NSString stringWithFormat:@"阅读数 %ld",(long)model.view];
    
    mx_weakify(self);
   
    [self.superViews.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSInteger count = model.forumImgs.count > 4 ? 4 : model.forumImgs.count;
    UIImageView *lastImageView = nil;
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_model.forumImgs[i][@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"bannerPlace"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        [self.superViews addSubview:imageView];
        
        if (lastImageView) {
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(lastImageView.mas_right).offset(9);
                make.top.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(kImgWidth, kImgWidth));
            }];
        }else{
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(9);
                make.top.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(kImgWidth, kImgWidth));
            }];
        }
        lastImageView = imageView;
    }
    self.superViews.sd_resetLayout.leftSpaceToView(self.contentView, 0).topSpaceToView(self.titleLab, 10).rightSpaceToView(self.contentView, 0).heightIs(0);
    [self setupAutoHeightWithBottomView:self.superViews bottomMargin:25];
    [self.titleLab updateLayout];
    [self.superViews updateLayout];
    
}


@end
