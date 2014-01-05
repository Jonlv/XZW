//
//  XZWUtil.h
//  XZW
//
//  Created by Dee on 13-8-23.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

@end

@implementation UIColor (Hex)

+ (UIColor*) colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

@end


@interface XZWUtil : NSObject


+(NSString *)filterHTML:(NSString *)html;

+ (NSString *)stringByEscapingXML:(NSString*)theString;

+ (NSString *)stringByUnescapingXML:(NSString*)theString;


//+ (UIImage *)fixOrientationImage:(UIImage*)initImage;

+(UIImage*)imageByRotatingImage:(UIImage*)initImage;

+(NSString*)judgeChatTimeBySendTime:(NSString*)sendTimerString;

+(UIImage*)convertToSmallSizeFromUIImage:(UIImage*)largeImage;

+(BOOL)checkLogin;

+(UIImage*)getRightUIImage:(UIImage*)largeImage;

+(NSString*)getMyPath;

+(NSString*)getDataBase;

+(NSArray*)findAstro:(NSString*)dateString;

+(UIColor*)setColorByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+(UIColor*)xzwRedColor;

+(NSString*)judgeTimeBySendTime:(NSDate*)sendTime;

@end
