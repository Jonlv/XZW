//
//  XZWAstrolabeViewController.m
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAstrolabeViewController.h"
#import "XZWUtil.h"
#import "JSONKit.h"

#import "IIViewDeckController.h"
#import "XZWZodiac.h"
#import "XZWAstrolabeResultViewController.h"

#import "XZWSavedAstrolabeViewController.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

static const int XZWMoveViewTag = 1;

@interface XZWAstrolabeViewController () <UIScrollViewDelegate> {
	UIScrollView *mainUSV;


	UITextField *nickNameUTF;



	UILabel *dateUL;

	XZWSelectDateView *xzwSDV;

	//  UIButton *daylightBtn;
	UILabel *bornUL;


	UILabel *bornLocUL;

	// UIButton *showAscButton;
	UIButton *lowTButton, *normalTButton, *highTButton;


	UIPickerView *timePickView;
	UIView *timeView;



	NSArray *cityArray;
	NSDictionary *citysDic;

	UIView *cityView;
	UIPickerView *cityPickView;

	UIButton *manualButton;


	UILabel *timeUL;
	UILabel *cityUL;


	UITextField *longUTF;
	UITextField *latUTF;

	UITextField *timezoneUTF;


	NSDate *bornDate;


	UITapGestureRecognizer *tapGest;
}

@end

@implementation XZWAstrolabeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.title = @"星盘占卜";

	mainUSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64)];
	mainUSV.showsHorizontalScrollIndicator = mainUSV.showsVerticalScrollIndicator = false;
	//mainUSV.delegate = self;
	[self.view addSubview:mainUSV];
	[mainUSV release];


	tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endViewEdit)];
	[mainUSV addGestureRecognizer:tapGest];
	[tapGest release];

	tapGest.enabled = false;

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	[self initData];
	[self initView];
}

- (void)dealloc {
	[cityArray   release];

	if (bornDate) {
		[bornDate  release];
		bornDate = nil;
	}

	[super dealloc];
}

#pragma mark -


- (void)bornTime {
}

- (void)selectBtn {
	[self.view endEditing:true];
	[xzwSDV playAnimate];
	[self endSelectTime];
}

