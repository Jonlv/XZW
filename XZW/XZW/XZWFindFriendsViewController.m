//
//  XZWFindFriendsViewController.m
//  XZW
//
//  Created by dee on 13-9-18.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWFindFriendsViewController.h"
#import "XZWNetworkManager.h"
#import "Interface.h"
#import "JSONKit.h"
#import "XZWSelectAstroView.h"
#import "IIViewDeckController.h"
#import "XZWFindFriendsResultViewController.h"


@interface XZWFindFriendsViewController () <XZWSelectAstroViewDelegate> {
	UITextField *mFrientIDUTF, *mFriendNicknameUTF;
	UILabel *astroUL;
	ASIHTTPRequest *loginRequest;
	int astroTag;
	XZWSelectAstroView *selectAstr;
}

@end

@implementation XZWFindFriendsViewController

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

	self.title =  @"查找好友";

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	[self initView];

	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


	listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(seeResult) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];


	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];
}

- (void)toggleView {
	[self.view endEditing:true];

	[self.navigationController.viewDeckController toggleLeftView];
}

- (void)seeResult {

	XZWFindFriendsResultViewController *xffr = nil;


	if (![[mFrientIDUTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
		xffr = [[XZWFindFriendsResultViewController alloc] initWithString:mFrientIDUTF.text andType:0];
	}
	else if (![[mFriendNicknameUTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
		xffr = [[XZWFindFriendsResultViewController alloc] initWithString:mFriendNicknameUTF.text andType:1];
	}
	else {
		xffr = [[XZWFindFriendsResultViewController alloc] initWithString:[NSString stringWithFormat:@"%d", astroTag] andType:2];
	}


	[self.navigationController pushViewController:xffr animated:true];
	[xffr release];
}

- (void)initView {
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];


	UILabel *emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 320, 25)];
	emailUL.text = @"输入好友ID查找";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];

	UIImageView *utfBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registbox"]];
	utfBackground.frame = CGRectMake(20, 50, 278, 32);
	[self.view addSubview:utfBackground];
	[utfBackground release];

	mFrientIDUTF = [[UITextField alloc] initWithFrame:CGRectMake(25, 55, 220, 22)];
	mFrientIDUTF.text = @"";
	mFrientIDUTF.returnKeyType = UIReturnKeyDone;
	mFrientIDUTF.delegate = self;
	mFrientIDUTF.keyboardType  = UIKeyboardTypeNumberPad;
	mFrientIDUTF.backgroundColor = [UIColor clearColor];
	[self.view addSubview:mFrientIDUTF];
	[mFrientIDUTF release];



	emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 320, 25)];
	emailUL.text = @"输入好友昵称查找";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];

	utfBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registbox"]];
	utfBackground.frame = CGRectMake(20, 115, 278, 32);
	[self.view addSubview:utfBackground];
	[utfBackground release];

	mFriendNicknameUTF = [[UITextField alloc] initWithFrame:CGRectMake(25, 120, 190, 22)];
	mFriendNicknameUTF.text = @"";
	mFriendNicknameUTF.returnKeyType = UIReturnKeyDone;
	mFriendNicknameUTF.delegate = self;
	mFriendNicknameUTF.backgroundColor = [UIColor clearColor];
	[self.view addSubview:mFriendNicknameUTF];
	[mFriendNicknameUTF release];



	emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, 320, 25)];
	emailUL.text = @"选择星座查找";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];

	UIButton *selectAstButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[selectAstButton setFrame:CGRectMake(20, 150 + 30, 278, 32)];
	[selectAstButton setImage:[UIImage imageNamed:@"checkf_"] forState:UIControlStateNormal];
	[selectAstButton addTarget:self action:@selector(savedAstrolabe) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:selectAstButton];

	astroUL = [[UILabel alloc] initWithFrame:CGRectMake(25, 150 + 30, 278, 32)];
	astroUL.backgroundColor = [UIColor clearColor];
	astroUL.textColor = [UIColor grayColor];
	astroUL.text = @"白羊座";
	[self.view addSubview:astroUL];
	[astroUL release];



	selectAstr = [[XZWSelectAstroView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	selectAstr.alpha = 0.f;
	selectAstr.delegate = self;
	[self.view addSubview:selectAstr];
	[selectAstr release];

    //    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    loginButton.frame = CGRectMake(129, 163, 64, 24);
    //    [loginButton  setBackgroundImage:[UIImage imageNamed:@"regist" ] forState:UIControlStateNormal];
    //    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [loginButton   setTitle:@"登录" forState:UIControlStateNormal];
    //    [loginButton  addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:loginButton];
    //
    //    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    loginButton.frame = CGRectMake(25, 163, 64, 24);
    //    [loginButton  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    //    [loginButton   setTitle:@"点击注册" forState:UIControlStateNormal];
    //    [loginButton  addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:loginButton];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:true];
}

#pragma mark -


- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (textField == mFrientIDUTF) {
		mFriendNicknameUTF.text = @"";
	}
	else {
		mFrientIDUTF.text = @"";
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:true];

	return true;
}

#pragma mark -

- (void)selectAstro:(XZWSelectAstroView *)astroView selectedAstro:(int)selectedAstro name:(NSString *)nameString {
	astroUL.text = nameString;
	astroTag = selectedAstro;
}

- (void)savedAstrolabe {
	mFriendNicknameUTF.text = @"";
	mFrientIDUTF.text = @"";
	[self.view endEditing:true];

	[selectAstr playAnimate];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
