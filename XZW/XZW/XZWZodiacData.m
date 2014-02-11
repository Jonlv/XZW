//
//  XZWZodiacData.m
//  XZW
//
//  Created by Dee on 13-8-23.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWZodiacData.h"

@implementation XZWZodiacData



+ (NSString *)degree:(double)arg {
	int h = (int)(arg) % 30;
	int m = round([XZWZodiacData mod:arg * 100 y:100] / 100 * 60);


	return [NSString stringWithFormat:@"%02d度%02d分", h, m];
}

+ (double)mod:(double)n y:(double)m {
	if ((int)(n) % (int)(m) == 0) {
		return (int)n % (int)m;
	}
	else {
		return n - (((int)(n / m)) * m);
	}
}

+ (NSString *)zodiac:(double)l {
	int z = (l - [XZWZodiacData mod:l y:30]) / 30;


	return [[XZWZodiacData getSignArray] objectAtIndex:z];
}

+ (int)zodiacIndex:(double)l {
	int z = (l - [XZWZodiacData mod:l y:30]) / 30;


	return z;
}

+ (NSArray *)getNameArray {
	return @[@"太阳", @"月亮", @"水星", @"金星", @"火星", @"木星", @"土星", @"天王星", @"海王星", @"冥王星", @"上升", @"天顶"];
}

+ (NSArray *)getSignArray {
	return @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];
}

+ (NSArray *)getTypeArray {
	return @[@"会", @"冲", @"刑", @"拱", @"六合"];
}

+ (NSArray *)getTypesArray {
	return @[@"合相", @"对分相", @"四分相", @"三分相", @"六分相"];
}

+ (NSArray *)getAnglesArray {
	return @[@"上升", @"天底", @"下降", @"天顶"];
}

@end
