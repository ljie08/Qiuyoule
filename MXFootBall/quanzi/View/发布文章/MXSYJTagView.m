//
//  MXSYJTagView.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/30.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJTagView.h"

#define KW (screen_width - 65) / 4

@implementation MXSYJTagView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        self.nameLab = [[UILabel alloc]init];
        [self addSubview:self.nameLab];
        self.nameLab.font = fontBoldSize(15);
        self.nameLab.textColor = mx_FontBalckColor;
        self.nameLab.textAlignment = NSTextAlignmentLeft;
        self.nameLab.text = @"选择专题";
        self.nameLab.sd_layout.leftSpaceToView(self, 15).topSpaceToView(self, 10).heightIs(15);
        [self.nameLab setSingleLineAutoResizeWithMaxWidth:200];
        
        
        NSArray *tags = [NSArray array];
        
        // 创建标签列表
        self.tagList = [[YZTagList alloc] init];
        // 高度可以设置为0，会自动跟随标题计算
        self.tagList.frame = CGRectMake(0, 25, screen_width, 115);
        // 需要排序
        self.tagList.isSort = NO;
        // 标签尺寸
        self.tagList.tagSize = CGSizeMake(KW, 40);
        // 不需要自适应标签列表高度
        self.tagList.isFitTagListH = NO;
        [self addSubview:self.tagList];
        
        
        // 设置标签背景色
        self.tagList.tagBackgroundColor = mx_LineColor;
        // 设置标签颜色
        self.tagList.tagColor = mx_FontLightGreyColor;
        
        self.tagList.tagFont = fontBoldSize(15);
        
        self.tagList.tagSelectColor = [UIColor whiteColor];
        self.tagList.tagSelectBackgroundColor = mx_BlueColor;
        self.tagList.tagSelectFont = fontBoldSize(15);

        
        
        
        //    __weak typeof(_tagList) weakTagList = _tagList;
        
        
        /**
         *  这里一定先设置标签列表属性，然后最后去添加标签
         */
        [self.tagList addTags:tags];
        
        NSLog(@"%f",self.tagList.tagListH);
        
    }
    
    return self;
    
}

- (void)setArr:(NSMutableArray *)arr{
    
    _arr = arr;
    [self.tagList addTags:(NSArray *)arr];
    
}

@end
