//
//  XZWAstrolabeDivinationViewController.m
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAstrolabeDivinationViewController.h"
#import "XZWUtil.h"
#import "XZWZodiacData.h"
#import "JSONKit.h"

@interface XZWAstrolabeDivinationViewController () {
	UIScrollView *mainUSV;
	NSArray *dataArray;

	UIView *xingView;
	UIView *gongView;
	UIView *xiangView;

	UIScrollView *contentUSV;

	UIView *arrowView;

	int firstSelected, xingSelected, gongSelected, xiangSelect;


	NSMutableArray *dataBaseArray;
	NSDictionary *xwArr;
}

@end

@implementation XZWAstrolabeDivinationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (id)initWithArray:(NSArray *)theDataArray {
	self = [super init];
	if (self) {
		// Custom initialization

		dataArray = theDataArray;
		[dataArray retain];

		dataBaseArray = [[NSMutableArray alloc]  init];
	}
	return self;
}

- (void)dealloc {
	[dataArray  release];
	[dataBaseArray release];
	[xwArr release];

	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];


	[dataBaseArray setArray:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data" ofType:nil] encoding:NSUTF8StringEncoding error:nil] objectFromJSONString]];
	xwArr = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Data_xw" ofType:nil] encoding:NSUTF8StringEncoding error:nil] objectFromJSONString];
	[xwArr  retain];

	// Do any additional setup after loading the view.
	self.title = @"占算结果";

	self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];

	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];



	gongView = [[UIView alloc] initWithFrame:CGRectMake(0,   44, 320, TotalScreenHeight - 64 + 44)];
	[self.view addSubview:gongView];
	[gongView release];

	xiangView = [[UIView alloc] initWithFrame:CGRectMake(0,   44, 320, TotalScreenHeight - 64 + 44)];
	[self.view addSubview:xiangView];
	[xiangView release];

	xingView = [[UIView alloc] initWithFrame:CGRectMake(0,   44, 320, TotalScreenHeight - 64 + 44)];
	[self.view addSubview:xingView];
	[xingView release];


	NSArray *titleArray = @[@"星位", @"宫位", @"相位"];

	NSArray *theImageArray = @[@"sun", @"moon", @"mercury", @"venus", @"spark", @"jupiter", @"saturn", @"uranus", @"neptune", @"pluto", @"rise"];

	NSArray *gongArray = @[@"太阳", @"月亮", @"水星", @"金星", @"火星", @"木星", @"土星", @"天王星", @"海王星", @"冥王星", @"上升"];

	NSArray *xiangArray = @[@"p1", @"p2", @"p3", @"p4", @"p5"];

	NSArray *xiangNameArray = @[@"合相", @"六合相位", @"四分相", @"三分相", @"对分相"];


	double am = [[dataArray objectAtIndex:3]  doubleValue];

	for (int i = 0; i < 3; i++) {
		UIButton *fortuneButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[fortuneButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
		fortuneButton.frame = CGRectMake(i * 106.6, 0, 106.6, 44);
		[fortuneButton addTarget:self action:@selector(switchDivinationBtn:) forControlEvents:UIControlEventTouchUpInside];
		fortuneButton.tag =  i + 1;
		[self.view addSubview:fortuneButton];
	}

	UIScrollView *xingUSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 5, 320, 44)];
	xingUSV.showsHorizontalScrollIndicator = xingUSV.showsVerticalScrollIndicator = false;
	xingView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
	[xingView addSubview:xingUSV];
	[xingUSV release];

	for (int i = 0; i < 10 + am; i++) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:theImageArray[i]] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(selectXing:) forControlEvents:UIControlEventTouchUpInside];
		button.frame = CGRectMake(40 * i, 3, 40, 40);
		[button setTitle:gongArray[i] forState:UIControlStateNormal];
		[xingUSV addSubview:button];
		button.tag =  i + 1;
		[button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[button setTitleColor:[XZWUtil xzwRedColor] forState:UIControlStateSelected];
		[button setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
		button.titleLabel.font = [UIFont systemFontOfSize:12];
		[button setTitleEdgeInsets:UIEdgeInsetsMake(15, -23, 0.0, 0.0)];

		if (i == 0) {
			button.selected = true;
		}
	}
	[xingUSV setContentSize:CGSizeMake(10 + am * 40, 40)];


	gongView.hidden = true;

	xingUSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 5, 320, 44)];
	xingUSV.showsHorizontalScrollIndicator = xingUSV.showsVerticalScrollIndicator = false;
	gongView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]; [gongView addSubview:xingUSV];
	[xingUSV release];


	for (int i = 0; i < 10; i++) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:theImageArray[i]] forState:UIControlStateNormal];
		[button addTarget:self action:@selector(selectGong:) forControlEvents:UIControlEventTouchUpInside];   button.tag =  i + 1;
		button.frame = CGRectMake(40 * i, 3, 40, 40);
		[button setTitle:gongArray[i] forState:UIControlStateNormal];
		[xingUSV addSubview:button];
		[button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[button setTitleColor:[XZWUtil xzwRedColor] forState:UIControlStateSelected];
		[button setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
		button.titleLabel.font = [UIFont systemFontOfSize:12];
		[button setTitleEdgeInsets:UIEdgeInsetsMake(15, -23, 0.0, 0.0)];
		if (i == 0) {
			button.selected = true;
		}
	}
	[xingUSV setContentSize:CGSizeMake(10 * 40, 40)];




	xingUSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 5, 320, 44)];
	xiangView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]; xingUSV.showsHorizontalScrollIndicator = xingUSV.showsVerticalScrollIndicator = false;
	[xiangView addSubview:xingUSV];
	[xingUSV release];



	xiangView.hidden = true;

	for (int i = 0; i < 5; i++) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:xiangArray[i]] forState:UIControlStateNormal];
		button.tag =  i + 1;
		[button addTarget:self action:@selector(selectXiang:) forControlEvents:UIControlEventTouchUpInside];
		button.frame = CGRectMake(6 + 50 * i, 3, 40, 40);
		[button setTitle:xiangNameArray[i] forState:UIControlStateNormal];
		[xingUSV addSubview:button];
		[button setTitleColor:[XZWUtil xzwRedColor] forState:UIControlStateSelected];
		[button setImageEdgeInsets:UIEdgeInsetsMake(-20, 0, 0, 0)];
		button.titleLabel.font = [UIFont systemFontOfSize:12];
		button.titleLabel.adjustsFontSizeToFitWidth = true;
		[button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		[button setTitleEdgeInsets:UIEdgeInsetsMake(15, -23, 0.0, 0.0)];

		if (i == 0) {
			button.selected = true;
		}
	}
	[xingUSV setContentSize:CGSizeMake([xiangNameArray count] * 40, 40)];


	contentUSV =  [[UIScrollView alloc] initWithFrame:CGRectMake(0, 89, 320, TotalScreenHeight - 89 - 64)];
	contentUSV.backgroundColor = [UIColor clearColor];
	contentUSV.showsHorizontalScrollIndicator = contentUSV.showsVerticalScrollIndicator = false;
	[self.view addSubview:contentUSV];
	[contentUSV release];




	arrowView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, 106.6, 10)];
	[self.view addSubview:arrowView];
	[arrowView release];

	UIImageView *arrowUIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"uarrow"]];
	arrowUIV.center = CGPointMake(arrowView.center.x, 2.5);
	[arrowView addSubview:arrowUIV];
	[arrowUIV release];

	UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 4)];
	redView.backgroundColor  = [UIColor colorWithHex:0xfb5c92];
	[self.view addSubview:redView];
	[redView release];



	[self genView];
}