- (void)selectDayLight {
	daylightBtn.selected = !daylightBtn.selected;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)endViewEdit {
	[self.view endEditing:true];


	[UIView animateWithDuration:.3f animations: ^{
	    [mainUSV setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	}];



	tapGest.enabled = false;
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//
//    [self endSelectTime];
//    [self.view endEditing:true];
//
//    [mainUSV  setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];;
//   // [UIView animateWithDuration:.3f animations:^{
//    //    [mainUSV  setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];}];
//
//}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)calAbstrolabe {
	[self.view endEditing:true];


	[UIView animateWithDuration:.3f animations: ^{
	    [mainUSV setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	}];


	if ([nickNameUTF.text length] <= 0) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"请输入您的昵称" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease] show];


		return;
	}



	double latitude, longitude, daylight, timezone, showAsc, sml = 0.f;


	BOOL rightPosition = false;

	if (manualButton.selected) {
		if ([latUTF.text length] > 0 && [longUTF.text length] > 0 && [timezoneUTF.text length] > 0) {
			if (([latUTF.text doubleValue] <= 90 && [latUTF.text doubleValue] >= -90) && ([longUTF.text doubleValue]  <=  180  && [longUTF.text doubleValue]  >=  -180) && ([timezoneUTF.text doubleValue]  <=  12  && [timezoneUTF.text doubleValue]  >=  -12)) {
				latitude = [latUTF.text doubleValue];
				longitude = [longUTF.text doubleValue];
				timezone = [timezoneUTF.text doubleValue];

				rightPosition = true;
			}
		}
	}


	NSArray *cityData = [[citysDic objectForKey:[cityArray objectAtIndex:[cityPickView selectedRowInComponent:0]]] objectForKey:[[[citysDic objectForKey:[cityArray objectAtIndex:[cityPickView selectedRowInComponent:0]]] allKeys] objectAtIndex:[cityPickView selectedRowInComponent:1]]];

	if (!rightPosition) {
		latitude = [[cityData objectAtIndex:1]  doubleValue];
		longitude = [[cityData objectAtIndex:0]  doubleValue];


		timezone = 8;
	}



	int i = [[cityData objectAtIndex:3]  intValue];

	NSString *time = [cityData objectAtIndex:2];

	NSString *timeDelta = nil;

	if (i == -1) {
		timeDelta = [NSString stringWithFormat:@"(时差-%@)", time];
	}
	else {
		timeDelta = [NSString stringWithFormat:@"(时差%@)", time];
	}


	if (showAscButton.selected) {
		showAsc = 1.f;
	}
	if (daylightBtn.selected) {
		daylight = 1.f;
	}




	if (lowTButton.selected) {
		sml = 0;
	}
	else if (normalTButton.selected) {
		sml = 1;
	}
	else {
		sml = 2;
	}




	NSCalendar *gregorian = [NSCalendar  currentCalendar];


	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

	NSDateComponents *comps = [gregorian components:unitFlags fromDate:bornDate];

	int year = [comps year];
	int month = [comps month];
	int day = [comps day];


	XZWZodiac *xzwZodiac = [[[XZWZodiac alloc] init] autorelease];
	[xzwZodiac setYear:year month:month day:day hour:[timePickView selectedRowInComponent:0]  minute:[timePickView selectedRowInComponent:1] daylight:daylight timezone:timezone longitude:longitude latitude:latitude am:showAsc sml:sml];

	XZWAstrolabeResultViewController *xzwResult = [[XZWAstrolabeResultViewController alloc] initZodiac:xzwZodiac andName:nickNameUTF.text andBirthday:[NSString stringWithFormat:@" %@%d时%d分", dateUL.text, [timePickView selectedRowInComponent:0], [timePickView selectedRowInComponent:1]] birthLoc:[bornLocUL.text stringByReplacingOccurrencesOfString:@" " withString:@" ,"]     birthPosi:[NSString stringWithFormat:@" %g,%g", longitude, latitude] timeZone:[NSString stringWithFormat:@" %d%@", (int)timezone, timeDelta]];

	xzwResult.savedArray = @[nickNameUTF.text, [NSNumber numberWithInt:year], [NSNumber numberWithInt:month], [NSNumber numberWithInt:day], [NSNumber numberWithInt:[timePickView selectedRowInComponent:0]], [NSNumber numberWithInt:[timePickView selectedRowInComponent:1]], [NSNumber numberWithDouble:daylight], [NSNumber numberWithInt:timezone], [NSNumber numberWithDouble:longitude], [NSNumber numberWithDouble:latitude], [NSNumber numberWithInt:showAsc],  [NSNumber numberWithInt:sml]];
	[self.navigationController pushViewController:xzwResult animated:true];
	[xzwResult  release];



    //
    //    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    //
    //    [queue inDatabase:^(FMDatabase *db) {
    //
    //        NSString *dbString = [NSString stringWithFormat:@"insert into User (name , year , month , day , hour , minute , daylight , timezone , longitude , latitude , am , sml ,birthday  ,locString ,timezoneString ) values ('%@','%d','%d','%d','%d','%d','%f','%f','%f','%f','%f','%f','%@','%@','%@');",nickNameUTF.text,year,month,day, [timePickView selectedRowInComponent:0],[timePickView selectedRowInComponent:1], daylight,timezone,longitude,latitude,showAsc,sml,[NSString stringWithFormat:@" %@%d时%d分",dateUL.text, [timePickView selectedRowInComponent:0] ,[timePickView selectedRowInComponent:1]] ,[bornLocUL.text  stringByReplacingOccurrencesOfString:@" " withString:@" ,"],[NSString stringWithFormat:@" %d%@",(int)timezone,timeDelta ] ];
    //
    //
    //        [db executeUpdate:dbString];
    //
    //    }];
}

#pragma mark -  init

