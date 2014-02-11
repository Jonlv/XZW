//
//  XZWAppDelegate.h
//  XZW
//
//  Created by Dee on 13-8-20.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

static float VERSION_CODE;

@interface XZWAppDelegate : UIResponder <UIApplicationDelegate,IIViewDeckControllerDelegate>{
    
     
}

@property (strong, nonatomic) UIWindow *window;

+ (float)VERSION_CODE;

@end
