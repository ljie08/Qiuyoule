//
//  ZTGoodsDetailWebView.m
//  ZTShop
//
//  Created by zt on 2017/12/18.
//  Copyright © 2017年 zt. All rights reserved.
//

#import "ZTGoodsDetailWebView.h"

@implementation ZTGoodsDetailWebView

- (instancetype)init{
    self = [super init];
    self.backgroundColor = [UIColor redColor];
    if (self) {
        self.scrollView.contentSize = CGSizeMake(0, 0);
    }
    return self;
}

- (void)setHtml: (NSString *)html{
    _html = html;
    NSString *body = [NSString stringWithFormat:[self htmlTep], _html];
    self.body = body;
    [self loadHTMLString:body baseURL:nil];
}

- (NSString *)htmlTep{
    return @"<!DOCTYPE html>\
    <html>\
   <head>\
    <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>\
    <style>*{margin:0;padding:0;list-style:none;}iframe,video,embed,.tenvideo_player{width:100%% !important;height:220px !important;}</style>\
    </head>\
    <body><div class='content'>%@</div>\
    <script type='text/javascript'>\
    window.onload = function(){\
    var links = document.getElementsByTagName('a');\
    for(var i = 0; i < links.length; i++ ){\
    links[i].href = 'caida_open_url://'+links[i].href;\
    }\
    var $img = document.getElementsByTagName('img');\
    for(var p in  $img){\
    $img[p].style.width = '100%%';\
    $img[p].style.height ='auto'\
    }\
    }\
    </script>\
    </body>\
    </html>";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
