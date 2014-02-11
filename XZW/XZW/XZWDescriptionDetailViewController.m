//
//  XZWDescriptionDetailViewController.m
//  XZW
//
//  Created by dee on 13-11-8.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWDescriptionDetailViewController.h"
#import "XZWDBOperate.h"

@interface XZWDescriptionDetailViewController (){
    
    
    NSDictionary *myDic;
    NSArray   *operateArray;
}

@end

@implementation XZWDescriptionDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}


-(id)initWithDic:(NSDictionary*)detail{
    self = [super init];
    if (self) {
        // Custom initialization
        
        myDic = detail;
        [myDic  retain];
        
        
        
        UILabel *astroUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 5, 320, 30)];
        astroUL.textColor = [UIColor grayColor];
        astroUL.text = [@"梦见" stringByAppendingString:detail[@"name"]] ;
      //  astroUL.textAlignment = UITextAlignmentCenter;
        astroUL.backgroundColor = [UIColor clearColor];
        [self.view addSubview:astroUL];
        [astroUL release];
        
        
        UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10, 35, 300, TotalScreenHeight - 64 - 35)];
        backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12]; backgroundUIV.userInteractionEnabled = true;
        [self.view addSubview:backgroundUIV];
        [backgroundUIV release];
        
        
        NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-size: %f;   color: %@;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@</body> \n"
                              "</html>", 15.f, @"#808080", [detail[@"description"]   stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"]];
        
        UIWebView *myWebView = [[UIWebView alloc]  initWithFrame:CGRectMake(15, 38, 290, TotalScreenHeight - 64 - 41 )];
        myWebView.backgroundColor = [UIColor clearColor];
        [myWebView loadHTMLString:jsString baseURL:nil];
        [self.view addSubview:myWebView];
        [myWebView release];
        
//        NSString *js = @"window.onload = function(){"
//       " document.body.style.backgroundColor = '#808080';"// 
//    "}";
//        [myWebView stringByEvaluatingJavaScriptFromString:js];
        
        if ([myWebView  respondsToSelector:@selector(scrollView)]) {
            
            myWebView.scrollView.showsHorizontalScrollIndicator = false;
            myWebView.scrollView.showsVerticalScrollIndicator = false;
            
        }
        
        
        
        
        
    }
    return self;
}
  

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"周公解梦";
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self  action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
  //  [self getCateAll];
    
 //   [self initView];
    
}

-(void)getCateAll{
    
//    if (myDic) {
//        [myDic  release];
//        myDic = nil;
//    }
    
    
     operateArray = [XZWDBOperate getDreamNameFromCat:myDic[@"name"]];
    [operateArray  retain];
    
    
    
}


-(void)initView{
    
    UILabel *activeCatUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 15, 200, 20)];
    [activeCatUL setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:activeCatUL];
    [activeCatUL release];
    
  
    UIScrollView *usv = [[UIScrollView alloc]   initWithFrame:CGRectMake(0, 40, 320, TotalScreenHeight - 40 - 64 - 25 )];
    [usv setAlwaysBounceHorizontal:false];
    [usv setAlwaysBounceVertical:false];
    [self.view addSubview:usv];
    [usv release];
     
    //个数
    //(TotalScreenHeight - 40 - 64 - 25) / 40 * 3
    
    int countPerPage = (TotalScreenHeight - 40 - 64 - 25) / 40 * 3;
    
    int page = 0 ;
    
    
    for (int i = 0 ; i < [operateArray count] ; i++) {
        
        page =  ceil( i  / countPerPage) ;
        
        UIButton *nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nameButton.tag = i ;
        [nameButton setFrame:CGRectMake( page * 320 + 5 + 100 * (i % 3) , 30 + (( i - page * countPerPage ) / 3) * 40   , 100, 30)];
        [nameButton  setTitle:operateArray[i][@"name"] forState:UIControlStateNormal];
        [nameButton addTarget:self action:@selector(nameAction:) forControlEvents:UIControlEventTouchUpInside];
        [usv addSubview:nameButton];
         ;
        
    }
    
    [usv   setContentSize:CGSizeMake(320 * ceil( [operateArray count]  / countPerPage), usv.bounds.size.height)];
    
}



-(void)pop{
    
    [self.navigationController  popViewControllerAnimated:true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
