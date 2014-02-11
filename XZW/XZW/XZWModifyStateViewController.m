//
//  XZWModifyStateViewController.m
//  XZW
//
//  Created by dee on 13-9-11.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWModifyStateViewController.h"
#import "Interface.h"

@interface XZWModifyStateViewController ()<UITextViewDelegate>{
 
    UITextView *modifyTextView;
    NSMutableDictionary *keyDictionary;
    
    
    UITextView *profileUTV;
    UILabel *wordLimitUL;
    
    int totalNum;
}
@end

@implementation XZWModifyStateViewController


-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        // Custom initialization
        
        keyDictionary = [[NSMutableDictionary alloc]  initWithDictionary:dic];
        
    }
    return self;
}

-(void)dealloc{
    
    
    [keyDictionary  release];
    keyDictionary = nil;
    
    [super dealloc];
}

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
    
    
    if ([keyDictionary  objectForKey:@"uname"]) {
        
        totalNum =  10 ;
        
    }else {
        
        totalNum =  50 ;
    }

    
    self.title = @"修改资料";
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];

    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(modify) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"option"] forState:UIControlStateNormal];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    
    UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 10, 300, 100)];
    backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    [self.view  addSubview:backgroundUIV];
    [backgroundUIV release];
    
    
    
    
    profileUTV = [[UITextView alloc]  initWithFrame:CGRectMake(13, 13, 300, 93)];
    [profileUTV  setBackgroundColor:[UIColor clearColor]];
    profileUTV.delegate = self;
    profileUTV.font = [UIFont systemFontOfSize:13];
    profileUTV.textColor = [UIColor grayColor];
    profileUTV.text =  [[keyDictionary allValues]  objectAtIndex:0];
    [self.view addSubview:profileUTV];
    [profileUTV release];
    
    [profileUTV  becomeFirstResponder];
    
    
    wordLimitUL = [[UILabel alloc]  initWithFrame:CGRectMake(0, 78, 300, 30)];
    wordLimitUL.textAlignment = UITextAlignmentRight;
    wordLimitUL.textColor = [UIColor grayColor];
    wordLimitUL.text = [NSString stringWithFormat:@"%d", totalNum - profileUTV.text.length];
    wordLimitUL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:wordLimitUL];
    [wordLimitUL  release];
    
}


-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > totalNum) {
        
        textView.text  = [textView.text   substringToIndex:totalNum];
        
    }
    
    
   // NSLog(@"profileUTV.text %d",[profileUTV.text  dataUsingEncoding:NSUTF16StringEncoding].length);
    
    wordLimitUL.text = [NSString stringWithFormat:@"%d", totalNum - profileUTV.text.length];
}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:true];
}

-(void)modify
{
    
    [keyDictionary    setObject:profileUTV.text forKey:[[[keyDictionary allKeys]  objectAtIndex:0] isEqualToString:@"uname"]?@"unameChanged": [[keyDictionary allKeys]  objectAtIndex:0] ];
    
    
    
    [[NSNotificationCenter defaultCenter]  postNotificationName:XZWModifyProfileNotification object:keyDictionary];
    
    [self goBack];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
