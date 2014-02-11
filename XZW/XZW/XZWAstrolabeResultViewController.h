//
//  XZWAstrolabeResultViewController.h
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZWZodiac.h"
#import "XZWAstrolabeView.h"

@interface XZWAstrolabeResultViewController : UIViewController<XZWAstrolableDataSource>{
    
    
    NSArray *dataArray;
    
    double astVaule;
    
    NSString *nickNameString;
    NSString *bornDate;
    NSString *bornLoc;
    NSString *positionString;
    NSString *timeZoneString;
    
}

@property (nonatomic,retain)  NSArray *savedArray;

-(id)initZodiac:(XZWZodiac*)zodiac andName:(NSString*)nameString andBirthday:(NSString*)birthday birthLoc:(NSString*)birthLoc birthPosi:(NSString*)birthPosi timeZone:(NSString*)birthTimeZoneString;


-(id)initWithAstrolabeDic:(NSDictionary*)theDictionary;


@end
