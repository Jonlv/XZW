//
//  XZWChatCell.m
//  XZW
//
//  Created by dee on 13-10-15.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWChatCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWUtil.h"
#import <QuartzCore/QuartzCore.h>


#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@implementation XZWChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _userHead =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        _bubbleBg =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        _messageConent=[[[UILabel alloc]initWithFrame:CGRectZero]autorelease];
        _headMask =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        _chatImage =[[[UIImageView alloc]initWithFrame:CGRectZero]autorelease];
        
        [_messageConent setBackgroundColor:[UIColor clearColor]];
        [_messageConent setFont:[UIFont systemFontOfSize:15]];
        [_messageConent setNumberOfLines:20];
        [self.contentView addSubview:_bubbleBg];
        [self.contentView addSubview:_userHead];
        [self.contentView addSubview:_headMask];
        [self.contentView addSubview:_messageConent];
        [self.contentView addSubview:_chatImage];
        [_chatImage setBackgroundColor:[UIColor redColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [_headMask setImage:[[UIImage imageNamed:@"UserHeaderImageBox"]stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        
        
        chatTimeUL = [[UILabel alloc]   initWithFrame:CGRectMake(100, 3, 120, 20)];
        chatTimeUL.layer.cornerRadius = 4.f;
        chatTimeUL.textAlignment = UITextAlignmentCenter;
        chatTimeUL.textColor = [UIColor whiteColor];
        chatTimeUL.font = [UIFont systemFontOfSize:11];
        chatTimeUL.backgroundColor = [[UIColor blackColor]   colorWithAlphaComponent:.2f];
        [self.contentView addSubview:chatTimeUL];
        [chatTimeUL release];
        
        
        UILongPressGestureRecognizer *ulpgr = [[UILongPressGestureRecognizer alloc]  initWithTarget:self action:@selector(longpress:)];
        [self addGestureRecognizer:ulpgr];
        [ulpgr release];
        
    }
    return self;
}


#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    if (action == @selector(deleteAction:) ||
        action == @selector(broomAction:) ||
        action == @selector(textAction:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

-(void)longpress:(UILongPressGestureRecognizer*)lgr{
     
    
    
    if ([UIMenuController sharedMenuController].menuVisible) {
        
        return ;
    }
    
    [self becomeFirstResponder];
    
    UIMenuItem *textItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ textItem];
    [[UIMenuController sharedMenuController] setTargetRect:[_messageConent   frame] inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
    
}

-(void)deleteAction:(id)sender{
    
    if (_delegate) {
        
        if ([_delegate  respondsToSelector:@selector(chatDelete:)]) {
            
            [_delegate chatDelete:_row];
            
        }
        
    }
}


-(void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    
    NSString *orgin=_messageConent.text;
    CGSize textSize=[orgin sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake((320-HEAD_SIZE-3*INSETS-40), TEXT_MAX_HEIGHT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    switch (_msgStyle) {
        case kWCMessageCellStyleMe:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS + 20,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
        }
            break;
        case kWCMessageCellStyleOther:
        {
            [_chatImage setHidden:YES];
            [_messageConent setHidden:NO];
            [_userHead setFrame:CGRectMake(INSETS, INSETS + 20,HEAD_SIZE , HEAD_SIZE)];
            [_messageConent setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_messageConent.frame.origin.x-15, _messageConent.frame.origin.y-12, textSize.width+30, textSize.height+30);
        }
            break;
        case kWCMessageCellStyleMeWithImage:
        {
            //[_messageConent setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-textSize.width-15, (CELL_HEIGHT-textSize.height)/2, textSize.width, textSize.height)];
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(CELL_WIDTH-INSETS*2-HEAD_SIZE-115, (CELL_HEIGHT-100)/2, 100, 100)];
            [_userHead setFrame:CGRectMake(CELL_WIDTH-INSETS-HEAD_SIZE, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"SenderTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-12, 100+30, 100+30);
        }
            break;
        case kWCMessageCellStyleOtherWithImage:
        {
            [_chatImage setHidden:NO];
            [_messageConent setHidden:YES];
            [_chatImage setFrame:CGRectMake(2*INSETS+HEAD_SIZE+15, (CELL_HEIGHT-100)/2,100,100)];
            [_userHead setFrame:CGRectMake(INSETS, INSETS,HEAD_SIZE , HEAD_SIZE)];
            
            [_bubbleBg setImage:[[UIImage imageNamed:@"ReceiverTextNodeBkg"]stretchableImageWithLeftCapWidth:20 topCapHeight:30]];
            
            _bubbleBg.frame=CGRectMake(_chatImage.frame.origin.x-15, _chatImage.frame.origin.y-12, 100+30, 100+30);
            
        }
            break;
        default:
            break;
    }
    
    
    _headMask.frame=CGRectMake(_userHead.frame.origin.x-3, _userHead.frame.origin.y-1, HEAD_SIZE+6, HEAD_SIZE+6);
    
}
-(void)setHeadImageURL:(NSString*)headImageURL
{
    [_userHead setImageWithURL:[NSURL URLWithString:headImageURL]];
}
-(void)setChatImageURL:(NSString*)chatImage
{
    [_chatImage setImageWithURL:[NSURL URLWithString:chatImage]];
}


-(void)setTime:(NSString*)timeString{
    
    chatTimeUL.text = [XZWUtil judgeChatTimeBySendTime:timeString];
}

-(void)setMessage:(NSString*)aMessage
{
    [_messageConent setText:aMessage];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
