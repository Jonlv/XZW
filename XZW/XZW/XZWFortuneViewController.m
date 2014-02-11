//
//  XZWFortuneViewController.m
//  XZW
//
//  Created by Dee on 13-8-27.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWFortuneViewController.h"
#import "XZWUtil.h"
#import "XZWFortuneResultViewController.h"
#import "IIViewDeckController.h"

@interface XZWFortuneViewController ()

@end

@implementation XZWFortuneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"今日运势";

	[self initView];

	// Do any additional setup after loading the view.
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


	NSArray *astroArray = @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];

	NSArray *astroPicArray =  @[@"baiyang", @"jinniu", @"shuangzi", @"juxie", @"shizi", @"chunv", @"tiancheng", @"tianxie", @"sheshou", @"mojie", @"shuiping", @"shuangyu"];

	for (int i = 0; i < 12; i++) {
		UIImage *astroUI = [UIImage imageNamed:[astroPicArray objectAtIndex:i]];

		CGFloat width = CGImageGetWidth(astroUI.CGImage);
		CGFloat height = CGImageGetHeight(astroUI.CGImage);

		UIButton *astroButton = [UIButton buttonWithType:UIButtonTypeCustom];
		astroButton.frame = CGRectMake(0, 0, width, height);
		astroButton.center = CGPointMake(i % 3  *  107  + 53, 50 + 100 * (i / 3));
		[astroButton addTarget:self action:@selector(astroAction:) forControlEvents:UIControlEventTouchUpInside];
		astroButton.tag = i + 1;
		[astroButton setImage:astroUI forState:UIControlStateNormal];
		[astroButton setTitleColor:[XZWUtil xzwRedColor] forState:UIControlStateNormal];
		[astroButton setTitleEdgeInsets:UIEdgeInsetsMake(height, 0, 0, 0)];
		[self.view addSubview:astroButton];



		UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(i % 3  *  107  + 70,  50 + 100 * (i / 3), 100, 30)];
		descLabel.text = [astroArray objectAtIndex:i];
		descLabel.font = [UIFont boldSystemFontOfSize:15];
		descLabel.center = CGPointMake(i % 3  *  107  + 53, 99 + 100 * (i / 3));
		descLabel.textAlignment = UITextAlignmentCenter;
		descLabel.backgroundColor = [UIColor clearColor];
		descLabel.textColor = [XZWUtil xzwRedColor];
		[self.view addSubview:descLabel];
		[descLabel release];
	}




	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];
}

#pragma mark -

- (void)astroAction:(UIButton *)sender {
	XZWFortuneResultViewController *resultViewController = [[XZWFortuneResultViewController alloc] initWithAstroID:sender.tag];
	[self.navigationController pushViewController:resultViewController animated:true];
	[resultViewController release];
}

- (void)toggleView {
	[self.navigationController.viewDeckController toggleLeftViewAnimated:true];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
