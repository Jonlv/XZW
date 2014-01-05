//
//  XZWQuanIssueTopCell.h
//  XZW
//
//  Created by dee on 13-12-10.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XZWQuanIssueTopCellDelegate <NSObject>


-(void)likeIndex:(int)index;

-(void)commentIndex:(int)index;

-(void)clickPicIndex:(int)index;

@end



@interface XZWQuanIssueTopCell : UITableViewCell{
    
    
    UIImageView *avatarUIV;
    
    UILabel *nameUL,*contentUL;
    
    UILabel *dateUL;
    
    UIButton *commentButton;
    
    UIButton *likeButton;
    
    UIButton *imageButton;
    
    
}

@property (nonatomic,assign) id<XZWQuanIssueTopCellDelegate> delegate;



-(CGFloat)setAvatarURLString:(NSString*)urlString name:(NSString*)nameString description:(NSString*)commentString date:(NSString*)dateString andTag:(int)index andSelect:(BOOL)selected picImage:(NSString*)imageString;

-(CGFloat)setAvatarURLString:(NSString*)urlString name:(NSString*)nameString description:(NSString*)commentString date:(NSString*)dateString andTag:(int)index andSelect:(BOOL)selected;


@end
