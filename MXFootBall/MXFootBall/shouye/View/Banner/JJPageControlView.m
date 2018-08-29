
//
//  JJPageControlView.m
//  JJMedia
//
//  Created by ljie on 16/6/24.
//  Copyright © 2016年 zhouqixin. All rights reserved.
//

#import "JJPageControlView.h"

#define Un_Point_Width 5 //未选中的圆点的宽
#define Point_Width 20 //选中的圆点的宽
#define Point_Height 5 //圆点的高
#define Point_Padding 15 //圆点间距

@implementation JJPageControlView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setCount:(long)count {
    _count = count;
    self.frame = CGRectMake(0, 0, (count-1) * Point_Padding + (count-1) * Un_Point_Width + Point_Width, Point_Height);//圆点所在frame。圆点间距15，未选中圆点宽高5，选中的宽为20
    
    for (int i = 0; i < count; i++) {
        CGFloat x = (i - 1) * Un_Point_Width + i * Point_Padding + Point_Width;
        UIView *point = [[UIView alloc] init];//圆点
        if (i == 0) {//选中的圆点
            point.frame = CGRectMake(0, 0, Point_Width, Point_Height);
            point.backgroundColor = mx_Wode_colorffffff;//选中的圆点颜色
        } else {//未选中的圆点
            point.frame = CGRectMake(x, 0, Un_Point_Width, Point_Height);
            point.backgroundColor = mx_Wode_colord9d9d9;
        }
        point.layer.cornerRadius = 2.5;
        point.layer.masksToBounds = YES;
        point.tag = 10 + i;
        
        [self addSubview:point];
    }
}

- (void)setCurrentPage:(long)currentPage {
    _currentPage = currentPage;
    for (int i = 0; i < (int)self.count; i++) {
        UIView * view = [self viewWithTag:10 + i];
        if (view.tag == 10+currentPage) {//被选中
            CGFloat x = Un_Point_Width*i + Point_Padding*i;
            view.backgroundColor = mx_Wode_colorffffff;
            view.frame = CGRectMake(x, 0, Point_Width, Point_Height);
        } else {
            // o未选中
            // □被选中
            // o o o □ o
            if (i < currentPage) {//被选中的圆点的左边的未选中的圆点
                //□左边的o的frame
                view.frame = CGRectMake(Un_Point_Width * i + i * Point_Padding, 0, Un_Point_Width, Point_Height);
            } else {//被选中的圆点的右边的未选中的圆点
                //□右边的o的frame
                view.frame = CGRectMake(Un_Point_Width * (i-1) + i * Point_Padding + Point_Width, 0, Un_Point_Width, Point_Height);
            }
            
            view.backgroundColor = mx_Wode_colorffffff;
        }
    }
}

@end
