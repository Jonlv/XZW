//
//  XZWAppDelegate.h
//  XZW
//
//  Created by Dee on 13-8-20.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@class XZWMainViewController;
@class XZWMenuViewController;
static float VERSION_CODE;

@interface XZWAppDelegate : UIResponder <UIApplicationDelegate,IIViewDeckControllerDelegate>{
    
     
}

@property (retain, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController    *xzwNavVC;
@property (nonatomic, retain) XZWMenuViewController     *menuVC;
@property (nonatomic, retain) XZWMainViewController     *mainVC;
+ (float)VERSION_CODE;
+ (XZWAppDelegate *)sharedXZWAppDelegate;
@end
