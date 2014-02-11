//
//  XZWStarView.h
//  XZW
//
//  Created by dee on 13-9-4.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZWStarView : UIView



- (id)initWithFrame:(CGRect)frame star:(int)star;

- (id)initWithFrame:(CGRect)frame quanStar:(int)star;


-(void)setStars:(int)star;



- (id)initWithFrame:(CGRect)frame quanDetailStar:(int)star;

-(void)setquanDetailStar:(int)star;

@end
