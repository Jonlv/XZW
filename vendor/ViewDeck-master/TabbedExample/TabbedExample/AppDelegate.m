//
//  AppDelegate.m
//  TabbedExample
//
//  Created by Tom Adriaenssen on 03/02/12.
//  Copyright (c) 2012 Adriaenssen BVBA. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "IIViewDeckController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"
#import "SelectorController.h"
#import "IIWrapController.h"

#define VIEWDECK_ENABLED YES
#define TABBAR_ENABLED YES

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    
    
    NSArray *pData = [NSArray arrayWithObjects: [NSArray arrayWithObjects:[NSNumber numberWithDouble:358.4758], [NSNumber numberWithDouble:35999.05], [NSNumber numberWithDouble:-0.0002], [NSNumber numberWithDouble:0.01675], [NSNumber numberWithDouble:-0.00004], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1], [NSNumber numberWithDouble:101.2208], [NSNumber numberWithDouble:1.7192], [NSNumber numberWithDouble:0.00045], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], nil],
                      
                      [NSArray array],
                      
                      
                      [NSArray arrayWithObjects:[NSNumber numberWithDouble:102.2794], [NSNumber numberWithDouble:149472.5], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.205614], [NSNumber numberWithDouble:0.00002], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.3871], [NSNumber numberWithDouble:28.7538], [NSNumber numberWithDouble:0.3703], [NSNumber numberWithDouble:0.0001], [NSNumber numberWithDouble:47.1459], [NSNumber numberWithDouble:1.1852], [NSNumber numberWithDouble:0.0002], [NSNumber numberWithDouble:7.009], [NSNumber numberWithDouble:0.00186], nil],
                      
                      
                      [NSArray arrayWithObjects:[NSNumber numberWithDouble:212.6032], [NSNumber numberWithDouble:58517.8], [NSNumber numberWithDouble:0.0013], [NSNumber numberWithDouble:0.00682], [NSNumber numberWithDouble:-0.00005], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.7233], [NSNumber numberWithDouble:54.3842], [NSNumber numberWithDouble:0.5082], [NSNumber numberWithDouble:-0.0014], [NSNumber numberWithDouble:75.7796], [NSNumber numberWithDouble:0.8999], [NSNumber numberWithDouble:0.0004], [NSNumber numberWithDouble:3.3936], [NSNumber numberWithDouble:0.001], nil],
                      
                      
                      
                      [NSArray arrayWithObjects:[NSNumber numberWithDouble:319.5294], [NSNumber numberWithDouble:19139.86], [NSNumber numberWithDouble:0.0002], [NSNumber numberWithDouble:0.09331], [NSNumber numberWithDouble:0.00009], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1.5237], [NSNumber numberWithDouble:285.4318], [NSNumber numberWithDouble:1.0698], [NSNumber numberWithDouble:0.0001], [NSNumber numberWithDouble:48.7864], [NSNumber numberWithDouble:0.77099], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1.8503], [NSNumber numberWithDouble:-0.0007], nil],
                      
                      
                      
                      
                      
                      
                      [NSArray arrayWithObjects:[NSNumber numberWithDouble:225.4928], [NSNumber numberWithDouble:3033.688], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.04838], [NSNumber numberWithDouble:-0.00002], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:5.2029], [NSNumber numberWithDouble:273.393], [NSNumber numberWithDouble:1.3383], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:99.4198], [NSNumber numberWithDouble:1.0583], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1.3097], [NSNumber numberWithDouble:-0.0052], nil],
                      
                      
                      
                      
                      
                      
                      [NSArray arrayWithObjects:[NSNumber numberWithDouble:174.2153], [NSNumber numberWithDouble:1223.508], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.05423], [NSNumber numberWithDouble:-0.0002], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:9.5525], [NSNumber numberWithDouble:338.9117], [NSNumber numberWithDouble:-0.3167], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:112.8261], [NSNumber numberWithDouble:0.8259], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:2.4908], [NSNumber numberWithDouble:-0.0047], nil],
                      
                      
                      
                      
                      
                      
                      
                      [NSArray arrayWithObjects:[NSNumber numberWithDouble:74.1757], [NSNumber numberWithDouble:427.2742], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.04682], [NSNumber numberWithDouble:0.00042], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:19.2215], [NSNumber numberWithDouble:95.6863], [NSNumber numberWithDouble:2.0508], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:73.5222], [NSNumber numberWithDouble:0.5242], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.7726], [NSNumber numberWithDouble:0.0001], nil],
                      
                      
                      
                      
                      
                      [NSArray arrayWithObjects:[NSNumber numberWithDouble:30.13294], [NSNumber numberWithDouble:240.4552], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.00913], [NSNumber numberWithDouble:-0.00127], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:30.11375], [NSNumber numberWithDouble:284.1683], [NSNumber numberWithDouble:-21.6329], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:130.6841], [NSNumber numberWithDouble:1.1005], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:1.7794], [NSNumber numberWithDouble:-0.0098], nil],
                      
                      
                      
                      [NSArray arrayWithObjects:[NSNumber numberWithDouble:229.9472], [NSNumber numberWithDouble:144.9131], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0.24864], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:39.51774], [NSNumber numberWithDouble:113.5214], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:0], [NSNumber numberWithDouble:108.9544], [NSNumber numberWithDouble:1.39601], [NSNumber numberWithDouble:0.00031], [NSNumber numberWithDouble:17.14678], [NSNumber numberWithDouble:0], nil],
                      
                      
                      nil];
    
   int  t = 1;
    
    for (int i = 0; i < 10; i++) {
        
        if (i == 1) {
            i = 2;
        }
        
        
        double m = 0.01745329 * [self mod:( [pData[i][0]  doubleValue] +  [pData[i][1]   doubleValue] * t +  [pData[i][2]  doubleValue]  * t * t  )     y:360] ;
        
        NSLog(@"i m %lf",[pData[i][0]  doubleValue]);
        
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    array[0] = [NSMutableArray array];
    array[0][0] =@1;
    
    
    NSLog(@"array %@",array);
    
    
    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    if (VIEWDECK_ENABLED) { 
        UIViewController *selectorController = [[SelectorController alloc] initWithNibName:@"SelectorController" bundle:nil];
        
        IIViewDeckController* deckController = [[IIViewDeckController alloc] initWithCenterViewController:viewController1 leftViewController:selectorController];
        deckController.automaticallyUpdateTabBarItems = YES;
        deckController.navigationControllerBehavior = IIViewDeckNavigationControllerIntegrated;
        deckController.maxSize = 220;
        viewController1 = deckController;
    }
    viewController1 = [[IIWrapController alloc] initWithViewController:[[UINavigationController alloc] initWithRootViewController:viewController1]];
    
    if (TABBAR_ENABLED) {
        self.tabBarController = [[UITabBarController alloc] init];
        self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, nil];
        self.window.rootViewController = self.tabBarController;
    }
    else {
        self.window.rootViewController = viewController1;
    }

    [self.window makeKeyAndVisible];
    return YES;
}



-(double)mod:(int)n y:(int )m{
    
    if (n % m ==0) {
        
        return n % m;
        
    }else {
        
        return n-((int)(n/m) * m);
    }
}

- (UIViewController*)controllerForIndex:(int)index {
    switch (index) {
        case 0:
            return [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
        case 1:
            return [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];
        case 2:
            return [[FourthViewController alloc] initWithNibName:@"FourthViewController" bundle:nil];
        case 3:
            return [[FifthViewController alloc] initWithNibName:@"FifthViewController" bundle:nil];
    }
    
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
