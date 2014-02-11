//
//  XZWStarView.m
//  XZW
//
//  Created by dee on 13-9-4.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWStarView.h"

@implementation XZWStarView

- (id)initWithFrame:(CGRect)frame star:(int)star
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        for (int i = 0 ; i < 5 ; i++) {
            
            UIImageView *starUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(15 * i , 0, 12, 12)];
           
            if (star > i) {
                
                starUIV.image = [UIImage imageNamed:@"redstar"];
            }else {
                
                starUIV.image = [UIImage imageNamed:@"graystar"];
            }
            
            [self addSubview:starUIV];
            [starUIV release];
            
            
        }
        
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame quanDetailStar:(int)star{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        for (int i = 0 ; i < 5 ; i++) {
            
            UIImageView *starUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(17  *  i , 0, 16, 16)];
            starUIV.tag = i + 1;
        
            [self addSubview:starUIV];
            [starUIV release];
            
            
        }
        
    }
    return self;
    
}



-(void)setquanDetailStar:(int)star{
    
    for (int i = 0 ; i < 5 ; i++) {
        
        UIImageView *starUIV = (UIImageView *)[self viewWithTag: ( 5 - i )  ];
        if (star > i) {
            
            starUIV.image = [UIImage imageNamed:@"star_j"];
            
        }else {
            
            starUIV.image = nil;
        }
        
        
    }
    
}




#pragma mark -


- (id)initWithFrame:(CGRect)frame quanStar:(int)star
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        for (int i = 0 ; i < 5 ; i++) {
            
            UIImageView *starUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(13 * i , 0, 16, 16)];
            starUIV.tag = i + 1;
            if (star > i) {
                
                starUIV.image = [UIImage imageNamed:@"e_r_star"];
            }else {
                
                starUIV.image = [UIImage imageNamed:@"e_g_star"];
            }
            
            [self addSubview:starUIV];
            [starUIV release];
            
            
        }
        
    }
    return self;
}



-(void)setStars:(int)star{
    
    for (int i = 0 ; i < 5 ; i++) {
        
        UIImageView *starUIV = (UIImageView *)[self viewWithTag:i+1]; 
        if (star > i) {
            
            starUIV.image = [UIImage imageNamed:@"e_r_star"];
        }else {
            
            starUIV.image = [UIImage imageNamed:@"e_g_star"];
        }
                 
        
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
