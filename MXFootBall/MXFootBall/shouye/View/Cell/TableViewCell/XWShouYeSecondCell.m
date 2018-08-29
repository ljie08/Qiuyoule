//
//  XWShouYeSecondCell.m
//  MXFootBall
//
//  Created by wxw on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "XWShouYeSecondCell.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import "XWShouYeFirstCollectionViewCell.h"

@interface XWShouYeSecondCell ()<UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet JhtVerticalMarquee *verticalMarquee;

@property (assign, nonatomic)BOOL isPauseV;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation XWShouYeSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addPaoMaDeng];
    [self registerCollectionView];
}

//注册Collectionview
- (void)registerCollectionView{
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XWShouYeFirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    self.collectionView.scrollEnabled = NO;
    
}

//跑马灯
- (void)addPaoMaDeng{
    
    NSArray *soureArray = @[@"我是渣渣飞",
                            @"我是古添杰",
                            @"贪婪古月等你来挑战！"];
    
    self.verticalMarquee.sourceArray = soureArray;
    [self.verticalMarquee marqueeOfSettingWithState:MarqueeStart_V];
    
    //添加手势，点击操作
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapVerticalMarqueeToClick:)];
    [self.verticalMarquee addGestureRecognizer:tap];
    
}

//跑马灯点击事件
- (void)tapVerticalMarqueeToClick:(UITapGestureRecognizer *)tap{
    NSLog(@"你戳了第%ld条数据",self.verticalMarquee.currentIndex);
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    XWShouYeFirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.describeLabel.hidden = NO;
    cell.describeLabelHeight.constant = 28;
    
    return cell;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 88 + 10 + 24);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(15, 15, 10, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return screen_width - ((60 + 150) * 2);
}

#pragma mark -- UICollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block(indexPath, @"嘿嘿嘿");
        
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
