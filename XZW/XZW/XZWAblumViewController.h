//
//  XZWAblumViewController.h
//  在“个人资料”中点击相册中的“查看更多”后看到的界面
//
//  Created by dee on 13-9-26.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define XZWNotification_AlbumDeleteSuccessfully @"notification_albumDeleteSuccessfully"

@interface XZWAblumViewController : UIViewController

- (id)initWithUserID:(int)theUserID;

@end
