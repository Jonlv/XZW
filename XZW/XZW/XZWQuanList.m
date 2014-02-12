//
//  XZWQuanList.m
//  XZW
//
//  Created by dee on 13-9-24.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWQuanList.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWStarView.h"


#define kMBProgessHud 8888

@implementation XZWQuanList
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame andLinkString:(NSString *)linkStringArg {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code

		zhiDaoArray  = [[NSMutableArray alloc] init];
		current = 1;
        linkPreString = [[NSMutableString alloc] initWithFormat:@"%@", linkStringArg];

		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];


		MBProgressHUD *mbProgessHud = [[MBProgressHUD alloc] initWithView:self];
		mbProgessHud.tag = kMBProgessHud;
		mbProgessHud.labelText = @"加载中...";
		[self addSubview:mbProgessHud];
		[mbProgessHud release];
		[mbProgessHud show:true];


		resolveRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d", linkPreString, current]]];

		[resolveRequest startAsynchronous];
		isLoading = true;

		[resolveRequest setCompletionBlock: ^{
		    myTableView = [[UITableView alloc] initWithFrame:self.bounds];
		    [self addSubview:myTableView];
		    myTableView.backgroundColor = [UIColor clearColor];
		    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
		    myTableView.delegate = self;
		    myTableView.dataSource = self;
		    [myTableView release];


		    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
		    [myTableView setTableFooterView:footerView];

		    UILabel *ul = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
		    ul.text = @"加载中...";
		    ul.backgroundColor = [UIColor clearColor];
		    ul.textAlignment = UITextAlignmentCenter;
		    [footerView addSubview:ul];
		    [ul release];

		    UIActivityIndicatorView *uaiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		    uaiv.frame = CGRectMake(95, 5, 30, 30);
		    [footerView addSubview:uaiv];
		    [uaiv release];
		    [uaiv startAnimating];


		    totalPage = [[[[[resolveRequest responseData] objectFromJSONData] objectForKey:@"data"] objectForKey:@"totalPages"] intValue];

		    [self bringSubviewToFront:mbProgessHud];


		    if ([[[[[resolveRequest responseData] objectFromJSONData] objectForKey:@"data"] objectForKey:@"data"] count] == 0 || [[[[[resolveRequest responseData]   objectFromJSONData] objectForKey:@"data"] objectForKey:@"data"] count] < 20) {
		        isFinished = true;

		        [myTableView.tableFooterView setHidden:true];
		        myTableView.tableFooterView = nil;

		        //    return  ;
			}


		    [zhiDaoArray setArray:[[[[resolveRequest responseData] objectFromJSONData] objectForKey:@"data"] objectForKey:@"data"]];


		    refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - myTableView.bounds.size.height, self.frame.size.width, myTableView.bounds.size.height)];
		    refreshView.delegate = self;
		    [myTableView addSubview:refreshView];
		    [refreshView release];

		    [refreshView refreshLastUpdatedDate];



		    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
		    isLoading = false;


		    [mbProgessHud hide:true afterDelay:.6f];

		    [myTableView reloadData];
		}];

		[resolveRequest setFailedBlock: ^{
		    [self bringSubviewToFront:mbProgessHud];
		    [mbProgessHud hide:true afterDelay:.8f];


		    [self doneLoadingTableViewData];
		    isLoading = false;
		}];
	}
	return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */




#pragma mark -

- (void)dealloc {
	[self stopLoading];

	[zhiDaoArray  release];
	[linkPreString release];

	[super dealloc];
}

- (void)stopLoading {
	if (resolveRequest) {
		[resolveRequest cancel];
		[resolveRequest release];
		resolveRequest = nil;
	}
}

#pragma mark -


- (void)loadNewPage {
	if (isLoading) {
		return;
	}

	if (isFinished) {
		return;
	}

	if (totalPage <= current) {
		isFinished = true;

		[myTableView.tableFooterView setHidden:true];
		myTableView.tableFooterView = nil;

		return;
	}

	if (resolveRequest) {
		[resolveRequest cancel];
		[resolveRequest release];
		resolveRequest = nil;
	}


	resolveRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d", linkPreString, current + 1]]];

	[resolveRequest startAsynchronous];


	[resolveRequest setCompletionBlock: ^{
	    // Use when fetching binary data
	    NSData *responseData = [resolveRequest responseData];


	    isLoading = false;

	    totalPage = [[[[[resolveRequest responseData]   objectFromJSONData] objectForKey:@"data"] objectForKey:@"totalPages"]  intValue];


	    if ([[[[[resolveRequest responseData]   objectFromJSONData] objectForKey:@"data"] objectForKey:@"data"]  count]  == 0) {
	        isFinished = true;



	        [myTableView.tableFooterView setHidden:true];
	        myTableView.tableFooterView = nil;

	        return;
		}


	    [zhiDaoArray addObjectsFromArray:[[[responseData   objectFromJSONData] objectForKey:@"data"] objectForKey:@"data"]];




	    [myTableView reloadData];


	    current++;
	}];
	[resolveRequest setFailedBlock: ^{
	    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
	    isLoading = false;
	}];
}