- (void)initData {
	cityArray = [[NSArray alloc] initWithObjects:@"北京", @"上海", @"天津", @"重庆", @"广东", @"浙江", @"山东", @"内蒙古", @"辽宁", @"山西", @"吉林", @"黑龙江", @"江苏", @"安徽", @"福建", @"江西", @"河北", @"河南", @"湖北", @"湖南", @"海南", @"广西", @"四川", @"贵州", @"云南", @"西藏", @"陕西", @"甘肃", @"青海", @"宁夏", @"新疆", @"港澳台", nil];

	citysDic = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData" ofType:nil] encoding:NSUTF8StringEncoding error:nil] objectFromJSONString];
	[citysDic retain];
}

- (void)initView {
	// self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	UIImageView *backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 230)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[mainUSV addSubview:backgroundUIV];
	[backgroundUIV release];


	UILabel *nicknameUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 40)];
	nicknameUL.backgroundColor = [UIColor clearColor];
	nicknameUL.textColor = [UIColor grayColor];
	[nicknameUL setText:@"昵       称:"];
	[mainUSV addSubview:nicknameUL];
	[nicknameUL release];

	UIImageView *inputUIV = [[UIImageView alloc] initWithFrame:CGRectMake(95, 25, 204, 26)];
	inputUIV.image = [UIImage imageNamed:@"biginput"];
	[mainUSV addSubview:inputUIV];
	[inputUIV release];

	nickNameUTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 27, 190, 22)];
	nickNameUTF.text = @"";
	nickNameUTF.returnKeyType = UIReturnKeyDone;
	nickNameUTF.delegate = self;
	nickNameUTF.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:nickNameUTF];
	[nickNameUTF release];

	UILabel *birthdayUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 200, 40)];
	birthdayUL.backgroundColor = [UIColor clearColor];
	birthdayUL.textColor = [UIColor grayColor];
	birthdayUL.text = @"出生日期:";
	[mainUSV addSubview:birthdayUL];
	[birthdayUL release];

	UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[selectBtn setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
	[selectBtn addTarget:self action:@selector(selectBtn) forControlEvents:UIControlEventTouchUpInside];
	selectBtn.frame =  CGRectMake(95, 60, 204, 25);
	[mainUSV addSubview:selectBtn];

	UIImageView *arrowUIV = [[UIImageView alloc] initWithFrame:CGRectMake(185, 10, 12, 8)];
	[arrowUIV setImage:[UIImage imageNamed:@"arrow"]];
	[selectBtn addSubview:arrowUIV];
	[arrowUIV  release];

	dateUL = [[UILabel alloc] initWithFrame:CGRectOffset(selectBtn.bounds, 10, 0)];
	dateUL.backgroundColor = [UIColor clearColor];
	dateUL.text = @"公历1980年1月1日";
	[selectBtn addSubview:dateUL];
	[dateUL release];


	xzwSDV = [[XZWSelectDateView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	xzwSDV.delegate = self;
	xzwSDV.alpha = 0.f;
	[self.view addSubview:xzwSDV];
	[xzwSDV release];

	UILabel *birthdayTimeUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 200, 40)];
	birthdayTimeUL.backgroundColor = [UIColor clearColor];
	birthdayTimeUL.textColor = [UIColor grayColor];
	birthdayTimeUL.text = @"出生时间:";
	[mainUSV addSubview:birthdayTimeUL];
	[birthdayTimeUL release];


	UIButton *bornButton = [UIButton buttonWithType:UIButtonTypeCustom];
	bornButton.frame = CGRectMake(95, 95, 141, 26);
	[bornButton setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
	[bornButton addTarget:self action:@selector(startToSelectTime) forControlEvents:UIControlEventTouchUpInside];
	[mainUSV addSubview:bornButton];

	arrowUIV = [[UIImageView alloc] initWithFrame:CGRectMake(120, 8, 12, 8)];
	[arrowUIV setImage:[UIImage imageNamed:@"arrow"]];
	[bornButton addSubview:arrowUIV];
	[arrowUIV  release];

	bornUL = [[UILabel alloc] initWithFrame:CGRectOffset(bornButton.bounds, 10, 0)];
	bornUL.text = @"12:00";
	bornUL.backgroundColor = [UIColor clearColor];
	[bornButton addSubview:bornUL];
	[bornUL release];


	UILabel *daylightUL = [[UILabel alloc] initWithFrame:CGRectMake(260, 88, 70, 40)];
	daylightUL.textColor = [UIColor grayColor];
	daylightUL.font = [UIFont systemFontOfSize:13];
	daylightUL.text = @"夏令时";
	daylightUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:daylightUL];
	[daylightUL release];

	UILabel *bornLoc = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 200, 40)];
	bornLoc.textColor = [UIColor grayColor];
	bornLoc.text = @"出生地点:";
	bornLoc.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:bornLoc];
	[bornLoc release];


	UIButton *bornLocButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[bornLocButton setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
	[bornLocButton addTarget:self action:@selector(startToSelectCity) forControlEvents:UIControlEventTouchUpInside];
	bornLocButton.frame =  CGRectMake(95, 130, 204, 25);
	[mainUSV addSubview:bornLocButton];


	bornLocUL = [[UILabel alloc] initWithFrame:CGRectOffset(bornLocButton.bounds, 10, 0)];
	bornLocUL.text = @"北京 市区";
	bornLocUL.backgroundColor = [UIColor clearColor];
	[bornLocButton addSubview:bornLocUL];
	[bornLocUL release];


	arrowUIV = [[UIImageView alloc] initWithFrame:CGRectMake(185, 10, 12, 8)];
	[arrowUIV setImage:[UIImage imageNamed:@"arrow"]];
	[bornLocButton addSubview:arrowUIV];
	[arrowUIV  release];



	daylightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[daylightBtn addTarget:self action:@selector(selectDayLight) forControlEvents:UIControlEventTouchUpInside];
	[daylightBtn setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
	[daylightBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
	[daylightBtn setFrame:CGRectMake(240, 100, 17, 17)];
	[mainUSV addSubview:daylightBtn];



	showAscButton  = [UIButton buttonWithType:UIButtonTypeCustom];
	[showAscButton addTarget:self action:@selector(showAsc) forControlEvents:UIControlEventTouchUpInside];
	[showAscButton setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
	[showAscButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
	[showAscButton setFrame:CGRectMake(90, 165, 17, 17)];
	[mainUSV addSubview:showAscButton];


	UILabel *showAscUL = [[UILabel alloc] initWithFrame:CGRectMake(112, 155, 300, 40)];
	showAscUL.backgroundColor = [UIColor clearColor];
	showAscUL.textColor = [UIColor grayColor];
	showAscUL.text = @"显示上升与天顶";
	[mainUSV addSubview:showAscUL];
	[showAscUL release];




	UILabel *tolerateUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 200, 40)];
	tolerateUL.backgroundColor = [UIColor clearColor];
	tolerateUL.textColor = [UIColor grayColor];
	tolerateUL.text = @"容  许  度:";
	[mainUSV addSubview:tolerateUL];
	[tolerateUL release];



	lowTButton = [UIButton buttonWithType:UIButtonTypeCustom];
	lowTButton.frame = CGRectMake(102, 202, 17, 17);
	[lowTButton setImage:[UIImage imageNamed:@"nsin_selection"] forState:UIControlStateNormal];
	[lowTButton setImage:[UIImage imageNamed:@"sin_selection"] forState:UIControlStateSelected];
	[lowTButton addTarget:self action:@selector(selectLow) forControlEvents:UIControlEventTouchUpInside];
	[mainUSV addSubview:lowTButton];

	normalTButton = [UIButton buttonWithType:UIButtonTypeCustom];
	normalTButton.frame = CGRectMake(162, 202, 17, 17);
	normalTButton.selected = true;
	[normalTButton setImage:[UIImage imageNamed:@"nsin_selection"] forState:UIControlStateNormal];
	[normalTButton setImage:[UIImage imageNamed:@"sin_selection"] forState:UIControlStateSelected];
	[normalTButton addTarget:self action:@selector(selectNormal) forControlEvents:UIControlEventTouchUpInside];
	[mainUSV addSubview:normalTButton];


	highTButton = [UIButton buttonWithType:UIButtonTypeCustom];
	highTButton.frame = CGRectMake(222, 202, 17, 17);
	[highTButton setImage:[UIImage imageNamed:@"nsin_selection"] forState:UIControlStateNormal];
	[highTButton setImage:[UIImage imageNamed:@"sin_selection"] forState:UIControlStateSelected];
	[highTButton addTarget:self action:@selector(selectHigh) forControlEvents:UIControlEventTouchUpInside];
	[mainUSV addSubview:highTButton];


	UILabel *lowUL = [[UILabel alloc] initWithFrame:CGRectMake(125, 190, 40, 40)];
	[lowUL setText:@"低"];
	lowUL.backgroundColor = [UIColor clearColor];
	lowUL.textColor = [UIColor grayColor];
	[mainUSV addSubview:lowUL];
	[lowUL release];

	lowUL = [[UILabel alloc] initWithFrame:CGRectMake(185, 190, 40, 40)];
	[lowUL setText:@"默认"];
	lowUL.backgroundColor = [UIColor clearColor];
	lowUL.textColor = [UIColor grayColor];
	[mainUSV addSubview:lowUL];
	[lowUL release];

	lowUL = [[UILabel alloc] initWithFrame:CGRectMake(245, 190, 40, 40)];
	[lowUL setText:@"高"];
	lowUL.backgroundColor = [UIColor clearColor];
	lowUL.textColor = [UIColor grayColor];
	[mainUSV addSubview:lowUL];
	[lowUL release];




	backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 245, 300, 165)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[mainUSV addSubview:backgroundUIV];
	[backgroundUIV release];



	manualButton  = [UIButton buttonWithType:UIButtonTypeCustom];
	[manualButton addTarget:self action:@selector(toggleManual) forControlEvents:UIControlEventTouchUpInside];
	[manualButton setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
	[manualButton setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
	[manualButton setFrame:CGRectMake(23, 262, 17, 17)];
	[mainUSV addSubview:manualButton];


	UILabel *manualUL = [[UILabel alloc] initWithFrame:CGRectMake(45, 250, 300, 40)];
	manualUL.backgroundColor = [UIColor clearColor];
	manualUL.textColor = [XZWUtil xzwRedColor];
	manualUL.text = @"手动输入经纬度";
	[mainUSV addSubview:manualUL];
	[manualUL release];



	UIImageView *textfieldUIV = [[UIImageView alloc] initWithFrame:CGRectMake(95, 300, 120, 26)];
	[textfieldUIV setImage:[UIImage imageNamed:@"smalinput"]];
	textfieldUIV.tag = 1;
	textfieldUIV.highlightedImage = [UIImage imageNamed:@"lightinput"];
	[mainUSV addSubview:textfieldUIV];
	[textfieldUIV release];



	manualUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 290, 100, 40)];
	[manualUL setText:@"经       度:"];
	manualUL.textColor = [UIColor grayColor];
	manualUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:manualUL];
	[manualUL release];


	longUTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 300, 110, 22)];
	longUTF.delegate = self;
	[mainUSV addSubview:longUTF];
	[longUTF release];


	manualUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 325, 100, 40)];
	[manualUL setText:@"纬       度:"];
	manualUL.textColor = [UIColor grayColor];
	manualUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:manualUL];
	[manualUL release];

	textfieldUIV = [[UIImageView alloc] initWithFrame:CGRectMake(95, 335, 120, 26)];
	[textfieldUIV setImage:[UIImage imageNamed:@"smalinput"]];
	textfieldUIV.highlightedImage = [UIImage imageNamed:@"lightinput"];
	textfieldUIV.tag = 2;
	[mainUSV addSubview:textfieldUIV];
	[textfieldUIV release];


	latUTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 335, 110, 22)];
	latUTF.delegate = self;
	[mainUSV addSubview:latUTF];
	[latUTF release];




	manualUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, 100, 40)];
	[manualUL setText:@"时区调整:"];
	manualUL.textColor = [UIColor grayColor];
	manualUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:manualUL];
	[manualUL release];



	textfieldUIV = [[UIImageView alloc] initWithFrame:CGRectMake(95, 370, 120, 26)];
	[textfieldUIV setImage:[UIImage imageNamed:@"smalinput"]];
	textfieldUIV.tag = 3;
	textfieldUIV.highlightedImage = [UIImage imageNamed:@"lightinput"];
	[mainUSV addSubview:textfieldUIV];
	[textfieldUIV release];



	timezoneUTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 370, 110, 22)];
	timezoneUTF.delegate = self;
	[mainUSV addSubview:timezoneUTF];
	[timezoneUTF release];


	manualUL = [[UILabel alloc] initWithFrame:CGRectMake(220, 290, 100, 40)];
	[manualUL setText:@"(例如121.30)"];
	[mainUSV addSubview:manualUL];
	manualUL.font = [UIFont systemFontOfSize:15];
	manualUL.backgroundColor = [UIColor clearColor];
	[manualUL release];


	manualUL = [[UILabel alloc] initWithFrame:CGRectMake(220, 325, 100, 40)];
	[manualUL setText:@"(例如25.03)"];
	[mainUSV addSubview:manualUL];
	manualUL.font = [UIFont systemFontOfSize:15];
	manualUL.backgroundColor = [UIColor clearColor];
	[manualUL release];


	manualUL = [[UILabel alloc] initWithFrame:CGRectMake(220, 360, 100, 40)];
	[manualUL setText:@"(例如8或-8)"];
	[mainUSV addSubview:manualUL];
	manualUL.font = [UIFont systemFontOfSize:15];
	manualUL.backgroundColor = [UIColor clearColor];
	[manualUL release];


	UIButton *savedButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[savedButton addTarget:self action:@selector(savedAstrolabe) forControlEvents:UIControlEventTouchUpInside];
	[savedButton setImage:[UIImage imageNamed:@"btchoice"] forState:UIControlStateNormal];
	savedButton.frame = CGRectMake(10, 420, 301, 40);
	[mainUSV addSubview:savedButton];

	manualUL = [[UILabel alloc] initWithFrame:savedButton.bounds];
	[manualUL setText:@"    已保存的星盘"];
	manualUL.textColor = [XZWUtil xzwRedColor];
	[savedButton addSubview:manualUL];
	manualUL.backgroundColor = [UIColor clearColor];
	[manualUL release];




	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];



	listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(calAbstrolabe) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];



	// [mainUSV    setContentSize:CGSizeMake(320, CGRectGetHeight(mainUSV.frame))];



	////


	timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	timeView.alpha = 0.f;
	timeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
	[self.view addSubview:timeView];
	[timeView  release];




	UIView *moveView = [[UIView alloc] initWithFrame:CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight)];
	moveView.tag = XZWMoveViewTag;
	moveView.backgroundColor = [UIColor colorWithHex:0x464d5b alpha:.8f];
	[timeView addSubview:moveView];
	[moveView release];

	UIImageView *toolBarUIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cledertop"]];
	toolBarUIV.frame = CGRectMake(0, 0, 320, 44);
	[moveView addSubview:toolBarUIV];
	[toolBarUIV release];

	UILabel *tipUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 44)];
	tipUL.backgroundColor = [UIColor clearColor];
	tipUL.textColor = [UIColor whiteColor];
	tipUL.text = @"选择时间";
	[toolBarUIV addSubview:tipUL];
	[tipUL release];

	timeUL = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
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


	timePickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 88, 320, 230)];
	timePickView.showsSelectionIndicator = true;
	timePickView.delegate = self;
	timePickView.dataSource = self;
	[moveView addSubview:timePickView];
	[timePickView release];

	[timePickView selectRow:12 inComponent:0 animated:false];




	cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	cityView.alpha = 0.f;
	cityView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
	[self.view addSubview:cityView];
	[cityView  release];

	moveView = [[UIView alloc] initWithFrame:CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight)];
	moveView.tag = XZWMoveViewTag;
	moveView.backgroundColor = [UIColor colorWithHex:0x464d5b alpha:.8f];
	[cityView addSubview:moveView];
	[moveView release];

	toolBarUIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cledertop"]];
	toolBarUIV.frame = CGRectMake(0, 0, 320, 44);
	[moveView addSubview:toolBarUIV];
	[toolBarUIV release];

	tipUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 44)];
	tipUL.backgroundColor = [UIColor clearColor];
	tipUL.textColor = [UIColor whiteColor];
	tipUL.text = @"选择城市";
	[toolBarUIV addSubview:tipUL];
	[tipUL release];

	cityUL = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
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



	cityPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 88, 320, 230)];
	cityPickView.showsSelectionIndicator = true;
	cityPickView.delegate = self;
	cityPickView.dataSource = self;
	[moveView addSubview:cityPickView];
	[cityPickView release];



	[mainUSV setContentSize:CGSizeMake(320, 480)];
}

