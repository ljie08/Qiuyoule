//
//  MXHomeScrollCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeScrollCell.h"
#import <JhtMarquee/JhtVerticalMarquee.h>

@interface MXHomeScrollCell()

@property (weak, nonatomic) IBOutlet JhtVerticalMarquee *contentScrollView;//滚动label

@end

@implementation MXHomeScrollCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MXHomeScrollCell";
    MXHomeScrollCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MXHomeScrollCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setDataWithArray:(NSArray *)arr {
    
    self.contentScrollView.sourceArray = arr;
    [self.contentScrollView marqueeOfSettingWithState:MarqueeStart_V];
    
    //添加手势，点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVerticalMarqueeToClick:)];
    [self.contentScrollView addGestureRecognizer:tap];
}

//跑马灯点击事件
- (void)tapVerticalMarqueeToClick:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(clickLabelWithTag:)]) {
        [self.delegate clickLabelWithTag:self.contentScrollView.currentIndex];
    }
    
    NSLog(@"你戳了第%ld条数据",self.contentScrollView.currentIndex);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
