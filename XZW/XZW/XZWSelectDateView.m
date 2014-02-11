//
//  XZWSelectDateView.m
//  XZW
//
//  Created by dee on 13-8-28.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSelectDateView.h"
#import "XZWUtil.h"
#import <QuartzCore/QuartzCore.h>

@interface XZWSelectDateView (){
    
    
    UIView  *backView;
    
    UIDatePicker *datePicker;
    XZWChinesePickView *chinesePV;
    
    UILabel *chineseUL;
    UILabel *dateUL;
    
    UIButton *zodiacButton;UIButton *chineseCalButton;
    
    
}

@end

@implementation XZWSelectDateView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         
        
        backView = [[UIView alloc]   initWithFrame:CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight)];
        [self addSubview:backView];
        [backView release];
        
        UIImageView *backgroundView = [[UIImageView alloc]   initWithFrame:CGRectMake(0, TotalScreenHeight - 88 - 44 - 230, 320, 88 +230 +44)];
        backgroundView.userInteractionEnabled = true;
        backgroundView.backgroundColor = [UIColor colorWithHex:0x464d5b alpha:.8f];
        [backView addSubview:backgroundView];
        [backgroundView release];
        
        
        UIImageView *toolBarUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"cledertop"]];
        toolBarUIV.layer.shadowOffset = CGSizeMake(0, -2);
        toolBarUIV.frame = CGRectMake(0, 0, 320, 44);
        [backgroundView addSubview:toolBarUIV];
        [toolBarUIV release];
        
        
        
        
        
        NSDateFormatter *tempDateFormate =[[[NSDateFormatter alloc]  init]  autorelease];
        [tempDateFormate setDateFormat:@"YYYY年MM月DD日"];
        
        datePicker =  [[UIDatePicker alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight - 230 -44, 320, 230)];
        [datePicker   addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        datePicker.date = [tempDateFormate dateFromString:@"1980年1月1日"];
        datePicker.datePickerMode =  UIDatePickerModeDate;
        [backView addSubview:datePicker];
        [datePicker release];
        
        
        chinesePV = [[XZWChinesePickView alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight - 230 -44, 320, 230)];
        chinesePV.hidden = true;
        [backView addSubview:chinesePV];
        [chinesePV release];
        
        UILabel *tipUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 0, 320, 44)];
        tipUL.backgroundColor = [UIColor clearColor];
        tipUL.textColor = [UIColor whiteColor];
        tipUL.text = @"选择日期";
        [backgroundView addSubview:tipUL];
        [tipUL release];
        
        
        zodiacButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [zodiacButton addTarget:self action:@selector(showChineseZ) forControlEvents:UIControlEventTouchUpInside];
        [zodiacButton setBackgroundImage:[UIImage imageNamed:@"graycalendar_btn"] forState:UIControlStateNormal];
        [zodiacButton setBackgroundImage:[UIImage imageNamed:@"calendar_btn"] forState:UIControlStateSelected];
        zodiacButton.frame = CGRectMake(174, 6 , 64, 31);
        zodiacButton.selected = false;
        [zodiacButton  setTitle:@"农历" forState:UIControlStateNormal];
        [backgroundView addSubview:zodiacButton];
        
        
        chineseCalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chineseCalButton.frame = CGRectMake(242, 6 , 64, 31);
        chineseCalButton.selected = true;
        [chineseCalButton addTarget:self action:@selector(showZ) forControlEvents:UIControlEventTouchUpInside];
        [chineseCalButton setBackgroundImage:[UIImage imageNamed:@"graycalendar_btn"] forState:UIControlStateNormal];
        [chineseCalButton setBackgroundImage:[UIImage imageNamed:@"calendar_btn"] forState:UIControlStateSelected];
        [chineseCalButton  setTitle:@"公历" forState:UIControlStateNormal];
        [backgroundView addSubview:chineseCalButton];
        
        
        
        chineseUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, -40, 320, 40)];
        [chineseUL   setText:@" "];
        chineseUL.textAlignment = NSTextAlignmentCenter;
        chineseUL.backgroundColor = [UIColor clearColor];
        chineseUL.textColor = [UIColor whiteColor];
        chinesePV.delegate = self;
        [chinesePV addSubview:chineseUL];
        [chineseUL release];
        
        dateUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, -40, 320, 40)];
        [dateUL   setText:@" "];
        dateUL.textColor = [UIColor whiteColor];
        dateUL.textAlignment = NSTextAlignmentCenter;
        dateUL.backgroundColor = [UIColor clearColor];
        [datePicker addSubview:dateUL];
        [dateUL release];

       // [self valueChange:datePicker];
        
        [self performSelector:@selector(valueChange:) withObject:datePicker afterDelay:.1f];
        
         
        chineseUL.text = [[chinesePV getDateArray]   objectAtIndex:1];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andDateString:(NSString*)dateString
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        backView = [[UIView alloc]   initWithFrame:CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight)];
        [self addSubview:backView];
        [backView release];
        
        UIImageView *backgroundView = [[UIImageView alloc]   initWithFrame:CGRectMake(0, TotalScreenHeight - 88 - 44 - 230, 320, 88 +230 +44)];
        backgroundView.userInteractionEnabled = true;
        backgroundView.backgroundColor = [UIColor colorWithHex:0x464d5b alpha:.8f];
        [backView addSubview:backgroundView];
        [backgroundView release];
        
        
        UIImageView *toolBarUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"cledertop"]];
        toolBarUIV.layer.shadowOffset = CGSizeMake(0, -2);
        toolBarUIV.frame = CGRectMake(0, 0, 320, 44);
        [backgroundView addSubview:toolBarUIV];
        [toolBarUIV release];
        
        
        
        
        
        NSDateFormatter *tempDateFormate =[[[NSDateFormatter alloc]  init]  autorelease];
     
        [tempDateFormate setDateFormat:@"yyyyMMdd"];
        
         NSDate *lastHundredDate = [NSDate  dateWithTimeIntervalSinceNow: - 100 * 365.5 * 24 * 3600 ];
        
        datePicker =  [[UIDatePicker alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight - 230 -44, 320, 230)];
        [datePicker   addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        datePicker.date = [tempDateFormate dateFromString:dateString]? [tempDateFormate dateFromString:dateString]: [NSDate date];
        datePicker.datePickerMode =  UIDatePickerModeDate;
        datePicker.maximumDate = [NSDate date];
        datePicker.minimumDate = lastHundredDate;
        [backView addSubview:datePicker];
        [datePicker release];
        
        
        
        chinesePV = [[XZWChinesePickView alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight - 230 -44, 320, 230)];
        chinesePV.hidden = true;
        [backView addSubview:chinesePV];
        [chinesePV release];
        
        UILabel *tipUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 0, 320, 44)];
        tipUL.backgroundColor = [UIColor clearColor];
        tipUL.textColor = [UIColor whiteColor];
        tipUL.text = @"选择日期";
        [backgroundView addSubview:tipUL];
        [tipUL release];
        
        
        zodiacButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [zodiacButton addTarget:self action:@selector(showChineseZ) forControlEvents:UIControlEventTouchUpInside];
        [zodiacButton setBackgroundImage:[UIImage imageNamed:@"graycalendar_btn"] forState:UIControlStateNormal];
        [zodiacButton setBackgroundImage:[UIImage imageNamed:@"calendar_btn"] forState:UIControlStateSelected];
        zodiacButton.frame = CGRectMake(174, 6 , 64, 31);
        zodiacButton.selected = false;
        [zodiacButton  setTitle:@"农历" forState:UIControlStateNormal];
        [backgroundView addSubview:zodiacButton];
        
        
        chineseCalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chineseCalButton.frame = CGRectMake(242, 6 , 64, 31);
        chineseCalButton.selected = true;
        [chineseCalButton addTarget:self action:@selector(showZ) forControlEvents:UIControlEventTouchUpInside];
        [chineseCalButton setBackgroundImage:[UIImage imageNamed:@"graycalendar_btn"] forState:UIControlStateNormal];
        [chineseCalButton setBackgroundImage:[UIImage imageNamed:@"calendar_btn"] forState:UIControlStateSelected];
        [chineseCalButton  setTitle:@"公历" forState:UIControlStateNormal];
        [backgroundView addSubview:chineseCalButton];
        
        
        
        chineseUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, -40, 320, 40)];
        [chineseUL   setText:@" "];
        chineseUL.textAlignment = NSTextAlignmentCenter;
        chineseUL.backgroundColor = [UIColor clearColor];
        chineseUL.textColor = [UIColor whiteColor];
        chinesePV.delegate = self;
        [chinesePV addSubview:chineseUL];
        [chineseUL release];
        
        dateUL = [[UILabel alloc]   initWithFrame:CGRectMake(0, -40, 320, 40)];
        [dateUL   setText:@" "];
        dateUL.textColor = [UIColor whiteColor];
        dateUL.textAlignment = NSTextAlignmentCenter;
        dateUL.backgroundColor = [UIColor clearColor];
        [datePicker addSubview:dateUL];
        [dateUL release];
        
        // [self valueChange:datePicker];
        
        //[self performSelector:@selector(valueChange:) withObject:datePicker afterDelay:.1f];
        
        
        chineseUL.text = [[chinesePV getDateArray]   objectAtIndex:1];
        
    }
    return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self dismissAnimate];
    
}


