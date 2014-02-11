//
//  XZWVistorsViewController.m
//  XZW
//
//  Created by dee on 13-10-14.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWVistorsViewController.h"
#import "XZWFriendTable.h"
#import "XZWNearByFriendsView.h"
#import "XZWMyProfileViewController.h"

@interface XZWVistorsViewController (){
    
    
    
    XZWNearByFriendsView *vistorsView;
}

@end

@implementation XZWVistorsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"最近访客";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];

    
    [self initView];
    
}


-(void)initView{
    
    vistorsView = [[XZWNearByFriendsView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight -64 ) andLinkString:XZWVisitorList];
    [vistorsView  reloadFirst];
    vistorsView.delegate = self;
    [self.view addSubview:vistorsView];
    [vistorsView  release];
}



-(void)selectNearByID:(int)userID{
    
    XZWMyProfileViewController *vc = [[XZWMyProfileViewController alloc]  initUserID:userID];
    [self.navigationController pushViewController:vc animated:true];
    [vc release];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