- (void)selectXing:(UIButton *)button {
	xingSelected = button.tag - 1;

	UIScrollView *usv = (UIScrollView *)[button  superview];

	for (UIView *view in[usv subviews]) {
		if ([view isKindOfClass:[UIButton class]]) {
			UIButton *tempView = (UIButton *)view;


			if (tempView == button) {
				tempView.selected = true;
			}
			else {
				tempView.selected = false;
			}
		}
	}


	[self genView];
}

- (void)selectGong:(UIButton *)button {
	gongSelected = button.tag - 1;

	UIScrollView *usv = (UIScrollView *)[button  superview];

	for (UIView *view in[usv subviews]) {
		if ([view isKindOfClass:[UIButton class]]) {
			UIButton *tempView = (UIButton *)view;


			if (tempView == button) {
				tempView.selected = true;
			}
			else {
				tempView.selected = false;
			}
		}
	}


	[self genView];
}

- (void)selectXiang:(UIButton *)button {
	xiangSelect = button.tag - 1;

	UIScrollView *usv = (UIScrollView *)[button  superview];

	for (UIView *view in[usv subviews]) {
		if ([view isKindOfClass:[UIButton class]]) {
			UIButton *tempView = (UIButton *)view;


			if (tempView == button) {
				tempView.selected = true;
			}
			else {
				tempView.selected = false;
			}
		}
	}


	[self genView];
}

