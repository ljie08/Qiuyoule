//
//  MXLJUtil.m
//  MXFootBall
//
//  Created by 仙女🎀 on 2018/3/22.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXLJUtil.h"

@implementation MXLJUtil

- (instancetype)init {
    if (self = [super init]) {
        _passtime = 0.0;
    }
    return self;
}

+ (UIColor *)hexStringToColor:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6)
        return [UIColor blackColor];
    
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat) r / 255.0f)
                           green:((CGFloat) g / 255.0f)
                            blue:((CGFloat) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexNumber:(NSUInteger)hexColor {
    CGFloat r = ((hexColor >> 16) & 0xFF) / 255.0f;
    CGFloat g = ((hexColor >> 8) & 0xFF) / 255.0f;
    CGFloat b = (hexColor & 0xFF) / 255.0f;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

//计算两个日期之间的天数
+ (NSInteger)getDaysFromNowToEnd:(NSDate *)endDate {
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *beginDate = [NSDate date];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time = [endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    int a = ((int)time)%(3600*24);
    if (a == 0) {
        return days;//只取到天数
    } else {
        if (a > 0) {//未来
            return days+1;
        } else {//过去
            return days;
        }
    }
}

/**
 倒计时 将来的某个时间距现在还有多久
 
 @param futureTime 将来的某个时间
 @return NSDateComponents.year, NSDateComponents.month, NSDateComponents.day, NSDateComponents.hour, NSDateComponents.minute, NSDateComponents.sencond
 */
+ (NSDateComponents *)dateFromNowToFutureTime:(NSString *)futureTime {
    NSDate *nowDate = [NSDate date]; // 当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
    
    //根据后台返回字段确定要不要加8小时+28800
    NSTimeInterval time=[futureTime doubleValue];//因为时差问题要加8小时 == 28800 sec
    NSDate *future=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:nowDate toDate:future options:0];
//    NSLog(@"year=%zd month=%zd day=%zd hour=%zd minute=%zd",compas.year,compas.month,compas.day,compas.hour,compas.minute);
    return compas;
}

/**
 毫秒倒计时

 @param future 将来的时间
 @param passTime 过去的时间（毫秒）
 @return <#return value description#>
 */
+ (MXLJCountDown *)getCountDownFromFutureTime:(double)future passTime:(CGFloat)passTime {
    MXLJCountDown *down = [[MXLJCountDown alloc] init];
    
    NSInteger hours = (future - passTime)/1000/60/60;//总小时
    NSInteger day = hours/24;//天数
    NSInteger hour = hours%24;//小时数
    NSInteger minute = (NSInteger)((future - passTime)/1000/60)%60;
    NSInteger second = (NSInteger)(future - passTime)/1000%60;
    NSInteger mSecond = (NSInteger)(future - passTime)%1000/100;
    
    down.day = day>9 ? [NSString stringWithFormat:@"%ld", day] : [NSString stringWithFormat:@"0%ld", day];
    down.hour = hour>9 ? [NSString stringWithFormat:@"%ld", hour] : [NSString stringWithFormat:@"0%ld", hour];
    down.minute = minute>9 ? [NSString stringWithFormat:@"%ld", minute] : [NSString stringWithFormat:@"0%ld", minute];
    down.second = second>9 ? [NSString stringWithFormat:@"%ld", second] : [NSString stringWithFormat:@"0%ld", second];
    down.millisecond = mSecond>9 ? [NSString stringWithFormat:@"%ld", mSecond] : [NSString stringWithFormat:@"0%ld", mSecond];
    
    down.dayNum = day;
    down.hourNum = hour;
    down.minuteNum = minute;
    down.secondNum = second;
    down.millisecondNum = mSecond;
    
    return down;
}

//获取当前时间字符串 时间戳
+ (NSString *)getNowDateTimeString {
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
//    NSLog(@"时间戳%@", timeString);
    return timeString;
}

//0点的今天时间戳
+ (NSString *)getZeroWithTimeInterverl {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", today]];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", [date timeIntervalSince1970]];//转为字符型
    
    NSLog(@"时间戳%@", timeString);
    return timeString;
}

//某天0点的时间戳
+ (NSString *)getZeroTimeInterverlWithDateStr:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00", dateStr]];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", [date timeIntervalSince1970]];//转为字符型
    
    NSLog(@"时间戳%@", timeString);
    return timeString;
}

