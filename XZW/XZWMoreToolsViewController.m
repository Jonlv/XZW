//
//  XZWMoreToolsViewController.m
//  XZW
//
//  Created by dee on 13-11-7.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMoreToolsViewController.h"
#import "XZWMyDreamViewController.h"
#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>

@interface XZWMoreToolsViewController ()

@end

@implementation XZWMoreToolsViewController

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
    
    
    self.title  = @"更多工具";

    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    

    [self initView];
    
}

-(void)initView{
    
    UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toolButton addTarget:self action:@selector(dreamAction) forControlEvents:UIControlEventTouchUpInside];
    [toolButton setImage:[UIImage imageNamed:@"jm_icon"] forState:UIControlStateNormal];
    toolButton.frame = CGRectMake(5, 5, 57, 57);
    [self.view addSubview:toolButton];
    
    UILabel *toolName = [[UILabel alloc]  initWithFrame:CGRectMake(5, 65, 157, 20)];
    toolName.backgroundColor = [UIColor clearColor];
    toolName.text = @"周公解梦";
    toolName.font = [UIFont systemFontOfSize:14];
    toolName.textColor = [UIColor grayColor];
    [self.view addSubview:toolName];
    [toolName release];
    
    
    
//    UIButton * addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addPicBtn   setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
//    [addPicBtn  addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
//    [addPicBtn  setFrame:CGRectMake( 25  + 57 , 10, 46, 46)];
//    [self.view addSubview:addPicBtn];
//    
//    toolName = [[UILabel alloc]  initWithFrame:CGRectMake(20  + 57, 65, 157, 20)];
//    toolName.backgroundColor = [UIColor clearColor];
//    toolName.text = @"添加工具";
//    toolName.font = [UIFont systemFontOfSize:14];
//    toolName.textColor = [UIColor grayColor];
//    [self.view addSubview:toolName];
//    [toolName release];
    
    
}

-(void)add{
    
    
    UINavigationController *navigationController =[[[UINavigationController alloc]  initWithRootViewController:[[[NSClassFromString(@"XZWRecommendViewController") alloc]  init]  autorelease]]  autorelease];
    
    [navigationController.navigationBar   setBackgroundImage:[UIImage imageNamed:@"top"] forBarMetrics:UIBarMetricsDefault];
     
    
    [self.viewDeckController setCenterController:navigationController];
    
    
}


-(void)pop{
    
    
    [self.navigationController popViewControllerAnimated:true];
}


-(void)toggleView{
    
    
    [self.navigationController.viewDeckController  toggleLeftViewAnimated:true];
}


-(void)dreamAction{
    
    
    XZWMyDreamViewController *dreamVC = [[XZWMyDreamViewController alloc]  init];
    [self.navigationController pushViewController:dreamVC animated:true];
    [dreamVC release];
}



-(void)viewWillAppear:(BOOL)animated{
    
    self.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    
    
    [super viewWillAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated{
    
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
    
    [super viewWillDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
