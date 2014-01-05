//
//  XZWQuanIssueCell.m
//  XZW
//
//  Created by dee on 13-10-10.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWQuanIssueCell.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWUtil.h"

@implementation XZWQuanIssueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        avatarUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(5, 5, 47, 47)];
        [self.contentView addSubview:avatarUIV];
        [avatarUIV  release];
        
        sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(56, 8 , 250, 20)]  autorelease];
        [self.contentView addSubview:sendLabel];
        [sendLabel release];
        
        dateUL = [[UILabel alloc]   initWithFrame:CGRectMake(210, 5, 105, 30)];
        dateUL.textAlignment = UITextAlignmentRight;
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
        
        postImageView = [[UIImageView alloc]  initWithFrame:CGRectMake(40, 40, 100, 100)];
        postImageView.clipsToBounds = true;
        postImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:postImageView];
        [postImageView release];
        
        
        
        
        
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeButton.frame = CGRectMake(266, 50, 9, 11);
        [likeButton titleLabel].font = [UIFont systemFontOfSize:13];
        [likeButton  setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
        [likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     //   [likeButton  addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        [likeButton setBackgroundImage:[UIImage imageNamed:@"zanfinger"] forState:UIControlStateNormal];
        [likeButton setBackgroundImage:[UIImage imageNamed:@"zanfinger"] forState:UIControlStateSelected];
        [self.contentView addSubview:likeButton];
        
        
        
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(296, 50, 13, 13);
        [commentButton titleLabel].font = [UIFont systemFontOfSize:13];
        [commentButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
        [commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
     //   [commentButton  addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        [commentButton setBackgroundImage:[UIImage imageNamed:@"comment_2"] forState:UIControlStateNormal];
        [self.contentView addSubview:commentButton];
        
        
        
        
        lineUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 87, 320, 1)];
        lineUIV.image = [UIImage imageNamed:@"ys_line"];
        [self.contentView addSubview:lineUIV];
        [lineUIV release];
        
        
        fromUL = [[[RCLabel alloc] initWithFrame:CGRectMake(56, 38 , 250, 20)]  autorelease];
        [self.contentView addSubview:fromUL];
        [fromUL release];

        
    }
    return self;
}

-(void)likeAction:(UIButton*)button{
    
    
}

-(void)commentAction:(UIButton*)button{
    
    
}

 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(CGFloat)setContentDic4Feed:(NSDictionary*)contentDic{
    
    [avatarUIV setImageWithURL:[NSURL URLWithString:contentDic[@"avatar"]]];
    
    
    
    sendLabel.frame = CGRectMake(56, 8 , 250, 20);
    
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@" <font size=15 color='#e14278'>%@</font><font size=13 color='#919191'> %@<font>",contentDic[@"uname"],contentDic[@"act_text"]] ];
    sendLabel.componentsAndPlainText = componentsDS;
    
    CGSize optimumSize = CGSizeZero ;
    
    optimumSize = [sendLabel optimumSize];
    
    CGRect myframe = sendLabel.frame ;
    myframe.size.height = optimumSize.height;
    sendLabel.frame = myframe ;
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[contentDic[@"time"] longLongValue]];
    dateUL.text = [XZWUtil judgeTimeBySendTime:date];
    
    contentUL.text = contentDic[@"content"];
    contentUL.frame = CGRectMake(60, CGRectGetMaxY(sendLabel.frame) + 10, 250, 40);
    [contentUL  sizeToFit];
    
    
    
    fromUL.frame = CGRectMake(56, CGRectGetMaxY(contentUL.frame) + 10 , 250, 20);
    
    componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#919191'>来自<font> <font size=13 color='#e14278'>%@</font>",contentDic[@"discuss_name"]] ];
    fromUL.componentsAndPlainText = componentsDS;
    
    optimumSize = [fromUL optimumSize];
    
    myframe = fromUL.frame ;
    myframe.size.height = optimumSize.height;
    fromUL.frame = myframe ;
    
    
    
    
    likeButton.frame = CGRectMake(256, CGRectGetMaxY(contentUL.frame) + 10, 13, 13);
    [likeButton setTitle:contentDic[@"diggs"] forState:UIControlStateNormal];
    
    commentButton.frame = CGRectMake(286, CGRectGetMaxY(contentUL.frame) + 10, 13, 13);
    [commentButton setTitle:contentDic[@"comments"] forState:UIControlStateNormal];
    
    
    
    lineUIV.frame = CGRectMake(0, CGRectGetMaxY(commentButton.frame) + 5, 320, 1);
    
    
    return 0.f;
}


////

