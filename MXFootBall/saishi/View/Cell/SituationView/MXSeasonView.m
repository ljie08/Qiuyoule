//
//  MXReasonView.m
//  MXFootBall
//
//  Created by YY on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSeasonView.h"

@implementation MXSeasonView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {

    }
    return self;
}
-(void)layoutSubviews{
    [self setupSubViews];
}
-(void)setModel:(MXGoalModel *)model{
    _model=model;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    for (NSInteger i=0; i<6; i++) {
        UILabel *leftLB=[[UILabel alloc] init];
        [self addSubview:leftLB];
        [leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scaleWithSize(15));
            make.top.mas_equalTo((scaleWithSize(15)+scaleWithSize(25)*i));
            make.width.mas_equalTo(scaleWithSize(20));
            make.height.mas_equalTo(scaleWithSize(12));
        }];
        leftLB.text=[NSString stringWithFormat:@"%li",25-i*5];
        if (i==0) {
            leftLB.text=@"25+";
        }
        leftLB.font=fontSize(scaleWithSize(10));
        leftLB.textAlignment=NSTextAlignmentRight;
        
        UIView *rightView=[[UIView alloc] init];
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scaleWithSize(43));
            make.top.mas_equalTo((scaleWithSize(25)+scaleWithSize(25)*i));
            make.width.mas_equalTo(screen_width-scaleWithSize(60));
            make.height.mas_equalTo(scaleWithSize(1));
        }];
        rightView.backgroundColor=[UIColor darkGrayColor];
        
    }
    NSArray *titleArr=@[@"0-15'",@"15-30'",@"30-45'",@"45-60'",@"60-75'",@"75-90'",];
    CGFloat W=(screen_width-scaleWithSize(60))/titleArr.count;
    for (NSInteger i=0; i<titleArr.count; i++) {
        UILabel *bottomLB=[[UILabel alloc] init];
        [self addSubview:bottomLB];
        [bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scaleWithSize(43)+W*i);
            make.top.mas_equalTo(scaleWithSize(150));
            make.width.mas_equalTo(W);
            make.height.mas_equalTo(scaleWithSize(20));
        }];
        bottomLB.textAlignment=NSTextAlignmentCenter;
        bottomLB.text=titleArr[i];
        bottomLB.font=fontSize(scaleWithSize(8));
        CGFloat redviewWid=scaleWithSize(8);
        CGFloat redBetweenBlue=scaleWithSize(4);
        CGFloat Margin=(W-redviewWid*2-redBetweenBlue)/2;
        
        UIView *redView=[[UIView alloc] init];
        [self addSubview:redView];
        [redView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scaleWithSize(43)+Margin+W*i);
            make.top.mas_equalTo(scaleWithSize(150-([model.mainTeamScoreArr[i] floatValue])*5));
            make.width.mas_equalTo(scaleWithSize(8));
            make.height.mas_equalTo(scaleWithSize(([model.mainTeamScoreArr[i] floatValue])*5));
        }];
        redView.backgroundColor=[UIColor redColor];

        UIView *blueView=[[UIView alloc] init];
        [self addSubview:blueView];
        CGFloat blueMargin=Margin+redBetweenBlue+redviewWid;
        [blueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(scaleWithSize(150-([model.guestTeamScoreArr[i] floatValue])*5));
            make.left.mas_equalTo(scaleWithSize(43)+blueMargin+W*i);
            make.width.mas_equalTo(scaleWithSize(8));
            make.height.mas_equalTo(scaleWithSize(([model.guestTeamScoreArr[i] floatValue])*5));
        }];
        blueView.backgroundColor=[UIColor blueColor];
        
    }
    for (NSInteger i=0; i<2; i++) {
        UIView *teamView=[[UIView alloc] init];
        [self addSubview:teamView];
        [teamView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scaleWithSize(30));
            make.top.mas_equalTo(scaleWithSize(180)+scaleWithSize(18)*i);
            make.width.mas_equalTo(scaleWithSize(8));
            make.height.mas_equalTo(scaleWithSize(8));
        }];
        UILabel *rightLB=[[UILabel alloc] init];
        [self addSubview:rightLB];
        [rightLB mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(scaleWithSize(45));
            make.top.mas_equalTo(scaleWithSize(180)+scaleWithSize(18)*i);
            make.width.mas_equalTo(screen_width-scaleWithSize(50));
            make.height.mas_equalTo(scaleWithSize(10));
        }];
        rightLB.font=fontSize(scaleWithSize(10));
        switch (i) {
            case 0:{
                teamView.backgroundColor=[UIColor redColor];
                rightLB.text=[NSString stringWithFormat:@"卡利阿美赛季共统计%@场比赛，场均进球%.2f",model.mainTeamTotalMatches,[[model.mainTeamScoreArr valueForKeyPath:@"@sum.floatValue"]floatValue]/[model.mainTeamTotalMatches floatValue]];
            }
                break;
            case 1:{
                teamView.backgroundColor=[UIColor blueColor];
                rightLB.text=[NSString stringWithFormat:@"防卫者赛季共统计%@场比赛，场均进球%.2f",model.guestTeamTotalMatches,[[model.guestTeamScoreArr valueForKeyPath:@"@sum.floatValue"]floatValue]/[model.guestTeamTotalMatches floatValue]];
            }
                break;
            default:
                break;
        }
    }
    NSArray *horizontalArr=@[@"时间",@"0-15'",@"15-30'",@"30-45'",@"45-60'",@"60-75'",@"75-90'"];
    NSArray *verticalArr=@[@"主队",@"客队"];
    
    for (NSInteger i=0; i<3; i++) {
        for (NSInteger j=0; j<horizontalArr.count; j++) {
            UILabel *chartLB=[[UILabel alloc] init];
            [self addSubview:chartLB];
            CGFloat W=(screen_width-scaleWithSize(50))/horizontalArr.count;
            CGFloat H= (i<1)?scaleWithSize(25):scaleWithSize(45);
            CGFloat Margin=(i<1)?0:(scaleWithSize(25)+scaleWithSize(45)*(i-1));
            [chartLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(scaleWithSize(220)+Margin);
                make.left.mas_equalTo(scaleWithSize(30)+W*j);
                make.width.mas_equalTo(W);
                make.height.mas_equalTo(H);
            }];
            chartLB.font=fontSize(scaleWithSize(10));
            chartLB.numberOfLines=0;
            chartLB.textAlignment=NSTextAlignmentCenter;
            if (i==0) {
                chartLB.backgroundColor=[MXLJUtil hexStringToColor:@"0x1C5CDF"];
                chartLB.text=horizontalArr[j];
                if (j!=horizontalArr.count-1) {
                    UIView *verticalLine=[UIView new];
                    [self addSubview:verticalLine];
                    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(scaleWithSize(220)+Margin);
                        make.left.mas_equalTo(scaleWithSize(30)+W*(j+1));
                        make.width.mas_equalTo(0.5);
                        make.height.mas_equalTo(H);
                    }];
                    verticalLine.backgroundColor=[UIColor redColor];
                }
            }else if (j==0&&i!=0) {
                chartLB.text=verticalArr[i-1];
                chartLB.backgroundColor=[MXLJUtil hexStringToColor:@"0XBCD1EC"];
            }else if(i==1&&j!=0){
                chartLB.text=[NSString stringWithFormat:@"%@\n%@%%",model.mainTeamScoreArr[j-1],model.mainTeamScoreRate[j-1]];
                chartLB.backgroundColor=kColorWithRGBF(0XDFD0D1);
            }else if (i==2&&j!=0){
                chartLB.text=[NSString stringWithFormat:@"%@\n%@%%",model.guestTeamScoreArr[j-1],model.guestTeamScoreRate[j-1]];
                chartLB.backgroundColor=kColorWithRGBF(0XDFD0D1);
            }
        }
        
        if (i==2) {
            UIView *line=[[UIView alloc] init];
            [self  addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(scaleWithSize(290));
                make.left.mas_equalTo(scaleWithSize(30));
                make.width.mas_equalTo(screen_width-scaleWithSize(50));
                make.height.mas_equalTo(scaleWithSize(0.3));
            }];
            line.backgroundColor=[UIColor lightGrayColor];
        }
    }
}
-(void)setupSubViews{
    
}
@end
