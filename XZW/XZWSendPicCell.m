//
//  XZWSendPicCell.m
//  XZW
//
//  Created by dee on 13-10-23.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSendPicCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWUtil.h"
#import "Interface.h"

@implementation XZWSendPicCell

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
        
        
        picUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 87, 320, 1)];
        picUIV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:picUIV];
        [picUIV release];
        
        
        
        lineUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 87, 320, 1)];
        lineUIV.image = [UIImage imageNamed:@"ys_line"];
        [self.contentView addSubview:lineUIV];
        [lineUIV release];
        
         
        
    }
    return self;
}



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
    
//    contentUL.text = contentDic[@"content"];
//    contentUL.frame = CGRectMake(60, CGRectGetMaxY(sendLabel.frame) + 10, 250, 40);
//    [contentUL  sizeToFit];
    
    picUIV.frame = CGRectMake(60, CGRectGetMaxY(sendLabel.frame) + 10, 70, 70);
    [picUIV   setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/data/upload/%@",XZWHost,[contentDic[@"savepath"]   stringByReplacingOccurrencesOfString:@".jpg" withString:@"_200_200.jpg"]]]];
    
    lineUIV.frame =  CGRectMake(0, CGRectGetMaxY(picUIV.frame) + 8 , 320, 1);
       
    
    
    return 0.f;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
