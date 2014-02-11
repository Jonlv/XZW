//
//  XZWTodayIssueViewController.m
//  XZW
//
//  Created by dee on 13-9-24.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWTodayIssueViewController.h"
#import "IIViewDeckController.h"
#import "XZWIssueView.h"
#import "XZWUtil.h"
#import "XZWIssueDetailViewController.h"


@interface XZWTodayIssueViewController ()<XZWIssueTableClickDelegate>{
    
    
    UIView *arrowView;
    
    
    XZWIssueView *recentIssue,*myIssue ;
    
}

@end

@implementation XZWTodayIssueViewController

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
    
    
    
    self.title = @"今日讨论"; 
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self.navigationController.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
 
    
    [self initView];
    
}




- (void)initView{
    
    
    
    myIssue = [[XZWIssueView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight -108 ) andLinkString:[XZWGetDiscuss  stringByAppendingString:@"&type=my"]];
    myIssue.delegate = self;
    [self.view addSubview:myIssue];
    [myIssue  release];
    
    
    
    recentIssue = [[XZWIssueView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight -108 ) andLinkString:[XZWGetDiscuss  stringByAppendingString:@"&type=recent"]];
    recentIssue.delegate = self;
    [self.view addSubview:recentIssue];
    [recentIssue  release];
    
    
    
    
    self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];
    
    UIButton *sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(0, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(recentIssue) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"最近讨论" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
    
    
    
    
    sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(106.2, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(joinIssue) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"我参与的" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
    
     
    
    arrowView = [[UIView alloc]  initWithFrame:CGRectMake(0, 35, 100, 10)];
    [self.view  addSubview:arrowView];
    [arrowView release];
    
    UIImageView *arrowUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"uarrow"]];
    arrowUIV.center = CGPointMake(arrowView.center.x, 2.5);
    [arrowView addSubview:arrowUIV];
    [arrowUIV release];
    
    UIView *redView = [[UIView alloc]  initWithFrame:CGRectMake(0, 40, 320, 4)];
    redView.backgroundColor  = [UIColor colorWithHex:0xfb5c92];
    [self.view  addSubview:redView];
    [redView release];

    
    
}

-(void)recentIssue{
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(0, 35, 100, 10) ;}];
    [self.view bringSubviewToFront:recentIssue];
}

-(void)joinIssue{
    
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(110, 35, 100, 10) ;}];
    [self.view bringSubviewToFront:myIssue];
}


-(void)selectIssueDic:(NSDictionary*)issueDic{
    
     
    
    XZWIssueDetailViewController *idvc = [[XZWIssueDetailViewController alloc]  initWithDic:issueDic];
    [self.navigationController pushViewController:idvc animated:true];
    [idvc release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
