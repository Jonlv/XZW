//
//  XZWModifyProfileViewController.m
//  XZW
//
//  Created by dee on 13-9-11.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWModifyProfileViewController.h"
#import "XZWNetworkManager.h"
#import "XZWUtil.h"
#import "XZWSelectDateView.h"
#import "XZWModifyStateViewController.h"
#import "JSONKit.h"

@interface XZWModifyProfileViewController () <UITableViewDataSource, UITableViewDelegate, XZWSelectDateViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
	UITableView *profileTableView;


	ASIHTTPRequest *profileRequest;


	NSMutableDictionary *profileDic;

	XZWSelectDateView *normalSDV;


	NSDate *birthDate;

	NSMutableDictionary *cityDic;


	ASIHTTPRequest *citiesListRequest;

	UIPickerView *citiesPickView;

	BOOL swallowChange;
}
@end

@implementation XZWModifyProfileViewController


- (id)initWithDic:(NSDictionary *)myProfileDic {
	self = [super init];
	if (self) {
		// Custom initialization

		profileDic = [[NSMutableDictionary alloc] initWithDictionary:myProfileDic];


		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyDic:) name:XZWModifyProfileNotification object:nil];
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view endEditing:true];

	[UIView animateWithDuration:.3f animations: ^{
	    citiesPickView.frame =  CGRectMake(0, TotalScreenHeight, 320, 216.0);
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	self.title = @"修改资料";



	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	cityDic = [[NSMutableDictionary alloc] init];


	listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];


	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


	[self initView];

	[self getData];
}

- (void)getData {
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"XZWCities"]]) {
		[cityDic setDictionary:[NSDictionary dictionaryWithContentsOfFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"XZWCities"]]];

		citiesPickView.delegate = self;
		citiesPickView.dataSource = self;

		[self slide];
	}
	else {
		citiesListRequest = [XZWNetworkManager asiWithLink:XZWLocationList postDic:nil completionBlock: ^{
		    if ([[[citiesListRequest responseString]  objectFromJSONString][@"status"]     intValue] == 1) {
		        [cityDic setDictionary:[[[citiesListRequest responseString]  objectFromJSONString] objectForKey:@"data"]];

		        [cityDic writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"XZWCities"] atomically:true];

		        citiesPickView.delegate = self;
		        citiesPickView.dataSource = self;

		        [self slide];
			}
		    else {
			}
		} failedBlock: ^{}];
	}
}

