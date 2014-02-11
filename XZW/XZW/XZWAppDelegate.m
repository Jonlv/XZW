//
//  XZWAppDelegate.m
//  XZW
//
//  Created by Dee on 13-8-20.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAppDelegate.h"
#import "XZWMenuViewController.h"
#import "XZWSelectBirthdayViewController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "XZWDBOperate.h"
#import "IIViewDeckController.h"
#import "XZWMainViewController.h"
#import "XZWAstrolabeViewController.h"
#import "XZWZodiac.h"
#import "JSONKit.h"
#import "XZWLoginViewController.h"
#import "XZWUtil.h"
#import "XZWPollingObject.h"
#import "Harpy.h"
#import "WXApi.h"
#import "JSONKit.h"
#import <ShareSDK/ShareSDK.h>

@implementation XZWAppDelegate

+ (float)VERSION_CODE {
    return VERSION_CODE;
}

#pragma mark - vc init


- (void)logoutAction {
	NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];

	for (NSHTTPCookie *cookie in[cookieJar cookies]) {
		if ([cookie.name isEqualToString:@"PHPSESSID"]) {
			[cookieJar deleteCookie:cookie];
		}

		if ([cookie.name isEqualToString:@"T3_TSV3_LOGGED_USER"]) {
			[cookieJar deleteCookie:cookie];
		}

		if ([cookie.name isEqualToString:@"T3_TSV3_ACTIVE_TIME"]) {
			[cookieJar deleteCookie:cookie];
		}
	}


	//

	XZWLoginViewController *loginVC = [[XZWLoginViewController alloc]  init];

	UINavigationController *myUNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
	[myUNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
	[self.window.rootViewController presentModalViewController:myUNC animated:true];
	[loginVC release];
	[myUNC release];



	double delayInSeconds = 1.0;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
	    UIViewController *viewController = nil;
	    viewController = [[NSClassFromString(@"XZWMainViewController") alloc]  init];

	    UINavigationController *navigationController = [[[UINavigationController alloc] initWithRootViewController:viewController]  autorelease];

	    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
	    [viewController  release];

	    [(IIViewDeckController *)self.window.rootViewController setCenterController: navigationController];
	});
}

- (void)initRootController {
	//**************** logout notification **************//
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAction) name:XZWLogOutNotification object:nil];



	XZWMenuViewController *menuVC = [[[XZWMenuViewController alloc]  init]   autorelease];

	XZWMainViewController *mainVC = [[[XZWMainViewController alloc]  init]  autorelease];


	UINavigationController *xzwNav = [[[UINavigationController alloc] initWithRootViewController:mainVC] autorelease];
	[xzwNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];



	IIViewDeckController *rootVC = [[[IIViewDeckController alloc] initWithCenterViewController:xzwNav leftViewController:menuVC rightViewController:[[[NSClassFromString(@"XZWGetChatFriendViewController") alloc] init]  autorelease]]  autorelease];
	rootVC.delegate = self;

	rootVC.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
	rootVC.leftSize = 105.f;
	rootVC.rightSize = 100.f;



	[self.window setRootViewController:rootVC];
}

//- (BOOL)viewDeckController:(IIViewDeckController*)viewDeckController shouldPan:(UIPanGestureRecognizer*)panGestureRecognizer{
//
//
//    return true;
//}

- (BOOL)viewDeckController:(IIViewDeckController *)viewDeckController shouldOpenViewSide:(IIViewDeckSide)viewDeckSide {
	if (viewDeckSide == IIViewDeckRightSide) {
		if ([viewDeckController.centerController isKindOfClass:[UINavigationController class]] || [viewDeckController.centerController isKindOfClass:NSClassFromString(@"XZWChatStyleTwoViewController")]) {
			UINavigationController *tempUNC = (UINavigationController *)viewDeckController.centerController;

			if ([[tempUNC topViewController] isKindOfClass:NSClassFromString(@"XZWChatStyleTwoViewController")]) {
				return true;
			}
		}


		return false;
	}



	return true;
}

