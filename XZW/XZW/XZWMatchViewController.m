//
//  XZWMatchViewController.m
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMatchViewController.h"
#import "IIViewDeckController.h"
#import "XZWUtil.h"

#import "XZWMatchResultViewController.h"

@interface XZWMatchViewController () {
	UIButton *boyAstroButton;
	UILabel *boyUL;

	UIButton *girlAstroButton;
	UILabel *girlUL;

	UILabel *boyDateUL;
	UILabel *girlDateUL;

	XZWSelectDateView *boySDV;
	XZWSelectDateView *girlSDV;

	XZWSelectAstroView *boySAV;
	XZWSelectAstroView *girlSAV;

	int boySelected, girlSelected;
}

@end

@implementation XZWMatchViewController

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


	self.title = @"星座配对";

	[self initView];
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

#pragma mark -


- (void)initView {
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


	listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(seeResult) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];


	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


	UIImageView *backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[self.view addSubview:backgroundUIV];
	[backgroundUIV release];

	backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 120, 300, 100)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[self.view addSubview:backgroundUIV];
	[backgroundUIV release];


	boyUL = [[UILabel alloc] initWithFrame:CGRectMake(95, 30, 320, 30)];
	boyUL.text = @"白羊座男";
	boyUL.textColor = [XZWUtil xzwRedColor];
	[boyUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:boyUL];
	[boyUL release];




    //   UIButton * selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [selectBtn setImage:[UIImage imageNamed:@"btn_inquiry"] forState:UIControlStateNormal];
    //    [selectBtn  addTarget:self action:@selector(seeResult) forControlEvents:UIControlEventTouchUpInside];
    //    selectBtn.frame =  CGRectMake(95, 260, 53, 25);
    //    [self.view addSubview:selectBtn];
    //


	UILabel *theUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 225, 320, 20)];
	theUL.text = @"可点击星座图标快速选择星座哦";
	theUL.font = [UIFont systemFontOfSize:10];
	theUL.backgroundColor = [UIColor clearColor];
	theUL.textColor = [XZWUtil xzwRedColor];
	[self.view addSubview:theUL];
	[theUL release];


	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame = CGRectMake(110,  260, 100, 24);
	[loginButton setBackgroundImage:[[UIImage imageNamed:@"regist"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
	loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[loginButton setTitle:@"查询" forState:UIControlStateNormal];
	[loginButton addTarget:self action:@selector(seeResult) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginButton];



	UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[selectBtn setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
	[selectBtn addTarget:self action:@selector(boySelectBtn) forControlEvents:UIControlEventTouchUpInside];
	selectBtn.frame =  CGRectMake(95, 60, 204, 25);
	[self.view addSubview:selectBtn];

	UIImageView *arrowUIV = [[UIImageView alloc] initWithFrame:CGRectMake(185, 10, 12, 8)];
	[arrowUIV setImage:[UIImage imageNamed:@"arrow"]];
	[selectBtn addSubview:arrowUIV];
	[arrowUIV  release];

	boyDateUL = [[UILabel alloc] initWithFrame:CGRectOffset(selectBtn.bounds, 10, 0)];
	boyDateUL.backgroundColor = [UIColor clearColor];
	boyDateUL.text = @"公历1980年1月1日";
	[selectBtn addSubview:boyDateUL];
	[boyDateUL release];



	girlUL = [[UILabel alloc] initWithFrame:CGRectMake(95, 140, 320, 30)];
	girlUL.text = @"白羊座女";
	girlUL.textColor = [XZWUtil xzwRedColor];
	[girlUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:girlUL];
	[girlUL release];


	selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[selectBtn setImage:[UIImage imageNamed:@"biginput"] forState:UIControlStateNormal];
	[selectBtn addTarget:self action:@selector(girlSelectBtn) forControlEvents:UIControlEventTouchUpInside];
	selectBtn.frame =  CGRectMake(95, 170, 204, 25);
	[self.view addSubview:selectBtn];

	arrowUIV = [[UIImageView alloc] initWithFrame:CGRectMake(185, 10, 12, 8)];
	[arrowUIV setImage:[UIImage imageNamed:@"arrow"]];
	[selectBtn addSubview:arrowUIV];
	[arrowUIV  release];

	girlDateUL = [[UILabel alloc] initWithFrame:CGRectOffset(selectBtn.bounds, 10, 0)];
	girlDateUL.backgroundColor = [UIColor clearColor];
	girlDateUL.text = @"公历1980年1月1日";
	[selectBtn addSubview:girlDateUL];
	[girlDateUL release];



	boyAstroButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[boyAstroButton setImage:[UIImage imageNamed:@"baiyang"] forState:UIControlStateNormal];
	boyAstroButton.frame = CGRectMake(20, 20, 80, 80);
	boyAstroButton.center = CGPointMake(55, 60);
	[boyAstroButton addTarget:self action:@selector(boyAstroAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:boyAstroButton];


	girlAstroButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[girlAstroButton setImage:[UIImage imageNamed:@"baiyang"] forState:UIControlStateNormal];
	girlAstroButton.frame = CGRectMake(20, 20, 80, 80);
	[girlAstroButton addTarget:self action:@selector(girlAstroAction) forControlEvents:UIControlEventTouchUpInside];
	girlAstroButton.center = CGPointMake(55, 170);
	[self.view addSubview:girlAstroButton];




	boySDV = [[XZWSelectDateView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	boySDV.delegate = self;
	boySDV.alpha = 0.f;
	[self.view addSubview:boySDV];
	[boySDV release];



	girlSDV = [[XZWSelectDateView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	girlSDV.delegate = self;
	girlSDV.alpha = 0.f;
	[self.view addSubview:girlSDV];
	[girlSDV release];


	boySAV = [[XZWSelectAstroView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	boySAV.alpha = 0.f;
	boySAV.delegate = self;
	[self.view addSubview:boySAV];
	[boySAV release];


	girlSAV = [[XZWSelectAstroView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	girlSAV.alpha = 0.f;
	girlSAV.delegate = self;
	[self.view addSubview:girlSAV];
	[girlSAV release];
}

#pragma mark -

- (void)seeResult {
	XZWMatchResultViewController *matchResult = [[XZWMatchResultViewController alloc] initWithBoyIndex:boySelected:girlSelected];
	[self.navigationController pushViewController:matchResult animated:true];
	[matchResult release];
}

- (void)boyAstroAction {
	[boySAV  playAnimate];
}

- (void)girlAstroAction {
	[girlSAV  playAnimate];
}

- (void)boySelectBtn {
	[boySDV playAnimate];
}

- (void)girlSelectBtn {
	[girlSDV playAnimate];
}

#pragma mark -

- (void)toggleView {
	[self.navigationController.viewDeckController toggleLeftViewAnimated:true];
}

#pragma mark - selectAstro

- (void)selectAstro:(XZWSelectAstroView *)astroView selectedAstro:(int)selectedAstro name:(NSString *)nameString {
	NSArray *astroPicArray =  @[@"baiyang", @"jinniu", @"shuangzi", @"juxie", @"shizi", @"chunv", @"tiancheng", @"tianxie", @"sheshou", @"mojie", @"shuiping", @"shuangyu"];

	if (astroView == boySAV) {
		boyUL.text = [nameString stringByAppendingString:@"男"];

		boySelected = selectedAstro;

		[boyAstroButton setImage:[UIImage imageNamed:[astroPicArray objectAtIndex:selectedAstro]] forState:UIControlStateNormal];
	}
	else {
		girlUL.text = [nameString stringByAppendingString:@"女"];

		girlSelected = selectedAstro;

		[girlAstroButton setImage:[UIImage imageNamed:[astroPicArray objectAtIndex:selectedAstro]] forState:UIControlStateNormal];
	}
}

#pragma mark - selectdate




- (void)dateView:(XZWSelectDateView *)dateView dateChanged:(NSDate *)date andDateString:(NSString *)dateString {
	NSCalendar *gregorian = [NSCalendar  currentCalendar];

	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	NSDateComponents *comps = [gregorian components:unitFlags fromDate:date];

	int month = [comps month];
	int day = [comps day];


	NSArray *astroDateArray = [XZWUtil findAstro:[NSString stringWithFormat:@"%d%02d", month, day]];

	int index =  [[astroDateArray objectAtIndex:0]  intValue];


	NSArray *astroPicArray =  @[@"baiyang", @"jinniu", @"shuangzi", @"juxie", @"shizi", @"chunv", @"tiancheng", @"tianxie", @"sheshou", @"mojie", @"shuiping", @"shuangyu"];



	NSArray *astroArray = @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];


	if (dateView == boySDV) {
		boyDateUL.text = dateString;


		boyUL.text = [[astroArray objectAtIndex:index] stringByAppendingString:@"男"];

		boySelected = index;

		[boyAstroButton setImage:[UIImage imageNamed:[astroPicArray objectAtIndex:boySelected]] forState:UIControlStateNormal];
	}
	else {
		girlDateUL.text = dateString;

		girlUL.text = [[astroArray objectAtIndex:index] stringByAppendingString:@"女"];

		girlSelected = index;

		[girlAstroButton setImage:[UIImage imageNamed:[astroPicArray objectAtIndex:girlSelected]] forState:UIControlStateNormal];
	}
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
