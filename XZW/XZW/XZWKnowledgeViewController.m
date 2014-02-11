//
//  XZWKnowledgeViewController.m
//  XZW
//
//  Created by dee on 13-10-17.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWKnowledgeViewController.h"
#import "IIViewDeckController.h"
#import "XZWKnowledgeDetailViewController.h"
#import "RCLabel.h"
#import "XZWDBOperate.h"
#import "XZWKnowledgeCollectionViewController.h"
#import "XZWNetworkManager.h"

@interface XZWKnowledgeViewController () {
	ASIHTTPRequest *getKnowledgeRequest;

	int count;

	RCLabel *tempLabel;
}

@end

@implementation XZWKnowledgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
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

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	self.title = @"知识";

	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCollectCount) name:XZWChangeCollectNotification object:nil];


	[self initView];
}

- (void)initView {
	UILabel *astroUL = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 30)];
	astroUL.textColor = [UIColor grayColor];
	astroUL.text = @"星座";
	astroUL.textAlignment = UITextAlignmentCenter;
	astroUL.backgroundColor = [UIColor clearColor];
	[self.view addSubview:astroUL];
	[astroUL release];

	UIImageView *backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 300, 100)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12]; backgroundUIV.userInteractionEnabled = true;
	[self.view addSubview:backgroundUIV];
	[backgroundUIV release];

	NSArray *dataArray = @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];


	for (int i = 0; i < [dataArray  count]; i++) {
		UIButton *knowledgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[knowledgeButton addTarget:self action:@selector(knowlegdeAction:) forControlEvents:UIControlEventTouchUpInside];
		knowledgeButton.tag = i;
		[knowledgeButton setTitle:dataArray[i] forState:UIControlStateNormal];
		[knowledgeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		knowledgeButton.frame = CGRectMake((i % 4) * 75, 5 + (i / 4) * 30, 75, 30);
		[backgroundUIV addSubview:knowledgeButton];

		NSArray *tagArray = @[@"25", @"24", @"23", @"28", @"27", @"29", @"30", @"31", @"32", @"33", @"34", @"35"];
		knowledgeButton.tag = [tagArray[i]    intValue];
	}

	astroUL = [[UILabel alloc] initWithFrame:CGRectMake(0, 135, 320, 30)];
	astroUL.textColor = [UIColor grayColor];
	astroUL.text = @"生肖";
	astroUL.textAlignment = UITextAlignmentCenter;
	astroUL.backgroundColor = [UIColor clearColor];
	[self.view addSubview:astroUL];
	[astroUL release];


	backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 165, 300, 100)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	backgroundUIV.userInteractionEnabled = true;
	[self.view addSubview:backgroundUIV];
	[backgroundUIV release];

	dataArray = @[@"子鼠", @"丑牛", @"寅虎", @"卯兔", @"辰龙", @"巳蛇",  @"午马", @"未羊", @"申猴", @"酉鸡", @"戌狗", @"亥猪"];

	for (int i = 0; i < [dataArray  count]; i++) {
		UIButton *knowledgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[knowledgeButton addTarget:self action:@selector(knowlegdeAction:) forControlEvents:UIControlEventTouchUpInside];
		knowledgeButton.tag = i;
		[knowledgeButton setTitle:dataArray[i] forState:UIControlStateNormal];
		[knowledgeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		knowledgeButton.frame = CGRectMake((i % 4) * 75, 5 +  (i / 4) * 30, 75, 30);
		[backgroundUIV addSubview:knowledgeButton];

		NSArray *tagArray = @[@"36", @"37", @"38", @"39", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47"];
		knowledgeButton.tag = [tagArray[i]    intValue];
	}



	astroUL = [[UILabel alloc] initWithFrame:CGRectMake(0, 265, 320, 30)];
	astroUL.textColor = [UIColor grayColor];
	astroUL.text = @"血型";
	astroUL.textAlignment = UITextAlignmentCenter;
	astroUL.backgroundColor = [UIColor clearColor];
	[self.view addSubview:astroUL];
	[astroUL release];


	backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 295, 300, 40)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12]; backgroundUIV.userInteractionEnabled = true;
	[self.view addSubview:backgroundUIV];
	[backgroundUIV release];

	dataArray = @[@"A型", @"B型", @"O型", @"AB型"];

	for (int i = 0; i < [dataArray  count]; i++) {
		UIButton *knowledgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[knowledgeButton addTarget:self action:@selector(knowlegdeAction:) forControlEvents:UIControlEventTouchUpInside];
		knowledgeButton.tag = i;
		[knowledgeButton setTitle:dataArray[i] forState:UIControlStateNormal];
		[knowledgeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		knowledgeButton.frame = CGRectMake((i % 4) * 75, 5 + (i / 4) * 30, 75, 30);
		[backgroundUIV addSubview:knowledgeButton];

		NSArray *tagArray = @[@"48", @"49", @"50", @"51", @"40", @"41", @"42", @"43", @"44", @"45", @"46", @"47"];
		knowledgeButton.tag = [tagArray[i]    intValue];
	}




	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]) {
		[self loadCollectCount];
	}
}

