//
//  XZWZodiacData.h
//  XZW
//
//  Created by Dee on 13-8-23.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZWZodiacData : NSObject


+(double)mod:(double)n y:(double )m;

+(NSString*)degree:(double )arg;

+(NSString*)zodiac:(double)l;

+(int)zodiacIndex:(double)l;

+(NSArray*)getSignArray;

+(NSArray*)getNameArray;

+(NSArray*)getTypeArray;
+(NSArray*)getTypesArray;
+(NSArray*)getAnglesArray;

@end