#pragma mark -

- (void)toggleView {
	[self.navigationController.viewDeckController toggleLeftViewAnimated:true];
}

- (void)toggleManual {
	[manualButton setSelected:!manualButton.selected];


	[(UIImageView *)[mainUSV viewWithTag:1]   setHighlighted : manualButton.selected];
	[(UIImageView *)[mainUSV viewWithTag:2]   setHighlighted : manualButton.selected];
	[(UIImageView *)[mainUSV viewWithTag:3]   setHighlighted : manualButton.selected];
}

- (void)selectLow {
	lowTButton.selected = true;
	normalTButton.selected = false;
	highTButton.selected = false;
}

- (void)selectNormal {
	lowTButton.selected = false;
	normalTButton.selected = true;
	highTButton.selected = false;
}

- (void)selectHigh {
	lowTButton.selected = false;
	normalTButton.selected = false;
	highTButton.selected = true;
}

- (void)selectBornLoc {
}

- (void)showAsc {
	showAscButton.selected = !showAscButton.selected;
}

- (void)savedAstrolabe {
	XZWSavedAstrolabeViewController *savedAstro = [[XZWSavedAstrolabeViewController alloc]   init];
	[self.navigationController pushViewController:savedAstro animated:true];
	[savedAstro release];
}

- (void)startToSelectCity {
	[self endSelectTime];

	[self.view endEditing:true];

	[UIView animateWithDuration:.3f animations: ^{   cityView.alpha = 1.f;  [cityView viewWithTag:XZWMoveViewTag].frame = CGRectMake(0, TotalScreenHeight - 280 - 88, 320, 320); }];
}

