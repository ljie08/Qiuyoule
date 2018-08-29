//
//  MXTableCollectionCell.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/3/19.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXTableCollectionCell.h"
#import "MXSYJFlowLayout.h"
#import "MXSYJCollectionCell.h"

#define Kwidths  ([UIScreen mainScreen].bounds.size.width / 2)

@interface MXTableCollectionCell ()<UICollectionViewDataSource,SYJWaterfallLayoutDelegate,UICollectionViewDelegate>


@end

@implementation MXTableCollectionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //创建瀑布流布局
        MXSYJFlowLayout *waterfall = [MXSYJFlowLayout waterFallLayoutWithColumnCount:2];
        //设置各属性的值
        waterfall.rowSpacing = 0;
        waterfall.columnSpacing = 0;
        waterfall.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        //或者一次性设置
        //    [waterfall setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        
        //设置代理，实现代理方法
        waterfall.delegate = self;
        /*
         //或者设置block
         [waterfall setItemHeightBlock:^CGFloat(CGFloat itemWidth, NSIndexPath *indexPath) {
         //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
         XRImage *image = self.images[indexPath.item];
         return image.imageH / image.imageW * itemWidth;
         }];
         */
        
        //创建collectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width,240) collectionViewLayout:waterfall];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[MXSYJCollectionCell class] forCellWithReuseIdentifier:@"cell"];

        
        
    }
    
    return self;
}


//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(MXSYJFlowLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    
    //    int y = (arc4random() % 80) + 240;
    
    return 80;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.arrModle.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MXSYJCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.arrModle.count > 0) {
        
        cell.model = (MXSYJChannelModel *)self.arrModle[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(index:)]) {
        [self.delegate index:indexPath.row];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(Kwidths, 80);
}

- (void)setArrModle:(NSMutableArray *)arrModle{
    
    _arrModle = arrModle;
    [self.collectionView reloadData];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
