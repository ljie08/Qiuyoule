//
//  ZTGoodsDetailWebView.h
//  ZTShop
//
//  Created by zt on 2017/12/18.
//  Copyright © 2017年 zt. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface ZTGoodsDetailWebView : WKWebView

@property (nonatomic, strong) NSString *html;
@property (nonatomic, copy) NSString *body;

@end
