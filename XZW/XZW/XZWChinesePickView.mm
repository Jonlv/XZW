//
//  XZWChinesePickView.m
//  XZW
//
//  Created by Dee on 13-8-20.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWChinesePickView.h"

#import "IDJCalendarUtil.h"
#import "ChineseCalendarDB.h"


static const int XZWMinYear = 1901;
static  int XZWMaxYear = 2050;

@implementation XZWChinesePickView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        NSCalendar *gregorian = [NSCalendar  currentCalendar];
        
        
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:[NSDate date]];
        
        int year = [comps year];
        
        XZWMaxYear = 2050 > year ? year : 2050;
        
        datePickView = [[UIPickerView alloc] initWithFrame:self.bounds];
        datePickView.showsSelectionIndicator = true;
        [self addSubview:datePickView];
        datePickView.delegate = self;
        datePickView.dataSource = self;
        [datePickView release];
        
        [datePickView  selectRow:79 inComponent:0 animated:false];
        
        /*
        
        NSCalendar *gregorian = [NSCalendar  currentCalendar];
        
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
        NSDate *date = [NSDate date];
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];
        
        int year = [comps year];
        int month = [comps month];
        int day = [comps day];
        
        // 1901
        
        
        NSDateComponents *theChineseComponents =  [IDJCalendarUtil  toChineseDateWithYear:year month:[NSString stringWithFormat:@"%d",month] day:day];
        
        
        [datePickView  selectRow:[theChineseComponents year] - XZWMinYear  inComponent:0 animated:false];
        
        [datePickView reloadComponent:1];
        
        [datePickView  selectRow: [theChineseComponents month] - 1  inComponent:1 animated:false];
        
        [datePickView reloadComponent:2];
        
        [datePickView  selectRow:[theChineseComponents day] - 1  inComponent:2 animated:false];
         */
        
    }
    return self;
}
#pragma mark - 

-(NSArray*)getDateArray{
    
    
     
        
        
        NSString *monthString = nil;
        
        {
            
            if (luarMonth != 0) {
                
                if ([datePickView selectedRowInComponent:1]  ==  luarMonth ) {
                    
                    
                    monthString =  [NSString stringWithFormat:@"闰%d 月",  [datePickView selectedRowInComponent:1]] ;
                    
                }else if  ([datePickView selectedRowInComponent:1] + 1 <=  luarMonth ){
                    
                    
                    
                    
                    monthString =  [NSString stringWithFormat:@"%d 月", 1 +[datePickView selectedRowInComponent:1]] ;
                }else {
                    
                    
                    monthString = [NSString stringWithFormat:@"%d 月",  [datePickView selectedRowInComponent:1]] ;
                }
                
                
                
            }else {
                
                
                
                monthString = [NSString stringWithFormat:@"%d 月", 1 +[datePickView selectedRowInComponent:1]] ;
            }
            
        }
    
    NSCalendar *gregorian = [[[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
     
    
    NSDateComponents *dateComponents= [IDJCalendarUtil toSolarDateWithYear:XZWMinYear + [datePickView selectedRowInComponent:0] month:[IDJCalendarUtil monthFromCppToMineWithYear:XZWMinYear + [datePickView selectedRowInComponent:0] month:[datePickView selectedRowInComponent:1] +1 ] day:[datePickView selectedRowInComponent:2] + 1 ];
    
    [dateComponents setCalendar:gregorian];
     
         
    
    return [NSArray arrayWithObjects:[dateComponents date],[NSString stringWithFormat:@"农历   %d 年 %@ %d 日",XZWMinYear + [datePickView selectedRowInComponent:0],monthString, [datePickView selectedRowInComponent:2] + 1], nil];
}

#pragma mark -

-(void)getDate{
    
    
    NSLog(@"year %d month %d day %d",XZWMinYear + [datePickView selectedRowInComponent:0], [datePickView selectedRowInComponent:1] , [datePickView selectedRowInComponent:2]);
    
    
    
    
    NSLog(@"component %@ ",[IDJCalendarUtil toSolarDateWithYear:XZWMinYear + [datePickView selectedRowInComponent:0] month:[IDJCalendarUtil monthFromCppToMineWithYear:XZWMinYear + [datePickView selectedRowInComponent:0] month:[datePickView selectedRowInComponent:1] +1 ] day:[datePickView selectedRowInComponent:2] + 1 ]);
    
}




     



#pragma mark - PickerView delegate 

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    if (component == 0) {
        
        return   [NSString stringWithFormat:@"%d年",XZWMinYear  +row]  ;
        
    } else if (component == 1) {
        
        if (luarMonth != 0) {
            
            if (row  ==  luarMonth ) {
                
                
                return [NSString stringWithFormat:@"闰%d月",  row] ;
                
            }else if  (row + 1 <=  luarMonth ){
                
                
                
                
                return [NSString stringWithFormat:@"%d月", 1 +row] ;
            }else {
                
                
                return [NSString stringWithFormat:@"%d月",  row] ;
            }
            
            
            
        }else {
            
            
            
            return [NSString stringWithFormat:@"%d月", 1 +row] ;
        }
        
    } else {
        
        
        
        return [NSString stringWithFormat:@"%d日", 1 +row] ;
        
    }
    
    
     
}

#pragma mark - 

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        
        tView = [[[UILabel alloc] initWithFrame:CGRectMake(10,0,100,40)]  autorelease];
        // Setup label properties - frame, font, colors etc
      
        tView.backgroundColor = [UIColor clearColor];

        tView.font = [UIFont boldSystemFontOfSize:25];
        tView.textAlignment = NSTextAlignmentCenter;
        
    }
    
        if (component == 0) {
            
            tView.text = [NSString stringWithFormat:@"%d年",XZWMinYear  +row]  ;
            
        } else if (component == 1) {
            
            if (luarMonth != 0) {
                
                if (row  ==  luarMonth ) {
                    
                    
                    tView.text =  [NSString stringWithFormat:@"闰%d月",  row] ;
                    
                }else if  (row + 1 <=  luarMonth ){
                    
                    
                    
                    
                    tView.text =  [NSString stringWithFormat:@"%d月", 1 +row] ;
                }else {
                    
                    
                    tView.text = [NSString stringWithFormat:@"%d月",  row] ;
                }
                
                
                
            }else {
                
                
                
                tView.text = [NSString stringWithFormat:@"%d月", 1 +row] ;
            }
            
        } else {
            
            
            
            tView.text = [NSString stringWithFormat:@"%d日", 1 +row] ;
            
        }
        
    // Fill the label text here 
    return tView;
}


