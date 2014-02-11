//
//  XZWQuanDetailViewController.m
//  XZW
//
//  Created by dee on 13-9-25.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWQuanDetailViewController.h"
#import "IIViewDeckController.h"
#import "XZWUtil.h"
#import "Interface.h"
#import "XZWFriendTable.h"
#import "XZWMyProfileViewController.h"
#import "XZWIssueTableView.h"
#import "XZWStarView.h"
#import "XZWPublishIssueViewController.h"
#import "UIBadgeView.h"
#import "XZWQuanFriendView.h"
#import "XZWQuanIssueView.h"
#import "GoodsGalleryViewController.h"

#define kMBProgessHud 8898

@interface XZWQuanDetailViewController ()<UITableViewDelegate,UITableViewDataSource,XZWQuanIssueViewDelegate>{
    
    UIView *arrowView;
    
    XZWQuanFriendView *friendTable;
    
    XZWQuanIssueView *issueTableView;
    
    int quanID;
    
    ASIHTTPRequest *quanInfoRequest;
    
    UIView *quanInfo;
    
    UITableView *quanInfoUTV;
    
    NSMutableDictionary *infoDic;
    
    BOOL isLike,isMember;
    
    ASIHTTPRequest *likeRequest;
    
    ASIHTTPRequest *leaveRequest;
    
    UIBadgeView *newMemberView;
    
    
    ASIHTTPRequest *delineRequest,*acceptRequest;
    
}

@end

@implementation XZWQuanDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithQuanID:(int)quan
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        quanID = quan ;
        
        
        
    }
    return self;
}


-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    infoDic = [[NSMutableDictionary alloc]   init];
    
    self.title =  @"圈子";
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 21, 21);
    [listButton addTarget:self action:@selector(sendIssue) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
     
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    
    
    [self initView];
    
}


-(void)sendIssue{
    
    XZWPublishIssueViewController *publishVC = [[XZWPublishIssueViewController alloc]  initWithQuanID:quanID];
    [self.navigationController pushViewController:publishVC animated:true];
    [publishVC release];
         
    
}



-(void)dealloc{
    
    [infoDic release];
    [XZWNetworkManager cancelAndReleaseRequest:quanInfoRequest];
    
    [super dealloc];
}




#pragma mark -