- (void)loadCollectCount {
	getKnowledgeRequest = [XZWNetworkManager asiWithLink:[NSString stringWithFormat:@"%@%@", XZWGetCount, [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]] postDic:nil completionBlock: ^{
	    if (tempLabel) {
	        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[NSString stringWithFormat:@" <font size=17 color='#919191'> 已收藏<font><font size=17 color='#e14278'>%@</font><font size=17 color='#919191'>条知识 <font>", [[getKnowledgeRequest   responseString]  objectFromJSONString][@"mycount"]]];
	        tempLabel.userInteractionEnabled = false;
	        tempLabel.componentsAndPlainText = componentsDS;
		}
	    else {
	        UIButton *collectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
	        collectedButton.frame = CGRectMake(8, 365, 303, 35);
	        [collectedButton setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
	        [collectedButton addTarget:self action:@selector(collectAction) forControlEvents:UIControlEventTouchUpInside];
	        [self.view addSubview:collectedButton];

	        UILabel *astroUL = [[UILabel alloc] initWithFrame:CGRectMake(0, 335, 320, 30)];
	        astroUL.textColor = [UIColor grayColor];
	        astroUL.text = @"喜欢的知识";
	        astroUL.textAlignment = UITextAlignmentCenter;
	        astroUL.backgroundColor = [UIColor clearColor];
	        [self.view addSubview:astroUL];
	        [astroUL release];


	        tempLabel = [[RCLabel alloc] initWithFrame:CGRectMake(8, 370, 303, 35)];
	        RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle:[NSString stringWithFormat:@" <font size=17 color='#919191'> 已收藏<font><font size=17 color='#e14278'>%@</font><font size=17 color='#919191'>条知识 <font>", [[getKnowledgeRequest   responseString]  objectFromJSONString][@"mycount"]]];
	        tempLabel.userInteractionEnabled = false;
	        tempLabel.componentsAndPlainText = componentsDS;
	        [self.view addSubview:tempLabel];
	        [tempLabel release];
		}
	} failedBlock: ^{}];
}

- (void)collectAction {
	XZWKnowledgeDetailViewController *xzwVC = [[XZWKnowledgeDetailViewController alloc]  initForCollection];
	[self.navigationController pushViewController:xzwVC animated:true];
	[xzwVC release];
}

- (void)knowlegdeAction:(UIButton *)action {
	XZWKnowledgeDetailViewController *detailVC = [[XZWKnowledgeDetailViewController alloc] initKnowledgeDic:@{ @"id":[NSString stringWithFormat:@"%d", action.tag], @"name": [NSString stringWithFormat:@"%@", action.titleLabel.text] }];
	[self.navigationController pushViewController:detailVC animated:true];
	[detailVC release];
}

- (void)toggleView {
	[self.navigationController.viewDeckController toggleLeftViewAnimated:true];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
