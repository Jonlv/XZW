//
//  XZWChinesePickView.h
//  XZW
//
//  Created by Dee on 13-8-20.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XZWDatePickerViewDelegate <NSObject>


@optional

-(void)dateChanged:(NSDate*)changedDate;


-(void)dateChanged:(NSDate*)Date andChineseDateString:(NSString*)ChineseDateString;

@end


@interface XZWChinesePickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    
    UIPickerView *datePickView;
    
    int luarMonth;
}


@property (assign,nonatomic) id<XZWDatePickerViewDelegate> delegate;





-(void)getDate;

-(NSArray*)getDateArray;


@end
