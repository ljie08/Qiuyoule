//
//  MXOfficialDetailCell.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/5/9.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXOfficialDetailCell.h"

@implementation MXOfficialDetailCell

+ (instancetype)myCellWithTableview:(UITableView *)tableview {
    static NSString *cellid = @"MXOfficialDetailCell";
    MXOfficialDetailCell *cell = [tableview dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MXOfficialDetailCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screen_width-30, 40)];
    self.titleLab.numberOfLines = 0;
    self.titleLab.font = [UIFont boldSystemFontOfSize:17];
    self.titleLab.textColor = mx_FontBalckColor;
    [self addSubview:self.titleLab];
    
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, screen_width, CGFLOAT_MIN)];
    self.webview.userInteractionEnabled = NO;
    [self addSubview:self.webview];
    
    [self.webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setDataWithModel:(MXSYJFocusOnModel *)model {
    self.titleLab.text = model.title;
    [self.webview loadHTMLString:model.content baseURL:nil];
    
//    self.titleLab.frame = CGRectMake(15, 0, screen_width-30, [MXOfficialDetailCell cellHeightWithString:model.title]);
//    self.webview.frame = CGRectMake(0, CGRectGetMaxY(self.titleLab.frame)+10, screen_width, CGFLOAT_MIN);
}

+ (CGFloat)cellHeightWithString:(NSString *)string {
    CGFloat height = [MXLJUtil initWithSize:CGSizeMake(screen_width-30, CGFLOAT_MAX) string:string font:18].height;
    return height;
}

//监听webview高度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize size = [self.webview sizeThatFits:CGSizeZero];
//        [self.webview setScalesPageToFit:YES];
        self.webview.frame = CGRectMake(0, 0, screen_width, size.height);
        
        self.webHeight = size.height;
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:size.height] forKey:@"webheight"];
        // 用通知发送加载完成后的高度
        [[NSNotificationCenter defaultCenter] postNotificationName:@"webview_height" object:self userInfo:dic];
    }
}

- (void)dealloc {
    [self.webview.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