- (void)reloadFirst {
	isLoading = true;


	isFinished = false;


	current  = 1;


	if (resolveRequest) {
		[resolveRequest   cancel];
		[resolveRequest release];
		resolveRequest = nil;
	}


	resolveRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d", linkPreString, current]]];


	MBProgressHUD *hud =  (MBProgressHUD *)[self viewWithTag:kMBProgessHud];
	[hud show:true];

	[resolveRequest startAsynchronous];


	[resolveRequest setCompletionBlock: ^{
	    // Use when fetching binary data
	    NSData *responseData = [resolveRequest responseData];


	    isLoading = false;

	    if ([[[[[resolveRequest responseData]   objectFromJSONData] objectForKey:@"data"] objectForKey:@"data"]  count]  == 0) {
	        isFinished = true;


	        [myTableView.tableFooterView setHidden:true];
	        myTableView.tableFooterView = nil;
		}
	    else {
	        UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
	        [myTableView setTableFooterView:footerView];

	        UILabel *ul = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	        ul.text = @"加载中...";
	        ul.backgroundColor = [UIColor clearColor];
	        ul.textAlignment = UITextAlignmentCenter;
	        [footerView addSubview:ul];
	        [ul release];

	        UIActivityIndicatorView *uaiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	        uaiv.frame = CGRectMake(95, 5, 30, 30);
	        [footerView addSubview:uaiv];
	        [uaiv release];
	        [uaiv startAnimating];
		}

	    [zhiDaoArray setArray:[[[responseData   objectFromJSONData] objectForKey:@"data"] objectForKey:@"data"]];


	    //  current ++;




	    [myTableView reloadData];

	    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];



	    [hud hide:true afterDelay:1.f];
	}];
	[resolveRequest setFailedBlock: ^{
	    [hud hide:true afterDelay:1.f];

	    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];

	    isLoading = false;
	}];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource {
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	isLoading = YES;
}

