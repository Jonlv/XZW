//
//  XZWQuanViewController.m
//  XZW
//
//  Created by dee on 13-9-24.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWQuanViewController.h"
#import "IIViewDeckController.h"
#import "XZWUtil.h"
#import "Interface.h"
#import "XZWQuanList.h"
#import "XZWQuanDetailViewController.h"
#import "XZWMyProfileViewController.h"
#import "XZWCreateQuanViewController.h"
#import "GoodsGalleryViewController.h"
#import "XZWMyProfileViewController.h"
#import "XZWIssueDetailViewController.h"
#import "XZWQuanFeedView.h"

@interface XZWQuanViewController () <XZWQuanTableClickDelegate, QuanFeedViewDelegate> {
	UIView *arrowView;

	XZWQuanList *quanList;

	XZWQuanList *recommandQuanList;

	XZWQuanFeedView *quanFeedView;
    BOOL shouldUpdateQuanList;
}

@end

@implementation XZWQuanViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    if (shouldUpdateQuanList) {
        [quanList reloadFirst];
        shouldUpdateQuanList = NO;
    }
    [super viewDidAppear:animated];
}

#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.


	self.title = @"圈子";

	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


    //    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    listButton.frame = CGRectMake(0, 0, 25, 20);
    //    [listButton addTarget:self action:@selector(getMore) forControlEvents:UIControlEventTouchUpInside];
    //    [listButton setImage:[UIImage imageNamed:@"more1"] forState:UIControlStateNormal];
    //
    //
    //    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    //



	listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(addQuan) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"add2"] forState:UIControlStateNormal];


	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


	[self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMyQuan) name:kNotificationUpdateMyQuan object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
#pragma mark -

- (void)addQuan {
	XZWCreateQuanViewController *createQuan = [[XZWCreateQuanViewController alloc]  init];
	[self.navigationController pushViewController:createQuan animated:true];
	[createQuan release];
}

#pragma mark -


- (void)clickFeedMessageDic:(NSDictionary *)messageDic {
	if (messageDic[@"savepath"]) {
		GoodsGalleryViewController *ggvc = [[GoodsGalleryViewController alloc] initWithPhotoOneArray:@[messageDic] page:0];
		[self.navigationController presentModalViewController:ggvc animated:true];
		[ggvc release];
	}
	else if ([messageDic[@"big_type"]     intValue] == 2) {
		XZWIssueDetailViewController *dvc = [[XZWIssueDetailViewController alloc] initWithFeedDic:messageDic];
		[self.navigationController pushViewController:dvc animated:true];
		[dvc release];
	}
	else if ([messageDic[@"big_type"]     intValue] == 1) {
		XZWQuanDetailViewController *dvc = [[XZWQuanDetailViewController alloc] initWithQuanID:[messageDic[@"gid"]  intValue]];
		[self.navigationController pushViewController:dvc animated:true];
		[dvc release];
	}
}

#pragma mark -


- (void)initView {
	self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];

	UIButton *sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sunButton.frame = CGRectMake(0, 0, 106.2, 44);
	[sunButton addTarget:self action:@selector(myQuan) forControlEvents:UIControlEventTouchUpInside];
	[sunButton setTintColor:[UIColor grayColor]];
	[sunButton setTitle:@"我的圈" forState:UIControlStateNormal];
	[self.view addSubview:sunButton];




	sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sunButton.frame = CGRectMake(106.2, 0, 106.2, 44);
	[sunButton addTarget:self action:@selector(recommand) forControlEvents:UIControlEventTouchUpInside];
	[sunButton setTintColor:[UIColor grayColor]];
	[sunButton setTitle:@"推荐圈" forState:UIControlStateNormal];
	[self.view addSubview:sunButton];


	sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
	sunButton.frame = CGRectMake(213, 0, 106.2, 44);
	[sunButton addTarget:self action:@selector(dymanic) forControlEvents:UIControlEventTouchUpInside];
	[sunButton setTintColor:[UIColor grayColor]];
	[sunButton setTitle:@"圈动态" forState:UIControlStateNormal];
	[self.view addSubview:sunButton];


	arrowView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, 100, 10)];
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


	quanFeedView = [[XZWQuanFeedView alloc] initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 108) andLinkString:XZWQuanDt];
	quanFeedView.delegate = self;
	[self.view addSubview:quanFeedView];
	[quanFeedView release];


	recommandQuanList =  [[XZWQuanList alloc] initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 108) andLinkString:[XZWQuanZiList stringByAppendingString:@"&type=recom"]];
	recommandQuanList.delegate = self;
	[self.view addSubview:recommandQuanList];
	[recommandQuanList release];


	quanList = [[XZWQuanList alloc] initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 108) andLinkString:[XZWQuanZiList stringByAppendingString:@"&type=my"]];
	quanList.delegate = self;
	[self.view addSubview:quanList];
	[quanList release];
}

- (void)myQuan {
    if (shouldUpdateQuanList) {
        [quanList reloadFirst];
        shouldUpdateQuanList = NO;
    }
	[UIView animateWithDuration:.3f animations: ^{ arrowView.frame =  CGRectMake(0, 35, 100, 10); }];

	[self.view bringSubviewToFront:quanList];
}

- (void)recommand {
	[UIView animateWithDuration:.3f animations: ^{ arrowView.frame =  CGRectMake(110, 35, 100, 10); }];

	[self.view bringSubviewToFront:recommandQuanList];
}

- (void)dymanic {
	[UIView animateWithDuration:.3f animations: ^{ arrowView.frame =  CGRectMake(220, 35, 100, 10); }];

	[self.view bringSubviewToFront:quanFeedView];
}

- (void)selectQuanID:(int)quanID {
	XZWQuanDetailViewController *quanDVC = [[XZWQuanDetailViewController alloc] initWithQuanID:quanID];
	[self.navigationController pushViewController:quanDVC animated:true];
	[quanDVC release];
}

- (void)toggleView {
	[self.navigationController.viewDeckController toggleLeftViewAnimated:true];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)updateMyQuan
{
    shouldUpdateQuanList = YES;
}
@end
