//
//  MXEventTableFootView.m
//  MXFootBall
//
//  Created by YY on 2018/4/10.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXEventTableFootView.h"

@implementation MXEventTableFootView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}
-(void)setupViews{
    NSArray *typeArr=@[@"点球",@"进球",@"乌龙球",@"红牌",@"黄牌",@"两黄一红",@"换人",@"角球",@"任意球"];
    NSArray *imagesArr=@[@"8",@"saishi_zhibo_lanqiu_lan",@"saishi_zhibo_lanqiu_zi",@"4",@"3",@"saishi_zhibo_lianghuangyihong",@"9",@"2",@"6"];
    CGFloat leftMargin=scaleWithSize(18);
    CGFloat iconWH=scaleWithSize(10);
    CGFloat betweenMargin=scaleWithSize(2);
    CGFloat w= (screen_width-2*leftMargin-6*iconWH-6*betweenMargin)/6;
    for (NSInteger i=0; i<6; i++) {
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(leftMargin+(w+betweenMargin+iconWH)*i, scaleWithSize(15), iconWH, iconWH)];
        iconImageView.image=[UIImage imageNamed:imagesArr[i]];
        [self addSubview:iconImageView];
        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(leftMargin+iconWH*(i+1)+(w+betweenMargin)*i, scaleWithSize(15), w, scaleWithSize(10))];
        textLabel.text=typeArr[i];
        textLabel.font= fontSize(scaleWithSize(10));
        [self addSubview:textLabel];
    }
    for (NSInteger i=0; i<3; i++) {
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(leftMargin+(w+betweenMargin+iconWH)*i, scaleWithSize(15)+25, iconWH, iconWH)];
        iconImageView.image=[UIImage imageNamed:imagesArr[6+i]];
        [self addSubview:iconImageView];
        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(leftMargin+iconWH*(i+1)+(w+betweenMargin)*i, scaleWithSize(15)+25, w, scaleWithSize(10))];
        textLabel.text=typeArr[6+i];
        textLabel.font= fontSize(scaleWithSize(10));
        [self addSubview:textLabel];

    }
}


@end
