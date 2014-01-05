//
//  XZWTopContentCell.m
//  XZW
//
//  Created by dee on 13-9-25.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWTopContentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWUtil.h"
#import "UIButton+Extensions.h"

@implementation XZWTopContentCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        avatarUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(5, 5, 47, 47)];
        [self.contentView addSubview:avatarUIV];
        [avatarUIV  release];
        
        nameUL = [[UILabel alloc]   initWithFrame:CGRectMake(60, 2, 260, 30)];
        nameUL.backgroundColor = [UIColor clearColor];
        nameUL.font = [UIFont boldSystemFontOfSize:15];
        [nameUL setTextColor:[XZWUtil xzwRedColor]];
        [self.contentView addSubview:nameUL];
        [nameUL release];
        
        dateUL = [[UILabel alloc]   initWithFrame:CGRectMake(60, 5, 260, 30)];
        dateUL.backgroundColor = [UIColor clearColor];
        dateUL.textColor = [UIColor grayColor];
        dateUL.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:dateUL];
        [dateUL release];
        
        contentUL = [[UILabel alloc]   initWithFrame:CGRectMake(60, 34, 250, 40)];
        contentUL.numberOfLines = 0 ;
        contentUL.textColor = [UIColor grayColor];
        contentUL.backgroundColor = [UIColor clearColor];
        [contentUL  sizeThatFits:CGSizeMake(260, 3000)];
        [self.contentView addSubview:contentUL];
        [contentUL release];
        
        
        
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeButton.frame = CGRectMake(266, 50, 13, 13);
        [likeButton  addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [likeButton  setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
        [likeButton setImage:[UIImage imageNamed:@"zan4"] forState:UIControlStateNormal];
        [likeButton setImage:[UIImage imageNamed:@"hzan"] forState:UIControlStateSelected];
        [self.contentView addSubview:likeButton];
        
        
        
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(296, 50, 13, 13);
        [commentButton  addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [commentButton  setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
        [commentButton setImage:[UIImage imageNamed:@"comment_2"] forState:UIControlStateNormal];
        [self.contentView addSubview:commentButton];
        
        self.contentView.userInteractionEnabled = true;
        
    }
    return self;
}

-(CGFloat)setAvatarURLString:(NSString*)urlString name:(NSString*)nameString description:(NSString*)commentString date:(NSString*)dateString andTag:(int)index andSelect:(BOOL)selected{
    
    [avatarUIV setImageWithURL:[NSURL URLWithString:urlString]];
    nameUL.text = nameString;
    contentUL.text = commentString;
    contentUL.frame = CGRectMake(60, 34, 250, 40);
    [contentUL  sizeThatFits:CGSizeMake(250, 3000)];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]];
    
    dateUL.text = [XZWUtil judgeTimeBySendTime:date];
    
    [contentUL   sizeToFit];
    
    dateUL.frame = CGRectMake(60, CGRectGetMaxY(contentUL.frame) + 8 , 300, 20);
    
    commentButton.frame = CGRectMake(290, CGRectGetMaxY(contentUL.frame) + 13, 15 , 13);
    commentButton.tag = index;
    
    likeButton.frame = CGRectMake(266, CGRectGetMaxY(contentUL.frame) + 11, 15 , 13);
    likeButton.selected = selected;
    likeButton.tag = index ;
    
    
    return CGRectGetMaxY(commentButton.frame) ;
}


-(void)likeAction:(UIButton*)sender{
    
    
    if (delegate) {
    
        if ([delegate respondsToSelector:@selector(likeIndex:)]) {
            
            [delegate likeIndex:sender.tag];
        }
    
    }
    
    
}

-(void)commentAction:(UIButton*)sender{
    
    if (delegate) {
        
        if ([delegate respondsToSelector:@selector(commentIndex:)]) {
            
            [delegate commentIndex:sender.tag];
        }
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
