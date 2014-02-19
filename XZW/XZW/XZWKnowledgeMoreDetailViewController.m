//
//  XZWKnowledgeMoreDetailViewController.m
//  XZW
//
//  Created by dee on 13-11-4.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWKnowledgeMoreDetailViewController.h"
#import "XZWNetworkManager.h"
#import <ShareSDK/ShareSDK.h>
#import "XZWDBOperate.h"


@interface XZWKnowledgeMoreDetailViewController () {
	BOOL isLoading;

	ASIHTTPRequest *getDetailRequest;

	int knowID;

	NSDictionary *contentDic;

	ASIHTTPRequest *collectRequest;

	BOOL changingCollect;
}

@end

@implementation XZWKnowledgeMoreDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (id)initKnowledgeDic:(NSDictionary *)knowledgeDic {
	self = [super init];
	if (self) {
		knowID = [knowledgeDic[@"id"]  intValue];


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


		NSString *detailString = nil;

		detailString = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] ? [NSString stringWithFormat:@"&uid=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]] : @"";



		getDetailRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [XZWKnowledgeDetail stringByReplacingOccurrencesOfString:@"****" withString:[NSString stringWithFormat:@"%d", knowID]], detailString]]];


		[getDetailRequest startAsynchronous];


		[getDetailRequest setCompletionBlock: ^{
		    isLoading = false;


		    contentDic = [[getDetailRequest responseString] objectFromJSONString][0];
		    [contentDic retain];

		    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(12, 39, 296, TotalScreenHeight - 64 - 39)];
		    webView.opaque = false;
		    webView.backgroundColor = [UIColor clearColor];
		    if ([webView respondsToSelector:@selector(scrollView)]) {
		        webView.scrollView.showsHorizontalScrollIndicator = webView.scrollView.showsVerticalScrollIndicator = false;
			}
		    [webView loadHTMLString:[NSString stringWithFormat:@"<body style=\"background-color: transparent\"><p><font size=5  color=\"#e14278\"> %@ </font></p> <font size=3 color=\"gray\">%@ </font>", [[getDetailRequest   responseString]   objectFromJSONString][0][@"art_title"], [[getDetailRequest   responseString]   objectFromJSONString][0][@"art_content"]]  baseURL:nil];
		    [self.view addSubview:webView];
		    [webView release];




		    if (contentDic[@"collection"]) {
		        UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
		        collectButton.frame = CGRectMake(275, 8, 38, 28);
                collectButton.imageEdgeInsets = UIEdgeInsetsMake(-6, 0, 0, 0);
		        [collectButton addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
		        [collectButton setImage:[UIImage imageNamed:@"grayst"] forState:UIControlStateNormal];
		        [collectButton setImage:[UIImage imageNamed:@"peach"] forState:UIControlStateSelected];
		        [self.view addSubview:collectButton];

		        collectButton.selected = [contentDic[@"collection"]  intValue] == 1;
			}
		}];


		[getDetailRequest setFailedBlock: ^{
		    isLoading = false;
		}];
	}
	return self;
}

- (void)dealloc {
	if (contentDic) {
		[contentDic  release];
	}

	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];


	self.title = @"知识";

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

	// Do any additional setup after loading the view.

	UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];


	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];

	listButton = [UIButton buttonWithType:UIButtonTypeCustom];
	listButton.frame = CGRectMake(0, 0, 23, 20);
	[listButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
	[listButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];


	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton]   autorelease];
}

- (void)collect:(UIButton *)sender {
	if (changingCollect) {
		return;
	}

	changingCollect = true;

	if (!sender.selected) {
		collectRequest = [XZWNetworkManager asiWithLink:[XZWAddToCollection stringByAppendingFormat:@"%d", knowID] postDic:nil completionBlock: ^{
		    if ([[[collectRequest responseString]  objectFromJSONString][@"status"]  intValue] == 1) {
		        sender.selected = !sender.selected;

		        [[NSNotificationCenter defaultCenter] postNotificationName:XZWChangeCollectNotification object:nil];
			}
		    else {
		        [[[[UIAlertView alloc] initWithTitle:nil message:[[[collectRequest responseString]  objectFromJSONString][@"info"]  description] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease] show];
			}


		    changingCollect = false;
		} failedBlock: ^{
		    changingCollect = false;
		}];
	}
	else {
		collectRequest = [XZWNetworkManager asiWithLink:[XZWDelCollection stringByAppendingFormat:@"%d", knowID] postDic:nil completionBlock: ^{
		    if ([[[collectRequest responseString]  objectFromJSONString][@"status"]  intValue] == 1) {
		        sender.selected = !sender.selected;

		        [[NSNotificationCenter defaultCenter] postNotificationName:XZWChangeCollectNotification object:nil];
			}
		    else {
		        [[[[UIAlertView alloc] initWithTitle:nil message:[[[collectRequest responseString]  objectFromJSONString][@"info"]  description] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil]  autorelease] show];
			}


		    changingCollect = false;
		} failedBlock: ^{
		    changingCollect = false;
		}];
	}


    //    if (sender.selected) {
    //
    //        [XZWDBOperate initKnowledgeWithKnowID:knowID title:contentDic[@"art_title"] titleDes:contentDic[@"art_content"]];
    //
    //    }else {
    //
    //        [XZWDBOperate deleteKnowledgeID:[NSString stringWithFormat:@"%d",knowID]];
    //
    //    }
}

- (void)share {
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];

	//构造分享内容
	id <ISSContent> publishContent = [ShareSDK  content:@""
	                                     defaultContent:[contentDic[@"art_title"] stringByAppendingString:@" 来自星座屋 http://www.xingzuowu.com"]
	                                              image:[ShareSDK imageWithPath:imagePath]
	                                              title:[contentDic[@"art_title"] stringByAppendingString:@""]
	                                                url:@"http://xingzuowu.com"
	                                        description:contentDic[@"art_title"]
	                                          mediaType:SSPublishContentMediaTypeApp];


	id <ISSCAttachment> imageAttach = [ShareSDK imageWithPath:imagePath];

	[publishContent addSinaWeiboUnitWithContent:INHERIT_VALUE image:imageAttach];

	[publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
	                                     content:INHERIT_VALUE
	                                       title:INHERIT_VALUE
	                                         url:INHERIT_VALUE
	                                       image:INHERIT_VALUE
	                                musicFileUrl:nil
	                                     extInfo:nil
	                                    fileData:nil
	                                emoticonData:nil];

	//定制微信朋友圈信息
	[publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage]
	                                      content:INHERIT_VALUE
	                                        title:INHERIT_VALUE
	                                          url:INHERIT_VALUE
	                                        image:INHERIT_VALUE
	                                 musicFileUrl:INHERIT_VALUE
	                                      extInfo:nil
	                                     fileData:nil
	                                 emoticonData:nil];



	[publishContent addSinaWeiboUnitWithContent:INHERIT_VALUE image:INHERIT_VALUE];

	id <ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享内容" shareViewDelegate:nil];


	id <ISSContainer> container = [ShareSDK container];

	NSArray *shareList = [ShareSDK getShareListWithType:
	                      ShareTypeSinaWeibo, ShareTypeWeixiSession, ShareTypeWeixiTimeline,
	                      nil];


	[ShareSDK showShareActionSheet:container
	                     shareList:shareList
	                       content:publishContent
	                 statusBarTips:true
	                   authOptions:nil
	                  shareOptions:shareOptions
	                        result:nil];
}

- (void)pop {
	if (isLoading) {
		[getDetailRequest   cancel];
		[getDetailRequest release];
		getDetailRequest = nil;
	}

	[self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
