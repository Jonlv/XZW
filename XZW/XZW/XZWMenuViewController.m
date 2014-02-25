//
//  XZWMenuViewController.m
//  XZW
//
//  Created by Dee on 13-8-20.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMenuViewController.h"
#import "ASIHTTPRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWUtil.h"
#import "XZWQueryZodiacViewController.h"
#import "XZWAstrolabeViewController.h"
#import "IIViewDeckController.h"
#import "XZWMainViewController.h"
#import "XZWMyFriendViewController.h"
#import "XZWMyProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "XZWLoginViewController.h"
#import "XZWTodayIssueViewController.h"
#import "XZWAppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface XZWMenuViewController ()
{
	UIImageView *avatarUIV;

	UILabel *usernameUL;

	int mPrivateLetterCount;
}
@property (nonatomic, retain) UINavigationController *navVC;
@property (nonatomic, retain) XZWMainViewController  *mainVC;
@property (nonatomic, copy)   NSIndexPath            *currentIndexPath;
@end

@implementation XZWMenuViewController


#pragma mark - init


- (void)editMyProfile {
	XZWMyProfileViewController *myProfileVC = [[XZWMyProfileViewController alloc] init];
	UINavigationController *myUNC = [[UINavigationController alloc] initWithRootViewController:myProfileVC];
	[myUNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
	[self presentModalViewController:myUNC animated:true];
	[myProfileVC release];
	[myUNC release];
}

- (void)loginAction {
	XZWLoginViewController *loginVC = [[XZWLoginViewController alloc] init];

	UINavigationController *myUNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
	[myUNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
	[self presentModalViewController:myUNC animated:true];
	[loginVC release];
	[myUNC release];
}

- (void)loginFinish {
	[avatarUIV setImage:nil];

	[avatarUIV setImageWithURL:[NSURL URLWithString:[[[NSUserDefaults standardUserDefaults] valueForKey:@"avatar"] description]]];
	usernameUL.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
}

- (void)initViews {
	self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];

    int layoutOffset = (XZWAppDelegate.VERSION_CODE >= 7.0)?20:0;

	//(start) 头像
	avatarUIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10 + layoutOffset, 30, 30)];
	[avatarUIV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]]]];
	avatarUIV.image = [UIImage imageNamed:@"personimg"];
	[self.view addSubview:avatarUIV];
	[avatarUIV release];


	UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
	selectButton.frame = CGRectMake(0, 0 + layoutOffset, 140, 40);
	[selectButton addTarget:self action:@selector(editMyProfile) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:selectButton];
	//(end) 头像


	//    UIImageView *rightArrowUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(200, 18, 9, 14)];
	//    [rightArrowUIV setImage:[UIImage imageNamed:@"rtarrow"]];
	//    [self.view addSubview:rightArrowUIV];
	//    [rightArrowUIV release];

	//


	UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	homeBtn.frame = CGRectMake(180, 18 + layoutOffset, 24, 20);
	[homeBtn addTarget:self action:@selector(homeAction) forControlEvents:UIControlEventTouchUpInside];
	[homeBtn setImage:[UIImage imageNamed:@"home"] forState:UIControlStateNormal];
	[self.view addSubview:homeBtn];


	usernameUL = [[UILabel alloc] initWithFrame:CGRectMake(60, 0 + layoutOffset, 260, 50)];
	usernameUL.backgroundColor =  [UIColor clearColor];
	usernameUL.textColor = [UIColor whiteColor];
	usernameUL.font = [UIFont boldSystemFontOfSize:17];
	[usernameUL setText:[NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]  description]]];
	[self.view addSubview:usernameUL];
	[usernameUL release];

	menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 50 + layoutOffset, 320, TotalScreenHeight - 70)];
	[menuTable setDelegate:self];
	[menuTable setDataSource:self];
	menuTable.backgroundColor =  [UIColor colorWithHex:0x4c4c4c];
	[self.view addSubview:menuTable];
	[menuTable release];
	menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;

	UIImageView *lineUIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49 + layoutOffset, 320, 1)];
	lineUIV.image = [UIImage imageNamed:@"table_line"];
	[self.view addSubview:lineUIV];
	[lineUIV release];
}

#pragma mark -