//获取当前的时间
+ (NSString*)getCurrentTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    //当前时间,
    NSDate *datenow = [NSDate date];
    
    //将date按formatter格式转成string
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"当前时间 =  %@",currentTimeString);
    return currentTimeString;
}

//将时间点转化成日历形式
- (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate * destinationDateNow = [NSDate date];
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    
    //设置当前的时间点
    
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    
    [resultComps setYear:[currentComps year]];
    
    [resultComps setMonth:[currentComps month]];
    
    [resultComps setDay:[currentComps day]];
    
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
    
}

//获取时间段
+ (NSString *)getTheTimeBucket {
    NSDate * currentDate = [NSDate date];
    
    if ([currentDate compare:[[[MXLJUtil alloc] init] getCustomDateWithHour:0]] == NSOrderedDescending && [currentDate compare:[[[MXLJUtil alloc] init] getCustomDateWithHour:9]] == NSOrderedAscending) {
        return NSLocalizedString(@"morning", nil);
        
    } else if ([currentDate compare:[[[MXLJUtil alloc] init] getCustomDateWithHour:9]] == NSOrderedDescending && [currentDate compare:[[[MXLJUtil alloc] init] getCustomDateWithHour:11]] == NSOrderedAscending) {
        return NSLocalizedString(@"a.m", nil);
        
    } else if ([currentDate compare:[[[MXLJUtil alloc] init] getCustomDateWithHour:11]] == NSOrderedDescending && [currentDate compare:[[[MXLJUtil alloc] init] getCustomDateWithHour:13]] == NSOrderedAscending) {
        return  NSLocalizedString(@"midday", nil);
        
    } else if ([currentDate compare:[[[MXLJUtil alloc] init] getCustomDateWithHour:13]] == NSOrderedDescending && [currentDate compare:[[[MXLJUtil alloc] init] getCustomDateWithHour:18]] == NSOrderedAscending) {
        return NSLocalizedString(@"p.m", nil);
    } else {
        return NSLocalizedString(@"night", nil);
    }
}

//时间戳转为时间字符串
+ (NSString *)timeInterverlToDateStr:(NSString *)timeStr {
    //timeStr时间戳
    NSTimeInterval time=[timeStr doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSLog(@"date:%@",[detaildate description]);
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式yyyy.MM.dd HH:mm
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;
}

//时间戳转为date
+ (NSDate *)dateStrToDate:(NSString *)timeStr {
    //timeStr时间戳
    NSTimeInterval time=[timeStr doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    NSDate *date = [dateFormatter dateFromString:currentDateStr];
    
    return date;
}

//时间戳转为分钟字符串 314800 -> 5分14秒
+ (NSString *)timeMinuteToDateStr:(NSString *)timeStr {
    //timeStr时间戳
    if (timeStr.length > 4) {
        
        timeStr = [timeStr stringByReplacingCharactersInRange:NSMakeRange(timeStr.length-4, 3) withString:@""];
        int time = [timeStr intValue];
        int minute = time/60;
        int second = time%60;
        if (minute < 10) {
            timeStr = [NSString stringWithFormat:@"0%d", minute];
        } else {
            timeStr = [NSString stringWithFormat:@"%d", time/60];
        }
        if (second < 10) {
            timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@":0%d", second]];
        } else {
            timeStr = [timeStr stringByAppendingString:[NSString stringWithFormat:@":%d", second]];
        }
    } else {
        timeStr = @"00:00";
    }
    
    return timeStr;
}


//获取当前日期的n天前或n天后
//n为负数，为n天前，n为正数为n天后
+ (NSString *)getNDay:(NSInteger)n dateType:(NSString *)dateType {
    NSDate *nowDate = [NSDate date];
    NSDate *theDate;
    
    if (n != 0) {
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*n ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    } else {
        theDate = nowDate;
    }
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:dateType];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    
    return the_date_str;
}