-(void)initView{
    
    
    self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];
    
    UIButton *sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(0, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(myIssue) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"话题" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
     
    
    sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(106.2, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(member) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"成员" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
    
    
    newMemberView = [[UIBadgeView alloc]  initWithFrame:CGRectMake(80, 10, 40, 34)];
    [newMemberView setBadgeString:nil];
    newMemberView.userInteractionEnabled = true;
    [newMemberView setBadgeColor:[UIColor redColor]];
    [sunButton addSubview:newMemberView];
    [newMemberView release];
    
    
    sunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sunButton.frame = CGRectMake(213, 0, 106.2, 44);
    [sunButton   addTarget:self action:@selector(info) forControlEvents:UIControlEventTouchUpInside];
    [sunButton  setTintColor:[UIColor grayColor]];
    [sunButton  setTitle:@"资料" forState:UIControlStateNormal];
    [self.view addSubview:sunButton];
    

    
    //// quan info
    
    
    
    
    friendTable = [[XZWQuanFriendView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight -108 ) andLinkString:[XZWQuanZiMember   stringByAppendingFormat:@"&gid=%d",quanID] andQuanID:quanID];
    friendTable.delegate = self;
    [self.view addSubview:friendTable];
    [friendTable  release];

    
    issueTableView = [[XZWQuanIssueView alloc]  initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight -108 ) andQuanID:quanID] ;
    issueTableView.delegate = self;
    [self.view addSubview:issueTableView];
    [issueTableView release];

    
    
    quanInfo = [[UIView alloc]   initWithFrame:CGRectMake(0, 44, 320, TotalScreenHeight -108 )];
    [self.view addSubview:quanInfo];
    [quanInfo release];
    
    
    
    
    
    
    quanInfoUTV = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 108 - 44 ) style:UITableViewStyleGrouped];
    quanInfoUTV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    quanInfoUTV.dataSource = self;
    quanInfoUTV.delegate = self;
    [quanInfo addSubview:quanInfoUTV];
    [quanInfoUTV release];
    
    
    
    
    UIImageView *bottomUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(0, CGRectGetHeight(quanInfoUTV.frame) , 320 , 44 )];
    bottomUIV.userInteractionEnabled = true;
    [bottomUIV setImage:[UIImage imageNamed:@"personbt"]];
    [quanInfo addSubview:bottomUIV];
    [bottomUIV release];
    
    
        

    
    
    
    //
    
    UIView *backgroundView = [[[UIView alloc]  initWithFrame:quanInfoUTV.bounds]  autorelease];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    quanInfoUTV.backgroundView = backgroundView;
        
    //
    
      
    
    
      
    
     
    quanInfoRequest = [XZWNetworkManager asiWithLink:[XZWQuanZiInfo  stringByAppendingFormat:@"&gid=%d",quanID] postDic:nil completionBlock:^{
        
        NSDictionary *backDic = [[quanInfoRequest responseString]  objectFromJSONString];
        
        
        if ([[backDic  objectForKey:@"status"] intValue] == 1   ) {
            
             
            
            [infoDic   setDictionary:[backDic objectForKey:@"data"]];
            
            
            
            isLike = [infoDic[@"islike"]  intValue] == 0 ?  false: true;
            isMember =  [infoDic[@"ismember"]  intValue] == 0 ?  false: true;
            
            
            UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            profileButton.clipsToBounds = false;
            [profileButton setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
            [profileButton setTitle:@"取消" forState:UIControlStateNormal];
            [bottomUIV addSubview:profileButton];
            [profileButton  addTarget:self action:@selector(cancelLike:) forControlEvents:UIControlEventTouchUpInside];
            profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [profileButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            profileButton.frame = CGRectMake(65 + 35, 4, 44, 38);
            [profileButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
            [profileButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];
            
            
            if (isLike) {
                
                [profileButton setTitle:@"取消" forState:UIControlStateNormal];
                [profileButton setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
                
            }else {
                
                [profileButton setTitle:@"喜欢" forState:UIControlStateNormal];
                [profileButton setImage:[UIImage imageNamed:@"linke"] forState:UIControlStateNormal];
                
            }
            
            
            profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            profileButton.clipsToBounds = false;
            [profileButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
            [profileButton setTitle:@"退出" forState:UIControlStateNormal];
            [bottomUIV addSubview:profileButton];
            [profileButton  addTarget:self action:@selector(goOut:) forControlEvents:UIControlEventTouchUpInside];
            profileButton.titleLabel.font = [UIFont systemFontOfSize:13];
            [profileButton   setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            profileButton.frame = CGRectMake(140 + 35, 4, 44, 38);
            [profileButton setImageEdgeInsets:UIEdgeInsetsMake(-15, 0, 0, 0)];
            [profileButton    setTitleEdgeInsets:UIEdgeInsetsMake(20, -45, 0, -30)];
            
            
            if (isMember) {
                
                [profileButton setTitle:@"退出" forState:UIControlStateNormal];
                
                [profileButton setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
                
            }else {
                
                [profileButton setTitle:@"申请加入" forState:UIControlStateNormal];
                
                [profileButton setImage:[UIImage imageNamed:@"jiaru"] forState:UIControlStateNormal];
            }
            
             
            
            
            
            [quanInfoUTV  reloadData];
            
        }
        
        
        
        
        
        
        ;} failedBlock:nil];
    
    
  
    
    arrowView = [[UIView alloc]  initWithFrame:CGRectMake(0, 35, 100, 10)];
    [self.view  addSubview:arrowView];
    [arrowView release];
    
    
    UIImageView *arrowUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"uarrow"]];
    arrowUIV.center = CGPointMake(arrowView.center.x, 2.5);
    [arrowView addSubview:arrowUIV];
    [arrowUIV release];
    
    
    arrowView.frame =  CGRectMake(220, 35, 100, 10);
    
    
    UIView *redView = [[UIView alloc]  initWithFrame:CGRectMake(0, 40, 320, 4)];
    redView.backgroundColor  = [UIColor colorWithHex:0xfb5c92];
    [self.view  addSubview:redView];
    [redView release];
    
    
    MBProgressHUD *mbProgessHud = [[MBProgressHUD alloc]  initWithView:self.view];
    mbProgessHud.tag = kMBProgessHud;
    mbProgessHud.labelText = @"加载中...";
    [self.view addSubview:mbProgessHud];
    [mbProgessHud release];
    
       
}


-(void)cancelLike:(UIButton*)sender{
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    hud.labelText = @"加载中...";
    [hud show:true];
    
    [self.view bringSubviewToFront:hud];
    
    [XZWNetworkManager cancelAndReleaseRequest:likeRequest];
    
    likeRequest = [XZWNetworkManager asiWithLink:[XZWLikeQuanZi   stringByAppendingFormat:@"&gid=%d",quanID] postDic:nil completionBlock:^{
        
        
        if ([[[likeRequest responseString]  objectFromJSONString][@"status"]   intValue] == 1  ) {
            
            
            hud.labelText = @"加载成功";
            
            
            
            isLike = !isLike;
            
         
            
            if (isLike) {
                
                [sender setTitle:@"取消" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"cancle"] forState:UIControlStateNormal];
                
            }else {
                
                [sender setTitle:@"喜欢" forState:UIControlStateNormal];
                [sender setImage:[UIImage imageNamed:@"linke"] forState:UIControlStateNormal];
                
            }
            
            
            
            
            
        }else {
            
            
            hud.labelText = [[likeRequest responseString]  objectFromJSONString][@"info"];
        }
        
        
        [hud  hide:true afterDelay:.6f];
        
        ;} failedBlock:^{
            
            
            hud.labelText = @"加载失败";
            
            
            [hud  hide:true afterDelay:.6f];
            
            ;}];
    
    
    
}


-(void)goOut:(UIButton*)sender{
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    hud.labelText = @"加载中...";
    [hud show:true];
    
    
    [self.view bringSubviewToFront:hud];
    
    [XZWNetworkManager cancelAndReleaseRequest:leaveRequest];
    
    leaveRequest = [XZWNetworkManager asiWithLink:  isMember? [XZWOutQuanZi   stringByAppendingFormat:@"&gid=%d",quanID]  : [XZWJoinQuanZi   stringByAppendingFormat:@"&gid=%d",quanID] postDic:nil completionBlock:^{
        
        
        if ([[[leaveRequest responseString]  objectFromJSONString][@"status"]   intValue] == 1  ) {
            
            
            
            
            isMember = !isMember;
            
//            if(isMember){
//                
//                
//                hud.labelText = @"加入成功";
//                
//            }else {
//                
//                hud.labelText = @"退出成功";
//                
//            }
//            
            
            
            
            hud.labelText = [[[leaveRequest responseString]  objectFromJSONString][@"info"]   description ];
            
            
            if (isMember) {
                
                [sender setTitle:@"退出" forState:UIControlStateNormal];
                
                [sender setImage:[UIImage imageNamed:@"exit"] forState:UIControlStateNormal];
                
            }else {
                
                [sender setTitle:@"申请加入" forState:UIControlStateNormal];
                
                [sender setImage:[UIImage imageNamed:@"jiaru"] forState:UIControlStateNormal];
            }
            
            
            
            
            
        }else {
            
            
            
            
            hud.labelText = [[[leaveRequest responseString]  objectFromJSONString][@"info"]   description ];
        }
        
                    
        
        [hud  hide:true afterDelay:.8f];
        
        ;} failedBlock:^{
            
            
            hud.labelText = @"加载失败";
            
            [hud  hide:true afterDelay:.6f];
            
            ;}];
    

    
    
}


-(void)myIssue{
    
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(0, 35, 100, 10) ;}];
    
    [self.view bringSubviewToFront:issueTableView];
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    
    [self.view bringSubviewToFront:hud];
    
}

-(void)member{
    
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(110, 35, 100, 10) ;}];
    
    [self.view bringSubviewToFront:friendTable];
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    
    [self.view bringSubviewToFront:hud];
}