#pragma mark -


-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    
    CGFloat width = 0.f;
    
    switch (component) {
        case 0:
        {
            width = 98.f;
        }
            break;
        case 1:{
            width = 70.f;
        }
            
            break;
        default:
        {
            width = 75.f;
        }
            break;
    }
    
    return  width ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    if (component == 0) {
        
        return XZWMaxYear - XZWMinYear + 1;
        
    } else if (component == 1) {
        
       
        return ChineseCalendarDB::GetYearMonths(XZWMinYear +  [pickerView selectedRowInComponent:0]); 
        
    } else {
        
        return ChineseCalendarDB::GetMonthDays((XZWMinYear +  [pickerView selectedRowInComponent:0]), [pickerView selectedRowInComponent:1] + 1)  ;
        
    }
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    
    return 3;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if (component == 0) {
         
        luarMonth =  ChineseCalendarDB::GetLeapMonth(XZWMinYear +  [pickerView selectedRowInComponent:0]);
         
        [pickerView reloadComponent:1];
        
        
        [pickerView reloadComponent:2];
        
    }else if (component == 1) {
        
        
        [pickerView reloadComponent:2];
        
    }else {
          
        
    }
    
    
    if (delegate) {
        
         
        if ([delegate  respondsToSelector:@selector(dateChanged:)]) {
            
            [delegate dateChanged:  nil ];
            
        }
        
        
        if ([delegate respondsToSelector:@selector(dateChanged:andChineseDateString:)]) {
            
            
            NSString *monthString = nil;
            
            {
                
                if (luarMonth != 0) {
                    
                    if ([datePickView selectedRowInComponent:1]  ==  luarMonth ) {
                        
                        
                        monthString =  [NSString stringWithFormat:@"闰%d 月",  [datePickView selectedRowInComponent:1]] ;
                        
                    }else if  ([datePickView selectedRowInComponent:1] + 1 <=  luarMonth ){
                        
                        
                        
                        
                        monthString =  [NSString stringWithFormat:@"%d 月", 1 +[datePickView selectedRowInComponent:1]] ;
                    }else {
                        
                        
                        monthString = [NSString stringWithFormat:@"%d 月",  [datePickView selectedRowInComponent:1]] ;
                    }
                    
                    
                    
                }else {
                    
                    
                    
                    monthString = [NSString stringWithFormat:@"%d 月", 1 +[datePickView selectedRowInComponent:1]] ;
                }
                
            }
            
             
            
            [delegate dateChanged: [[IDJCalendarUtil toSolarDateWithYear:XZWMinYear + [datePickView selectedRowInComponent:0] month:[IDJCalendarUtil monthFromCppToMineWithYear:XZWMinYear + [datePickView selectedRowInComponent:0] month:[datePickView selectedRowInComponent:1] +1 ] day:[datePickView selectedRowInComponent:2] + 1 ] date ] andChineseDateString:
             [NSString stringWithFormat:@"农历   %d 年 %@ %d 日",XZWMinYear + [datePickView selectedRowInComponent:0],monthString, [datePickView selectedRowInComponent:2] + 1]  ];
      
            
            
            
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
