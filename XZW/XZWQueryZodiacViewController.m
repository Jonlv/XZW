//
//  XZWQueryZodiacViewController.m
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWQueryZodiacViewController.h"
#import "XZWUtil.h"
#import "IIViewDeckController.h"
#import "JSONKit.h"
#import "XZWZodiacResultViewController.h"
#import "XZWZodiac.h"
#import "XZWZodiacData.h"


static const int XZWMoveViewTag = 1;

@interface XZWQueryZodiacViewController (){
    
    
    
    XZWSelectDateView *normalSDV;
    UILabel *dateUL;

    
    
    
    XZWSelectDateView *preciseSDV;
    UILabel *preciseDateUL;
    
    UIButton *daylightBtn;
    UILabel *bornUL;
    
    
    
    UIPickerView *timePickView;
    UIView *timeView;
    
    
    
    
    NSArray *cityArray;
    NSDictionary *citysDic;
    
    UIView *cityView;
    UIPickerView *cityPickView;
    
    UIButton *manualButton;

    
    
    UILabel *timeUL;
    UILabel *cityUL,*bornLocUL;
    
    NSDate *normalDate;
    NSDate *preciseDate;
      
}

@end

@implementation XZWQueryZodiacViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    
    [cityArray  release];
    [citysDic release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"星座查询";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    
    [self initData];
    
    [self initView];
    
}



#pragma mark -

-(void)viewWillAppear:(BOOL)animated{
    
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    
    
    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
    
    [super viewWillDisappear:animated];
}


#pragma mark -


#pragma mark -  init



-(void)initData{
    
    cityArray = [[NSArray alloc]  initWithObjects:@"北京",@"上海",@"天津",@"重庆",@"广东",@"浙江",@"山东",@"内蒙古",@"辽宁",@"山西",@"吉林",@"黑龙江",@"江苏",@"安徽",@"福建",@"江西",@"河北",@"河南",@"湖北",@"湖南",@"海南",@"广西",@"四川",@"贵州",@"云南",@"西藏",@"陕西",@"甘肃",@"青海",@"宁夏",@"新疆",@"港澳台", nil];
    
    citysDic = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle]  pathForResource:@"CityData" ofType:nil] encoding:NSUTF8StringEncoding error:nil] objectFromJSONString];
    [citysDic  retain];
    
    
    
}