-(void)info{
    
    [UIView animateWithDuration:.3f animations:^{ arrowView.frame =  CGRectMake(220, 35, 100, 10) ;}];
 
    [self.view bringSubviewToFront:quanInfo];
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self.view viewWithTag:kMBProgessHud];
    
    [self.view bringSubviewToFront:hud];
}


#pragma mark - 



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  6;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat height = 44.f;
    
    
    if (indexPath.row == 5) {
        
        UILabel *infoUL = [[[UILabel alloc]   initWithFrame:CGRectMake(50, 10, 250, 44)] autorelease];
        infoUL.text = infoDic[@"intro"];
        infoUL.numberOfLines = 0;
        [infoUL   sizeThatFits:CGSizeMake(250, 2000)];
        [infoUL  sizeToFit];
        
        height = CGRectGetMaxY(infoUL.frame) + 10;
        
        if (height < 44) {
            height = 44;
        }
        
    }
    
    
 
    return height ;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *infoUL = [[UILabel alloc]   initWithFrame:CGRectMake(50, 5, 250, 44)];
        infoUL.tag = 122;
        infoUL.numberOfLines = 0 ;
        infoUL.textAlignment = UITextAlignmentRight;
        infoUL.textColor = [XZWUtil xzwRedColor];
        [infoUL setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:infoUL];
        [infoUL release];
        
        
        UILabel *leftUL = [[UILabel alloc]  initWithFrame:CGRectMake(8, 0, 250, 44)];
        leftUL.tag = 100;
        leftUL.backgroundColor = [UIColor clearColor];
        leftUL.textColor = [UIColor grayColor];
        [cell.contentView addSubview:leftUL];
        [leftUL release];
        
        XZWStarView *starView = [[XZWStarView  alloc]  initWithFrame:CGRectMake(208, 10, 150, 15) quanDetailStar:1];
        starView.tag = 99 ;
        [cell.contentView  addSubview:starView];
        [starView release];
    }
    
    UILabel *leftUL = (UILabel *)[cell.contentView viewWithTag:100] ;
    leftUL.backgroundColor = [UIColor clearColor];
    leftUL.textColor = [UIColor grayColor];
    
    UILabel *rightUL = (UILabel *)[cell.contentView viewWithTag:122];
    rightUL.frame = CGRectMake(50, 0, 240, 44);
    rightUL.textAlignment = UITextAlignmentRight;
    
    
    XZWStarView *starView = (XZWStarView *)[cell.contentView viewWithTag:99]  ;
    [starView setHidden:true];
    
    switch (indexPath.row) {
        case 0:
        {
            leftUL.text = @"圈子";
            rightUL.text = infoDic[@"name"];
            
        }
            break;
           
        case 1:
        {
            
            leftUL.text = @"圈号";
            rightUL.text = infoDic[@"id"];
        }
            break;
            
        case 2:
        {
            
            leftUL.text = @"级别";
            rightUL.text = @"";
            
            [starView setHidden:FALSE];
            //[infoDic[@"group_level"]   intValue]
            [starView   setquanDetailStar:[infoDic[@"group_level"]   intValue]];
        }
            break;
            
        case 3:
        {
            
            leftUL.text = @"创建者";
            rightUL.text = infoDic[@"uname"];
        }
            break;
            
        case 4:
        {
            
            leftUL.text = @"分类";
            rightUL.text = infoDic[@"cname0"];
        }
            break;
        case 5:
        {
            
            leftUL.text = @"简介";
            rightUL.text = infoDic[@"intro"];
            rightUL.frame = CGRectMake(50, 13, 250, 44);
            [rightUL   sizeThatFits:CGSizeMake(250, 2000)];
            [rightUL  sizeToFit];
            
            
            rightUL.textAlignment = UITextAlignmentLeft;
            
            
            if (CGRectGetHeight(rightUL.frame) < 30) {
                
                rightUL.frame = CGRectMake(290 - CGRectGetWidth(rightUL.frame), 10, CGRectGetWidth(rightUL.frame), CGRectGetHeight(rightUL.frame));
                
            }

        }
            break;
        case 6:
        {
            
            leftUL.text = @"圈子";
            rightUL.text = infoDic[@"name"];
        }
            break;
            
        default:
        {
            
            
        }
            break;
    }
 
    
    
    return cell;
}


