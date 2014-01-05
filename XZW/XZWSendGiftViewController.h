//
//  XZWSendGiftViewController.h
//  XZW
//
//  Created by dee on 13-9-29.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZWSendGiftViewController : UIViewController{
    
    int userID;
}

- (id)initWithName:(NSString*)nameString andUser:(int)theUserID;

@end
