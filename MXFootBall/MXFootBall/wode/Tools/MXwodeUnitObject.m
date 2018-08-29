//
//  MXwodeUnitObject.m
//  MXFootBall
//
//  Created by Mac on 2018/3/7.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXwodeUnitObject.h"
#import "RXPopTipView.h"
static MXwodeUnitObject *_manager = nil;

@implementation MXwodeUnitObject
+ (MXwodeUnitObject *)shareManager {
    
    //    @synchronized (self) {
    if (!_manager) {
        _manager = [[MXwodeUnitObject alloc] init];
    }
    //    }
    return _manager;
}

+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"%@",[[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@""withString:@"\\"]];
}

+(NSInteger)getIntValue:(id)object
{
    return [self getIntValue:object withDefault:-1];
}

+(NSInteger)getIntValue:(id)object withDefault:(NSInteger)defaultvalue
{
    if (!object) {
        return defaultvalue;
    }
    return [object intValue];
}

//有些对象从json中取出来是nil，导致符给label的text失败，这里封装成函数
+(NSString *)getStringValue:(id)object
{
    return [self getStringValue:object withDefault:@""];
}

+(NSString *)getStringValue:(id)object withDefault:(NSString*)defaultvalue
{
    if (!object) {
        return defaultvalue;
    }
    return [NSString stringWithFormat:@"%@", object];
}

+(void)showAlertHint:(NSString*)title message:(NSString*)message viewcontroller:(UIViewController *)viewcontroller
{
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alerController addAction:cancleAction];
    [viewcontroller  presentViewController:alerController animated:YES completion:nil];
}

+(void)showMessage:(NSString *)message viewcontroller:(UIViewController *)viewcontroller {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [viewcontroller  presentViewController:alerController animated:YES completion:nil];
        [viewcontroller performSelector:@selector(dismissViewControllerAnimated:completion:) withObject:nil afterDelay:0.2];
    });
}

+(void)showPopHint:(NSString *)contentMessage targetView:(UIView*)popView showInView:(UIView*)showView
{
    RXPopTipView *popTipView;
    popTipView = [[RXPopTipView alloc] initWithMessage:contentMessage];
    //    popTipView.delegate = self;
    
    /* Some options to try.
     */
    popTipView.backgroundColor = mx_Wode_backgroundColor;
    popTipView.borderColor = mx_Wode_bordColor;
    popTipView.textColor = mx_Wode_darkGreyFontColor;
    popTipView.animation = CMPopTipAnimationSlide;//滑出还是弹出
    popTipView.has3DStyle = FALSE;
    popTipView.dismissTapAnywhere = YES;
    [popTipView autoDismissAnimated:YES atTimeInterval:1.0];
    
    [popTipView presentPointingAtView:popView inView:showView animated:YES];
}

//提取的通用接口，在一个view上创建左边title，中间内容和右边箭头的方法，contentX为负数的时候，不创建内容部分，showArrow为false的时候不创建箭头，中间的内容支持label和textfield
+(id)addTitleContentArrowViews:(UIView*)parentView font:(UIFont*)font title:(NSString*)title contentText:(NSString*)content contentX:(NSInteger)contentX contentClass:(NSString*)contentClass txtDelegate:(id<UITextFieldDelegate>)txtDelegate showArrow:(BOOL)showArrowImg
{
    //标题
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: font}];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, (parentView.frame.size.height-size.height)/2, size.width, size.height)];
    [parentView addSubview:lblTitle];
    lblTitle.text = title;
    lblTitle.font = font;
    lblTitle.textColor = mx_Wode_darkGreyFontColor;
    lblTitle.backgroundColor =[UIColor clearColor];
    
    UIView *viewContent = nil;
    if (contentX>=0) {
        font = [UIFont systemFontOfSize:17];
        //ios6上，content为空时，算出来的的size为0，所以加默认值
        if ([MXwodeUnitObject isBlankString:content]) {
            size = [@"模版" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];//ios7.0
        }
        else
        {
            size = [content sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]}];
        }
        CGFloat tempWidth = parentView.frame.size.width-contentX-45; //从contentx开始，右边边距15+箭头15+15
        //如果宽度小于0，就不管右边边距了，直接按字符大小设置
        viewContent = [[NSClassFromString(contentClass) alloc] initWithFrame:CGRectMake(contentX, (parentView.frame.size.height-size.height)/2, (tempWidth<=size.width ? size.width : tempWidth), size.height)];
        
        [parentView addSubview:viewContent];
        if ([[contentClass lowercaseString] isEqualToString:@"uilabel"]) {
            ((UILabel*)viewContent).text = content;
            ((UILabel*)viewContent).font = font;
            ((UILabel*)viewContent).textColor = mx_Wode_darkGreyFontColor;
            ((UILabel*)viewContent).backgroundColor = [UIColor clearColor];
        }
        else if ([[contentClass lowercaseString] isEqualToString:@"uitextfield"]) {
            ((UITextField*)viewContent).text = content;
            ((UITextField*)viewContent).font = font;
            ((UITextField*)viewContent).textColor = mx_Wode_darkGreyFontColor;
            ((UITextField*)viewContent).borderStyle = UITextBorderStyleNone;
            ((UITextField*)viewContent).clearButtonMode = UITextFieldViewModeWhileEditing;
            ((UITextField*)viewContent).delegate = txtDelegate;
            ((UITextField*)viewContent).autocorrectionType = UITextAutocorrectionTypeNo;
            ((UITextField*)viewContent).backgroundColor = [UIColor clearColor];
        }
    }
    //右箭头  15*15，距离右边也是15
    if (showArrowImg) {
        UIImageView *viewArrow = [[UIImageView alloc] initWithFrame:CGRectMake(parentView.frame.size.width-15-15, (parentView.frame.size.height-15)/2, 15, 15)];
        [parentView addSubview:viewArrow];
        [viewArrow setImage:[UIImage imageNamed:@"rightArrow"]];
    }
    return viewContent;
}


/**
 *  手机号码验证
 *
 *  @param mobileNumbel 传入的手机号码
 *
 *  @return 格式正确返回true  错误 返回fals
 */
+ (BOOL) isMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189,181(增加)
     */
    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,181(增加)
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNumbel]
         || [regextestcm evaluateWithObject:mobileNumbel]
         || [regextestct evaluateWithObject:mobileNumbel]
         || [regextestcu evaluateWithObject:mobileNumbel])) {
        return YES;
    }
    
    return NO;
}

/**UILabel 自适应高度和宽度*/
+ (CGFloat)getWodeUILabelHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
+ (CGFloat)getWodeUILabelWidthWithTitle:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}


@end