-(void)playAnimate{
    
    self.alpha = 1.f;
    
    [UIView animateWithDuration:.3f animations:^{
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        backView.frame = CGRectMake(0, 0, 320, TotalScreenHeight);
        
    }];
    
    
    
    
}



-(void)dismissAnimate{
    
    
    [UIView animateWithDuration:.6f animations:^{
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.0f];
        backView.frame = CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight);
         
    } completion:^(BOOL finished){ self.alpha = 0.f  ;}];
    

}


-(void)dateChanged:(NSDate *)Date andChineseDateString:(NSString *)ChineseDateString{
    

    [chineseUL   setText:ChineseDateString];
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(getDate:andDateString:)]) {
            
            NSMutableString *mutableString = [NSMutableString stringWithString:ChineseDateString];
            
            
            [delegate getDate:Date andDateString:[mutableString  stringByReplacingOccurrencesOfString:@" " withString:@""]  ];
             
        }
        
        
    }
    
    
    
    
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(dateView:dateChanged:andDateString:)]) {
            
            ;
            
            NSMutableString *mutableString = [NSMutableString stringWithString:ChineseDateString];
            
            
            [delegate  dateView:self dateChanged:Date andDateString:[mutableString  stringByReplacingOccurrencesOfString:@" " withString:@""]  ];
            
        }
        
        
    }
    
    
    
    
}


