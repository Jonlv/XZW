//
//  MyScrollView.h
//  单张相片的显示界面，可以缩放
//
//
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//
 
#import <UIKit/UIKit.h>


@interface MyScrollView : UIScrollView <UIScrollViewDelegate>
{
	UIImage *image;
	UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame imageUrlString:(NSString*)urlString;

- (void)setImageWithUrl:(NSString*)urlString;

@property (nonatomic, retain) UIImage *image;

@end
