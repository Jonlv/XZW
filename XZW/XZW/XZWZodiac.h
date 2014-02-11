//
//  XZWZodiac.h
//  XZW
//
//  Created by Dee on 13-8-21.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZWZodiac : NSObject


-(void)setYear:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute daylight:(int)daylight timezone:(int)timezone longitude:(double)longitude1 latitude:(double)latitude1 am:(double)am1 sml:(double)sml;

-(NSArray*)getPlanet;
-(NSArray*) getHouse;
-(NSArray*) getAspect;

-(void)print;


-(double)getT;
-(double)getK;
-(double)getAm;

-(double)getAst;

@end
