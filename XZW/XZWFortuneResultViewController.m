//
//  XZWFortuneResultViewController.m
//  XZW
//
//  Created by dee on 13-9-4.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWFortuneResultViewController.h"
#import "XZWNetworkManager.h"
#import "Interface.h"
#import "JSONKit.h"
#import "XZWUtil.h"
#import "XZWZodiacData.h"
#import "XZWStarView.h"

@interface XZWFortuneResultViewController () {
	int astroID, selectedItem;

	ASIHTTPRequest *request;

	UIView *arrowView;

	NSMutableArray *fortuneArray;

	UIScrollView *mainUSV;
}

@end

@implementation XZWFortuneResultViewController


- (id)initWithAstroID:(int)theID {
	self = [super init];
	if (self) {
		// Custom initialization
		astroID = theID;

		fortuneArray = [[NSMutableArray alloc]  init];
	}
	return self;
}

- (void)dealloc {
	[fortuneArray  release];
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)loadData {
	request = [XZWNetworkManager asiWithLink:[NSString stringWithFormat:@"%@%d", XZWGetFortune, astroID] postDic:nil completionBlock: ^{
	    NSArray *responseArray = [[request responseString] objectFromJSONString];

	    [fortuneArray setArray:responseArray];

	    NSArray *titleArray = @[@"今日", @"明日", @"本周", @"本月", @"今年", @"爱情", ];

	    UIButton *tempBtn;

	    for (int i = 0; i < 6; i++) {
	        UIButton *fortuneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	        [fortuneButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
	        fortuneButton.frame = CGRectMake(i * 53.3, 0, 53.3, 44);
	        [fortuneButton addTarget:self action:@selector(switchFortuneBtn:) forControlEvents:UIControlEventTouchUpInside];
	        fortuneButton.tag =  i + 1;
	        [self.view addSubview:fortuneButton];


	        if (i == 0) {
	            tempBtn = fortuneButton;
			}
		}


	    arrowView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, 53.3, 10)];
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



	    mainUSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 64 - 44)];
	    mainUSV.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
	    [self.view addSubview:mainUSV];
	    [mainUSV release];


	    //[self initView:responseArray];

	    [self switchFortuneBtn:tempBtn];
	} failedBlock: ^{
	    [fortuneArray  removeAllObjects];

	    NSLog(@"failedBlock");
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.title =  [NSString stringWithFormat:@"%@运势", [[XZWZodiacData getSignArray] objectAtIndex:astroID - 1]];

	self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c]; //[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];



	[self loadData];
}

