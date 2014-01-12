//
//  XZWKnowledgeDetailViewController.m
//  XZW
//
//  Created by dee on 13-10-25.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWKnowledgeDetailViewController.h"
#import "XZWNetworkManager.h"
#import "XZWUtil.h"
#import "XZWKnowledgeMoreDetailViewController.h"


@interface XZWKnowledgeDetailViewController () <UITableViewDataSource, UITableViewDelegate> {
	UITableView *knowledgeUTV;
	NSMutableArray *knowArray;

	BOOL isLoading
	, isFinished;

	int current, totalPage, knowID;

	ASIHTTPRequest *getListRequest;
	NSString *titleString;
}

@end



@implementation XZWKnowledgeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)dealloc {
	[titleString  release];
	[knowArray release];

	[super dealloc];
}

- (id)initKnowledgeDic:(NSDictionary *)knowledgeDic {
	self = [super init];
	if (self) {
		knowArray = [[NSMutableArray alloc]  init];

		knowID = [knowledgeDic[@"id"]  intValue];

		titleString = [knowledgeDic[@"name"]  retain];


		UILabel *zodiacUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 310, 25)];
		zodiacUL.text = [NSString stringWithFormat:@"%@ > %@", @"知识", knowledgeDic[@"name"]];
		zodiacUL.textColor = [UIColor grayColor];
		[zodiacUL setBackgroundColor:[UIColor clearColor]];
		[self.view addSubview:zodiacUL];
		[zodiacUL release];


		UIImageView *backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 300, TotalScreenHeight - 64 - 35)];
		backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12]; backgroundUIV.userInteractionEnabled = true;
		[self.view addSubview:backgroundUIV];
		[backgroundUIV release];

		knowledgeUTV = [[UITableView alloc] initWithFrame:CGRectMake(10, 41, 300, TotalScreenHeight - 64 - 41)];
		[self.view addSubview:knowledgeUTV];
		knowledgeUTV.backgroundColor = [UIColor clearColor];
		knowledgeUTV.separatorStyle  = UITableViewCellSelectionStyleNone;
		knowledgeUTV.delegate = self;
		knowledgeUTV.dataSource = self;
		// knowledgeUTV.backgroundView = backgroundUIV;
		[knowledgeUTV release];
	}
	return self;
}

- (id)initForCollection {
	self = [super init];
	if (self) {
		knowArray = [[NSMutableArray alloc]  init];




		UILabel *zodiacUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 5, 310, 25)];
		zodiacUL.text = @"我的收藏";
		zodiacUL.textColor = [UIColor grayColor];
		[zodiacUL setBackgroundColor:[UIColor clearColor]];
		[self.view addSubview:zodiacUL];
		[zodiacUL release];


		titleString = zodiacUL.text;
		[titleString  retain];


		UIImageView *backgroundUIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 300, TotalScreenHeight - 64 - 35)];
		backgroundUIV.image = [[UIImage imageNamed:@"corner"] stretchableImageWithLeftCapWidth:12 topCapHeight:12]; backgroundUIV.userInteractionEnabled = true;
		[self.view addSubview:backgroundUIV];
		[backgroundUIV release];

		knowledgeUTV = [[UITableView alloc] initWithFrame:CGRectMake(10, 41, 300, TotalScreenHeight - 64 - 41)];
		[self.view addSubview:knowledgeUTV];
		knowledgeUTV.backgroundColor = [UIColor clearColor];
		knowledgeUTV.separatorStyle  = UITableViewCellSelectionStyleNone;
		knowledgeUTV.delegate = self;
		knowledgeUTV.dataSource = self;
		// knowledgeUTV.backgroundView = backgroundUIV;
		[knowledgeUTV release];
	}
	return self;
}

- (void)pop {
	if (isLoading) {
		[getListRequest   cancel];
		[getListRequest release];
		getListRequest = nil;
	}

	[self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"知识";

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];


	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];


	[self loadMessageIsFirst:true];

	// Do any additional setup after loading the view.
}

#pragma mark -

