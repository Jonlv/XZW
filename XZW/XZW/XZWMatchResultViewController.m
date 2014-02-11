//
//  XZWMatchResultViewController.m
//  XZW
//
//  Created by dee on 13-9-3.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMatchResultViewController.h"
#import "JSONKit.h"
#import "XZWUtil.h"

@interface XZWMatchResultViewController () {
	int boy;
	int girl;

	UIScrollView *mainUSV;

	NSMutableDictionary *matchDic;
}

@end

@implementation XZWMatchResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (id)initWithBoyIndex:(int)boyIndex :(int)girlIndex {
	self = [super init];
	if (self) {
		// Custom initialization


		boy = boyIndex;
		girl = girlIndex;


		matchDic = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc {
	[matchDic  release];
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
	    [self loadData];


	    dispatch_async(dispatch_get_main_queue(), ^{
	        [self initView];
		});
	});
}

- (void)initView {
	self.title = [NSString stringWithFormat:@"%@男对%@女", [[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:0], [[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:1]];

	mainUSV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:mainUSV];
	[mainUSV release];



	UIImageView *backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 85)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[mainUSV addSubview:backgroundUIV];
	[backgroundUIV release];

	UILabel *tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 100, 25)];
	[tipsUL setBackgroundColor:[UIColor clearColor]];
	[tipsUL setText:@"配对指数:"];
	[tipsUL setTextColor:[XZWUtil xzwRedColor]];
	[backgroundUIV addSubview:tipsUL];
	[tipsUL release];


	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 200, 25)];
	[tipsUL setBackgroundColor:[UIColor clearColor]];
	[tipsUL setText:@"天长地久指数:"];
	[tipsUL setTextColor:[XZWUtil xzwRedColor]];
	[backgroundUIV addSubview:tipsUL];
	[tipsUL release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, 200, 25)];
	[tipsUL setBackgroundColor:[UIColor clearColor]];
	[tipsUL setText:@"配对比重:"];
	[tipsUL setTextColor:[XZWUtil xzwRedColor]];
	[backgroundUIV addSubview:tipsUL];
	[tipsUL release];


	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(150, 30, 200, 25)];
	[tipsUL setBackgroundColor:[UIColor clearColor]];
	[tipsUL setText:@"两情相悦指数:"];
	[tipsUL setTextColor:[XZWUtil xzwRedColor]];
	[backgroundUIV addSubview:tipsUL];
	[tipsUL release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 55, 200, 25)];
	[tipsUL setBackgroundColor:[UIColor clearColor]];
	[tipsUL setText:@"结果评述:"];
	[tipsUL setTextColor:[XZWUtil xzwRedColor]];
	[backgroundUIV addSubview:tipsUL];
	[tipsUL release];

	UILabel *resultUL = [[UILabel alloc] initWithFrame:CGRectMake(83, 5, 200, 25)];
	[resultUL setBackgroundColor:[UIColor clearColor]];
	[resultUL setText:[[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:2]];
	[resultUL setTextColor:[UIColor grayColor]];
	[backgroundUIV addSubview:resultUL];
	[resultUL  release];

	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(259, 5, 200, 25)];
	[resultUL setBackgroundColor:[UIColor clearColor]];
	[resultUL setText:[[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:5]];
	[resultUL setTextColor:[UIColor grayColor]];
	[backgroundUIV addSubview:resultUL];
	[resultUL  release];


	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(83, 30, 200, 25)];
	[resultUL setBackgroundColor:[UIColor clearColor]];
	[resultUL setText:[[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:3]];
	[resultUL setTextColor:[UIColor grayColor]];
	[backgroundUIV addSubview:resultUL];
	[resultUL  release];


	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(259, 30, 200, 25)];
	[resultUL setBackgroundColor:[UIColor clearColor]];
	[resultUL setText:[[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:4]];
	[resultUL setTextColor:[UIColor grayColor]];
	[backgroundUIV addSubview:resultUL];
	[resultUL  release];


	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(83, 55, 200, 25)];
	[resultUL setBackgroundColor:[UIColor clearColor]];
	[resultUL setText:[[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:6]];
	[resultUL setTextColor:[UIColor grayColor]];
	resultUL.adjustsFontSizeToFitWidth = true;
	[backgroundUIV addSubview:resultUL];
	[resultUL  release];


	backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 105, 300, 95)];
	backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
	[mainUSV addSubview:backgroundUIV];
	[backgroundUIV release];

	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 25)];
	[tipsUL setBackgroundColor:[UIColor clearColor]];
	[tipsUL setText:@"恋爱建议:"];
	[tipsUL setTextColor:[XZWUtil xzwRedColor]];
	[backgroundUIV addSubview:tipsUL];
	[tipsUL release];


	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, 280, 25)];
	[resultUL setBackgroundColor:[UIColor clearColor]];
	resultUL.numberOfLines = 0;
	resultUL.font = [UIFont systemFontOfSize:15];
	[resultUL setText:[@"                    " stringByAppendingString :[[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:7]]];
	[resultUL setTextColor:[UIColor grayColor]];
	[backgroundUIV addSubview:resultUL];
	[resultUL sizeThatFits:CGSizeMake(280, 2000)];
	[resultUL  release];
	[resultUL   sizeToFit];



	tipsUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(resultUL.frame) + 23, 200, 25)];
	tipsUL.numberOfLines = 0;
	[tipsUL setBackgroundColor:[UIColor clearColor]];
	[tipsUL setText:@"注意事项:"];
	[tipsUL setTextColor:[XZWUtil xzwRedColor]];
	[backgroundUIV addSubview:tipsUL];
	[tipsUL release];


	resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(resultUL.frame) + 26, 280, 25)];
	resultUL.numberOfLines = 0;
	resultUL.font = [UIFont systemFontOfSize:15];
	[resultUL setBackgroundColor:[UIColor clearColor]];
	[resultUL setText:[@"                    " stringByAppendingString :[[[matchDic objectForKey:[NSString stringWithFormat:@"%d", boy + 1]] objectAtIndex:girl] objectAtIndex:8]]];
	[resultUL setTextColor:[UIColor grayColor]];
	[backgroundUIV addSubview:resultUL];
	[resultUL sizeThatFits:CGSizeMake(280, 2000)];
	[resultUL  release];
	[resultUL   sizeToFit];



	backgroundUIV.frame = CGRectMake(10, 105, 300, CGRectGetMaxY(resultUL.frame) + 10);


	[mainUSV setContentSize:CGSizeMake(320, CGRectGetMaxY(backgroundUIV.frame) + 15)];
}

- (void)goBack {
	[self.navigationController popViewControllerAnimated:true];
}

- (void)loadData {
	[matchDic setDictionary:[[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Match" ofType:nil] encoding:NSUTF8StringEncoding error:nil] objectFromJSONString]];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