- (void)initSetting {
	if ([[NSUserDefaults standardUserDefaults] integerForKey:@"XZWNewsInterval"] == 0) {
		[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"XZWNewsInterval"];
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWNewComment"];
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWNewFriend"];
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWPush"];
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWNewMessage"];
		[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWValidation"];

		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)initDataBase {
	[XZWDBOperate initDatabase];
}

- (void)clearData {
	[XZWDBOperate removeAllRecords];


	[[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"XZWNewsInterval"];
	[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWNewComment"];
	[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWNewFriend"];
	[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWPush"];
	[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWNewMessage"];
	[[NSUserDefaults standardUserDefaults] setBool:true forKey:@"XZWValidation"];


	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -


- (void)initShareSDK {
	[ShareSDK registerApp:@"c42ca71c482"];
	[ShareSDK connectSinaWeiboWithAppKey:@"4014013622" appSecret:@"86c8fed35302172eacfbf0d2067cc9fd" redirectUri:@"http://www.xingzuowu.com"];
	[ShareSDK connectWeChatWithAppId:@"wxe742b302525bd7fb"        //此参数为申请的微信AppID
	                       wechatCls:[WXApi class]];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return [ShareSDK handleOpenURL:url
	                    wxDelegate:self];
}

- (BOOL)  application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
	return [ShareSDK handleOpenURL:url
	             sourceApplication:sourceApplication
	                    annotation:annotation
	                    wxDelegate:self];
}

#pragma mark - life cycle



- (void)dealloc {
	[_window release];
	[super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    VERSION_CODE = [[[UIDevice currentDevice] systemVersion] floatValue];

	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	// Override point for customization after application launch.
	self.window.backgroundColor = [UIColor whiteColor];




	[self initRootController];

	[self initDataBase];

	[self.window makeKeyAndVisible];


	[self initShareSDK];


	if (![XZWUtil checkLogin]) {
		XZWLoginViewController *loginVC = [[XZWLoginViewController alloc]  init];

		UINavigationController *myUNC = [[UINavigationController alloc] initWithRootViewController:loginVC];
		[myUNC.navigationBar setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
		[self.window.rootViewController presentModalViewController:myUNC animated:false];
		[loginVC release];
		[myUNC release];
	}

	// 初始化设定
	[self initSetting];

	[[[XZWPollingObject alloc] init] getNewUnReadInstanly];


	if ([[NSUserDefaults standardUserDefaults] boolForKey:@"XZWAutoCheck"]) {
		[Harpy checkVersion];
	}


	return YES;
}

- (void)test {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

	NSString *documentDirectory = [paths objectAtIndex:0];

	NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"Dream.db"];

	FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];

	[queue inDatabase: ^(FMDatabase *db) {
	    NSString *dbString = nil;

	    dbString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID integer  NOT NULL   PRIMARY KEY AUTOINCREMENT default 1 ,catname text, name text, description text )", @"Dream"];

	    [db executeUpdate:dbString];



	    [db executeUpdate:@"delete from Dream"];


	    NSArray *catArray = @[@"动物类", @"鬼神类", @"活动类", @"建筑类", @"其他类", @"人物类", @"生活类", @"物品类", @"植物类", @"自然类"];


	    for (int i = 0; i < [catArray count]; i++) {
	        NSArray *array = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:catArray[i] ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil] objectFromJSONString];



	        for (int j = 0; j < [array count]; j++) {
	            NSString *dbString = [NSString stringWithFormat:@"insert into %@ (catname , name , description ) values ('%@','%@','%@');", @"Dream", catArray[i], array[j][0], array[j][1]];


	            NSLog(@"dbString %@", dbString);


	            [db executeUpdate:dbString];
			}
		}
	}];




	//  NSLog(@"%@~~",  [[NSString stringWithContentsOfFile:[[NSBundle mainBundle]   pathForResource:@"活动类" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil] objectFromJSONString][0][1] );
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
