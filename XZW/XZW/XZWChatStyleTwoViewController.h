//
//  XZWChatStyleTwoViewController.h
//  XZW
//
//  Created by dee on 13-12-30.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZWChatStyleTwoViewController : UIViewController



-(void)changeUser:(int)theUserID username:(NSString*)theUserName;

-(id)initWithUserID:(int)theUserID nameString:(NSString *)nameString avatarString:(NSString *)avatarString andChatID:(int)chatID;
-(id)initWithUserID:(int)theUserID nameString:(NSString*)nameString avatarString:(NSString*)avatarString;


@end
