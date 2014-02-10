//
//  XZWRegisterViewController.m
//  XZW
//
//  Created by dee on 13-9-9.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWRegisterViewController.h"
#import "JSONKit.h"

@interface XZWRegisterViewController () {
	UITextField *nicknameUTF, *emailUTF, *passwordUTF, *repasswordUTF;
	UILabel *bornUL;
	NSDate *birthDate;

	XZWSelectDateView *normalSDV;
	ASIHTTPRequest *registerRequest;

    CGRect mOriginFrame;
}

@end

@implementation XZWRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)viewDidLoad {
	self.title =  @"注册";

	[super viewDidLoad];


	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];
	[self initView];

	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    mOriginFrame = self.view.frame;
}

- (void)goBack {
	[self.navigationController popViewControllerAnimated:true];
}

- (void)initView {
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];



	UILabel *emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 320, 25)];
	emailUL.text = @"昵称";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];

	UIImageView *utfBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registbox"]];
	utfBackground.frame = CGRectMake(20, 50, 278, 32);
	[self.view addSubview:utfBackground];
	[utfBackground release];

	nicknameUTF = [[UITextField alloc] initWithFrame:CGRectMake(25, 55, 220, 22)];
	nicknameUTF.text = @"";
	nicknameUTF.returnKeyType = UIReturnKeyDone;
	nicknameUTF.delegate = self;
	nicknameUTF.backgroundColor = [UIColor clearColor];
	[self.view addSubview:nicknameUTF];
	[nicknameUTF release];




	emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 90, 320, 25)];
	emailUL.text = @"邮箱";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];



	utfBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registbox"]];
	utfBackground.frame = CGRectMake(20, 115, 278, 32);
	[self.view addSubview:utfBackground];
	[utfBackground release];

	emailUTF = [[UITextField alloc] initWithFrame:CGRectMake(25, 120, 190, 22)];
	emailUTF.text = @"";
	emailUTF.returnKeyType = UIReturnKeyDone;
	emailUTF.delegate = self;
	emailUTF.backgroundColor = [UIColor clearColor];
	[self.view addSubview:emailUTF];
	[emailUTF release];



	emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 90 + 65, 320, 25)];
	emailUL.text = @"密码";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];



	utfBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registbox"]];
	utfBackground.frame = CGRectMake(20, 115 + 65, 278, 32);
	[self.view addSubview:utfBackground];
	[utfBackground release];

	passwordUTF = [[UITextField alloc] initWithFrame:CGRectMake(25, 120  + 65, 190, 22)];
	passwordUTF.text = @"";
	passwordUTF.returnKeyType = UIReturnKeyDone;
	passwordUTF.delegate = self;
	passwordUTF.secureTextEntry = true;
	passwordUTF.backgroundColor = [UIColor clearColor];
	[self.view addSubview:passwordUTF];
	[passwordUTF release];




	emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 90 + 65 * 2, 320, 25)];
	emailUL.text = @"再次输入密码";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];



	utfBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"registbox"]];
	utfBackground.frame = CGRectMake(20, 115 + 65 * 2, 278, 32);
	[self.view addSubview:utfBackground];
	[utfBackground release];

	repasswordUTF = [[UITextField alloc] initWithFrame:CGRectMake(25, 120  + 65 * 2, 190, 22)];
	repasswordUTF.text = @"";
	repasswordUTF.secureTextEntry = true;
	repasswordUTF.returnKeyType = UIReturnKeyDone;
	repasswordUTF.delegate = self;
	repasswordUTF.backgroundColor = [UIColor clearColor];
	[self.view addSubview:repasswordUTF];
	[repasswordUTF release];


	emailUL = [[UILabel alloc] initWithFrame:CGRectMake(20, 90 + 65 * 3, 320, 25)];
	emailUL.text = @"生日";
	emailUL.textColor = [UIColor grayColor];
	[emailUL setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:emailUL];
	[emailUL release];



	UIButton *dateButton = [[UIButton alloc]   init];
	dateButton.frame = CGRectMake(20, 115 + 65 * 3, 278, 32);
	[dateButton addTarget:self action:@selector(dateAction) forControlEvents:UIControlEventTouchUpInside];
	[dateButton setImage:[UIImage imageNamed:@"regist1box"] forState:UIControlStateNormal];
	[self.view addSubview:dateButton];
	[dateButton release];

	bornUL = [[UILabel alloc] initWithFrame:CGRectMake(25, 120  + 65 * 3, 190, 22)];
	bornUL.text = @"1990年1月12日";
	bornUL.backgroundColor = [UIColor clearColor];
	[self.view addSubview:bornUL];
	[bornUL release];


	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.frame = CGRectMake(129,  155  + 65 * 3, 64, 24);
	[loginButton setBackgroundImage:[UIImage imageNamed:@"regist"] forState:UIControlStateNormal];
	loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
	[loginButton setTitle:@"注册" forState:UIControlStateNormal];
	[loginButton addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginButton];

	normalSDV = [[XZWSelectDateView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight)];
	normalSDV.delegate = self;
	normalSDV.alpha = 0.f;
	[self.view addSubview:normalSDV];
	[normalSDV release];
}

