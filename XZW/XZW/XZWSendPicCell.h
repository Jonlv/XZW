//
//  XZWSendPicCell.h
//  XZW
//
//  Created by dee on 13-10-23.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

@interface XZWSendPicCell : UITableViewCell{
    
    
    
    UIImageView *avatarUIV;
    
    RCLabel *sendLabel;
    
    UILabel *contentUL;
    
    UILabel *dateUL;
    
    
    UIImageView *picUIV;
    
    UIImageView *lineUIV ;
     
    
}



-(CGFloat)setContentDic:(NSDictionary*)contentDic;



@end