- (void)initMyView {
	// [dataArray[selectedItem][@"index"][0][@"star"]  intValue]


	CGFloat height = 15.f;

	for (int i = 0; i < [fortuneArray[selectedItem][@"index"] count]; i++) {
		UILabel *tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(i % 2 == 0 ? 10 : 175,  height, 200, 25)];
		[tipsUL setText:[NSString stringWithFormat:@"%@:", fortuneArray[selectedItem][@"index"][i][@"title"]]];
		tipsUL.textColor = [UIColor grayColor];
		tipsUL.font = [UIFont systemFontOfSize:14];
		tipsUL.backgroundColor = [UIColor clearColor];
		[mainUSV addSubview:tipsUL];
		[tipsUL release];


		if ([@"" isEqualToString: fortuneArray[selectedItem][@"index"][i][@"star"]]) {
			UILabel *resultUL = [[UILabel alloc] initWithFrame:CGRectMake(i % 2 == 0 ? 55 : 215, height, 200, 25)];
			resultUL.textColor = [UIColor grayColor];
			resultUL.text = fortuneArray[selectedItem][@"index"][i][@"val"];
			resultUL.font = [UIFont systemFontOfSize:14];
			resultUL.backgroundColor = [UIColor clearColor];
			[mainUSV addSubview:resultUL];
			[resultUL release];
		}
		else {
			XZWStarView *starview = [[XZWStarView alloc] initWithFrame:CGRectMake(i % 2 == 0 ? 55 : 215, height + 7, 70, 15) star:[fortuneArray[selectedItem][@"index"][i][@"star"]  intValue]];
			[mainUSV addSubview:starview];
			[starview release];
		}



		if (i % 2 != 0) {
			height = CGRectGetMaxY(tipsUL.frame);
		}
		else {
			if (i == [fortuneArray[selectedItem][@"index"] count] - 1) {
				height = CGRectGetMaxY(tipsUL.frame);
			}
		}
	}


	if (height != 15.f) {
		height += 10;

		UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_line"]];
		lineView.frame = CGRectMake(0, height, 320, 1);
		[mainUSV addSubview:lineView];
		[lineView release];


		height += 10;
	}



	for (int i = 0; i < [fortuneArray[selectedItem][@"data"] count]; i++) {
		UILabel *tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, height, 200, 25)];
		tipsUL.text = fortuneArray[selectedItem][@"data"][i][@"title"];
		tipsUL.textColor = [XZWUtil xzwRedColor];
		tipsUL.font = [UIFont systemFontOfSize:14];
		tipsUL.backgroundColor = [UIColor clearColor];
		[mainUSV addSubview:tipsUL];
		[tipsUL release];



		UILabel *resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipsUL.frame), 300, 1000)];
		resultUL.textColor = [UIColor grayColor];
		resultUL.font = [UIFont systemFontOfSize:14];
		resultUL.numberOfLines = 0;
		resultUL.text = fortuneArray[selectedItem][@"data"][i][@"val"];
		resultUL.backgroundColor = [UIColor clearColor];
		[mainUSV addSubview:resultUL];
		[resultUL release];
		[resultUL  sizeToFit];


		height = CGRectGetMaxY(resultUL.frame) + 25;
	}




	[mainUSV setContentSize:CGSizeMake(320, height + 10)];
}

