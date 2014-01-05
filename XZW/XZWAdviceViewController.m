//
//  XZWAdviceViewController.m
//  XZW
//
//  Created by dee on 13-10-30.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAdviceViewController.h"
#import "XZWNetworkManager.h"
#import "MBProgressHUD.h"


@interface XZWAdviceViewController () <UITextFieldDelegate>{
    
    UITextField  *titleUTF;
    
    UITextView   *myUTV;
    
    ASIHTTPRequest *adviceRequest;
    
    MBProgressHUD *hud;
}

@end

@implementation XZWAdviceViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    self.title = @"意见";
     
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(submitAdvice) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    [self initView];
    
    
    hud = [[MBProgressHUD alloc]  initWithView:self.view];
    [self.navigationController.view addSubview:hud];
    [hud release];
    
}


-(void)submitAdvice{
    
    if (titleUTF.text.length == 0  ) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先输入标题" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
         
        return ;
    }
    
    
    if (myUTV.text.length == 0  ) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先输入内容" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
        return ;
    }
    
    [self.view endEditing:true];
    
    [hud   show:true];
    hud.labelText = @"发送中...";
    
    adviceRequest = [XZWNetworkManager asiWithLink:XZWFeedBack postDic:@{@"feedback":myUTV.text} completionBlock:^{
    
         
        
        [hud setLabelText:[[adviceRequest responseString]  objectFromJSONString][@"info"]];
        [hud hide:true afterDelay:.6f];
      

    
    } failedBlock:^{
    
         
        hud.labelText = @"发送失败...";
        [hud hide:true afterDelay:.8f];
    
    }];
    
    
    
    
}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:true];
}


-(void)initView{
     
    
    UIImageView *utfBackground = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"registbox"]];
    utfBackground.frame = CGRectMake(6, 6, 278 + 28, 32);
    [self.view addSubview:utfBackground];
    [utfBackground release];
    
    titleUTF = [[UITextField alloc]  initWithFrame:CGRectMake(10, 9, 220, 22)];
    titleUTF.text = @"";
    titleUTF.placeholder = @"标题";
    titleUTF.returnKeyType = UIReturnKeyDone;
    titleUTF.delegate = self;
    titleUTF.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleUTF];
    [titleUTF release];

    utfBackground = [[UIImageView alloc]   initWithImage: [[UIImage imageNamed:@"registbox"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    utfBackground.frame = CGRectMake(6, 42, 278 + 28, 230);
    [self.view addSubview:utfBackground];
    [utfBackground release];
    
    myUTV = [[UITextView alloc]  initWithFrame:CGRectMake(7, 46, 304, 210)];
    myUTV.backgroundColor = [UIColor clearColor];
    myUTV.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:myUTV];
    [myUTV release];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:true];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