- (void)doneLoadingTableViewData {
	//  model should call this when its done loading
	isLoading = NO;
	[refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:myTableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[refreshView egoRefreshScrollViewDidScroll:scrollView];


	if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + 5) {
		[self performSelector:@selector(loadNewPage)];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
	[self reloadTableViewDataSource];

	[self performSelector:@selector(reloadFirst) withObject:nil];


	//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
	return isLoading; // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
	return [NSDate date]; // should return date data source was last changed
}

#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [zhiDaoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 91;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyCustomCellIdentifier = @"mycell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.clipsToBounds = true;

		UIImageView *ageUIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
		ageUIV.contentMode = UIViewContentModeScaleAspectFill;
		ageUIV.tag = 332;
		ageUIV.clipsToBounds = true;
		[cell.contentView addSubview:ageUIV];
		[ageUIV release];


		UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, 320, 25)];
		grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
		[cell.contentView addSubview:grayView];
		[grayView release];


		UIImageView *headerUIV = [[UIImageView alloc] initWithFrame:CGRectMake(13, 43, 40, 40)];
		headerUIV.tag = 334;
		headerUIV.layer.cornerRadius = 6.f;
		headerUIV.layer.masksToBounds = YES;
		headerUIV.layer.borderWidth = 1.f;
		headerUIV.layer.borderColor = [UIColor whiteColor].CGColor;
		[cell.contentView addSubview:headerUIV];
		[headerUIV release];

		// name
		UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(63, 37, 230, 30)];
		myLabel.tag = 3335;
		myLabel.backgroundColor = [UIColor clearColor];
		myLabel.numberOfLines = 1;
		myLabel.font = [UIFont boldSystemFontOfSize:25];
		myLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
		myLabel.shadowOffset = CGSizeMake(1, 1);
		myLabel.textColor = [UIColor whiteColor];
		[cell.contentView addSubview:myLabel];
		[myLabel release];


		//
		UIImageView *oddUIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"friends"]];
		oddUIV.center = CGPointMake(70, 78);
		[cell.contentView addSubview:oddUIV];
		[oddUIV release];


		oddUIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment"]];
		oddUIV.center = CGPointMake(125, 78);
		[cell.contentView addSubview:oddUIV];
		[oddUIV release];


		oddUIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zan"]];
		oddUIV.center = CGPointMake(168, 78);
		[cell.contentView addSubview:oddUIV];
		[oddUIV release];

		//////
		// members
		UILabel *ageUL = [[UILabel alloc] initWithFrame:CGRectMake(79, 71, 110, 15)];
		ageUL.tag = 3888;
		ageUL.adjustsFontSizeToFitWidth = true;
		ageUL.backgroundColor = [UIColor clearColor];
		ageUL.font = [UIFont systemFontOfSize:12];
		ageUL.textColor = [UIColor whiteColor];
		[cell.contentView addSubview:ageUL];
		[ageUL release];


		//////////

		// discuss
		myLabel = [[UILabel alloc] initWithFrame:CGRectMake(133, 71, 70, 15)];
		myLabel.tag = 3336;
		myLabel.backgroundColor = [UIColor clearColor];
		myLabel.numberOfLines = 1;
		myLabel.font = [UIFont systemFontOfSize:12];
		myLabel.textColor = [UIColor whiteColor];
		myLabel.highlightedTextColor = [UIColor whiteColor];
		[cell.contentView addSubview:myLabel];
		[myLabel release];


		//love
		myLabel = [[UILabel alloc] initWithFrame:CGRectMake(177, 71, 230, 15)];
		myLabel.tag = 3334;
		myLabel.backgroundColor = [UIColor clearColor];
		myLabel.textColor = [UIColor whiteColor];
		myLabel.font = [UIFont systemFontOfSize:12];
		myLabel.highlightedTextColor = [UIColor whiteColor];
		[cell.contentView addSubview:myLabel];
		[myLabel release];




        //
        //        UIImageView *selectUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(12, 6, 70, 70)];
        //        selectUIV.tag =3337;
        //        selectUIV.layer.cornerRadius = 3;
        //        [cell.contentView addSubview:selectUIV];
        //        [selectUIV release];
        //
        //

		UIImageView *lineUIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, 320, 1)];
		// lineUIV.image = [UIImage imageNamed:@"ys_line"];
		lineUIV.backgroundColor = [UIColor blackColor];
		[cell.contentView addSubview:lineUIV];
		[lineUIV release];


		XZWStarView *starview = [[XZWStarView alloc] initWithFrame:CGRectMake(250, 70, 170, 16) quanStar:0];
		starview.tag = 112;
		[cell.contentView addSubview:starview];
		[starview release];
	}


	[(UIImageView *)[cell.contentView viewWithTag:334]  setImageWithURL :[NSURL URLWithString:[[zhiDaoArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]]];
	[(UIImageView *)[cell.contentView viewWithTag:332]  setImageWithURL :[NSURL URLWithString:[XZWHost stringByAppendingFormat:@"data/upload/%@", [[zhiDaoArray objectAtIndex:indexPath.row] objectForKey:@"logo"]]]];

	[(UILabel *)[cell.contentView viewWithTag:3335]  setText :[[zhiDaoArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
	[(UILabel *)[cell.contentView viewWithTag:3888]  setText :[[zhiDaoArray objectAtIndex:indexPath.row] objectForKey:@"membercount"]];
	[(UILabel *)[cell.contentView viewWithTag:3336]  setText :[[zhiDaoArray objectAtIndex:indexPath.row] objectForKey:@"talk_count"]];
	[(UILabel *)[cell.contentView viewWithTag:3334]  setText :[[zhiDaoArray objectAtIndex:indexPath.row] objectForKey:@"like_count"]];


	[(XZWStarView *)[cell.contentView viewWithTag:112] setStars :[[[zhiDaoArray objectAtIndex:indexPath.row] objectForKey:@"group_level"] intValue]];


    //    [(UIImageView*)[cell.contentView viewWithTag:3337]  setImageWithURL:[NSURL URLWithString:[[zhiDaoArray  objectAtIndex:indexPath.row] objectForKey:@"avatar"]]];
    //
    //    NSMutableString *ageString = [NSMutableString string];
    //
    //    if ([[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"sex"]  intValue] ==1  ) {
    //
    //        [ageString  appendFormat:@"♂ %@ %@",[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"age"],[[XZWZodiacData getSignArray]  objectAtIndex:  [[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"constellation"] intValue]]];
    //
    //    }else {
    //
    //
    //        [ageString  appendFormat:@"♀ %@ %@",[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"age"],[[XZWZodiacData getSignArray]  objectAtIndex:  [[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"constellation"] intValue]]];
    //    }
    //
    //
    //    [(UILabel*)[cell.contentView viewWithTag:3888]  setText:ageString];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:true];

	if (delegate) {
		if ([delegate respondsToSelector:@selector(selectQuanID:)]) {
			[delegate selectQuanID:[[[zhiDaoArray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
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