- (void)slide {
	NSArray *dataArray =  cityDic[@"parent"];


	NSString *locationString;

	NSString *cityString;


	if ([[[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "] count] == 2) {
		locationString = [[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "][0];

		cityString = [[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "][1];
	}
	else {
		locationString = [[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "][1];
		cityString = [[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "][2];
	}


	int cityTag = 0, provinceTag = 0;

	for (int i = 0; i < [dataArray count]; i++) {
		if ([locationString hasPrefix:dataArray[i][@"title"]]) {
			provinceTag = i;

			break;
		}
	}

	dataArray =  cityDic[@"child"][provinceTag][@"list"];


	for (int i = 0; i < [dataArray count]; i++) {
		if ([cityString hasPrefix:dataArray[i][@"title"]]) {
			cityTag = i;

			break;
		}
	}



	[citiesPickView selectRow:provinceTag inComponent:0 animated:false];


	[citiesPickView reloadComponent:1];

	double delayInSeconds = 1.;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
	    [citiesPickView selectRow:cityTag inComponent:1 animated:false];
	});
}

- (void)dealloc {
	if (birthDate) {
		[birthDate   release];
		birthDate = nil;
	}

	[cityDic release];

	[super dealloc];
}

#pragma mark - xzwselectdate



- (void)modifyDic:(NSNotification *)notificationObject {
	[profileDic addEntriesFromDictionary:notificationObject.object];

	[profileTableView reloadData];
}

#pragma mark -


- (void)dateAction {
	[self.view endEditing:true];


//	[UIView animateWithDuration:.3f animations: ^{
//	    self.view.frame = CGRectMake(0, 0, 320, TotalScreenHeight);
//	}];

	[normalSDV playAnimate];
}

#pragma mark -


- (void)dateView:(XZWSelectDateView *)dateView dateChanged:(NSDate *)date andDateString:(NSString *)dateString {
	if (dateView == normalSDV) {
		[profileDic setObject:dateString forKey:@"birthday"];


		if (birthDate) {
			[birthDate release];
			birthDate = nil;
		}

		birthDate = date;
		[birthDate  retain];

		[profileTableView reloadData];
	}
	else {
	}




	if (swallowChange) {
	}




	swallowChange = true;
}

#pragma mark -

- (void)modify {
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:profileDic];


	if ([profileDic objectForKey:@"unameChanged"]) {
		[tempDic setObject:[profileDic objectForKey:@"unameChanged"]  forKey:@"uname"];
		[tempDic setObject:[profileDic objectForKey:@"uname"] forKey:@"old_name"];
		[tempDic removeObjectForKey:@"unameChanged"];
	}
	else {
		[tempDic setObject:[profileDic objectForKey:@"uname"]  forKey:@"uname"];
		[tempDic setObject:[profileDic objectForKey:@"uname"] forKey:@"old_name"];
	}



	@try {
		NSString *locationString;

		NSString *cityString;


		if ([[[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "] count] == 2) {
			locationString = [[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "][0];

			cityString = [[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "][1];
		}
		else {
			locationString = [[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "][1];
			cityString = [[profileDic objectForKey:@"location"] componentsSeparatedByString:@" "][2];
		}


		[tempDic setObject:locationString forKey:@"location1"];
		[tempDic setObject:cityString forKey:@"location2"];
	}
	@catch (NSException *exception)
	{
	}
	@finally
	{
	}


	[tempDic removeObjectForKey:@"avatar"];
	[tempDic removeObjectForKey:@"charm"];
	[tempDic removeObjectForKey:@"constellation"];
	[tempDic removeObjectForKey:@"like_count"];
	[tempDic removeObjectForKey:@"like_state"];
	[tempDic removeObjectForKey:@"score"];
	[tempDic removeObjectForKey:@"uid"];
	[tempDic removeObjectForKey:@"age"];



	NSDateFormatter *ndf = [[[NSDateFormatter alloc]  init]  autorelease];


	[ndf setDateFormat:@"yyyy-MM-dd"];

	[tempDic setObject:[ndf stringFromDate:birthDate] forKey:@"birthday"];


	profileRequest = [XZWNetworkManager asiWithLink:XZWModifyProfile postDic:tempDic completionBlock: ^{
	    NSDictionary *tempDic =  [[profileRequest  responseString]  objectFromJSONString];


	    if ([[tempDic objectForKey:@"status"]  intValue] == 1) {
	        [[NSNotificationCenter defaultCenter] postNotificationName:XZWRefreshProfileNotification object:nil];



	        [[[[UIAlertView alloc] initWithTitle:nil message:@"修改成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease]  show];




	        //            [[NSUserDefaults standardUserDefaults]   setObject:[[tempDic objectForKey:@"data"] objectForKey:@"uname"]forKey:@"username"];
	        //
	        //            [[NSUserDefaults standardUserDefaults]   setObject:[[tempDic objectForKey:@"data"] objectForKey:@"avatar"]forKey:@"avatar"];




	        //            [[NSUserDefaults standardUserDefaults]  synchronize];

	        //            [[NSNotificationCenter defaultCenter]  postNotificationName:XZWLoginNotification object:[tempDic objectForKey:@"data"]];
		}
	    else {
	        [[[[UIAlertView alloc] initWithTitle:nil message:[tempDic objectForKey:@"info"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease]  show];
		}
	} failedBlock: ^{
	    [[[[UIAlertView alloc] initWithTitle:nil message:@"修改失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease]  show];
	}];
}

- (void)goBack {
	[self.navigationController popViewControllerAnimated:true];
}

- (void)initView {
	profileTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 88 - 20) style:UITableViewStyleGrouped];
	profileTableView.delegate = self;
	profileTableView.dataSource = self;
	profileTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
	[self.view addSubview:profileTableView];
	[profileTableView release];

	citiesPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, TotalScreenHeight, 320, 216.0)];
	citiesPickView.showsSelectionIndicator = true;
	[self.view addSubview:citiesPickView];
	[citiesPickView release];



	UIView *uv = [[UIView alloc] initWithFrame:profileTableView.bounds];
	uv.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
	[profileTableView setBackgroundView:uv];
	[uv release];


	normalSDV = [[XZWSelectDateView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight) andDateString:[[[profileDic objectForKey:@"birthday"]  description] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
	normalSDV.delegate = self;
	normalSDV.alpha = 0.f;
	[self.view addSubview:normalSDV];
	[normalSDV release];



	NSDateFormatter *tempDateFormate = [[[NSDateFormatter alloc]  init]  autorelease];

	[tempDateFormate setDateFormat:@"yyyyMMdd"];

	birthDate  = [tempDateFormate dateFromString:[[[profileDic objectForKey:@"birthday"]  description] stringByReplacingOccurrencesOfString:@"-" withString:@""]];

	[birthDate  retain];
}

#pragma mark -

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	[self goBack];
}

#pragma mark - actionsheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) {
		return;
	}


	switch (actionSheet.tag) {
		case 0:
		{
		}
            break;

		case 1:
		{
		}
            break;

		case 2:
		{
			[profileDic setObject:[NSString stringWithFormat:@"%d", buttonIndex] forKey:@"relationship_status"];
		}
            break;

		case 3:
		{
			[profileDic setObject:[NSString stringWithFormat:@"%d", buttonIndex] forKey:@"blood_type"];
		}
            break;

		case 4:
		{
			[profileDic setObject:[NSString stringWithFormat:@"%d", buttonIndex + 1] forKey:@"sex"];
		}
            break;

		case 5:
		{
		}
            break;

		default:
			break;
	}


	[profileTableView reloadData];
}

#pragma mark - PickerView delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString *rowString = nil;

	switch (component) {
		case 0:
		{
			rowString = cityDic[@"parent"][row][@"title"];
		}

            break;

		default: {
			@try {
				rowString = cityDic[@"child"][[pickerView selectedRowInComponent:0]][@"list"][row][@"title"];
			}
			@catch (NSException *exception)
			{
				rowString = @"";
			}
			@finally
			{
			}
		}
            break;
	}



	return rowString;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 110;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	int count = 0;

	switch (component) {
		case 0:
		{
			count = [cityDic[@"parent"]  count];
		}
            break;

		default:
		{
			count = [cityDic[@"child"][[pickerView selectedRowInComponent:0]][@"list"]  count];
		}
            break;
	}


	return count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	[pickerView reloadAllComponents];

	[profileDic setObject:[NSString stringWithFormat:@"%@ %@", cityDic[@"parent"][[pickerView selectedRowInComponent:0]][@"title"], cityDic[@"child"][[pickerView selectedRowInComponent:0]][@"list"][[pickerView selectedRowInComponent:1]][@"title"]] forKey:@"location"];

	[profileTableView reloadData];
}

#pragma mark -


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	XZWModifyStateViewController *xzwVC = nil;

	[self.view endEditing:true];


	if (CGRectGetMinY(citiesPickView.frame) < TotalScreenHeight) {
		[UIView animateWithDuration:.3f animations: ^{
		    citiesPickView.frame =  CGRectMake(0, TotalScreenHeight, 320, 216.0);
		}];

		return;
	}




	switch (indexPath.row) {
		case 0:
		{
			xzwVC = [[XZWModifyStateViewController alloc] initWithDic:[profileDic objectForKey:@"unameChanged"] ? @{   @"unameChanged" : [[profileDic objectForKey:@"unameChanged"]  description]  }:@{   @"uname":  [[profileDic objectForKey:@"uname"]  description]  }];
		}
            break;

		case 1:
		{
			[self dateAction];
		}
            break;

		case 2:
		{
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"婚恋状态" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保密", @"单身", @"恋爱", @"已婚", @"离婚", @"未婚", nil];
			actionSheet.tag = 2;
			actionSheet.delegate = self;
			[actionSheet showInView:self.navigationController.view];
			[actionSheet release];
		}
            break;

		case 3:
		{
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"血型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保密", @"A型", @"B型", @"AB型", @"O型",  nil];
			actionSheet.tag = 3;
			actionSheet.delegate = self;
			[actionSheet showInView:self.navigationController.view];
			[actionSheet release];
		}
            break;

		case 4:
		{
			UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男", @"女",  nil];
			actionSheet.tag = 4;
			actionSheet.delegate = self;
			[actionSheet showInView:self.navigationController.view];
			[actionSheet release];
		}
            break;

		case 5:
		{
			[UIView animateWithDuration:.3f animations: ^{
			    citiesPickView.frame =  CGRectMake(0, TotalScreenHeight - 64 - 216.0, 320, 216.0);
			}];



			//            xzwVC = [[XZWModifyStateViewController alloc]  initWithDic:     @{   @"location":  [[profileDic  objectForKey:@"location"]  description]  }    ];
		}
            break;

		case 6:
		{
			xzwVC = [[XZWModifyStateViewController alloc] initWithDic:@{   @"intro":  [[profileDic objectForKey:@"intro"]  description]  }];
		}
            break;

		default:
		{
			xzwVC = [[XZWModifyStateViewController alloc] initWithDic:@{   @"charm":  [[profileDic objectForKey:@"charm"]  description]  }];
		}
            break;
	}



	if (xzwVC) {
		[self.navigationController pushViewController:xzwVC animated:true];
		[xzwVC release];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = 37.f;

	if (indexPath.row == 6) {
		UILabel *resultUL = [[[UILabel alloc] initWithFrame:CGRectMake(80, 0, 220, 37)]  autorelease];
		resultUL.backgroundColor = [UIColor clearColor];
		resultUL.textAlignment = UITextAlignmentLeft;
		resultUL.textColor = [XZWUtil xzwRedColor];
		resultUL.frame = CGRectMake(80, 10, 190, 37);
		resultUL.numberOfLines = 0;
		resultUL.text = [profileDic objectForKey:@"intro"];
		[resultUL sizeThatFits:CGSizeMake(190, 1037)];
		[resultUL sizeToFit];

		height = CGRectGetMaxY(resultUL.frame) + 10;


		if (height < 37) {
			height = 37.f;
		}
	}



	return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int rows  = 7;

	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];


		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;

		cell.backgroundColor = [UIColor whiteColor];


		UILabel *resultUL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 37)];
		resultUL.backgroundColor = [UIColor clearColor];
		resultUL.tag = 8;
		resultUL.textAlignment = UITextAlignmentRight;
		resultUL.textColor = [XZWUtil xzwRedColor];
		[cell.contentView addSubview:resultUL];
		[resultUL release];



		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		resultUL.frame = CGRectMake(0, 0, 270, 37);


		resultUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 220, 37)];
		resultUL.backgroundColor = [UIColor clearColor];
		resultUL.tag = 9;
		resultUL.font = [UIFont boldSystemFontOfSize:15];
		resultUL.textColor = [XZWUtil xzwRedColor];
		[cell.contentView addSubview:resultUL];
		[resultUL release];
	}

	UILabel *leftUL =   (UILabel *)[cell.contentView viewWithTag:9];
	leftUL.textColor = [UIColor grayColor];
	UILabel *resultUL = (UILabel *)[cell.contentView viewWithTag:8];
	resultUL.frame = CGRectMake(70, 0, 200, 37);
	resultUL.textAlignment = UITextAlignmentRight;

	switch (indexPath.row) {
		case 0: {
			leftUL.text = @"昵称";

			resultUL.text = [profileDic objectForKey:@"unameChanged"] ? [profileDic objectForKey:@"unameChanged"] : [[profileDic objectForKey:@"uname"]  description];
		}


            break;

		case 1: {
			leftUL.text = @"生日";

			resultUL.text = [[profileDic objectForKey:@"birthday"]  description];
		}


            break;


		case 2: {
			leftUL.text = @"婚恋状态";




			switch ([[profileDic objectForKey:@"relationship_status"] intValue]) {
				case 0: {
					resultUL.text = @"保密";
				}
                    break;

				case 1: {
					resultUL.text = @"单身";
				}
                    break;

				case 2: {
					resultUL.text = @"恋爱";
				}
                    break;

				case 3: {
					resultUL.text = @"已婚";
				}
                    break;

				case 4: {
					resultUL.text = @"离婚";
				}
                    break;

				default: {
					resultUL.text = @"未婚";
				}
                    break;
			}
		}


            break;

		case 3: {
			leftUL.text = @"血型";


			switch ([[profileDic objectForKey:@"blood_type"] intValue]) {
				case 0: {
					resultUL.text = @"保密";
				}
                    break;

				case 1: {
					resultUL.text = @"A型";
				}
                    break;

				case 2: {
					resultUL.text = @"B型";
				}
                    break;

				case 3: {
					resultUL.text = @"AB型";
				}
                    break;

				case 4: {
					resultUL.text = @"O型";
				}
                    break;

				default: {
					resultUL.text = @"S型";
				}
                    break;
			}
		}


            break;

		case 4: {
			leftUL.text = @"性别";




			if ([[profileDic objectForKey:@"sex"]  intValue] == 1) {
				resultUL.text = @"男";
			}
			else {
				resultUL.text = @"女";
			}
		}


            break;

		case 5: {
			leftUL.text = @"位置";

			resultUL.text = [profileDic objectForKey:@"location"];
		}


            break;

		case 6: {
			leftUL.text = @"个性签名";

			resultUL.frame = CGRectMake(80, 10, 190, 37);
			resultUL.text = [profileDic objectForKey:@"intro"];
			resultUL.numberOfLines = 0;
			resultUL.textAlignment = UITextAlignmentLeft;
			[resultUL sizeThatFits:CGSizeMake(190, 1037)];
			[resultUL sizeToFit];

			if (CGRectGetHeight(resultUL.frame) < 30) {
				resultUL.frame = CGRectMake(280 - CGRectGetWidth(resultUL.frame), 10, CGRectGetWidth(resultUL.frame), CGRectGetHeight(resultUL.frame));
			}
		}


            break;

		default:
		{
			leftUL.text = @"昵称";

			resultUL.text = [[profileDic objectForKey:@"charm"]  description];
		}
            break;
	}

	return cell;
}

#pragma mark -



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
