//
//  XZWGiftCell.h
//  XZW
//
//  Created by dee on 13-9-29.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

@interface XZWGiftCell : UITableViewCell{
    
    UIImageView *giftUIV;
    
    UILabel *nameUL;
    UILabel *giftNameUL;
    UILabel *dateUL;
    
    RCLabel *sendLabel;
    
    UIView  *lineView;
}

-(void)setDic:(NSDictionary*)sendDic isSend:(BOOL)isSend;

@end
