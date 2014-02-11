//
//  XZWChatCell.h
//  XZW
//
//  Created by dee on 13-10-15.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

//头像大小
#define HEAD_SIZE 50.0f
#define TEXT_MAX_HEIGHT 500.0f
//间距
#define INSETS 8.0f

enum kWCMessageCellStyle {
    kWCMessageCellStyleMe = 0,
    kWCMessageCellStyleOther = 1,
    kWCMessageCellStyleMeWithImage=2,
    kWCMessageCellStyleOtherWithImage=3
};

@protocol XZWChatDelegate <NSObject>

-(void)chatDelete:(int)row;

@end



@interface XZWChatCell : UITableViewCell
{
    UIImageView *_userHead;
    UIImageView *_bubbleBg;
    UIImageView *_headMask;
    UIImageView *_chatImage;
    UILabel *_messageConent;
    
    UILabel *chatTimeUL;
}
@property (nonatomic) enum kWCMessageCellStyle msgStyle;
@property (nonatomic) int height,row;
@property (nonatomic,assign) id<XZWChatDelegate> delegate;

-(void)setHeadImageURL:(NSString*)headImageURL;
-(void)setChatImageURL:(NSString*)chatImageURL;

-(void)setTime:(NSString*)timeString;
-(void)setMessage:(NSString*)aMessage;
@end
