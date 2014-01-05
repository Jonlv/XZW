//
//  XZWMyFriendViewController.m
//  XZW
//
//  Created by dee on 13-9-17.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMyFriendViewController.h"
#import "IIViewDeckController.h"
#import "XZWUtil.h"
#import "Interface.h"
#import "XZWFriendTable.h"
#import "XZWMyFriendViewController.h"
#import "XZWMyProfileViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "XZWNearByFriendsView.h"

@interface XZWMyFriendViewController ()<UIActionSheetDelegate,XZWFriendTableClickDelegate,CLLocationManagerDelegate>{
    
    UIImageView *girlTipsUIV,*boyTipsUIV;

    XZWFriendTable *friendTable,*sameConstelView;
    
    XZWNearByFriendsView *nearByFriendView;
    
    UIView *arrowView;
    
    
    CLLocationManager *locManager;
    
    
    
}

@end

@implementation XZWMyFriendViewController

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
    
    self.title = @"好友";
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 25, 20);
    [listButton addTarget:self action:@selector(getMore) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"more1"] forState:UIControlStateNormal];
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    
    [self initView];
    
}

- (void)initView{
    
    self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];
    
    UIButton *sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(0, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(firendAction) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"好友" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
    
    
    
    boyTipsUIV =  [[UIImageView alloc]   initWithFrame:CGRectMake(75, 10, 18, 18)];
    [sunButton addSubview:boyTipsUIV];
    [boyTipsUIV setImage:[UIImage imageNamed:@"boy.png"]];
    [boyTipsUIV release];
    
    
    girlTipsUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(73, 14, 18, 18)];
    [sunButton addSubview:girlTipsUIV];
    [girlTipsUIV setImage:[UIImage imageNamed:@"girl"]];
    [girlTipsUIV release];
    
    
    girlTipsUIV.hidden = boyTipsUIV.hidden = true;
    
    
    sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(106.2, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(nearByAction) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"附近的人" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
    
    
    sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(213, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(sameZodiac) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"同星座的人" forState:UIControlStateNormal];
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
    
    
    if (![[NSUserDefaults standardUserDefaults] doubleForKey:@"userLatitude"]) {
        
        
        [[NSUserDefaults standardUserDefaults]  setDouble:23.5 forKey:@"userLatitude"];
        [[NSUserDefaults standardUserDefaults]  setDouble:123 forKey:@"userLongitude"];
    }
    
    
    sameConstelView = [[XZWFriendTable alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight -108 ) andLinkString:[XZWSearchUser  stringByAppendingFormat:@"&skey=%d&stype=%d",[[[NSUserDefaults standardUserDefaults]      objectForKey:@"constellation"]  intValue],2] ];
    sameConstelView.delegate = self;
    [self.view addSubview:sameConstelView];
    [sameConstelView  release];
    
    
    nearByFriendView = [[XZWNearByFriendsView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight -108 ) andLinkString:XZWNearBy];
    nearByFriendView.delegate = self;
    [self.view addSubview:nearByFriendView];
    [nearByFriendView  release];

    
    friendTable = [[XZWFriendTable alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight -108 ) andLinkString:XZWFriendList];
    friendTable.delegate = self;
    [self.view addSubview:friendTable];
    [friendTable  release];
    
    
    
    locManager = [[CLLocationManager alloc]init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 100;
    [locManager  startUpdatingLocation];
    
    if (![CLLocationManager  locationServicesEnabled]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"未能定位" message:@"请先打开定位服务!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];

        
        [nearByFriendView reloadFirst];
        
    }
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - location



#pragma mark -

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [manager stopUpdatingLocation];
    
    [[NSUserDefaults standardUserDefaults]  setDouble:newLocation.coordinate.latitude forKey:@"userLatitude"];
    [[NSUserDefaults standardUserDefaults]  setDouble:newLocation.coordinate.longitude forKey:@"userLongitude"];
    
    
    [nearByFriendView reloadFirst];
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
     
    
    
    [nearByFriendView reloadFirst];
}



#pragma mark -


-(void)firendAction{
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(0, 35, 100, 10) ;}];
    
    [self.view  bringSubviewToFront:friendTable];
}

-(void)nearByAction{
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(110, 35, 100, 10) ;}];
    
    [self.view  bringSubviewToFront:nearByFriendView];
    
}

-(void)sameZodiac{
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(220, 35, 100, 10) ;}];
    
    
    [self.view  bringSubviewToFront:sameConstelView];
    
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
            
            
            girlTipsUIV.hidden =  false ;
            boyTipsUIV.hidden = true;
            [friendTable   setSexAndReload:2];
        }
            
            break;
        case 1:
        {
            
            [friendTable   setSexAndReload:1];
            
            girlTipsUIV.hidden =   true;
            boyTipsUIV.hidden = false;
        }
            break;
        case 2:
        {
            
            [friendTable   setSexAndReload:0];
            
            girlTipsUIV.hidden = boyTipsUIV.hidden = true;
        }
            break;
            
        default:
        {
            
            
        }
            break;
    }
    
    
}

-(void)toggleView{
    
    
    [self.navigationController.viewDeckController  toggleLeftViewAnimated:true];
}

#pragma mark - delegate

-(void)selectID:(int)userID{
    
    XZWMyProfileViewController *vc = [[XZWMyProfileViewController alloc]  initUserID:userID];
    [self.navigationController pushViewController:vc animated:true];
    [vc release];
    
}

-(void)selectNearByID:(int)userID{
    
    XZWMyProfileViewController *vc = [[XZWMyProfileViewController alloc]  initUserID:userID];
    [self.navigationController pushViewController:vc animated:true];
    [vc release];
    
}


@end
