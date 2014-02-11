//
//  XZWAboutViewController.m
//  XZW
//
//  Created by dee on 13-10-30.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWAboutViewController.h"
#import <ShareSDK/ShareSDK.h> 
#import "XZWUtil.h"

@interface XZWAboutViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *myTableView;
        
}

@end

@implementation XZWAboutViewController

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
    
    self.title = @"关于我们";
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];

    [self initView];
   
}

-(void)initView{
    
    myTableView = [[UITableView alloc]   initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight - 64) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    [myTableView release];
    
     
    UIView *backgroundView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 50)]  autorelease];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    myTableView.backgroundView = backgroundView;
    
    UIView *headerView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 130)];
    myTableView.tableHeaderView = headerView; 
    [headerView release];
    
    UIImageView *iconUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(133, 30, 57, 57)];
    [iconUIV  setImage:[UIImage imageNamed:@"Icon"]];
    [headerView addSubview:iconUIV];
    [iconUIV release];
    
    UILabel *uiLabel = [[UILabel alloc]   initWithFrame:CGRectMake(0, 90, 320, 20)];
    [uiLabel setText:@"星座屋"];
    uiLabel.font = [UIFont systemFontOfSize:13];
    uiLabel.backgroundColor = [UIColor clearColor];
    uiLabel.textAlignment = UITextAlignmentCenter;
    [headerView addSubview:uiLabel];
    [uiLabel release];
    
}


#pragma mark - table delegate &datasource

 
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    return 58;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.section) {
        case 0:{
            
            
            switch (indexPath.row) {
                case 0:
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.xingzuowu.com"]];
                    
                }
                    break;
                case 2:{
                    
                    
                    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
                    
                    //构造分享内容
                    id<ISSContent> publishContent = [ShareSDK content:@""
                                                       defaultContent:@"分享 星座屋 http://www.xingzuowu.com"
                                                                image:[ShareSDK imageWithPath:imagePath]
                                                                title:@"分享 星座屋"
                                                                  url:@"http://www.xingzuowu.com"
                                                          description:@"分享 星座屋 http://www.xingzuowu.com"
                                                            mediaType:SSPublishContentMediaTypeNews];
                    
                     
                    [publishContent addSinaWeiboUnitWithContent:INHERIT_VALUE image:INHERIT_VALUE];
                    
                    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                                         content:INHERIT_VALUE
                                                           title:INHERIT_VALUE
                                                             url:INHERIT_VALUE
                                                           image:INHERIT_VALUE
                                                    musicFileUrl:nil
                                                         extInfo:nil
                                                        fileData:nil
                                                    emoticonData:nil];
                    //定制微信朋友圈信息
                    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage]
                                                          content:INHERIT_VALUE
                                                            title:INHERIT_VALUE
                                                              url:INHERIT_VALUE
                                                            image:INHERIT_VALUE
                                                     musicFileUrl:INHERIT_VALUE
                                                          extInfo:nil
                                                         fileData:nil
                                                     emoticonData:nil];
                    
                    id<ISSShareOptions> shareOptions = [ShareSDK simpleShareOptionsWithTitle:@"分享内容" shareViewDelegate:nil];
                    
                    
                    id<ISSContainer> container = [ShareSDK container];
                    
                    NSArray *shareList = [ShareSDK getShareListWithType:
                                          ShareTypeSinaWeibo,ShareTypeWeixiSession,ShareTypeWeixiTimeline,
                                          nil];
                     
                    
                    [ShareSDK showShareActionSheet:container
                                         shareList:shareList
                                           content:publishContent
                                     statusBarTips:true
                                       authOptions:nil
                                      shareOptions:shareOptions
                                            result:nil];
                    
                    
                    
                }
                    break ;
                default:
                    break;
            }
            
            
            
        }
            
            break;
            
        default:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.xingzuowu.com"]];
            
        }
            break;
    }
    
    
    
}


 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    int total = 1 ;
    
    if (section == 0) {
        total = 3;
    }
    
    return total;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
               
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *ul =[[UILabel alloc]  initWithFrame:CGRectMake(60, 5, 233, 30)];
        ul.tag = 36;
        ul.textAlignment = UITextAlignmentRight;
        ul.textColor = UIColor.grayColor;
       // ul.highlightedTextColor = UIColor.whiteColor;
        ul.backgroundColor = UIColor.clearColor;
        ul.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:ul];
        [ul release];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
         
        
//        ul =[[UILabel alloc]  initWithFrame:CGRectMake(60, 28, 160, 24)];
//        ul.tag = 37;
//        ul.textColor = UIColor.grayColor;
//        ul.highlightedTextColor = UIColor.whiteColor;
//        ul.backgroundColor = UIColor.clearColor;
//        ul.font = [UIFont systemFontOfSize:15];
//        [cell.contentView addSubview:ul];
//        [ul release];
        
         
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;

    
     UILabel *leftUL  = cell.textLabel;
    UILabel *rightUL  = (UILabel *)[cell.contentView viewWithTag:36];
    
    switch (indexPath.section) {
        case 0:
        {
         
            switch (indexPath.row) {
                case 0:
                {
                    leftUL.text = @"星座屋手机版";
                    rightUL.text = @"http://m.xingzuowu.com";
                    
                }
                    break;
                case 1:
                {
                    leftUL.text = @"官方QQ群";
                    rightUL.text = @"161753056";
                    
                }
                    break;
                    
                default:{
                    
                    leftUL.text = @"分享给好友";
                    rightUL.text = @"";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

                }
                    break;
            }
            
            
            
            
        }
            break;
            
        default:{
            
            leftUL.text = @"关注我们";
            rightUL.text = @"";
            
        }
            break;
    }
    
    
      
    
    
     
    
    
    
    return cell;
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