- (void)homeAction {
	if (nil == self.mainVC) {
        self.mainVC = [XZWAppDelegate sharedXZWAppDelegate].mainVC;
        self.navVC = [XZWAppDelegate sharedXZWAppDelegate].xzwNavVC;
    }

	[self.viewDeckController setCenterController:self.navVC];

	[self.viewDeckController closeLeftViewAnimated:true completion: ^(IIViewDeckController *controller, BOOL success) {
	}];


	self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    if (self.currentIndexPath) {
        [menuTable.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UITableViewCell *cell = obj;
            [cell.contentView viewWithTag:9999].hidden = YES;
        }];
        self.currentIndexPath = nil;
    }
}

#pragma mark - tableview


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 25.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//(start)
    self.currentIndexPath = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *bg = [cell.contentView viewWithTag:9999];
    bg.hidden = NO;
    [tableView.visibleCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj != cell) {
            UITableViewCell *otherCell = obj;
            [otherCell.contentView viewWithTag:9999].hidden = YES;
        }
    }];
	{
		UIViewController *viewController = nil;

		switch (indexPath.section) {
                // 个人中心
			case 0:
			{
				switch (indexPath.row + 1) {
					case 0:
					{
						viewController = [[NSClassFromString(@"XZWMainViewController") alloc]  init];
					}
                        break;

					case 1:
					{
						viewController = [[NSClassFromString(@"XZWFeedViewController") alloc]  init];
					}
                        break;

					case 2:
					{
						viewController = [[NSClassFromString(@"XZWMyMessageViewController") alloc]  init];
					}
                        break;

					case 3:
					{
						viewController = [[NSClassFromString(@"XZWMyFriendViewController") alloc]  init];
					}
                        break;

					case 4:
					{
						viewController = [[NSClassFromString(@"XZWFindFriendsViewController") alloc]  init];
					}
                        break;

					case 5:
					{
						viewController = [[NSClassFromString(@"XZWQuanViewController") alloc]  init];
					}
                        break;

					case 6:
					{
						viewController = [[NSClassFromString(@"XZWTodayIssueViewController") alloc]  init];
					}
                        break;

					default:
						break;
				}
			}
                break;

                // 星座工具
			case 1:
			{
				switch (indexPath.row) {
					case 0:
					{
						viewController = [[NSClassFromString(@"XZWFortuneViewController") alloc]  init];
					}
                        break;

					case 1:
					{
						viewController = [[NSClassFromString(@"XZWQueryZodiacViewController") alloc]  init];
					}
                        break;

					case 2:
					{
						viewController = [[NSClassFromString(@"XZWMatchViewController") alloc]  init];
					}
                        break;

					case 3:
					{
						viewController = [[NSClassFromString(@"XZWAstrolabeViewController") alloc]  init];
					}
                        break;

					default: {
						viewController = [[NSClassFromString(@"XZWMoreToolsViewController") alloc]  init];
					}
                        break;
				}
			}
                break;

                // 其他
			default:

				switch (indexPath.row) {
					case 0:
					{
						viewController = [[NSClassFromString(@"XZWKnowledgeViewController") alloc]  init];
					}

                        break;

					case 1:
					{
						viewController = [[NSClassFromString(@"XZWSettingViewController") alloc]  init];
					}

                        break;

					default:
					{
						viewController = [[NSClassFromString(@"XZWRecommendViewController") alloc]  init];
					}
                        break;
				}

				break;
		}



		if (viewController) {
			UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController]  autorelease];

			[navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];

			[viewController release];

			[self.viewDeckController setCenterController:navigationController];
		}
	}
	//(end)


	[self.viewDeckController closeLeftViewAnimated:true completion: ^(IIViewDeckController *controller, BOOL success) {
	}];


	self.viewDeckController.panningMode = IIViewDeckFullViewPanning;


	return;


    //    [self.viewDeckController closeLeftViewBouncing:^(IIViewDeckController *controller) {
    //
    //        UIViewController *viewController = nil;
    //
    //
    //
    //        switch (indexPath.section) {
    //            case 0:
    //            {
    //
    //                switch (indexPath.row) {
    //                    case 0:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWMainViewController") alloc]  init];
    //                    }
    //                        break;
    //                    case 1:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWMainViewController") alloc]  init];
    //                    }
    //                        break;
    //                    case 2:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWMainViewController") alloc]  init];
    //                    }
    //                        break;
    //                    case 3:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWMyFriendViewController") alloc]  init];
    //                    }
    //                        break;
    //                    case 4:
    //                    {
    //
    //                        viewController = [[NSClassFromString(@"XZWFindFriendsViewController") alloc]  init];
    //                    }
    //                        break;
    //                    case 5:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWQuanViewController") alloc]  init];
    //                    }
    //                        break;
    //                    case 6:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWTodayIssueViewController") alloc]  init];
    //                    }
    //                        break;
    //
    //                    default:
    //                        break;
    //                }
    //
    //
    //
    //            }
    //
    //                break;
    //            case 1:
    //            {
    //
    //                switch (indexPath.row) {
    //                    case 0:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWQueryZodiacViewController") alloc]  init];
    //                    }
    //                        break;
    //
    //                    case 1:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWFortuneViewController") alloc]  init];
    //                    }
    //                        break;
    //                    case 2:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWMatchViewController") alloc]  init];
    //                    }
    //                        break;
    //
    //                    case 3:
    //                    {
    //                        viewController = [[NSClassFromString(@"XZWAstrolabeViewController") alloc]  init];
    //                    }
    //                        break;
    //
    //                    default:
    //                        break;
    //                }
    //
    //
    //            }
    //
    //                break;
    //
    //            default:
    //                break;
    //        }
    //
    //
    //
    //
    //        if (viewController) {
    //
    //            UINavigationController *navigationController =[[[UINavigationController alloc]  initWithRootViewController:viewController]  autorelease];
    //
    //            [navigationController.navigationBar   setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
    //
    //            [viewController  release];
    //
    //            [self.viewDeckController setCenterController:navigationController];
    //
    //
    //        }
    //
    //    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 6;
	}
	else if (section == 1) {
		return 5;
	}
	else {
		return 3;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIImageView *tempView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 24)]  autorelease];
	tempView.backgroundColor = [UIColor colorWithHex:0x2f2f2f];
	UILabel *tempUL = [[UILabel alloc] initWithFrame:tempView.bounds];

	if (section == 0) {
		[tempUL setText:@"    个人中心"];
	}
	else if (section == 1) {
		[tempUL setText:@"    星座工具"];
	}
	else {
		[tempUL setText:@"    其他"];
	}
	tempUL.font = [UIFont boldSystemFontOfSize:15];
	tempUL.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
	tempUL.shadowOffset = CGSizeMake(1, -1);
	[tempUL setBackgroundColor:[UIColor clearColor]];
	[tempUL setTextColor:[UIColor grayColor]];
	[tempView addSubview:tempUL];
	[tempUL release];

	UIImageView *lineUIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 24, 320, 1)];
	lineUIV.image = [UIImage imageNamed:@"table_line"];
	[tempUL addSubview:lineUIV];
	[lineUIV release];


	return tempView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        UIView *selectedBg = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
        selectedBg.tag = 9999;
        selectedBg.backgroundColor = [UIColor blackColor];
        selectedBg.alpha = 0.3f;
        selectedBg.hidden = YES;
        [cell.contentView addSubview:selectedBg];
        
		UILabel *ul = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 160, 40)];
		ul.backgroundColor = [UIColor clearColor];
		ul.font = [UIFont boldSystemFontOfSize:17];
		ul.textColor = [UIColor whiteColor];
		[cell.contentView addSubview:ul];
		ul.tag = 99;
		[ul release];

		UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 24, 20)];
		leftImage.tag = 999;
		[cell.contentView addSubview:leftImage];
		[leftImage release];

		cell.selectionStyle = UITableViewCellSelectionStyleNone;

		cell.contentView.backgroundColor = [UIColor colorWithHex:0x4c4c4c];


		UIImageView *lineUIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 320, 1)];
		lineUIV.image = [UIImage imageNamed:@"table_line"];
		[cell.contentView addSubview:lineUIV];
		[lineUIV release];



		UILabel *dynUL =  [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 160, 40)];
		dynUL.backgroundColor = [XZWUtil xzwRedColor];
		dynUL.font = [UIFont boldSystemFontOfSize:17];
		dynUL.textColor = [UIColor whiteColor];
		[cell.contentView addSubview:dynUL];
		dynUL.textAlignment = UITextAlignmentCenter;
		dynUL.layer.cornerRadius = 6.f;
		dynUL.tag = 991;
		[dynUL release];
	}

    UIView *selectedBg = [cell.contentView viewWithTag:9999];
    if (self.currentIndexPath == nil || self.currentIndexPath.row != indexPath.row) {
        selectedBg.hidden = YES;
    }
    else {
        selectedBg.hidden = NO;
    }
	UIImageView *leftImage = (UIImageView *)[cell.contentView viewWithTag:999];
	UILabel *referentUL = (UILabel *)[cell.contentView viewWithTag:99];
	UILabel *privateLetterUL = (UILabel *)[cell.contentView viewWithTag:991];
	privateLetterUL.hidden = true;

	switch (indexPath.section) {
            // 个人中心
		case 0:
		{
			switch (indexPath.row) {
				case -1: // 好像这一行没用到
				{
					[referentUL setText:@"首页"];
					leftImage.image =  [UIImage imageNamed:@"home"];
				}
                    break;

				case 0:
				{
					[referentUL setText:@"动态"];
					leftImage.image =  [UIImage imageNamed:@"trends"];
				}
                    break;

				case 1:
				{
					privateLetterUL.hidden = false;
					privateLetterUL.font = [UIFont boldSystemFontOfSize:16];
					if (mPrivateLetterCount > 0) {
						if (mPrivateLetterCount > 99) {
							privateLetterUL.text = @"99+";
						}
						else if (mPrivateLetterCount <= 99) {
							privateLetterUL.text = [NSString stringWithFormat:@" %d ", mPrivateLetterCount];
						}
					}
					else {
						privateLetterUL.hidden = true;
					}

					privateLetterUL.frame = CGRectMake(84, 9, 160, 40);
					[privateLetterUL  sizeToFit];
					privateLetterUL.font = [UIFont boldSystemFontOfSize:14];


					[referentUL setText:@"私信"];
					leftImage.image = [UIImage imageNamed:@"discuss"];
				}
                    break;

				case 2:
				{
					[referentUL setText:@"好友"];
					leftImage.image =  [UIImage imageNamed:@"friend"];
				}
                    break;

				case 3:
				{
					[referentUL setText:@"查找好友"];
					leftImage.image =  [UIImage imageNamed:@"seek"];
				}
                    break;

				case 4:
				{
					[referentUL setText:@"圈子"];
					leftImage.image =  [UIImage imageNamed:@"circle"];
				}
                    break;

				case 5:
				{
					[referentUL setText:@"讨论"];
					leftImage.image =  [UIImage imageNamed:@"discuss"];
				}
                    break;

				case 6:
				{
					[referentUL setText:@"讨论"];
					leftImage.image =  [UIImage imageNamed:@""];
				}
                    break;

				default:
					break;
			}
		}
            break;

            // 星座工具
		case 1:
		{
			switch (indexPath.row) {
				case 0:
				{
					[referentUL setText:@"今日运势"];

					leftImage.image =  [UIImage imageNamed:@"inquiry"];
				}
                    break;

				case 1:
				{
					[referentUL setText:@"星座查询"];
					leftImage.image =  [UIImage imageNamed:@"fortune"];
				}
                    break;

				case 2:
				{
					[referentUL setText:@"星座配对"];
					leftImage.image =  [UIImage imageNamed:@"pair"];
				}
                    break;

				case 3:
				{
					[referentUL setText:@"星盘占卜"];
					leftImage.image =  [UIImage imageNamed:@"divine"];
				}
                    break;

				case 4:
				{
					[referentUL setText:@"更多工具"];
					leftImage.image =  [UIImage imageNamed:@"more"];
				}
                    break;

				case 5:
				{
					[referentUL setText:@""];
				}
                    break;

				case 6:
				{
					[referentUL setText:@""];
				}
                    break;

				default:
					break;
			}
		}
            break;

            // 其他
		case 2:
		{
			switch (indexPath.row) {
				case 0:
				{
					[referentUL setText:@"知识"];
					leftImage.image =  [UIImage imageNamed:@"knowledge"];
				}
                    break;

				case 1:
				{
					[referentUL setText:@"设置"];
					leftImage.image =  [UIImage imageNamed:@"setup"];
				}
                    break;


				default:
				{
					[referentUL setText:@"应用推荐"];
					leftImage.image =  [UIImage imageNamed:@"good"];
				}
                    break;
			}
		}
            break;
	}


	return cell;
}

#pragma mark -


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


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinish) name:XZWLoginNotification object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessage:) name:XZWNewMessageNotification object:nil];

	[self initViews];
}

- (void)dealloc
{
    self.mainVC = nil;
    self.navVC = nil;
    self.currentIndexPath = nil;
    [super dealloc];
}

- (void)getNewMessage:(NSNotification *)object {
	mPrivateLetterCount = [object.object[@"sixin_new"] intValue];

	[menuTable reloadData];

	//[[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWShake"]

	if (mPrivateLetterCount != 0  && [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWShake"]) {
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	}
}

#pragma mark -


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
