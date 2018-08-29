//
//  MXHomeBtnCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeBtnCell.h"
#import "MXHomeBtnCollectionCell.h"

@interface MXHomeBtnCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation MXHomeBtnCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview withBtnArr:(NSArray *)btnArr {
    static NSString *cellid = @"MXHomeBtnCell";
    MXHomeBtnCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MXHomeBtnCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCollectionviewLayout];//有数据且cell不存在时调用，否则会重复添加collectioncell，导致重复
    }
    if (!cell.btnsArr.count) {
        cell.btnsArr = [NSArray arrayWithArray:btnArr];
    }
    
    return cell;
}

- (NSArray *)btnsArr {
    if (_btnsArr == nil) {
        _btnsArr = [NSArray array];
    }
    return _btnsArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    
    float num = 0.0;
    //隐藏mingrt
    if (Timestamps - [[MXLJUtil getNowDateTimeString] doubleValue]  > 0) {
        num = 3.0;
    } else {
        num = 4.0;
    }
    flow.itemSize = CGSizeMake((screen_width)/3.0, 75);
    CGFloat width;
//    if (self.btnsArr.count > 0) {
        width = screen_width;
//    } else {
//        width = 55*self.btnsArr.count;
//    }
    self.btnsCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, 100) collectionViewLayout:flow];
    self.btnsCollectionview.backgroundColor = [UIColor clearColor];
    self.btnsCollectionview.delegate = self;
    self.btnsCollectionview.dataSource = self;
    self.btnsCollectionview.showsHorizontalScrollIndicator = NO;
    [self.btnsCollectionview registerNib:[UINib nibWithNibName:@"MXHomeBtnCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MXHomeBtnCollectionCell"];
    [self.contentView addSubview:self.btnsCollectionview];
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        return self.btnsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXHomeBtnCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXHomeBtnCollectionCell" forIndexPath:indexPath];
    if (self.btnsArr.count) {
        MXLJAccess *access = self.btnsArr[indexPath.row];
        [cell setBtnDataWithModel:access];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(fastAccessWithTag:)]) {
        [self.delegate fastAccessWithTag:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
