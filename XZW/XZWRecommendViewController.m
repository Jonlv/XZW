//
//  XZWRecommendViewController.m
//  XZW
//
//  Created by dee on 13-12-18.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWRecommendViewController.h"
#import "IIViewDeckController.h"

@interface XZWRecommendViewController ()

@end

@implementation XZWRecommendViewController

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
    
    self.title = @"应用推荐";
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self.navigationController.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
     
    UIWebView *webview = [[UIWebView alloc]   initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64)];
    [webview  loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.xingzuoappapk.com/apple/"]]];
    [self.view addSubview:webview];
    [webview release];
    

    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
      
    
}

@end