-(void)dateView:(XZWSelectDateView*)dateView dateChanged:(NSDate *)Date andChineseDateString:(NSString *)ChineseDateString{
    
    
    [chineseUL   setText:ChineseDateString];
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(dateView:dateChanged:andDateString:)]) {
            
            NSMutableString *mutableString = [NSMutableString stringWithString:ChineseDateString];
            
            
            [delegate  dateView:self dateChanged:Date andDateString:[mutableString  stringByReplacingOccurrencesOfString:@" " withString:@""]  ];
            
        }
        
        
    }
    
    
    
}




//-(void)dateChanged:(NSDate *)changedDate{
//    
//    
//    NSDate *selectedDate = changedDate;
//    
//    NSCalendar *gregorian = [NSCalendar  currentCalendar];
//    
//    
//    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
//    
//    NSDateComponents *comps = [gregorian components:unitFlags fromDate:selectedDate];
//    
//    int year = [comps year];
//    int month = [comps month];
//    int day = [comps day];
//    
//    [chineseUL setText: [NSString stringWithFormat:@"公历   %d 年 %d 月 %d 日",year,month,day]];
//}


-(void)showChineseZ{
    
    
    datePicker.hidden = true;
    chinesePV.hidden = false;
    
    chineseCalButton.selected = false;
    zodiacButton.selected = true;
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(getDate:andDateString:)]) {
            
            NSArray *dataArray = [chinesePV getDateArray]    ;
            
            [delegate getDate:[dataArray objectAtIndex:0] andDateString:[[dataArray objectAtIndex:1]  stringByReplacingOccurrencesOfString:@" " withString:@""] ];
            
        }
        
    }
    
    
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(dateView:dateChanged:andDateString:)]) {
            
            
            NSArray *dataArray = [chinesePV getDateArray]    ;
            
            [delegate  dateView:self dateChanged:[dataArray objectAtIndex:0] andDateString:[[dataArray objectAtIndex:1]  stringByReplacingOccurrencesOfString:@" " withString:@""]  ];
            
        }
        
        
    }
    
    
}

-(void)showZ{
    
    datePicker.hidden = false;
    chinesePV.hidden = true;
    
    chineseCalButton.selected = true;
    zodiacButton.selected = false;
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(getDate:andDateString:)]) {
            
            NSMutableString *mutableString = [NSMutableString stringWithString:dateUL.text];
            
            
            [delegate getDate:datePicker.date andDateString:[mutableString  stringByReplacingOccurrencesOfString:@" " withString:@""]  ];
            
        }
        
    }
    
    
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(dateView:dateChanged:andDateString:)]) {
            
             ;
            
            NSMutableString *mutableString = [NSMutableString stringWithString:dateUL.text];
            
            
            [delegate  dateView:self dateChanged:datePicker.date andDateString:[mutableString  stringByReplacingOccurrencesOfString:@" " withString:@""]  ];
            
        }
        
        
    }
    
    
    
    
}


-(void)valueChange:(UIDatePicker*)sender{
    
    
    NSDate *selectedDate = [datePicker  date]; 
    
    NSCalendar *gregorian = [NSCalendar  currentCalendar];
    
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
   
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:selectedDate];
    
    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    
    [dateUL setText: [NSString stringWithFormat:@"公历   %d 年 %d 月 %d 日",year,month,day]];
    
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(getDate:andDateString:)]) {
            
            NSMutableString *mutableString = [NSMutableString stringWithString:dateUL.text];
            
            
            [delegate getDate:selectedDate andDateString:[mutableString  stringByReplacingOccurrencesOfString:@" " withString:@""]  ];
            
        }
        
        
    }

    
    
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(dateView:dateChanged:andDateString:)]) {
            
            ;
            
            NSMutableString *mutableString = [NSMutableString stringWithString:dateUL.text];
            
            
            [delegate  dateView:self dateChanged:selectedDate andDateString:[mutableString  stringByReplacingOccurrencesOfString:@" " withString:@""]  ];
            
        }
        
        
    }
    
    
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
