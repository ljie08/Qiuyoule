//
//  MXSYJCommentLineView.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/17.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJCommentLineView.h"
#import "MLLinkLabel.h"
#import "MXSYJFollowCommentModel.h"

@interface MXSYJCommentLineView () <MLLinkLabelDelegate>

@property (nonatomic, strong) NSArray *commentItemsArray;

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSMutableArray *commentLabelsArray;

@property (nonatomic, strong) UIView *likeLableBottomLine;



@end


@implementation MXSYJCommentLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupViews];

    }
    return self;
}

- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];
        UIColor *highLightColor = [UIColor blueColor];
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.font = [UIFont systemFontOfSize:14];
        label.delegate = self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        MXSYJFollowCommentModel *model = commentItemsArray[i];
        MLLinkLabel *label = self.commentLabelsArray[i];
        label.delegate = self;
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithCommentItemModel:model];
        }
        label.attributedText = model.attributedContent;
    }
}

- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

- (void)commentItemsArray:(NSArray *)commentItemsArray
{
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
    
    if (!commentItemsArray.count) {
        self.fixedWidth = @(0); // 如果没有评论或者点赞，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        self.fixedHeight = @(0); // 如果没有评论或者点赞，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        return;
    } else {
        self.fixedHeight = nil; // 取消固定宽度约束
        self.fixedWidth = nil; // 取消固定高度约束
    }
    
    CGFloat margin = 5;
    
    UIView *lastTopView = nil;
    
    for (int i = 0; i < self.commentItemsArray.count; i++) {
        UILabel *label = (UILabel *)self.commentLabelsArray[i];
        label.tag = i;
        label.hidden = NO;
        CGFloat topMargin = (i == 0) ? 10 : 5;
        label.sd_layout
        .leftSpaceToView(self, 8)
        .rightSpaceToView(self, 0)
        .topSpaceToView(lastTopView,topMargin)
        .autoHeightRatio(0);
        
        label.isAttributedContent = YES;
        lastTopView = label;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentChildClick:)];
        [label addGestureRecognizer:gesture];
    }
    
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(MXSYJFollowCommentModel *)model
{
    NSString *text = model.followerName;
  
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.content]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : model.ownerId} range:[text rangeOfString:model.followerName]];
    return attString;
}

- (NSMutableAttributedString *)generateAttributedStringWithLikeItemModel:(MXSYJFollowCommentModel *)model
{
    NSString *text = model.followerName;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    UIColor *highLightColor = [UIColor blueColor];
    [attString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : model.ownerId} range:[text rangeOfString:model.followerName]];
    
    return attString;
}

- (void)commentChildClick: (id *)sender {
    //用tag传值判断
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    
    UIView *view = (UIView *)tap.view;
    
    if ([self.delegate respondsToSelector:@selector(replyClick: commentModel:indexPath:)]) {
        [self.delegate replyClick:view.tag commentModel:self.commentItemsArray[view.tag] indexPath:self.indexPath];
    }
}

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
}



@end
