//
//  MXHomeContentCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/26.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXHomeContentCell.h"
#import "MXHomeContentCollectionCell.h"

@interface MXHomeContentCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation MXHomeContentCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview withContentsArr:(NSArray *)contentsArr {
    static NSString *cellid = @"MXHomeContentCell";
    MXHomeContentCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MXHomeContentCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCollectionviewLayout];//有数据且cell不存在时调用，否则会重复添加collectioncell，导致重复
    }
    if (!cell.contentsArr.count) {
        cell.contentsArr = contentsArr;
    }
    
    return cell;
}

- (NSArray *)contentsArr {
    if (_contentsArr == nil) {
        _contentsArr = [NSArray array];
    }
    return _contentsArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//collectionview相关
- (void)setCollectionviewLayout {
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    flow.minimumLineSpacing = screen_width-30-300*Width_Scale;
    flow.minimumInteritemSpacing = 0;
    flow.itemSize = CGSizeMake(150*Width_Scale, 150);
    CGFloat width;
//    if (self.contentsArr.count > 0) {
        width = screen_width;
//    } else {
//        width = 150*self.contentsArr.count;
//    }
    self.contentsCollectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, width-30, 160) collectionViewLayout:flow];
    self.contentsCollectionview.backgroundColor = [UIColor clearColor];
    self.contentsCollectionview.delegate = self;
    self.contentsCollectionview.dataSource = self;
    self.contentsCollectionview.showsHorizontalScrollIndicator = NO;
    [self.contentsCollectionview registerNib:[UINib nibWithNibName:@"MXHomeContentCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"MXHomeContentCollectionCell"];
    [self.contentView addSubview:self.contentsCollectionview];
}

#pragma mark - collection

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.contentsArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXHomeContentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MXHomeContentCollectionCell" forIndexPath:indexPath];
    if (self.contentsArr.count) {
        [cell setContentDataWithModel:self.contentsArr[indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(lookContentWithTag:)]) {
        [self.delegate lookContentWithTag:indexPath.row];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
