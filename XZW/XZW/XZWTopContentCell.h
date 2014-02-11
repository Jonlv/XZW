//
//  XZWTopContentCell.h
//  XZW
//
//  Created by dee on 13-9-25.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZWTopContentCellDelegate <NSObject>


-(void)likeIndex:(int)index;

-(void)commentIndex:(int)index;


@end




@interface XZWTopContentCell : UITableViewCell{
    
    
    UIImageView *avatarUIV;
    
    UILabel *nameUL,*contentUL;
    
    UILabel *dateUL;
    
    UIButton *commentButton;
    
    
    UIButton *likeButton;
    
}

@property (nonatomic,assign) id<XZWTopContentCellDelegate> delegate;



-(CGFloat)setAvatarURLString:(NSString*)urlString name:(NSString*)nameString description:(NSString*)commentString date:(NSString*)dateString andTag:(int)index andSelect:(BOOL)selected;

@end