- (void)initView:(NSArray *)dataArray {
	UILabel *tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 25)];
	[tipsUL setText:@"综合运势:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];


	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(170, 15, 200, 25)];
	[tipsUL setText:@"爱情运势:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 200, 25)];
	[tipsUL setText:@"工作状况:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(170, 40, 200, 25)];
	[tipsUL setText:@"理财投资:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];



	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 200, 25)];
	[tipsUL setText:@"健康指数:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(170, 65, 200, 25)];
	[tipsUL setText:@"商谈指数:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 200, 25)];
	[tipsUL setText:@"幸运颜色:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(170, 90, 200, 25)];
	[tipsUL setText:@"幸运数字:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, 200, 25)];
	[tipsUL setText:@"健康指数:"];
	tipsUL.textColor = [UIColor grayColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];


	UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ys_line"]];
	lineView.frame = CGRectMake(0, 150, 320, 1);
	[mainUSV addSubview:lineView];
	[lineView release];


	XZWStarView *starview = [[XZWStarView alloc] initWithFrame:CGRectMake(75, 22, 70, 15) star:[dataArray[selectedItem][@"index"][0][@"star"]  intValue]];
	[mainUSV addSubview:starview];
	[starview release];

	starview = [[XZWStarView alloc] initWithFrame:CGRectMake(235, 22, 70, 15) star:[dataArray[selectedItem][@"index"][1][@"star"]  intValue]];
	[mainUSV addSubview:starview];
	[starview release];

	starview = [[XZWStarView alloc] initWithFrame:CGRectMake(75, 47, 70, 15) star:[dataArray[selectedItem][@"index"][2][@"star"]  intValue]];
	[mainUSV addSubview:starview];
	[starview release];

	starview = [[XZWStarView alloc] initWithFrame:CGRectMake(235, 47, 70, 15) star:[dataArray[selectedItem][@"index"][3][@"star"]  intValue]];
	[mainUSV addSubview:starview];
	[starview release];

	UILabel *resultUL = [[UILabel alloc] initWithFrame:CGRectMake(75, 65, 200, 25)];
	resultUL.textColor = [UIColor grayColor];
	resultUL.text = dataArray[selectedItem][@"index"][4][@"val"];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:resultUL];
	[resultUL release];


	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(235, 65, 200, 25)];
	resultUL.textColor = [UIColor grayColor];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.text = dataArray[selectedItem][@"index"][5][@"val"];
	resultUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:resultUL];
	[resultUL release];


	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(75, 90, 200, 25)];
	resultUL.textColor = [UIColor grayColor];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.text = dataArray[selectedItem][@"index"][6][@"val"];
	resultUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:resultUL];
	[resultUL release];

	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(235, 90, 200, 25)];
	[resultUL setText:@"健康指数:"];
	resultUL.textColor = [UIColor grayColor];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.text = dataArray[selectedItem][@"index"][7][@"val"];
	resultUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:resultUL];
	[resultUL release];



	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(75, 115, 200, 25)];
	[resultUL setText:@"速配星座:"];
	resultUL.textColor = [UIColor grayColor];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.text = dataArray[selectedItem][@"index"][8][@"val"];
	resultUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:resultUL];
	[resultUL release];


	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 165, 200, 25)];
	tipsUL.text = @"运势概述:";
	tipsUL.textColor = [XZWUtil xzwRedColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];


	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 190, 300, 1000)];
	resultUL.textColor = [UIColor grayColor];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.text = dataArray[selectedItem][@"data"][0][@"val"];
	resultUL.numberOfLines = 0;
	resultUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:resultUL];
	[resultUL release];
	[resultUL  sizeToFit];


	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 25, 200, 25)];
	tipsUL.text = @"爱情运势:";
	tipsUL.textColor = [XZWUtil xzwRedColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];



	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipsUL.frame), 300, 1000)];
	resultUL.textColor = [UIColor grayColor];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.text = dataArray[selectedItem][@"data"][1][@"val"];
	resultUL.backgroundColor = [UIColor clearColor];
	resultUL.numberOfLines = 0;
	[mainUSV addSubview:resultUL];
	[resultUL release];
	[resultUL  sizeToFit];


	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 25, 200, 25)];
	tipsUL.text = @"事业学业:";
	tipsUL.textColor = [XZWUtil xzwRedColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];



	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipsUL.frame), 300, 1000)];
	resultUL.textColor = [UIColor grayColor];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.text = dataArray[selectedItem][@"data"][2][@"val"];
	resultUL.backgroundColor = [UIColor clearColor];
	resultUL.numberOfLines = 0;
	[mainUSV addSubview:resultUL];
	[resultUL release];
	[resultUL  sizeToFit];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(resultUL.frame) + 25, 200, 25)];
	tipsUL.text = @"财富运势:";
	tipsUL.textColor = [XZWUtil xzwRedColor];
	tipsUL.font = [UIFont systemFontOfSize:14];
	tipsUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:tipsUL];
	[tipsUL release];



	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tipsUL.frame), 300, 1000)];
	resultUL.textColor = [UIColor grayColor];
	resultUL.font = [UIFont systemFontOfSize:14];
	resultUL.numberOfLines = 0;
	resultUL.text = dataArray[selectedItem][@"data"][3][@"val"];
	resultUL.backgroundColor = [UIColor clearColor];
	[mainUSV addSubview:resultUL];
	[resultUL release];
	[resultUL  sizeToFit];


	[mainUSV setContentSize:CGSizeMake(320, CGRectGetMaxY(resultUL.frame) + 10)];
}

#pragma mark -

- (void)switchFortuneBtn:(UIButton *)button {
	[UIView animateWithDuration:.3f animations: ^{ arrowView.frame =  CGRectMake((button.tag - 1) * 53.3, 35, 53.3, 10); }];

	selectedItem = button.tag - 1;

	for (UIView *subview in[mainUSV subviews]) {
		[subview removeFromSuperview];
		subview = nil;
	}

	[self initMyView];
	//[self initView:fortuneArray];
}

- (void)goBack {
	[XZWNetworkManager cancelAndReleaseRequest:request];

	[self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