- (void)endSelectCity {
	[self.view endEditing:true];

	[UIView animateWithDuration:.3f animations: ^{   cityView.alpha = 0.f; [cityView viewWithTag:XZWMoveViewTag].frame = CGRectMake(0, TotalScreenHeight, 320, 320); }];
}

- (void)startToSelectTime {
	[self endSelectCity];

	[self.view endEditing:true];

	[UIView animateWithDuration:.3f animations: ^{   timeView.alpha = 1.f; [timeView viewWithTag:XZWMoveViewTag].frame = CGRectMake(0, TotalScreenHeight - 280 - 88, 320, TotalScreenHeight); }];
}

- (void)endSelectTime {
	[self.view endEditing:true];

	[UIView animateWithDuration:.3f animations: ^{  timeView.alpha = 0.f;  [timeView viewWithTag:XZWMoveViewTag].frame = CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight); }];
}

#pragma mark -  textfield


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField != nickNameUTF) {
		//([string  characterAtIndex:0] >= 'a' && [string  characterAtIndex:0] <= 'z' ) || ([string  characterAtIndex:0] >= 'A' && [string  characterAtIndex:0] <= 'Z' ) ||

		if (string.length > 0) {
			if (([string characterAtIndex:0] >= '0' && [string characterAtIndex:0] <= '9') ||  [string characterAtIndex:0] == '-' || [string characterAtIndex:0] <= '.') {
				return true;
			}
			else {
				return false;
			}
		}
	}
	return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	tapGest.enabled = true;

	if (textField == longUTF) {
		[UIView animateWithDuration:.3f animations: ^{
		    [mainUSV setContentInset:UIEdgeInsetsMake(IS_iPhone5 ? -130 : -210, 0, 300, 0)];
		}];


		//[mainUSV scrollRectToVisible:CGRectMake(0, 400, 300, 100) animated:true];
	}
	else if (textField == latUTF) {
		[UIView animateWithDuration:.3f animations: ^{
		    [mainUSV setContentInset:UIEdgeInsetsMake(IS_iPhone5 ? -130 : -210, 0, 300, 0)];
		}];
	}
	else if (textField == nickNameUTF) {
		[UIView animateWithDuration:.3f animations: ^{
		    [mainUSV setContentInset:UIEdgeInsetsMake(IS_iPhone5 ? 0 : 0, 0, 300, 0)];
		}];
	}
	else {
		[mainUSV setContentInset:UIEdgeInsetsMake(IS_iPhone5 ? -130 : -210, 0, 300, 0)];

        //        [UIView animateWithDuration:.3f animations:^{
        //            [mainUSV  setContentInset:UIEdgeInsetsMake(IS_iPhone5 ?-130: -210, 0, 300, 0)];}];

		[mainUSV scrollRectToVisible:CGRectMake(0, 300, 300, 100) animated:true];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:true];




	[UIView animateWithDuration:.3f animations: ^{
	    [mainUSV setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
	}];


	return true;
}

