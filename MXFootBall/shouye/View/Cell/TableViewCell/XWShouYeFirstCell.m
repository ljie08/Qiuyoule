//
//  XWShouYeTableViewCell.m
//  MXFootBall
//
//  Created by wxw on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "XWShouYeFirstCell.h"
#import "XWShouYeFirstCollectionViewCell.h"

@interface XWShouYeFirstCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *picArr;

@end

@implementation XWShouYeFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registerCollectionView];
    
}

- (NSArray *)picArr {
    if (_picArr == nil) {
        _picArr = [NSArray arrayWithObjects:@"home-zixunjingxuan", @"home-jishisaishi", @"home-shoucang", @"home-huang", nil];
    }
    return _picArr;
}

//注册
- (void)registerCollectionView{
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWShouYeFirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.scrollEnabled = NO;
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWShouYeFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
   
    return cell;
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(55, 55 + 10 + 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (screen_width - (55 * 4)) / 4;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, (screen_width - (55 * 4)) / 4 / 2, 15, (screen_width - (55 * 4)) / 4 / 2);
}

#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.block) {
        self.block(@"嘿嘿嘿", indexPath);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
