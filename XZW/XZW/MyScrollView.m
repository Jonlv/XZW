
#import "MyScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>

@implementation MyScrollView


@synthesize image;


#pragma mark -
#pragma mark === Intilization ===
#pragma mark -
- (id)initWithFrame:(CGRect)frame imageUrlString:(NSString*)urlString
{
    if ((self = [super initWithFrame:frame]))
	{
		self.delegate = self;
		self.minimumZoomScale = 0.5;
		self.maximumZoomScale = 2.5;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;

		imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		imageView.contentMode = UIViewContentModeScaleAspectFit;

		[self addSubview:imageView];

        [self setImageWithUrl:urlString];
        // UIActivityIndicatorView *activityView
    }

    return self;
}

- (void)setImage:(UIImage *)img
{
	imageView.image = img;
}

- (void)setImageWithUrl:(NSString*)urlString
{
    [imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
}

#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return imageView;
}

#pragma mark -
#pragma mark === UITouch Delegate ===
#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];

	if ([touch tapCount] == 2)
	{
		CGFloat zs = self.zoomScale;
		zs = (zs == 1.0) ? 2.0 : 1.0;
		[self setZoomScale:zs animated:true];

	} else if ([touch tapCount] == 1) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];

        UIView *bar = [[[self superview]  superview]  viewWithTag:1111];

        bar.alpha  = bar.alpha ==0 ?   1:  0;

        [UIView commitAnimations];
    }
}

#pragma mark -
#pragma mark === dealloc ===
#pragma mark -
- (void)dealloc
{
	[image release];
	[imageView release];

    [super dealloc];
}


@end
