//
//  XZWSelectBirthdayViewController.m
//  XZW
//
//  Created by Dee on 13-8-20.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSelectBirthdayViewController.h"

#import "XZWChinesePickView.h"

@interface XZWSelectBirthdayViewController ()



@end

@implementation XZWSelectBirthdayViewController

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
    
    XZWChinesePickView *chinesePV = [[XZWChinesePickView alloc]  initWithFrame:CGRectMake(0, 0, 320, 177)];
    [self.view addSubview:chinesePV];
    [chinesePV release];
    
    
//    
//    request =  [XZWNetworkManager asiWithLink:@"http://baidu.com" postDic:nil completionBlock:^{NSLog(@"complete %@",[request  responseString])
//        
//        ;} failedBlock:nil];
    
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [btn setFrame:CGRectMake(0, 30, 300, 300)];
//    [btn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
}


-(void)cancel{
     
    [XZWNetworkManager cancelRequest:request];
         
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