+(NSString *)SpecialTimeFormatWithTimeInterval:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeStr];
    NSTimeInterval timeString =[date timeIntervalSince1970];//转为字符型
    NSTimeInterval nowTime=[[NSDate date] timeIntervalSince1970];
    NSTimeInterval  timeInterval=nowTime-timeString;
    if (timeInterval<60) {
        return @"刚刚";
    }else if(timeInterval>60&&timeInterval<900){
        return @"1分钟前";
    }else if (timeInterval>900&&timeInterval<1800){
        return @"15分钟前";
    }else if (timeInterval>1800&&timeInterval<3600){
        return @"半小时前";
    }else if(timeInterval>3600&&timeInterval<3600*24){
        return [NSString stringWithFormat:@"%li小时前",(NSInteger)timeInterval/3600];
    }else if (timeInterval>3600*24&&timeInterval<3600*24*365){
        NSInteger days=(NSInteger)timeInterval/(3600*24);
        return [NSString stringWithFormat:@"%li天前",days];
    }else{
        return @"1年前" ;
    }
    
}
//字符串转size 自适应高度
+ (CGSize)initWithSize:(CGSize)size string:(NSString *)string font:(NSInteger)font {
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGSize sizes = [string boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return sizes;
}

/**
 小数 四舍五入 如: 100.178 = 100.18 | 100.123 = 100.12
 
 @param format 保留几位小数
 @param num 要计算的数字
 @return 四舍五入的结果
 */
+ (NSString *)roundingOffwithFormat:(NSString *)format  floatNum:(float)num {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:format];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:num]];
}

/** 对字典(Key-Value)排序
 @param dict 要排序的字典
 */
+ (NSMutableDictionary *)sortedDictionary:(NSMutableDictionary *)dict {
    NSMutableString *contentString =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    //拼接
    for (NSString *keyStr in sortedArray) {
        NSString *valueStr = [NSString stringWithFormat:@"%@", [dict objectForKey:keyStr]];//value有可能是integer类型，转化成string再做判断
        if (![valueStr isEqualToString:@""] && ![valueStr isEqualToString:@"key"] ) {
            [contentString appendFormat:@"%@=%@&", keyStr, [dict objectForKey:keyStr]];
        }
    }
    contentString = (NSMutableString *)[contentString substringToIndex:contentString.length-1];
    NSLog(@"%@", contentString);
    
    //加密
    NSString *signStr = [[NSString stringWithFormat:@"%@%@", contentString, MX_KEY] MD5];
    [dict setObject:signStr forKey:@"sign"];
    
    return dict;
}

/**
 压缩并剪裁图片
 
 @param url 图片url
 @param num 放大或缩小的倍数
 @param type 图片位置 0代表从0,0开始，1代表图片中间
 @param size 剪裁的图片的大小（宽高比）
 @return 剪裁好的图片
 */
+ (UIImage *)cutPicWithPicUrl:(NSString *)url bigOrSmall:(CGFloat)num picLocationType:(int)type size:(CGSize)size {
    //显示图片的上半部分
    NSData *imgdata = [NSData  dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *myimage =  [UIImage imageWithData:imgdata];
    
    //先将图片压缩，在剪裁
    NSData *data = nil;
    if(!UIImagePNGRepresentation(myimage)) {
        data = UIImageJPEGRepresentation(myimage,num);
    }else{
        data = UIImagePNGRepresentation(myimage);
    }
    myimage = [UIImage imageWithData:data];
    //首先，获取想要显示的部分的大小及位置
    CGSize imgSize = myimage.size;
    CGFloat width = imgSize.width;
    CGFloat height = imgSize.height;
    CGFloat rectW;//剪裁的宽度
    CGFloat rect_x;//x坐标
    CGFloat rectH;//剪裁的高度
    CGFloat rect_y;//y坐标
    
    CGRect rect;
    
    //w1:h1 = w2:h2
    //size.w:size.h = rectw:recth
    //w2 = w1*h2/h1
    if (type) {//剪裁中间的
        if (width >= height) {
            rectW = size.width*height/size.height;
            rectH = height;
            rect_x = (width-rectW)/2;
            rect_y = 0;
        } else {
            rectW = width;
            rectH = size.height*width/size.width;
            rect_x = 0;
            rect_y = (height-rectW)/2;
        }
    } else {//剪裁从0,0开始
        rectW = imgSize.width;
        rectH = imgSize.width;
        rect_x = 0;
        rect_y = 0;
    }
    
    rect = CGRectMake(rect_x, rect_y, rectW, rectH);
    
    //然后，将此部分从图片中剪切出来
    CGImageRef imageRef = CGImageCreateWithImageInRect([myimage CGImage], rect);
    UIImage *newImg = [UIImage imageWithCGImage:imageRef];
    //最后，将剪切下来图片返回
    return newImg;
}

//字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end
