//
//  Config.h
//  MXFootBall
//
//  Created by zt on 2018/3/5.
//  Copyright © 2018年 zt. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define mx_weakify(var)   __weak typeof(var) weakSelf = var
#define mx_strongify(var) __strong typeof(var) strongSelf = var


#define Timestamps 1528905600 //2018-06-14 00:00:00 1528905600

#define Color(r, g, b, a)  [UIColor colorWithRed: (r)/255.0 green: (g)/255.0 blue: (b)/255.0 alpha: (a)]
/* 屏幕宽高 */
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
/* 适配 */
#define scaleWithSize(s) ((s) * (screen_width / 375))

#define Width_Scale         screen_width / 375.0
#define Height_Scale         screen_height / 667.0

/* 字体大小 */
#define fontSize(fontSize) [UIFont systemFontOfSize: (fontSize)]
/** 粗体文字 */
#define fontBoldSize(fontSize)  [UIFont boldSystemFontOfSize:(fontSize)]

#define weakSelf(self) autoreleasepool{} __weak typeof(self) weak##Self = self;//定义弱引用

#define WX_APPID @"wx259e1a3c34d0d18c"
#define WX_SECRET @"1446c3b49f17071c7d4943251a1629ce"

//当前的windows
#define CurrentKeyWindow [UIApplication sharedApplication].keyWindow

//图片
#define Image(name) [UIImage imageNamed:name] //图片
#define PlaceholderImage [UIImage imageNamed:@"DefaultImage"]//占位图

//iPhone X
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONEX (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0)
//状态栏高度
#define STATUS_HEIGHT (UI_IS_IPHONEX ? 44: 20)
//iphoneX底部
//#define iPhoneXBottomHeight 34
//导航栏+状态栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT (STATUS_HEIGHT + 44)
//tabbar高度
#define TABBAR_HEIGHT (UI_IS_IPHONEX ? 83: 49)
//底部高度
#define TABBAR_FRAME (UI_IS_IPHONEX ? 34: 0)
//导航栏+状态栏+tabbar高度
#define STATUS_TABBAR_NAVIGATION_HEIGHT (STATUS_AND_NAVIGATION_HEIGHT + TABBAR_HEIGHT)


#define mx_Register_borderColor kColorWithRGBF(0x2375e5)//发送验证码按钮边框


//共有颜色定义
#define mx_All_Defalut_backgroundColor kColorWithRGBF(0xF2F2F2)
#define mx_redColor kColorWithRGBF(0xBF3536)
//#define mx_blueColor kColorWithRGBF(0xC13331)
#define mx_FontBalckColor kColorWithRGBF(0x333333)
#define mx_FontGreyColor kColorWithRGBF(0x666666)
#define mx_FontLightGreyColor kColorWithRGBF(0x999999)
#define mx_LineColor kColorWithRGBF(0xd9d9d9)
#define mx_GreenColor kColorWithRGBF(0x21A43D)
//33 164 61 21A43D
#define mx_BlueColor kColorWithRGBF(0x2978E3)


#define mx_shouye_status_color002374  kColorWithRGBF(0xC13331)//首页状态栏颜色
#define mx_status_color002374  kColorWithRGBF(0x601918)//状态栏颜色


#define mx_Wode_backgroundColor ([UIColor colorWithRed:247.0/255 green:247.0/255 blue:247.0/255 alpha:1])
#define mx_Wode_darkGreyFontColor ([UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1])
#define mx_Wode_bordColor ([UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1])
#define MXWodebackgroundColors ([UIColor colorWithRed:27.0/255 green:93.0/255 blue:233.0/255 alpha:1])
#define MXWodeRedColors ([UIColor colorWithRed:249.0/255 green:35.0/255 blue:37.0/255 alpha:1])
#define mx_Wode_colorBlueprogress ([UIColor colorWithRed:26/255.0f green:93/255.0f blue:222/255.0f alpha:1])//礼物progress颜色 蓝色
#define mx_Wode_colorcccccc                 kColorWithRGBF(0xcccccc)//评论的颜色
#define mx_Wode_color333333                 kColorWithRGBF(0X333333)//
#define mx_Wode_color666666                 kColorWithRGBF(0X666666)//
#define mx_Wode_colord9d9d9                 kColorWithRGBF(0Xd9d9d9)//
#define mx_Wode_colorBlue2374e4             kColorWithRGBF(0XBF3536)//背景红
#define mx_Wode_color999999                 kColorWithRGBF(0X999999)//

#define mx_Wode_colorf2f2f2                 kColorWithRGBF(0Xf2f2f2)//
#define mx_Wode_colorffffff                 kColorWithRGBF(0Xffffff)//
#define mx_Wode_colorff3b30                 kColorWithRGBF(0Xff3b30)//
#define mx_Wode_color16a635                 kColorWithRGBF(0X16a635)//
#define mx_Wode_colorff4242                 kColorWithRGBF(0Xff4242)//弹框的背景红色 色值
#define mx_Wode_colorfee100                 kColorWithRGBF(0xfee100)//弹框的确定按钮的黄色值
#define mx_Wode_colorff4c35                 kColorWithRGBF(0xff4c35)//弹框的确定按钮的红色值
#define mx_luntan_mingrentang_colore7180e   kColorWithRGBF(0xe7180e)//名人堂红色背景色值
#define mx_Wode_colorc2c2c2                  kColorWithRGBF(0xc2c2c2)//意见反馈提醒文字颜色
#define kMXSSToolConfigModelKey             @"MXSSToolConfigModelKey"
#define MXNotificationDefaultCenter [NSNotificationCenter defaultCenter]

#ifdef DEBUG
#define YYLog(fmt, ...) NSLog((@"%s [第%d行] "fmt),__PRETTY_FUNCTION__ ,__LINE__,##__VA_ARGS__)
#else
#define YYLog(...)
#endif

#ifdef DEBUG
#define YANGLog(format, ...) printf(" %s [第%d行] \n%s\n",__PRETTY_FUNCTION__,__LINE__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define YANGLog(format, ...)
#endif

#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr, "%s:%zd\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

//字符串是否为空
#define StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )

// 英文键盘高度                   216.0f
// 中文键盘高度                     252.0f
// 中文九宫格键盘未输入高度         184.f
// 中文九宫格输入键盘高度                          251.5f
#define SCREEN_MAX_LENGTH (MAX((screen_width), (screen_height)))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))  
#define IS_IPHONE_6 (UI_IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (UI_IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define isIPhone5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.height==1136 : NO)
#define kColorWithRGBF(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#endif /* Config_h */