#pragma mark - xzwselectdate

- (void)getDate:(NSDate *)theDate andDateString:(NSString *)dateString {
	dateUL.text = dateString;


	if (bornDate) {
		[bornDate  release];
		bornDate = nil;
	}

	bornDate = theDate;
	[bornDate  retain];
}

#pragma mark -  pickerview delegate & datasource

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	UILabel *tView = (UILabel *)view;
	if (!tView) {
		tView = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)]  autorelease];
		// Setup label properties - frame, font, colors etc

		tView.backgroundColor = [UIColor clearColor];

		tView.font = [UIFont boldSystemFontOfSize:25];
		tView.textAlignment = NSTextAlignmentCenter;
	}


	if (cityPickView == pickerView) {
		if (component == 0) {
			tView.text = [NSString stringWithFormat:@"%@",  [cityArray objectAtIndex:row]];
		}
		else {
			@try {
				tView.text = [NSString stringWithFormat:@"%@",  [[[citysDic objectForKey:[cityArray objectAtIndex:[pickerView selectedRowInComponent:0]]] allKeys] objectAtIndex:row]];
			}
			@catch (NSException *exception)
			{
				tView.text = @"";
			}
			@finally
			{
			}
		}
	}
	else {
		if (component == 0) {
			tView.text = [NSString stringWithFormat:@"%d时",  row];
		}
		else if (component == 1) {
			tView.text = [NSString stringWithFormat:@"%d分", row];
		}
		else {
		}
	}


	// Fill the label text here
	return tView;
}