#pragma mark -

- (void)registerAction {
	if ([nicknameUTF.text length] <= 0) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"请先输入昵称" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

		return;
	}


	if ([nicknameUTF.text length] <= 2) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"昵称太短了" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

		return;
	}

	if ([emailUTF.text length] <= 0) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"请先输入邮箱" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

		return;
	}



	if ([passwordUTF.text length] <= 0) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"请先输入密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

		return;
	}


	if ([passwordUTF.text length] < 6) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"密码长度最少为6位" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

		return;
	}




	if ([repasswordUTF.text length] <= 0) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"请先输入重复密码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

		return;
	}


	if (![self isValidateEmail:emailUTF.text]) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"邮箱输入有误" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

		return;
	}


	if (![repasswordUTF.text isEqualToString:passwordUTF.text]) {
		[[[[UIAlertView alloc] initWithTitle:nil message:@"两次密码不一致" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

		return;
	}



	NSCalendar *gregorian = [NSCalendar  currentCalendar];


	unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

	NSDateComponents *comps = [gregorian components:unitFlags fromDate:birthDate];

	int year = [comps year];
	int month = [comps month];
	int day = [comps day];

	NSLog(@"dic %@", [NSDictionary dictionaryWithObjectsAndKeys:emailUTF.text, @"email", passwordUTF.text, @"password", repasswordUTF.text, @"repassword", [NSString stringWithFormat:@"%d-%02d-%02d", year, month, day], @"birthday", [nicknameUTF.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"uname", nil]);

	registerRequest = [XZWNetworkManager asiWithLink:XZWRegister postDic:[NSDictionary dictionaryWithObjectsAndKeys:emailUTF.text, @"email", passwordUTF.text, @"password", repasswordUTF.text, @"repassword", [NSString stringWithFormat:@"%d-%02d-%02d", year, month, day], @"birthday", [nicknameUTF.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"uname", nil] completionBlock: ^{
	    NSDictionary *responceDic = [[registerRequest responseString]   objectFromJSONString];



	    if ([[responceDic objectForKey:@"status"]   intValue] == 0) {
	        [[[[UIAlertView alloc] initWithTitle:nil message:[responceDic objectForKey:@"info"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];
		}
	    else {
	        [[[[UIAlertView alloc] initWithTitle:nil message:[responceDic objectForKey:@"info"] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease]  show];

	        [self goBack];
		}
	} failedBlock:nil];
}

- (BOOL)isValidateEmail:(NSString *)email {
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:email];
}

#pragma mark - xzwselectdate


- (void)dateAction {
	[self.view endEditing:true];


	[UIView animateWithDuration:.3f animations: ^{
	    self.view.frame = mOriginFrame;
	}];

	[normalSDV playAnimate];
}

#pragma mark -


- (void)dateView:(XZWSelectDateView *)dateView dateChanged:(NSDate *)date andDateString:(NSString *)dateString {
	if (dateView == normalSDV) {
		bornUL.text = dateString;


		if (birthDate) {
			[birthDate release];
			birthDate = nil;
		}

		birthDate = date;
		[birthDate  retain];
	}
	else {
	}
}

#pragma mark -



- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (textField == nicknameUTF) {
		[UIView animateWithDuration:.3f animations: ^{
		    self.view.frame = mOriginFrame;
		}];
	}
	else if (textField == emailUTF) {
		[UIView animateWithDuration:.3f animations: ^{
		    self.view.frame = CGRectOffset(mOriginFrame, 0, -30);
		}];
	}
	else if (textField == passwordUTF) {
		[UIView animateWithDuration:.3f animations: ^{
		    self.view.frame = CGRectOffset(mOriginFrame, 0, -70);
		}];
	}
	else if (textField == repasswordUTF) {
		[UIView animateWithDuration:.3f animations: ^{
		    self.view.frame = CGRectOffset(mOriginFrame, 0, -130);
		}];
	}
	else {
		[UIView animateWithDuration:.3f animations: ^{
		    self.view.frame = mOriginFrame;
		}];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:true];

	[UIView animateWithDuration:.3f animations: ^{
	    self.view.frame = mOriginFrame;
	}];

	return true;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[UIView animateWithDuration:.3f animations: ^{
	    self.view.frame = mOriginFrame;
	}];
	[self.view endEditing:true];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