-(void)initView{
    
    
    UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 10, 300, 127)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [self.view  addSubview:backgroundUIV];
    [backgroundUIV release];

    UILabel *birthdayUL =[[UILabel alloc]  initWithFrame:CGRectMake(20, 50, 200, 40)];
    birthdayUL.backgroundColor = [UIColor clearColor];
    birthdayUL.textColor = [UIColor grayColor];
    birthdayUL.text = @"出生日期:";
    [self.view addSubview:birthdayUL];
    [birthdayUL release];

    
    
    
    UILabel *normalQuery = [[UILabel alloc]  initWithFrame:CGRectMake(25, 15, 100, 40)];
    normalQuery.backgroundColor = [UIColor clearColor];
    normalQuery.textColor = [UIColor grayColor];
    [normalQuery setText:@"普通查询"];
    [self.view addSubview:normalQuery];
    [normalQuery release];
    
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
    [selectBtn  addTarget:self action:@selector(selectBtn) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.frame =  CGRectMake(95, 60, 204, 25);
    [self.view addSubview:selectBtn];
    
    UIImageView *arrowUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(185, 10, 12, 8)];
    [arrowUIV  setImage:[UIImage imageNamed:@"arrow"]];
    [selectBtn  addSubview:arrowUIV];
    [arrowUIV  release];

    
    dateUL = [[UILabel alloc]   initWithFrame:CGRectOffset(selectBtn.bounds, 10, 0)];
    dateUL.backgroundColor = [UIColor clearColor];
    dateUL.text = @"公历1980年1月1日";
    [selectBtn addSubview:dateUL];
    [dateUL release];
    
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"btn_inquiry"] forState:UIControlStateNormal];
    [selectBtn  addTarget:self action:@selector(queryNormal) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.frame =  CGRectMake(95, 96, 53, 25);
    [self.view addSubview:selectBtn];
    
    
    //////////////////
    
    backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 150, 300, 210)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [self.view  addSubview:backgroundUIV];
    [backgroundUIV release];
    
    
    UILabel *preciseUL = [[UILabel alloc]  initWithFrame:CGRectMake(20, 150, 100, 40)];
    preciseUL.text = @" 精准查询";
    preciseUL.backgroundColor = [UIColor clearColor];
    preciseUL.textColor = [UIColor grayColor];
    [self.view addSubview:preciseUL];
    [preciseUL release];
    
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
    [selectBtn  addTarget:self action:@selector(preciseSelectBtn) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.frame =  CGRectMake(95,  200, 204, 25);
    [self.view addSubview:selectBtn];
    
    arrowUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(185, 10, 12, 8)];
    [arrowUIV  setImage:[UIImage imageNamed:@"arrow"]];
    [selectBtn  addSubview:arrowUIV];
    [arrowUIV  release];
    
    
    preciseDateUL = [[UILabel alloc]   initWithFrame:CGRectOffset(selectBtn.bounds, 10, 0)];
    preciseDateUL.backgroundColor = [UIColor clearColor];
    preciseDateUL.text = @"公历1980年1月1日";
    [selectBtn addSubview:preciseDateUL];
    [preciseDateUL release];

     
    birthdayUL =[[UILabel alloc]  initWithFrame:CGRectMake(20, 190, 200, 40)];
    birthdayUL.backgroundColor = [UIColor clearColor];
    birthdayUL.textColor = [UIColor grayColor];
    birthdayUL.text = @"出生日期:";
    [self.view addSubview:birthdayUL];
    [birthdayUL release];
    
    
    
    UIButton *bornButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bornButton.frame = CGRectMake(95, 240, 141, 26);
    [bornButton setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
    [bornButton addTarget:self action:@selector(startToSelectTime) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bornButton];

    arrowUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(120, 10, 12, 8)];
    [arrowUIV  setImage:[UIImage imageNamed:@"arrow"]];
    [bornButton  addSubview:arrowUIV];
    [arrowUIV  release];

    
    
    
    UILabel *bornDateUL = [[UILabel alloc]   initWithFrame:CGRectMake(20, 230, 200, 40)];
    bornDateUL.backgroundColor = [UIColor clearColor]; 
    bornDateUL.textColor = [UIColor grayColor];
    bornDateUL.text = @"出生时间:";
    [self.view addSubview:bornDateUL];
    [bornDateUL release];
    
    
    bornUL =[[UILabel alloc]   initWithFrame: CGRectOffset(bornButton.bounds, 10, 0) ];
    bornUL.text = @"12:00";
    bornUL.backgroundColor = [UIColor clearColor];
    [bornButton addSubview:bornUL];
    [bornUL release];
    
    
    daylightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [daylightBtn addTarget:self action:@selector(selectDayLight) forControlEvents:UIControlEventTouchUpInside];
    [daylightBtn  setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
    [daylightBtn  setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
    [daylightBtn setFrame:CGRectMake(240, 242, 17, 17)];
    [self.view addSubview:daylightBtn];
    
    UILabel *daylightUL = [[UILabel alloc]  initWithFrame:CGRectMake(260, 230, 70, 40)];
    daylightUL.textColor = [UIColor grayColor];
    daylightUL.font = [UIFont systemFontOfSize:13];
    daylightUL.text = @"夏令时";
    daylightUL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:daylightUL];
    [daylightUL release];
    
    UILabel *bornLoc = [[UILabel alloc]  initWithFrame:CGRectMake(20, 270, 200, 40)];
    bornLoc.textColor = [UIColor grayColor];
    bornLoc.text = @"出生地点:";
    bornLoc.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bornLoc];
    [bornLoc release];
    

    
    UIButton *bornLocButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bornLocButton setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
    [bornLocButton  addTarget:self action:@selector(startToSelectCity) forControlEvents:UIControlEventTouchUpInside];
    bornLocButton.frame =  CGRectMake(95, 280, 204, 25);
    [self.view addSubview:bornLocButton];
    
    
    bornLocUL = [[UILabel alloc]   initWithFrame: CGRectOffset(bornLocButton.bounds, 10, 0) ];
    bornLocUL.text = @"北京 市区";
    bornLocUL.backgroundColor = [UIColor clearColor];
    [bornLocButton addSubview:bornLocUL];
    [bornLocUL release];
    
    
    arrowUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(185, 10, 12, 8)];
    [arrowUIV  setImage:[UIImage imageNamed:@"arrow"]];
    [bornLocButton  addSubview:arrowUIV];
    [arrowUIV  release];
    
    
    
    selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setImage:[UIImage imageNamed:@"btn_inquiry"] forState:UIControlStateNormal];
    [selectBtn  addTarget:self action:@selector(query) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.frame =  CGRectMake(95, 316, 53, 25);
    [self.view addSubview:selectBtn];
    
    
    ///
    
    
    
    
    timeView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
    timeView.alpha = 0.f;
    timeView.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
    [self.view addSubview:timeView];
    [timeView  release];
    
    
    
    
    
    UIView *moveView = [[UIView alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight , 320, TotalScreenHeight)];
    moveView.tag = XZWMoveViewTag ;
    moveView.backgroundColor = [UIColor colorWithHex:0x464d5b alpha:.8f];
    [timeView addSubview:moveView];
    [moveView release];
    
    UIImageView *toolBarUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"cledertop"]];
    toolBarUIV.frame = CGRectMake(0, 0, 320, 44);
    [moveView addSubview:toolBarUIV];
    [toolBarUIV release];
    
    UILabel *tipUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 0, 320, 44)];
    tipUL.backgroundColor = [UIColor clearColor];
    tipUL.textColor = [UIColor whiteColor];
    tipUL.text = @"选择时间";
    [toolBarUIV addSubview:tipUL];
    [tipUL release];
    
    timeUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 44, 320, 44)];
    timeUL.backgroundColor = [UIColor clearColor];
    timeUL.textColor = [UIColor whiteColor];
    timeUL.text = @"出生时间    12:00";
    timeUL.textAlignment = UITextAlignmentCenter;
    [toolBarUIV addSubview:timeUL];
    [timeUL release];
    
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(0, 0, 320, TotalScreenHeight - 300);
    [dismissButton addTarget:self
                      action:@selector(endSelectTime) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:dismissButton];
    
    
    timePickView = [[UIPickerView alloc]  initWithFrame:CGRectMake(0, 88, 320, 230)];
    timePickView.showsSelectionIndicator = true;
    timePickView.delegate = self;
    timePickView.dataSource = self;
    [moveView addSubview:timePickView];
    [timePickView release];
    
    [timePickView  selectRow:12 inComponent:0 animated:false];
    
    
    
    
    
    cityView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
    cityView.alpha = 0.f;
    cityView.backgroundColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
    [self.view addSubview:cityView];
    [cityView  release];
    
    moveView = [[UIView alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight  , 320, TotalScreenHeight)];
    moveView.tag = XZWMoveViewTag ;
    moveView.backgroundColor = [UIColor colorWithHex:0x464d5b alpha:.8f];
    [cityView addSubview:moveView];
    [moveView release];
    
    toolBarUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"cledertop"]];
    toolBarUIV.frame = CGRectMake(0, 0, 320, 44);
    [moveView addSubview:toolBarUIV];
    [toolBarUIV release];
    
    tipUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 0, 320, 44)];
    tipUL.backgroundColor = [UIColor clearColor];
    tipUL.textColor = [UIColor whiteColor];
    tipUL.text = @"选择城市";
    [toolBarUIV addSubview:tipUL];
    [tipUL release];
    
    cityUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 44, 320, 44)];
    cityUL.backgroundColor = [UIColor clearColor];
    cityUL.textColor = [UIColor whiteColor];
    cityUL.text = @"出生城市    北京 市区";
    cityUL.textAlignment = UITextAlignmentCenter;
    [toolBarUIV addSubview:cityUL];
    [cityUL release];
    
    
    
    dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = CGRectMake(0, 0, 320, TotalScreenHeight - 300);
    [dismissButton addTarget:self
                      action:@selector(endSelectCity) forControlEvents:UIControlEventTouchUpInside];
    [cityView addSubview:dismissButton];
    
    
    
    cityPickView = [[UIPickerView alloc]  initWithFrame:CGRectMake(0, 88, 320, 230)];
    cityPickView.showsSelectionIndicator = true;
    cityPickView.delegate = self;
    cityPickView.dataSource = self;
    [moveView addSubview:cityPickView];
    [cityPickView release];
    

    
    
    
    ////
    
    
    
    normalSDV = [[XZWSelectDateView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
    normalSDV.delegate = self;
    normalSDV.alpha = 0.f;
    [self.view addSubview:normalSDV];
    [normalSDV release];
    
    
    
    preciseSDV = [[XZWSelectDateView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
    preciseSDV.delegate = self;
    preciseSDV.alpha = 0.f;
    [self.view addSubview:preciseSDV];
    [preciseSDV release];


    
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    

}



#pragma mark - 


-(void)query{
    
    
    NSCalendar *gregorian = [NSCalendar  currentCalendar];
    
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:preciseDate];
    
    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    

    
    NSArray *cityData = [[citysDic objectForKey:[cityArray objectAtIndex:[cityPickView selectedRowInComponent:0]]]  objectForKey:[[[citysDic objectForKey:[cityArray objectAtIndex:[cityPickView selectedRowInComponent:0]]] allKeys  ] objectAtIndex:[cityPickView selectedRowInComponent:1]]];

    double latitude = [[cityData objectAtIndex:1]  doubleValue];
    double longitude = [[cityData objectAtIndex:0]  doubleValue];
    
    
   double timezone = 8 ;
    
    XZWZodiac *xzwZodiac = [[[XZWZodiac alloc]  init] autorelease];
    [xzwZodiac setYear:year month:month day:day hour:[timePickView selectedRowInComponent:0]  minute:[timePickView selectedRowInComponent:1]  daylight:daylight timezone:timezone longitude:longitude latitude:latitude am:1.f sml:1.f];
  
    
    NSArray *planet = [xzwZodiac getPlanet];
    
    XZWZodiacResultViewController *resultVC = [[XZWZodiacResultViewController alloc]  initWithSunIndex:[XZWZodiacData zodiacIndex:[planet[0]  doubleValue]] upIndex:[XZWZodiacData zodiacIndex:[planet[10]  doubleValue]] wholeString:[NSString stringWithFormat:@"%@ %@ %@",preciseDateUL.text,bornUL.text,bornLocUL.text]];
    [self.navigationController pushViewController:resultVC animated:true];
    [resultVC release];
    
     
}

-(void)queryNormal{
    
    
    
    NSCalendar *gregorian = [NSCalendar  currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:normalDate];
    
    int month = [comps month];
    int day = [comps day];

    
    XZWZodiacResultViewController *resultVC = [[XZWZodiacResultViewController alloc]  initWithDateString:[NSString stringWithFormat:@"%02d%02d",month,day] wholeString:dateUL.text];
    [self.navigationController pushViewController:resultVC animated:true];
    [resultVC release];
    
}

-(void)toggleView{
    
    
    [self.navigationController.viewDeckController  toggleLeftViewAnimated:true];
}

-(void)selectDayLight{
    
    daylightBtn.selected = !daylightBtn.selected;
    
}

-(void)selectBtn{
     
    [normalSDV playAnimate]; 
}


-(void)preciseSelectBtn{
    
    [preciseSDV playAnimate];
}


-(void)startToSelectCity{
    
    [self endSelectTime];
    
    [self.view endEditing:true];
    
    [UIView animateWithDuration:.3f animations:^{   cityView.alpha = 1.f;  [cityView viewWithTag:XZWMoveViewTag].frame = CGRectMake(0, TotalScreenHeight - 280 - 88,320, 320); }];
    
    
    
}

-(void)endSelectCity{
    
    [self.view endEditing:true];
    
    [UIView animateWithDuration:.3f animations:^{   cityView.alpha = 0.f; [cityView viewWithTag:XZWMoveViewTag].frame = CGRectMake(0, TotalScreenHeight ,320, 320); }];
}





-(void)startToSelectTime{
    
    [self endSelectCity];
    
    [self.view endEditing:true];
    
    [UIView animateWithDuration:.3f animations:^{   timeView.alpha = 1.f; [timeView viewWithTag:XZWMoveViewTag].frame = CGRectMake(0, TotalScreenHeight - 280 - 88 ,320, TotalScreenHeight); }];
    
}


-(void)endSelectTime{
    
    [self.view endEditing:true];
    
    [UIView animateWithDuration:.3f animations:^{  timeView.alpha = 0.f;  [timeView viewWithTag:XZWMoveViewTag].frame = CGRectMake(0, TotalScreenHeight ,320, TotalScreenHeight); }];
    
}




#pragma mark - 


-(void)dateView:(XZWSelectDateView *)dateView dateChanged:(NSDate *)date andDateString:(NSString *)dateString{
     
    
    if (dateView == normalSDV) {
        
        
        dateUL.text = dateString;
        
        
        if (normalDate) {
            [normalDate release];
            normalDate = nil;
        }
        
        normalDate = date;
        [normalDate  retain];
        
        
    }else {
        
        preciseDateUL.text = dateString;
        
        if (preciseDate) {
            [preciseDate release];
            preciseDate = nil;
        }
        
        preciseDate = date;
        [preciseDate  retain];
        
        
    }
    
    
}


#pragma mark -  pickerview delegate & datasource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* tView = (UILabel*)view;
    if (!tView){
        
        tView = [[[UILabel alloc] initWithFrame:CGRectMake(10,0,100,40)]  autorelease];
        // Setup label properties - frame, font, colors etc
        
        tView.backgroundColor = [UIColor clearColor];
        
        tView.font = [UIFont boldSystemFontOfSize:25];
        tView.textAlignment = NSTextAlignmentCenter;
        
    }
    
    
    if (cityPickView == pickerView) {
        
        
        if (component == 0 ) {
            
            tView.text = [NSString stringWithFormat:@"%@",  [cityArray objectAtIndex:row]]  ;
            
        }else {
            
            
            @try {
                tView.text = [NSString stringWithFormat:@"%@",  [[[citysDic objectForKey:[cityArray objectAtIndex:[pickerView selectedRowInComponent:0]]] allKeys  ] objectAtIndex:row] ] ;
                
            }
            @catch (NSException *exception) {
                
                tView.text = @"" ;
                
            }
            @finally {
                
            }
            
        }
        
    }else {
        
        
        
        
        if (component == 0) {
            
            tView.text = [NSString stringWithFormat:@"%d时",  row]  ;
            
        } else if (component == 1) {
            
            tView.text = [NSString stringWithFormat:@"%d分", row] ;
            
            
        }else {
            
            
        }
        
        
    }
    
    
    // Fill the label text here
    return tView;
}


#pragma mark -


-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    
    CGFloat width = 0.f;
    
    
    
    
    if (pickerView == cityPickView) {
        
        switch (component) {
            case 0:
            {
                width = 98.f;
            }
                break;
            case 1:{
                width = 158.f;
            }
                
                break;
            default:
            {
                width = 75.f;
            }
                break;
        }
        
        
    }else {
        
        switch (component) {
            case 0:
            {
                width = 98.f;
            }
                break;
            case 1:{
                width = 98.f;
            }
                
                break;
            default:
            {
                width = 75.f;
            }
                break;
        }
        
    }
    
    return  width ;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    int totalNum = 0;
    
    
    if (pickerView == cityPickView) {
        
        
        
        switch (component) {
            case 0:
            {
                totalNum = [cityArray count];
            }
                break;
                
            default:
            {
                totalNum = [[[citysDic objectForKey:[cityArray objectAtIndex:[pickerView selectedRowInComponent:0]]]  allKeys]  count];
            }
                break;
        }
        
        
    }else {
        
        switch (component) {
            case 0:
            {
                totalNum = 24;
            }
                break;
                
            default:
            {
                totalNum = 60;
            }
                break;
        }
        
    }
    
    return totalNum;
    
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    
    if (pickerView == cityPickView) {
        
        
        if (component == 0) {
            
            [cityPickView reloadAllComponents];
            
        }else if (component == 1) {
            
            
            
        }else {
            
            
            
        }
        
        
        @try {
            bornLocUL.text = [NSString stringWithFormat:@"%@ %@",[cityArray objectAtIndex:[pickerView selectedRowInComponent:0]] , [[[citysDic objectForKey:[cityArray objectAtIndex:[pickerView selectedRowInComponent:0]]] allKeys  ] objectAtIndex:[pickerView selectedRowInComponent:1]] ] ;
            
        }
        @catch (NSException *exception) {
            
            bornLocUL.text =@"";
            
            
            
        }
        @finally {
            
        }
        
        
        cityUL.text =  [@"出生城市    "   stringByAppendingString:bornLocUL.text];
        
    }else {
        
        bornUL.text = [NSString stringWithFormat:@"%02d:%02d",[pickerView selectedRowInComponent:0],[pickerView selectedRowInComponent:1]];
        
        timeUL.text = [@"出生时间    "   stringByAppendingString:bornUL.text]  ;
        
    }
    
    
    
    
    
    
}






 


#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
