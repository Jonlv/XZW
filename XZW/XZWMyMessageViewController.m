//
//  XZWMyMessageViewController.m
//  XZW
//
//  Created by dee on 13-10-14.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMyMessageViewController.h"
#import "XZWMessageView.h"
#import "IIViewDeckController.h"
#import "XZWChatViewController.h"
#import "XZWChatStyleTwoViewController.h"
#import "XZWPollingObject.h"

@interface XZWMyMessageViewController () <MessageDelegate> {

    UITableView *messageUtV;
}

@end

@implementation XZWMyMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark -

-(void)viewWillAppear:(BOOL)animated{

    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;


    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated{

    self.viewDeckController.panningMode = IIViewDeckNoPanning;

    [super viewWillDisappear:animated];
}


#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.title = @"私信";


    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];


    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];


    [self initView];

}

- (void)toggle
{
    [self.navigationController.viewDeckController toggleLeftView];
    [[[XZWPollingObject alloc] init] getNewUnReadInstanly];
}


- (void)initView
{
    XZWMessageView* messageView = [[XZWMessageView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64) andLinkString:XZWSiXinList];
    messageView.delegate = self;
    [self.view addSubview:messageView];
    [messageView release];
}

- (void)clickMessageIndex:(NSDictionary*)messageDic
{
    if (![messageDic[@"list_id"] isKindOfClass:[NSNull class]] &&
        ![messageDic[@"uid"] isKindOfClass:[NSNull class]] &&
        ![messageDic[@"uname"] isKindOfClass:[NSNull class]] &&
        ![messageDic[@"avatar"] isKindOfClass:[NSNull class]]) {

        XZWChatStyleTwoViewController* chatVC = [[XZWChatStyleTwoViewController alloc]   initWithUserID:[messageDic[@"uid"] intValue] nameString:messageDic[@"uname"] avatarString:messageDic[@"avatar"] andChatID:[messageDic[@"list_id"] intValue]];
        [self.navigationController pushViewController:chatVC animated:true];
        [chatVC release];

        //        XZWChatViewController *chatVC = [[XZWChatViewController alloc]   initWithUserID:[messageDic[@"uid"]   intValue] nameString:messageDic[@"uname"] avatarString:messageDic[@"avatar"] andChatID:[messageDic[@"list_id"]   intValue] ];
        //        [self.navigationController pushViewController:chatVC animated:true];
        //        [chatVC  release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