#pragma mark - delegate



-(void)click:(NSArray*)indexArray{
    
    GoodsGalleryViewController *ggvc = [[GoodsGalleryViewController alloc]  initWithPhotoArray:indexArray page:0];
    [self.navigationController presentModalViewController:ggvc animated:true];
    [ggvc release];

}


-(void)acceptDic:(NSDictionary*)acceptDic{
     
    
    
    acceptRequest = [XZWNetworkManager  asiWithLink:[XZWManageQuanZi   stringByAppendingFormat:@"&gid=%@&uid=%@&op=%@",acceptDic[@"gid"],acceptDic[@"uid"],acceptDic[@"op"]] postDic:nil completionBlock:^{
    
     
        NSDictionary *responseDic  = [[acceptRequest responseString]   objectFromJSONString];
        
        if ([responseDic[@"status"]   intValue] == 1 ) {
            
          
            [friendTable  acceptFinish:[acceptDic[@"uid"]   intValue]];
            
            
        }else {
            
            
            [friendTable  acceptFail:responseDic[@"info"]];
            
        }
        
        
        
        
    
    
    } failedBlock:^{
    
        
        [friendTable  acceptFail:@"加载失败"];
    
    }];
    
    
    
}

-(void)deline:(NSDictionary*)delineDic{
    
    
    
    acceptRequest = [XZWNetworkManager  asiWithLink:[XZWManageQuanZi   stringByAppendingFormat:@"&gid=%@&uid=%@&op=%@",delineDic[@"gid"],delineDic[@"uid"],delineDic[@"op"]] postDic:nil completionBlock:^{
        
        
        
        NSDictionary *responseDic  = [[acceptRequest responseString]   objectFromJSONString];
        
        if ([responseDic[@"status"]   intValue] == 1 ) {
            
            [friendTable delineFinish:[delineDic[@"uid"]   intValue]];
            
        }else {
            
            
            
            [friendTable delineFail:responseDic[@"info"]];
        }
        
        
        
        
        
        
    } failedBlock:^{
        
        
        [friendTable  delineFail:@"加载失败"];
        
    }];
    
}


-(void)setNewCount:(int)count{
         
    [newMemberView setBadgeString:[NSString stringWithFormat:@"%d",count]];
    
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
