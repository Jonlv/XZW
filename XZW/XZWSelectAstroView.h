//
//  XZWSelectAstroView.h
//  XZW
//
//  Created by dee on 13-9-2.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XZWSelectAstroView;
@protocol XZWSelectAstroViewDelegate <NSObject>

-(void)selectAstro:(XZWSelectAstroView*)astroView selectedAstro:(int) selectedAstro name:(NSString*)nameString;

@end


@interface XZWSelectAstroView : UIView

@property (nonatomic,assign) id<XZWSelectAstroViewDelegate> delegate;

-(void)playAnimate;

@end
