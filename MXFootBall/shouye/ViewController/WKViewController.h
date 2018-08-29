//
//  WKViewController.h
//  WKDemo
//
//  Created by lee on 2017/5/12.
//  Copyright © 2017年 仿佛若有光. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WKViewController : BaseViewController

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *wktitle;

@end

@interface WKScriptMessageDelegate : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id <WKScriptMessageHandler> scriptMessageDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)delegate;

@end