- (void)loadMessageIsFirst:(BOOL)isFirst {
    //    MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];

	if (isFirst) {
		if (isLoading) {
			[getListRequest cancel];
			[getListRequest release];
			getListRequest = nil;
		}

		isLoading = true;
		isFinished = false;
		current  = 1;


		if (knowID == 0) {
			getListRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&id=%@", [XZWGetCollectionList stringByAppendingString:[NSString stringWithFormat:@"%d", current]], [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]]]];
		}
		else {
			getListRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", [XZWKnowledge stringByReplacingOccurrencesOfString:@"****" withString:[NSString stringWithFormat:@"%d", knowID]], current]]];
		}


		// [hud show:true];
	}
	else {
		if (isLoading) {
			return;
		}


		if (isFinished) {
			return;
		}


		if (totalPage  <=  current) {
			isFinished = true;

            //            [myTableView.tableFooterView   setHidden:true];
            //            myTableView.tableFooterView = nil;


			return;
		}


		if (knowID == 0) {
			getListRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&id=%@", [XZWGetCollectionList stringByAppendingString:[NSString stringWithFormat:@"%d", current + 1]], [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]]]];
		}
		else {
			getListRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", [XZWKnowledge stringByReplacingOccurrencesOfString:@"****" withString:[NSString stringWithFormat:@"%d", knowID]], current + 1]]];
		}
	}


	[getListRequest startAsynchronous];


	[getListRequest setCompletionBlock: ^{
	    isLoading = false;

	    NSDictionary *messageDic = [[getListRequest responseData]   objectFromJSONData];
	    totalPage = [messageDic[@"totalPages"] intValue];
	    current = [messageDic[@"nowPage"] intValue];

	    if (![[messageDic objectForKey:@"data"] isKindOfClass:[NSArray class]] || current > totalPage) {
	        isFinished = true;


            //                [myTableView.tableFooterView   setHidden:true];
            //                myTableView.tableFooterView = nil;
		}
	    else {
            //                UIView *footerView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
            //                [myTableView setTableFooterView:footerView];
            //
            //                UILabel *ul = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)];
            //                ul.text = @"加载中...";
            //                ul.backgroundColor = [UIColor clearColor];
            //                ul.textAlignment = UITextAlignmentCenter ;
            //                [footerView addSubview:ul];
            //                [ul release];
            //
            //                UIActivityIndicatorView *uaiv = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            //                uaiv.frame = CGRectMake(95, 5, 30, 30);
            //                [footerView addSubview:uaiv];
            //                [uaiv release];
            //                [uaiv startAnimating];


	        if (isFirst) {
	            [knowArray setArray:messageDic[@"data"]];
			}
	        else {
	            [knowArray addObjectsFromArray:messageDic[@"data"]];
			}
		}

	    [knowledgeUTV reloadData];


	    //     [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];

	    //    [hud hide:true afterDelay:.6f];
	}];

	[getListRequest setFailedBlock: ^{
	    isLoading = false;


	    //   [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];

	    /// [hud hide:true afterDelay:1.f];
	}];
}

#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [knowArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *MyCustomCellIdentifier = @"mycell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;


		cell.contentView.clipsToBounds = true;




		// name
		UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,  5, 280, 30)];
		myLabel.tag = 3335;
		myLabel.backgroundColor = [UIColor clearColor];
		myLabel.numberOfLines = 1;
		myLabel.font = [UIFont boldSystemFontOfSize:17];
		myLabel.textColor = [XZWUtil xzwRedColor];
		[cell.contentView addSubview:myLabel];
		[myLabel release];

		UILabel *contentUL = [[UILabel alloc] initWithFrame:CGRectMake(8, 30, 280, 40)];
		contentUL.backgroundColor = [UIColor clearColor];
		contentUL.numberOfLines = 2;
		contentUL.tag = 3336;
		contentUL.textColor = [UIColor grayColor];
		contentUL.font = [UIFont boldSystemFontOfSize:14];
		[cell.contentView addSubview:contentUL];
		[contentUL release];



		UIImageView *lineUIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 73, 320, 1)];
		lineUIV.image = [UIImage imageNamed:@"dashed"];
		[cell.contentView addSubview:lineUIV];
		[lineUIV release];
	}


	[(UILabel *)[cell.contentView viewWithTag:3335] setText:knowArray[indexPath.row][@"art_title"]];
	[(UILabel *)[cell.contentView viewWithTag:3336] setText:knowArray[indexPath.row][@"art_description"]];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	XZWKnowledgeMoreDetailViewController *moreDetail = [[XZWKnowledgeMoreDetailViewController alloc] initKnowledgeDic:@{@"name":titleString, @"id":knowArray[indexPath.row][@"art_id"]}];
	[self.navigationController pushViewController:moreDetail animated:true];
	[moreDetail release];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height + 5) {
		[self loadMessageIsFirst:false];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
