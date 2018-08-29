//
//  MXLJUtil.h
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MXLJUtil : NSObject

@property (nonatomic, assign) CGFloat passtime;

//#333333格式颜色
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert;

+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor;

//计算两个日期之间的天数
+ (NSInteger)getDaysFromNowToEnd:(NSDate *)endDate;

/**
 倒计时 将来的某个时间距现在还有多久
 
 @param futureTime 将来的某个时间
 @return NSDateComponents.year, NSDateComponents.month, NSDateComponents.day, NSDateComponents.hour, NSDateComponents.minute, NSDateComponents.sencond
 */
+ (NSDateComponents *)dateFromNowToFutureTime:(NSString *)futureTime ;

/**
 毫秒倒计时
 
 @param future 将来的时间
 @param passTime 过去的时间（毫秒）
 @return <#return value description#>
 */
+ (MXLJCountDown *)getCountDownFromFutureTime:(double)future passTime:(CGFloat)passTime;

//获取当前时间字符串 时间戳
+ (NSString *)getNowDateTimeString;

//0点的今天时间戳
+ (NSString *)getZeroWithTimeInterverl;

//某天0点的时间戳
+ (NSString *)getZeroTimeInterverlWithDateStr:(NSString *)dateStr;

//获取当前的时间
+ (NSString*)getCurrentTimes;

//时间戳转为时间字符串
+ (NSString *)timeInterverlToDateStr:(NSString *)timeStr;

//时间戳转为date
+ (NSDate *)dateStrToDate:(NSString *)timeStr;

//时间戳转为分钟字符串
+ (NSString *)timeMinuteToDateStr:(NSString *)timeStr;

//获取时间段
+ (NSString *)getTheTimeBucket;

//获取前n天
+ (NSString *)getNDay:(NSInteger)n dateType:(NSString *)dateType;

+ (NSString *)SpecialTimeFormatWithTimeInterval:(NSString *)timeStr;

//字符串转size 自适应高度
+ (CGSize)initWithSize:(CGSize)size string:(NSString *)string font:(NSInteger)font;

/**
 小数 四舍五入 如: 100.178 = 100.18 | 100.123 = 100.12
 
 @param format 保留几位小数
 @param num 要计算的数字
 @return 四舍五入的结果
 */
+ (NSString *)roundingOffwithFormat:(NSString *)format  floatNum:(float)num;

/** 对字典(Key-Value)排序
 @param dict 要排序的字典
 */
+ (NSMutableDictionary *)sortedDictionary:(NSMutableDictionary *)dict;

/**
 压缩并剪裁图片
 
 @param url 图片url
 @param num 放大或缩小的倍数
 @param type 图片位置 0代表从0,0开始，1代表图片中间
 @param size 剪裁的图片的大小（宽高比）
 @return 剪裁好的图片
 */
+ (UIImage *)cutPicWithPicUrl:(NSString *)url bigOrSmall:(CGFloat)num picLocationType:(int)type size:(CGSize)size;

//字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