#pragma mark -


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	CGFloat width = 0.f;




	if (pickerView == cityPickView) {
		switch (component) {
			case 0:
			{
				width = 98.f;
			}
			break;

			case 1: {
				width = 158.f;
			}

			break;

			default:
			{
				width = 75.f;
			}
			break;
		}
	}
	else {
		switch (component) {
			case 0:
			{
				width = 98.f;
			}
			break;

			case 1: {
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

	return width;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
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
	}
	else {
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (pickerView == cityPickView) {
		if (component == 0) {
			[cityPickView reloadAllComponents];
		}
		else if (component == 1) {
		}
		else {
		}


		@try {
			bornLocUL.text = [NSString stringWithFormat:@"%@ %@", [cityArray objectAtIndex:[pickerView selectedRowInComponent:0]], [[[citysDic objectForKey:[cityArray objectAtIndex:[pickerView selectedRowInComponent:0]]] allKeys] objectAtIndex:[pickerView selectedRowInComponent:1]]];
		}
		@catch (NSException *exception)
		{
			bornLocUL.text = @"";
		}
		@finally
		{
		}


		cityUL.text =  [@"出生城市    "   stringByAppendingString : bornLocUL.text];
	}
	else {
		bornUL.text = [NSString stringWithFormat:@"%02d:%02d", [pickerView selectedRowInComponent:0], [pickerView selectedRowInComponent:1]];

		timeUL.text = [@"出生时间    "   stringByAppendingString : bornUL.text];
	}
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
	self.viewDeckController.panningMode = IIViewDeckFullViewPanning;


	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	self.viewDeckController.panningMode = IIViewDeckNoPanning;

	[super viewWillDisappear:animated];
}

#pragma mark -




@end
