//
//  XZWChatViewController.h
//  XZW
//
//  Created by dee on 13-10-15.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZWChatViewController : UIViewController


// chat id 为 0 直接对话。


-(void)changeUser:(int)theUserID username:(NSString*)theUserName;

-(id)initWithUserID:(int)theUserID nameString:(NSString *)nameString avatarString:(NSString *)avatarString andChatID:(int)chatID;
-(id)initWithUserID:(int)theUserID nameString:(NSString*)nameString avatarString:(NSString*)avatarString;

@end
