//
//  XZWQuanIssueCell.h
//  XZW
//
//  Created by dee on 13-10-10.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

@interface XZWQuanIssueCell : UITableViewCell{
    
    UIImageView *avatarUIV;
    
    RCLabel *sendLabel;
    
    UILabel *contentUL;
    
    UILabel *dateUL;
    
    UIImageView *postImageView;
    
    
    UIButton *commentButton;
    
    
    UIButton *likeButton;
    
    UIImageView *lineUIV ;
    
    RCLabel *fromUL;

}


-(CGFloat)setContentDic4Feed:(NSDictionary*)contentDic;

-(CGFloat)setContentDic:(NSDictionary*)contentDic;

-(CGFloat)setAvatarURLString:(NSString*)urlString name:(NSString*)nameString type:(NSString*)type postImage:(NSString*)imageUrlString date:(NSString*)dateString description:(NSString*)commentString;

@end
