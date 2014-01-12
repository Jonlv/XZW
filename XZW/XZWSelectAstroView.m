//
//  XZWSelectAstroView.m
//  XZW
//
//  Created by dee on 13-9-2.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSelectAstroView.h"
#import "XZWUtil.h"
#import <QuartzCore/QuartzCore.h>


@interface XZWSelectAstroView () {
	UIView *backView;
	UILabel *chineseUL;
	UILabel *dateUL;
}

@end


@implementation XZWSelectAstroView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code


		backView = [[UIView alloc] initWithFrame:CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight)];
		backView.userInteractionEnabled = true;
		[self addSubview:backView];
		[backView release];

		UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, TotalScreenHeight - 88 - 44 - 230, 320, 88 + 230 + 44)];
		backgroundView.userInteractionEnabled = true;
		backgroundView.backgroundColor = [UIColor colorWithHex:0x464d5b alpha:.8f];
		[backView addSubview:backgroundView];
		[backgroundView release];


		UIImageView *toolBarUIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cledertop"]];
		toolBarUIV.layer.shadowOffset = CGSizeMake(0, -2);
		toolBarUIV.frame = CGRectMake(0, 0, 320, 44);
		[backgroundView addSubview:toolBarUIV];
		[toolBarUIV release];


		UILabel *tipUL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 44)];
		tipUL.backgroundColor = [UIColor clearColor];
		tipUL.textColor = [UIColor whiteColor];
		tipUL.text = @"选择星座";
		[backgroundView addSubview:tipUL];
		[tipUL release];


		NSArray *astroArray = @[@"白羊座", @"金牛座", @"双子座", @"巨蟹座", @"狮子座", @"处女座", @"天秤座", @"天蝎座", @"射手座", @"摩羯座", @"水瓶座", @"双鱼座"];

		NSArray *astroPicArray =  @[@"baiyang", @"jinniu", @"shuangzi", @"juxie", @"shizi", @"chunv", @"tiancheng", @"tianxie", @"sheshou", @"mojie", @"shuiping", @"shuangyu"];

		for (int i = 0; i < 12; i++) {
			UIImage *astroUI = [UIImage imageNamed:[astroPicArray objectAtIndex:i]];


			CGFloat width = CGImageGetWidth(astroUI.CGImage) / 2.5f;
			CGFloat height = CGImageGetHeight(astroUI.CGImage) / 2.5f;



			if (!IS_retina) {
				width = CGImageGetWidth(astroUI.CGImage) / 1.5;
				height = CGImageGetHeight(astroUI.CGImage) / 1.5;
			}


			UIButton *astroButton = [UIButton buttonWithType:UIButtonTypeCustom];
			astroButton.frame = CGRectMake(0, 0, width, height);
			astroButton.center = CGPointMake(i % 4  *  80  + 40, (IS_iPhone5 ? 0 : -88) + 285 + 80 * (i / 4));
			[astroButton addTarget:self action:@selector(astroAction:) forControlEvents:UIControlEventTouchUpInside];
			astroButton.tag = i + 1;
			[astroButton setTitle:[astroArray objectAtIndex:i] forState:UIControlStateNormal];
			[astroButton setImage:astroUI forState:UIControlStateNormal];
			[astroButton setTitleColor:[[XZWUtil xzwRedColor] colorWithAlphaComponent:.0f] forState:UIControlStateNormal];
			[astroButton setTitleEdgeInsets:UIEdgeInsetsMake(height, 0, 0, 0)];
			[backView addSubview:astroButton];



			UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(i % 4  *  80  + 70,  (IS_iPhone5 ? 0 : -88) + 50 + 100 * (i / 4), 80, 30)];
			descLabel.text = [astroArray objectAtIndex:i];
			descLabel.font = [UIFont boldSystemFontOfSize:15];
			descLabel.center = CGPointMake(i % 4  *  80  + 40, (IS_iPhone5 ? 0 : -88) + 325 + 80 * (i / 4));
			descLabel.textAlignment = UITextAlignmentCenter;
			descLabel.backgroundColor = [UIColor clearColor];
			descLabel.textColor = [UIColor whiteColor];
			[backView addSubview:descLabel];
			[descLabel release];
		}
	}
	return self;
}

- (void)astroAction:(UIButton *)sender {
	[delegate selectAstro:self selectedAstro:sender.tag - 1 name:[sender titleForState:UIControlStateNormal]];

	[self dismissAnimate];
}

- (void)playAnimate {
	self.alpha = 1.f;

	[UIView animateWithDuration:.3f animations: ^{
	    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
	    backView.frame = CGRectMake(0, 0, 320, TotalScreenHeight);
	}];
}

- (void)dismissAnimate {
	[UIView animateWithDuration:.6f animations: ^{
	    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.0f];
	    backView.frame = CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight);
	} completion: ^(BOOL finished) { self.alpha = 0.f; }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self dismissAnimate];
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
