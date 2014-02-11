//
//  XZWGiftListViewController.h
//  XZW
//
//  Created by dee on 13-9-29.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZWNetworkManager.h"

@interface XZWGiftListViewController : UIViewController{
    
    
    
    UIScrollView *catelogUSV;
    
    UIScrollView *contentUSV;
    
    NSString *usernameString;
    
    int userID;
    
    int clickTag;
    
}


- (id)initWithName:(NSString*)nameString andUser:(int)theUserID;

@end
