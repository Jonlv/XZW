//
 
#import <UIKit/UIKit.h>


@interface MyScrollView : UIScrollView <UIScrollViewDelegate>
{
	UIImage *image;
	UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame imageUrlString:(NSString*)urlString;

-(void)setImageWithUrl:(NSString*)urlString;

@property (nonatomic, retain) UIImage *image;

@end