-(CGFloat)setContentDic:(NSDictionary*)contentDic{
    
    [avatarUIV setImageWithURL:[NSURL URLWithString:contentDic[@"avatar"]]];
    
    
    
    sendLabel.frame = CGRectMake(56, 8 , 250, 20);
    
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@" <font size=15 color='#e14278'>%@</font><font size=13 color='#919191'> %@<font>",contentDic[@"uname"],contentDic[@"act_text"]] ];
    sendLabel.componentsAndPlainText = componentsDS;
    
    CGSize optimumSize = CGSizeZero ;
    
    optimumSize = [sendLabel optimumSize];
    
    CGRect myframe = sendLabel.frame ;
    myframe.size.height = optimumSize.height;
    sendLabel.frame = myframe ;
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[contentDic[@"time"] longLongValue]];
    dateUL.text = [XZWUtil judgeTimeBySendTime:date];
        
    contentUL.text = contentDic[@"content"];
    contentUL.frame = CGRectMake(60, CGRectGetMaxY(sendLabel.frame) + 10, 250, 40);
    [contentUL  sizeToFit];

     
    
    fromUL.frame = CGRectMake(56, CGRectGetMaxY(contentUL.frame) + 10 , 250, 20);
    
    componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#919191'>来自<font> <font size=13 color='#e14278'>%@</font>",contentDic[@"group_name"]] ];
    fromUL.componentsAndPlainText = componentsDS;
    
    optimumSize = [fromUL optimumSize];
    
     myframe = fromUL.frame ;
    myframe.size.height = optimumSize.height;
    fromUL.frame = myframe ;
    

    
    
    likeButton.frame = CGRectMake(256, CGRectGetMaxY(contentUL.frame) + 10, 13, 13);
    [likeButton setTitle:contentDic[@"diggs"] forState:UIControlStateNormal];
    
    commentButton.frame = CGRectMake(286, CGRectGetMaxY(contentUL.frame) + 10, 13, 13);
    [commentButton setTitle:contentDic[@"comments"] forState:UIControlStateNormal];
    
       
    
    lineUIV.frame = CGRectMake(0, CGRectGetMaxY(commentButton.frame) + 5, 320, 1);
    
    
    return 0.f;
}


////

-(CGFloat)setAvatarURLString:(NSString*)urlString name:(NSString*)nameString type:(NSString*)type postImage:(NSString*)imageUrlString date:(NSString*)dateString description:(NSString*)commentString{
    
    [avatarUIV setImageWithURL:[NSURL URLWithString:urlString]];
    
    
    NSString *actionDescription = nil ;
    
    
    if ([type isEqualToString:@"post"]) {
        
        actionDescription = @"发表了";
        postImageView.hidden = true;
        
        
    }else if ([type isEqualToString:@"postimage"]){
        
        actionDescription = @"上传了图片";
        postImageView.hidden = false;
        
    }else {
        
        
    } 
    
    
    sendLabel.frame = CGRectMake(56, 8 , 250, 20);
    
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@" <font size=15 color='#e14278'>%@</font><font size=15 color='#919191'>%@<font>",nameString,actionDescription] ];
    sendLabel.componentsAndPlainText = componentsDS;
   
    CGSize optimumSize = CGSizeZero ;
    
    optimumSize = [sendLabel optimumSize];
    
    CGRect myframe = sendLabel.frame ;
    myframe.size.height = optimumSize.height;
    sendLabel.frame = myframe ;
    
    
    
    
    
    contentUL.text = commentString;
    contentUL.frame = CGRectMake(60, CGRectGetMaxY(sendLabel.frame) + 10, 250, 40);
    [contentUL  sizeToFit];
    
    
    if ([type isEqualToString:@"postimage"]){
        
        
        postImageView.frame = CGRectMake(60, CGRectGetMaxY(contentUL.frame ) + 10  , 100, 100);
        [postImageView setImageWithURL:[NSURL URLWithString:[[imageUrlString  stringByReplacingOccurrencesOfString:@".jpg" withString:@"_200_200.jpg"] stringByReplacingOccurrencesOfString:@".png" withString:@"_200_200.png"]]];
        
        
    }
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]];
    dateUL.text = [XZWUtil judgeTimeBySendTime:date];
    
    if (postImageView.hidden) {
        
        
        dateUL.frame = CGRectMake(60, CGRectGetMaxY(contentUL.frame) + 8 , 300, 20);
        
        
        likeButton.frame = CGRectMake(266, CGRectGetMinY(dateUL.frame), 13, 13);
        
        commentButton.frame = CGRectMake(296, CGRectGetMinY(dateUL.frame), 13, 13);
        
    }else {
        
        
        dateUL.frame = CGRectMake(60, CGRectGetMaxY(postImageView.frame) + 8 , 300, 20);
        
        
        likeButton.frame = CGRectMake(266, CGRectGetMinY(dateUL.frame), 13, 13);
        
        commentButton.frame = CGRectMake(296, CGRectGetMinY(dateUL.frame), 13, 13);

    }
    
    lineUIV.frame =  CGRectMake(0, CGRectGetMaxY(dateUL.frame) + 9, 320, 1) ;
    
    return CGRectGetHeight(dateUL.frame) + 10;
    
}



-(CGFloat)setAvatarURLString:(NSString*)urlString name:(NSString*)nameString description:(NSString*)commentString date:(NSString*)dateString andTag:(int)index andSelect:(BOOL)selected{
    
    [avatarUIV setImageWithURL:[NSURL URLWithString:urlString]];
    
    
    
    
    
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


@end
