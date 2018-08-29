//
//  MXScreeningHeaderCollectionReusableView.m
//  MXFootBall
//
//  Created by dai on 2018/3/29.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXScreeningHeaderCollectionReusableView.h"

@implementation MXScreeningHeaderCollectionReusableView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.label] ;
        
    }
    
    return self ;
}
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(scaleWithSize(15), 0, screen_width, scaleWithSize(30))];
//        _label.text = @"澳超" ;
//        _label.backgroundColor = [UIColor clearColor];
    }
    return _label ;
    
}

@end