- (void)switchDivinationBtn:(UIButton *)sender {
	firstSelected = sender.tag - 1;


	[UIView animateWithDuration:.3f animations: ^{ arrowView.frame =  CGRectMake((sender.tag - 1) * 106.6, 35, 106.6, 10); }];

	switch (sender.tag) {
		case 1: {
			xingView.hidden = false;
			gongView.hidden = true;
			xiangView.hidden = true;
		}
		break;

		case 2: {
			xingView.hidden = true;
			gongView.hidden = false;
			xiangView.hidden = true;
		}
		break;

		default: {
			xingView.hidden = true;
			gongView.hidden = true;
			xiangView.hidden = false;
		}
		break;
	}

	[self genView];
}

- (void)genView {
	for (UIView *subview in[contentUSV subviews]) {
		[subview   removeFromSuperview];
		subview = nil;
	}


	UIImageView *backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 302)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[contentUSV addSubview:backgroundUIV];
	[backgroundUIV release];


	if (firstSelected == 0) {
		NSMutableArray *planet =  [NSMutableArray arrayWithArray:[dataArray objectAtIndex:0]];

		//   [XZWZodiacData zodiac: [planet[xingSelected]  floatValue]];

		NSArray *sd2 = dataBaseArray[1][[XZWZodiacData getNameArray][xingSelected]][[XZWZodiacData zodiac:[planet[xingSelected]  floatValue]]];



		UILabel *tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 100, 25)];
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		[tipsUL setText:[NSString stringWithFormat:@"落在%@:", [XZWZodiacData zodiac:[planet[xingSelected]  doubleValue]]]];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];

		UILabel *resultUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 5 + 3, 280, 25)];
		[resultUL setBackgroundColor:[UIColor clearColor]];
		[resultUL setText:[@"                     "  stringByAppendingString : sd2[0]]];
		[resultUL setTextColor:[UIColor grayColor]];
		[backgroundUIV addSubview:resultUL];
		[resultUL  release];
		resultUL.numberOfLines = 0;
		[resultUL sizeThatFits:CGSizeMake(280, 1000)];
		[resultUL  sizeToFit];


		tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(resultUL.frame) + 5, 200, 25)];
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		[tipsUL setText:@"优点:"];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];



		resultUL = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(resultUL.frame) + 5 + 3, 280, 25)];
		[resultUL setBackgroundColor:[UIColor clearColor]];
		[resultUL setText:[@"          "  stringByAppendingString : sd2[1]]];
		[resultUL setTextColor:[UIColor grayColor]];
		resultUL.numberOfLines = 0;
		[backgroundUIV addSubview:resultUL];
		[resultUL  release];
		[resultUL sizeThatFits:CGSizeMake(280, 1000)];
		[resultUL  sizeToFit];


		tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(resultUL.frame), 280, 25)];
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		[tipsUL setText:@"缺点:"];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];


		resultUL = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(resultUL.frame) + 3, 280, 25)];
		[resultUL setBackgroundColor:[UIColor clearColor]];
		[resultUL setText:[@"          "  stringByAppendingString : sd2[2]]];
		[resultUL setTextColor:[UIColor grayColor]];
		resultUL.numberOfLines = 0;
		[backgroundUIV addSubview:resultUL];
		[resultUL  release];
		[resultUL sizeThatFits:CGSizeMake(280, 1000)];
		[resultUL  sizeToFit];


		float backgroundHeight = CGRectGetMaxY(resultUL.frame) + 10;

		backgroundUIV.frame = CGRectMake(10, 10, 300, backgroundHeight);

		backgroundHeight += 20;

		backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, backgroundHeight, 300, 302)];
		backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
		[contentUSV addSubview:backgroundUIV];
		[backgroundUIV release];


		tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)];
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		[tipsUL setText:@"基本特质:"];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];


		resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 280, 25)];
		[resultUL setBackgroundColor:[UIColor clearColor]];
		resultUL.numberOfLines = 0;
		resultUL.font = [UIFont systemFontOfSize:15];
		[resultUL setText:sd2[3]];
		[resultUL setTextColor:[UIColor grayColor]];
		[backgroundUIV addSubview:resultUL];
		[resultUL sizeThatFits:CGSizeMake(280, 2000)];
		[resultUL  release];
		[resultUL   sizeToFit];




		tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
		tipsUL.numberOfLines = 0;
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		[tipsUL setText:@"具体特质:"];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];


		resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipsUL.frame), 280, 25)];
		resultUL.numberOfLines = 0;
		resultUL.font = [UIFont systemFontOfSize:15];
		[resultUL setBackgroundColor:[UIColor clearColor]];
		[resultUL setText:sd2[4]];
		[resultUL setTextColor:[UIColor grayColor]];
		[backgroundUIV addSubview:resultUL];
		[resultUL sizeThatFits:CGSizeMake(280, 2000)];
		[resultUL  release];
		[resultUL   sizeToFit];



		tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
		tipsUL.numberOfLines = 0;
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		[tipsUL setText:@"行事风格:"];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];


		resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipsUL.frame), 280, 25)];
		resultUL.numberOfLines = 0;
		resultUL.font = [UIFont systemFontOfSize:15];
		[resultUL setBackgroundColor:[UIColor clearColor]];
		[resultUL setText:sd2[5]];
		[resultUL setTextColor:[UIColor grayColor]];
		[backgroundUIV addSubview:resultUL];
		[resultUL sizeThatFits:CGSizeMake(280, 2000)];
		[resultUL  release];
		[resultUL   sizeToFit];


		tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 23, 200, 25)];
		tipsUL.numberOfLines = 0;
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		[tipsUL setText:@"个性盲点:"];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];


		resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipsUL.frame), 280, 25)];
		resultUL.numberOfLines = 0;
		resultUL.font = [UIFont systemFontOfSize:15];
		[resultUL setBackgroundColor:[UIColor clearColor]];
		[resultUL setText:sd2[6]];
		[resultUL setTextColor:[UIColor grayColor]];
		[backgroundUIV addSubview:resultUL];
		[resultUL sizeThatFits:CGSizeMake(280, 2000)];
		[resultUL  release];
		[resultUL   sizeToFit];


		backgroundUIV.frame = CGRectMake(10, backgroundHeight, 300, CGRectGetMaxY(resultUL.frame) + 10);


		[contentUSV setContentSize:CGSizeMake(320, CGRectGetMaxY(backgroundUIV.frame) + 15)];
	}
	else if (firstSelected == 1) {
		NSArray *house = [dataArray objectAtIndex:1];

		int hid = [house[1][gongSelected] intValue] + 1;

		NSString *sd4 = dataBaseArray[3][[XZWZodiacData getNameArray][gongSelected]][12 - hid];


		UILabel *tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 280, 25)];
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		//  [tipsUL setText:[NSString stringWithFormat:@"落在%@:",[XZWZodiacData zodiac:[planet[xingSelected]  doubleValue]]]] ;
		tipsUL.text = [NSString stringWithFormat:@"%@落在:第%@宫(%@)", [XZWZodiacData getNameArray][gongSelected], dataBaseArray[5][hid - 1], dataBaseArray[2][hid - 1]];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];

		tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 40, 200, 25)];
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		//  [tipsUL setText:[NSString stringWithFormat:@"落在%@:",[XZWZodiacData zodiac:[planet[xingSelected]  doubleValue]]]] ;
		tipsUL.text = @"特质分析:";
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];

		UILabel *resultUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 40 + 3, 280, 25)];
		[resultUL setBackgroundColor:[UIColor clearColor]];
		[resultUL setText:[@"                "  stringByAppendingString : sd4]];
		[resultUL setTextColor:[UIColor grayColor]];
		[backgroundUIV addSubview:resultUL];
		[resultUL  release];
		resultUL.numberOfLines = 0;
		[resultUL sizeThatFits:CGSizeMake(280, 1000)];
		[resultUL  sizeToFit];

		backgroundUIV.frame = CGRectMake(10, 10, 300, CGRectGetMaxY(resultUL.frame) + 10);


		[contentUSV setContentSize:CGSizeMake(320, CGRectGetMaxY(backgroundUIV.frame) + 15)];
	}
	else {
		NSArray *lasp = @[@0, @4, @2, @3, @1];
		NSArray *laspn = @[@0, @60, @90, @120, @180];
		NSArray *aspect = [dataArray objectAtIndex:2];
		NSArray *type = [XZWZodiacData getTypeArray];
		NSArray *name = [XZWZodiacData getNameArray];



		UILabel *tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 200, 25)];
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		//  [tipsUL setText:[NSString stringWithFormat:@"落在%@:",[XZWZodiacData zodiac:[planet[xingSelected]  doubleValue]]]] ;
		tipsUL.text = [NSString stringWithFormat:@"%@相位:", type[[lasp[xiangSelect] intValue]]];
		[tipsUL setTextColor:[XZWUtil xzwRedColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];

		tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, 280, 25)];
		[tipsUL setBackgroundColor:[UIColor clearColor]];
		[tipsUL setText:dataBaseArray[6][xiangSelect]];
		[tipsUL setTextColor:[UIColor grayColor]];
		[backgroundUIV addSubview:tipsUL];
		[tipsUL release];
		tipsUL.numberOfLines = 0;
		[tipsUL sizeThatFits:CGSizeMake(280, 1000)];
		[tipsUL  sizeToFit];




		float height = CGRectGetMaxY(tipsUL.frame);

		backgroundUIV.frame = CGRectMake(10, 10, 300, height + 10);



		float backgroundHeight = CGRectGetMaxY(backgroundUIV.frame);

		backgroundHeight += 10;


		backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, backgroundHeight, 300, 302)];
		backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
		[contentUSV addSubview:backgroundUIV];
		[backgroundUIV release];


		height = 10.f;

		for (int i = 0; i < [aspect count]; i++) {
			int pt1 = [aspect[i][0]   intValue];
			int pt2 = [aspect[i][1]   intValue];

			if (([aspect[i][2]   intValue] == [lasp[xiangSelect]  intValue]) && (pt2 != 11 && pt1 != 11)) {
				//   NSLog(@"%@",xwArr[laspn[xiangSelect][name[pt1]][name[pt2]]  ]);

				UILabel *tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, height, 280, 25)];
				[tipsUL setBackgroundColor:[UIColor clearColor]];
				//  [tipsUL setText:[NSString stringWithFormat:@"落在%@:",[XZWZodiacData zodiac:[planet[xingSelected]  doubleValue]]]] ;
				tipsUL.text = [NSString stringWithFormat:@"%@%@%@:", name[pt1], type[[aspect[i][2] intValue]], name[pt2]];
				[tipsUL setTextColor:[XZWUtil xzwRedColor]];
				[backgroundUIV addSubview:tipsUL];
				[tipsUL release];



				tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, height + 25, 280, 25)];
				[tipsUL setBackgroundColor:[UIColor clearColor]];



				@try {
					[tipsUL setText:[@""  stringByAppendingString : xwArr[[laspn[xiangSelect] description]][name[pt1]][name[pt2]]]];
				}
				@catch (NSException *exception)
				{
					[tipsUL setText:@""];
				}
				@finally
				{
				}

				[tipsUL setTextColor:[UIColor grayColor]];
				[backgroundUIV addSubview:tipsUL];
				[tipsUL release];
				tipsUL.numberOfLines = 0;
				[tipsUL sizeThatFits:CGSizeMake(280, 1000)];
				[tipsUL  sizeToFit];


				height = CGRectGetMaxY(tipsUL.frame) + 15;

				//  backgroundHeight =  CGRectGetMaxY(tipsUL.frame) + 10 ;
			}
		}

		backgroundUIV.frame = CGRectMake(10, backgroundHeight, 300, height);


		[contentUSV setContentSize:CGSizeMake(320, CGRectGetMaxY(backgroundUIV.frame) + 15)];
	}
}

- (void)goBack {
	[self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
