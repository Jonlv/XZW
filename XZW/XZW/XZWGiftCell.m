//
//  XZWGiftCell.m
//  XZW
//
//  Created by dee on 13-9-29.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWGiftCell.h"
#import "XZWUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Interface.h"

@implementation XZWGiftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        giftUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(5, 8, 60, 60)];
        [self.contentView addSubview:giftUIV];
        [giftUIV release];
        
        
        nameUL = [[UILabel alloc]  initWithFrame:CGRectMake(75,5, 230, 25)];
        nameUL.textColor = [XZWUtil xzwRedColor];
        nameUL.font = [UIFont systemFontOfSize:18];
        [nameUL setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:nameUL];
        [nameUL release];

        
        
        sendLabel = [[RCLabel alloc] initWithFrame:CGRectMake(70, 35 , 230, 20)];
      
        [self.contentView addSubview:sendLabel];
        [sendLabel release];

        dateUL = [[UILabel alloc]   initWithFrame:CGRectMake(75, 60, 200, 20)];
        dateUL.font = [UIFont systemFontOfSize:15];
        [dateUL setBackgroundColor:[UIColor clearColor]];
        dateUL.textColor = [UIColor grayColor];
        [self.contentView addSubview:dateUL];
        [dateUL release];
        
        
        lineView = [[UIView alloc]  initWithFrame:CGRectMake(0, 8, 320, 1)];
        lineView.backgroundColor = [[UIColor grayColor]  colorWithAlphaComponent:.5f];
        [self.contentView addSubview:lineView];
        [lineView release];
        
    }
    return self;
}

-(void)setDic:(NSDictionary*)sendDic isSend:(BOOL)isSend{
    
    [giftUIV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@apps/gift/Tpl/default/Public/gift/%@",XZWHost,[sendDic  objectForKey:@"giftImg"]]]];
    
    nameUL.text = [sendDic  objectForKey:@"giftName"] ;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[sendDic  objectForKey:@"cTime"] longLongValue]];
   
    RTLabelComponentsStructure *componentsDS = nil;
    
    if (!isSend) {
        
        
      componentsDS =  [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=15 color='#919191'>收到了<font><font size=15 color='#e14278'>%@</font><font size=15 color='#919191'>的礼物<font>",[sendDic  objectForKey:@"fromUser"]] ];
        
    }else {
        
        
      componentsDS =  [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=15 color='#919191'>送给了<font><font size=15 color='#e14278'>%@</font><font size=15 color='#919191'><font>",[sendDic  objectForKey:@"toUser"]] ];
    }
    
    sendLabel.componentsAndPlainText = componentsDS;
    
    CGSize optimumSize = CGSizeZero ;
    
    optimumSize = [sendLabel optimumSize];
    
    CGRect myframe = sendLabel.frame ;
    myframe.size.height = optimumSize.height;
    sendLabel.frame = myframe ;
    
    
    dateUL.text = [XZWUtil judgeTimeBySendTime:date];
    
    dateUL.frame = CGRectMake(75, CGRectGetMaxY(sendLabel.frame ) + 4 , 200, 20) ;
    
    lineView.frame = CGRectMake(0, CGRectGetMaxY(sendLabel.frame) + 29 + 2, 320, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
