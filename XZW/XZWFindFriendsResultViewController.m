//
//  XZWFindFriendsResultViewController.m
//  XZW
//
//  Created by dee on 13-9-24.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWFindFriendsResultViewController.h"
#import "XZWFriendTable.h"
#import "XZWMyProfileViewController.h"

@interface XZWFindFriendsResultViewController ()<UIActionSheetDelegate,XZWFriendTableClickDelegate>{
    
    XZWFriendTable *friendTable;
    
    int type;
     
}

@property (nonatomic,retain) NSString *searchKeyString;

@end

@implementation XZWFindFriendsResultViewController
@synthesize searchKeyString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithString:(NSString*)searchString andType:(int)theType
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        self.searchKeyString = searchString;
        
        type = theType;
    }
    return self;
}

-(void)dealloc{
    
    [searchKeyString  release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.title = @"好友查找结果";
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 25, 20);
    [listButton addTarget:self action:@selector(getMore) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"more1"] forState:UIControlStateNormal];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    friendTable = [[XZWFriendTable alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64 ) andLinkString:[XZWSearchUser  stringByAppendingFormat:@"&skey=%@&stype=%d",searchKeyString,type] ];
    friendTable.delegate = self;
    [self.view addSubview:friendTable];
    [friendTable  release];
    
}





-(void)getMore{
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]   initWithTitle:@"选择显示性别" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"只看女生",@"只看男生",@"查看全部", nil];
    [actionSheet  showInView:self.navigationController.view];
    [actionSheet release];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    switch (buttonIndex) {
        case 0:
        {
            
             
            [friendTable   setSexAndReload:2];
        }
            
            break;
        case 1:
        {
            
            [friendTable   setSexAndReload:1];
                     }
            break;
        case 2:
        {
            
            [friendTable   setSexAndReload:0]; 
        }
            break;
            
        default:
        {
            
            
        }
            break;
    }
     
    
}

-(void)selectID:(int)userID{
    
    
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
