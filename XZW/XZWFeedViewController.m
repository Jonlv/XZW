//
//  XZWFeedViewController.m
//  XZW
//
//  Created by dee on 13-10-12.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWFeedViewController.h"
#import "XZWUtil.h"
#import "XZWMyFeedView.h"
#import "IIViewDeckController.h"
#import "XZWMyFriendFeedView.h"
#import "GoodsGalleryViewController.h"
#import "XZWIssueDetailViewController.h"
#import "XZWQuanDetailViewController.h"
#import "XZWMyProfileViewController.h"

@interface XZWFeedViewController ()<MyFeedViewDelegate,MyFriendFeedViewDelegate>{

    XZWMyFeedView *mMessages;// 我的动态子标签页面
    XZWMyFriendFeedView *mFriendFeedView;// 好友动态子标签页面
    XZWMyFriendFeedView *mMyDynamicFeed;// 消息子标签页面

    UIView *arrowView;
}

@end

@implementation XZWFeedViewController



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

    self.title = @"动态";

    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];

    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:listButton] autorelease];

    [self initView];
}

- (void)toggleView
{
    [self.navigationController.viewDeckController toggleLeftViewAnimated:true];
}


- (void)initView
{
    self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];

    UIButton *sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(0, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(friendFeed) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"好友动态" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];


    sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(106.2, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(myFeed) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"我的动态" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];


    sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(213, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(myMessage) forControlEvents:UIControlEventTouchUpInside];
    [sunButton setTintColor:[UIColor grayColor]];
    [sunButton setTitle:@"消息" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];


    arrowView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, 100, 10)];
    [self.view  addSubview:arrowView];
    [arrowView release];

    UIImageView *arrowUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"uarrow"]];
    arrowUIV.center = CGPointMake(arrowView.center.x, 2.5);
    [arrowView addSubview:arrowUIV];
    [arrowUIV release];

    UIView *redView = [[UIView alloc]  initWithFrame:CGRectMake(0, 40, 320, 4)];
    redView.backgroundColor = [UIColor colorWithHex:0xfb5c92];
    [self.view addSubview:redView];
    [redView release];


    // 消息
    mMessages = [[XZWMyFeedView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 108 ) andLinkString:XZWGetDtinfo];
    mMessages.delegate = self;
    [self.view addSubview:mMessages];
    [mMessages release];

    mMyDynamicFeed =[[XZWMyFriendFeedView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 108 ) andLinkString:XZWMyDt];
    mMyDynamicFeed.delegate = self;
    [self.view addSubview:mMyDynamicFeed];
    [mMyDynamicFeed release];

    mFriendFeedView =[[XZWMyFriendFeedView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight - 108) andLinkString:XZWFriendDt];
    mFriendFeedView.delegate = self;
    [self.view addSubview:mFriendFeedView];
    [mFriendFeedView release];
}



//-(void)clickMyFriendFeedIndex:(NSDictionary*)messageDic{
//
//
//
//
//
//
//    return ;
//
//    XZWMyProfileViewController *profileVC = [[XZWMyProfileViewController alloc]   initUserID:4];
//    [self.navigationController pushViewController:profileVC animated:true];
//    [profileVC release];
//
//
//}

- (void)clickFeedMessageDic:(NSDictionary *)messageDic {


    XZWMyProfileViewController *profileVC = [[XZWMyProfileViewController alloc]   initUserID:[messageDic[@"fromUid"] intValue]];
    [self.navigationController pushViewController:profileVC animated:true];
    [profileVC release];


    //    if (messageDic[@"savepath"]){
    //
    //        GoodsGalleryViewController *ggvc = [[GoodsGalleryViewController alloc]  initWithPhotoOneArray:@[messageDic] page:0];
    //        [self.navigationController presentModalViewController:ggvc animated:true];
    //        [ggvc release];
    //
    //    }else if ([messageDic[@"big_type"]     intValue] == 2){
    //
    //        XZWIssueDetailViewController *dvc = [[XZWIssueDetailViewController alloc]  initWithFeedDic:messageDic];
    //        [self.navigationController pushViewController:dvc animated:true];
    //        [dvc release];
    //
    //    }else if ([messageDic[@"big_type"]     intValue] == 1){
    //
    //        XZWQuanDetailViewController *dvc = [[XZWQuanDetailViewController alloc]   initWithQuanID:[messageDic[@"gid"]  intValue]];
    //        [self.navigationController pushViewController:dvc animated:true];
    //        [dvc release];
    //
    //    }

}


- (void)clickMyFriendFeedIndex:(NSDictionary *)messageDic {

    if (messageDic[@"savepath"]) {

        GoodsGalleryViewController *ggvc = [[GoodsGalleryViewController alloc]  initWithPhotoOneArray:@[messageDic] page:0];
        [self.navigationController presentModalViewController:ggvc animated:true];
        [ggvc release];

    } else if ([messageDic[@"big_type"] intValue] == 2) {//讨论

        XZWIssueDetailViewController *dvc = [[XZWIssueDetailViewController alloc] initWithFeedDic:messageDic];
        [self.navigationController pushViewController:dvc animated:true];
        [dvc release];

    } else if ([messageDic[@"big_type"] intValue] == 1) {//圈子

        XZWQuanDetailViewController *dvc = [[XZWQuanDetailViewController alloc] initWithQuanID:[messageDic[@"gid"] intValue]];
        [self.navigationController pushViewController:dvc animated:true];
        [dvc release];
    }
}

// 好友动态
- (void)friendFeed {

    [UIView animateWithDuration:.3f animations:^{ arrowView.frame = CGRectMake(0, 35, 100, 10) ;}];
    [self.view bringSubviewToFront:mFriendFeedView];
}

// 我的动态
- (void)myFeed {

    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(110, 35, 100, 10) ;}];
    [self.view bringSubviewToFront:mMyDynamicFeed];
}

// 消息
- (void)myMessage {

    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(220, 35, 100, 10) ;}];
    [self.view bringSubviewToFront:mMessages];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
