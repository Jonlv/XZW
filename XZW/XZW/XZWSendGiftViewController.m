//
//  XZWSendGiftViewController.m
//  XZW
//
//  Created by dee on 13-9-29.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSendGiftViewController.h"
#import "XZWGiftCell.h"
#import "XZWGiftView.h"
#import "XZWUtil.h"

@interface XZWSendGiftViewController (){
    
    
    BOOL isSelfGift;
    
    
    UIView *arrowView;
    
    XZWGiftView *xzwGiftView,*sendGiftView;
    
}

@end

@implementation XZWSendGiftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


 


- (id)initWithName:(NSString*)nameString andUser:(int)theUserID
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.title = [nameString stringByAppendingString:@"的礼物"];
        userID = theUserID;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    
    
    [self initView];
    
    
}



- (void)initView{
    
    self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];
    
    
    if ([[[NSUserDefaults standardUserDefaults]  valueForKey:@"userID"]  intValue] == userID) {
        
        UIButton *sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sunButton.frame = CGRectMake(0, 0, 160, 44);
        [sunButton   addTarget:self action:@selector(receive) forControlEvents:UIControlEventTouchUpInside];
        [sunButton  setTintColor:[UIColor grayColor]];
        [sunButton  setTitle:@"收到的礼物" forState:UIControlStateNormal];
        [self.view addSubview:sunButton];
        
        
        
        
        sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sunButton.frame = CGRectMake(160, 0, 160, 44);
        [sunButton   addTarget:self action:@selector(sent) forControlEvents:UIControlEventTouchUpInside];
        [sunButton  setTintColor:[UIColor grayColor]];
        [sunButton  setTitle:@"送出的礼物" forState:UIControlStateNormal];
        [self.view addSubview:sunButton];
        
        
        
        arrowView = [[UIView alloc]  initWithFrame:CGRectMake(0, 35, 160, 10)];
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
        
        
        
        
        
        sendGiftView = [[ XZWGiftView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 64 - 44 ) andLinkString:[XZWGiftBox   stringByAppendingFormat:@"&uid=%d&box=send",userID]];
        [self.view addSubview:sendGiftView];
        [sendGiftView  release];
        
        
        xzwGiftView = [[ XZWGiftView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 64 - 44) andLinkString:[XZWGiftBox   stringByAppendingFormat:@"&uid=%d&box=receive",userID]];
        [self.view addSubview:xzwGiftView];
        [xzwGiftView  release];
        
    }else {
        
        
        xzwGiftView = [[ XZWGiftView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64 ) andLinkString:[XZWGiftBox   stringByAppendingFormat:@"&uid=%d&box=receive",userID]];
        [self.view addSubview:xzwGiftView];
        [xzwGiftView  release];
        
    }
    
   

    
}

-(void)receive{
     
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(0, 35, 160, 10) ;}];
    
    [self.view bringSubviewToFront:xzwGiftView];
    
}

-(void)sent{
    
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(160, 35, 160, 10) ;}];
    
    
    [self.view bringSubviewToFront:sendGiftView];
    
}
 

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
