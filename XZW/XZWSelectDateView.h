//
//  XZWSelectDateView.h
//  XZW
//
//  Created by dee on 13-8-28.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZWChinesePickView.h"

@class XZWSelectDateView;
@protocol XZWSelectDateViewDelegate <NSObject>



@optional

-(void)getDate:(NSDate*)theDate andDateString:(NSString*)dateString ;

-(void)dateView:(XZWSelectDateView*)dateView dateChanged:(NSDate *)Date andDateString:(NSString *)ChineseDateString;

@end


@interface XZWSelectDateView : UIView<XZWDatePickerViewDelegate>{
    
    

    
    
}

@property (assign,nonatomic) id<XZWSelectDateViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andDateString:(NSString*)dateString;

-(void)playAnimate;

-(void)dismissAnimate;

@end
