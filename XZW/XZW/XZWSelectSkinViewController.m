//
//  XZWSelectSkinViewController.m
//  XZW
//
//  Created by dee on 13-9-13.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSelectSkinViewController.h"
#import "Interface.h"
#import "XZWCustomSkinViewController.h"
#import "XZWUtil.h"
#import "IIViewDeckController.h"

@interface XZWSelectSkinViewController (){
    
    UIImageView *skinView;
    UIScrollView *skinUSV;
    
}

@end

@implementation XZWSelectSkinViewController

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
 
    
    self.title = @"换肤";
   
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goBack) name:XZWChangeSkinNotification object:nil];
    
    [self initView];
    
    
}


-(void)goBack{
    
         
    [self.navigationController popViewControllerAnimated:true];
}




-(void)customAction{
    
    
    
    self.navigationController.viewDeckController.panningMode = IIViewDeckNoPanning;
    
    XZWCustomSkinViewController *custskinView = [[XZWCustomSkinViewController alloc]   init];
    [self.navigationController pushViewController:custskinView animated:true];
    [custskinView release];
    
    
}

-(void)initView{
    
    
    skinUSV = [[UIScrollView alloc]   initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64)];
    [self.view addSubview:skinUSV];
    [skinUSV release];
    
     
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(10, 10, 298, 52);
    [customButton  setTitle:@"自定义皮肤" forState:UIControlStateNormal];
    [customButton  setTitleColor:[XZWUtil xzwRedColor] forState:UIControlStateNormal];
    [customButton   setTitleEdgeInsets:UIEdgeInsetsMake(0, 50, 0, 0)];
    [customButton  setBackgroundImage:[UIImage imageNamed:@"define"] forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(customAction) forControlEvents:UIControlEventTouchUpInside];
    [skinUSV addSubview:customButton];
    
    UIImageView *addUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"add"]];
    addUIV.center = CGPointMake(110, 26);
    [customButton addSubview:addUIV];
    [addUIV release];
    
    
    for (int i = 0; i < XZWTotalSkins; i++) {
        
        UIImageView *backgroundUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(10    , 70  + 160 * i , 300, 148)];
        backgroundUIV.userInteractionEnabled = true;
        backgroundUIV.image = [[UIImage imageNamed:@"corner"]  stretchableImageWithLeftCapWidth:12 topCapHeight:12];
        [skinUSV addSubview:backgroundUIV];
        [backgroundUIV release];
        
        UIButton *skinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        skinButton.tag = i + 1;
        skinButton.frame = CGRectMake(13 , 12, 274, 124);
        skinButton.contentMode = UIViewContentModeScaleAspectFill;
        [skinButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"indeximg_%d",i + 1]] forState:UIControlStateNormal];
        [skinButton addTarget:self action:@selector(changeSkinAction:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundUIV addSubview:skinButton];
         
    }
    
    
    [skinUSV   setContentSize:CGSizeMake(320, 160 * XZWTotalSkins + 90)];
    
    
    skinView = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"check"]]; 
    [skinUSV addSubview:skinView];
    [skinView release];
    
    skinView.frame = CGRectMake(260, 330  + 160 * ([[NSUserDefaults standardUserDefaults] integerForKey:@"Skin"] - 1 ), 30, 30);
    
}

-(void)changeSkinAction:(UIButton*)sender{
     
    
    skinView.hidden = false;
    
    [[NSUserDefaults standardUserDefaults]   setInteger:sender.tag - 1 forKey:@"Skin"];
    
    skinView.frame = CGRectMake(260, 330  + 160 * ([[NSUserDefaults standardUserDefaults] integerForKey:@"Skin"] - 1 ), 30, 30);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XZWChangeSkinNotification object:nil];
    
    [self goBack];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"Skin"] >= 0 ) {
        
        skinView.hidden = false;
        
        skinView.frame = CGRectMake(260, 330  + 160 * ([[NSUserDefaults standardUserDefaults] integerForKey:@"Skin"] - 1 ), 30, 30);
        
        
    }else {
         
        skinView.hidden = true;
          
    }
    
    
    self.navigationController.viewDeckController.panningMode = IIViewDeckFullViewPanning;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
