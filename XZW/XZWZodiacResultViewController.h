//
//  XZWZodiacResultViewController.h
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZWZodiacResultViewController : UIViewController






-(id)initWithDateString:(NSString*)dateString wholeString:(NSString*)theWholeString;

-(id)initWithSunIndex:(int)sunIndex upIndex:(int)upIndex wholeString:(NSString*)theWholeString;

@end
