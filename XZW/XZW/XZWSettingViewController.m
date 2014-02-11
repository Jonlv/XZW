//
//  XZWSettingViewController.m
//  XZW
//
//  Created by dee on 13-10-17.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSettingViewController.h"
#import "IIViewDeckController.h"
#import <SDWebImage/SDImageCache.h>
#import "XZWSwitch.h" 
#import "XZWNetworkManager.h"
#import "XZWAdviceViewController.h"
#import "Harpy.h"
#import "XZWAboutViewController.h"
#import "XZWMessageSettingViewController.h"
#import "XZWAboutViewController.h"


@interface XZWSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
     
    
    UITableView *settingTableView;
    
    BOOL isChecking;
}

@end

@implementation XZWSettingViewController

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
    
    self.title = @"设置";
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(toggleView) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"function"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
    settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight -64 ) style:UITableViewStyleGrouped];
    settingTableView.showsHorizontalScrollIndicator = settingTableView.showsVerticalScrollIndicator = false;
    [settingTableView setDataSource:self];
    [settingTableView setDelegate:self];
    settingTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:settingTableView];
    [settingTableView release];
    
    
    UIView *backGroundView = [[UIView alloc]  initWithFrame:settingTableView.bounds];
    [backGroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [settingTableView setBackgroundView:backGroundView];
    [backGroundView release];
    
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



-(void)toggleView{
    
    
    [self.navigationController.viewDeckController  toggleLeftViewAnimated:true];
}


#pragma mark - tableview


#pragma mark -


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        { 
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XZWLogOutNotification object:nil];
            
        }
            break;
            
        case 1:
        {
            
           // [[SDImageCache sharedImageCache]  clearMemory];
            
                if ([[NSFileManager defaultManager]   fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"XZWCities"]]) {
                    
                    [[NSFileManager defaultManager]  removeItemAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"XZWCities"]  error:nil];
                     
                }
            
            
            [[SDImageCache sharedImageCache]  clearDisk];
            [tableView reloadData];
            
        }
            break;
        case 2:
        {
            
            
        }
            break;
        case 3:
        {
            
            XZWMessageSettingViewController *adviceVC = [[XZWMessageSettingViewController alloc]  init];
            [self.navigationController pushViewController:adviceVC animated:true];
            [adviceVC release];
            
        }
            break;
        case 4:
        {
            
            
        }
            break;
        case 5:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    [Harpy checkVersion];
                    
//                    if (isChecking) {
//                        
//                        break ;
//                    }else {
//                        
//                        
//                        
//                        
//                        
//                        isChecking = true;
//                        
//                        ASIHTTPRequest    *checkRequest  = nil;
//                        
//                        checkRequest = [XZWNetworkManager asiWithLink:@"" postDic:nil completionBlock:^{
//                            
//                            
//                            [[checkRequest responseString]  objectFromJSONString];
//                             
//                            isChecking = false;
//                             
//                            
//                            [[[[UIAlertView alloc] initWithTitle:@"" message:@"更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil]    autorelease]show];
//                            
//                            
//                            
//                            
//                            
//                        } failedBlock:^{
//                            
//                            isChecking = false;
//                            
//                        }];
//                        
//                        
//                    }
                    
                    
                    
                    
                    
                }
                    break;
                case 1:
                {
                    XZWAdviceViewController *adviceVC = [[XZWAdviceViewController alloc]  init];
                    [self.navigationController pushViewController:adviceVC animated:true];
                    [adviceVC release];
                    
                    
                }
                    break;
                case 2:
                {
                    XZWAboutViewController *aboutVC = [[XZWAboutViewController alloc] init];
                    [self.navigationController pushViewController:aboutVC animated:true];
                    [aboutVC release];
                }
                    break;
                    
                default:
                    break;
            }
            
            
            
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
            
        }
            break;
        default:
            break;
    }
    
    
    
}



#pragma mark - alertview

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        
        
        
    } else {
        
        
         
    }
    
}

#pragma mark -

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)] autorelease];
    
    UILabel *settingUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, -4, 320, 15)];
    [headerView addSubview:settingUL];
    settingUL.font = [UIFont systemFontOfSize:13];
    settingUL.textColor = [UIColor grayColor];
    [settingUL setBackgroundColor:[UIColor clearColor]];
    [settingUL release];
    
    
    NSArray *dataArray = @[@"",@"退出登录,切换账号",@"清除系统缓存,不会删除用户信息",@"建议在网速较快的情况下使用高清",@"包括:私信,评论,系统通知",@"提示应用更新，提示系统更新",@"",@""  ];
    
    settingUL.text = dataArray[section];
    
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    int rows = 1;
    
    if (section == 5) {
        
        rows = 3;
    }
     
    
    return  rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return  0 ;
    }
    
    return 25;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UILabel *cellDetailUL = [[UILabel alloc]  initWithFrame:CGRectMake(100, 0, 200, 44)];
        cellDetailUL.tag = 334;
        cellDetailUL.textColor = [UIColor grayColor];
        cellDetailUL.textAlignment = UITextAlignmentRight;
        cellDetailUL.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:cellDetailUL];
        [cellDetailUL release];
        
        
        XZWSwitch *theSwitch = [[XZWSwitch alloc]  initWithFrame:CGRectMake(220, 8, 79, 44)];
        [theSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged]; 
        theSwitch.tag = 3335;
        [cell.contentView addSubview:theSwitch];
        [theSwitch release];
        
    }
    
    
    NSArray *dataArray = @[@"退出当前登录帐号",@"清除软件缓存",@"上传图片质量",@"接收新消息通知",@"自动检测版本更新",@[@"新版本检测",@"意见反馈",@"关于"]];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [dataArray[indexPath.section]  isKindOfClass:[NSArray class]]?  dataArray[indexPath.section][indexPath.row] : dataArray[indexPath.section]   ;
    
    
    XZWSwitch *mySwitch = (XZWSwitch *)[cell.contentView viewWithTag:3335] ;
    mySwitch.hidden = true;

    
    UILabel *detailUL = (UILabel *)[cell.contentView viewWithTag:334];
    detailUL.hidden = true;
    
    if (indexPath.section == 1) {
        
        detailUL.frame = CGRectMake(90, 0, 200, 44);
        
        detailUL.hidden = false;
        
        NSString *sizeString;
        long size =
        [[SDImageCache  sharedImageCache] getSize];
        if (size >1024) {
            sizeString = [NSString stringWithFormat:@"%.1fM",size /1024.f/1024.f];
        }else {
            
            sizeString = [NSString stringWithFormat:@"%.1fKB",size / 1024.f  ];
        }
        
        
        detailUL.text = [NSString stringWithFormat:@"%@",sizeString];
        
    }
    
    
    
    if ((indexPath.row == 1 || indexPath.row == 2) ) {
        
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    if ((indexPath.section >= 2 && indexPath.section <= 4) ) {
        
        mySwitch.hidden = false;
        mySwitch.switchTag = indexPath.section;
        
        switch (indexPath.section) {
            case 2:
            {
                
                mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWHighQuality"];
               
                detailUL.frame = CGRectMake(90 - 75, 0, 200, 44);
                
                detailUL.hidden = false;
                
                if (mySwitch.on) {
                    
                    detailUL.text = @"高清";
                    
                }else {
                    
                    
                    detailUL.text = @"普通 ";
                }
                
            }
                break;
                
            case 3:
            {
                
                mySwitch.hidden = true;
             //   mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWNewMessage"];
            }
                break;
            case 4:
            {
                
             //   mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWShake"];
                
                mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWAutoCheck"];
            }
                break;
            case 5:
            {
                
                
            }
                break;
            default:
                break;
        }
        
        
    }
    
    
    return cell;
}


#pragma mark - 


-(void)changeSwitch:(XZWSwitch*)switchControl{
    
    
    
    switch (switchControl.switchTag) {
        case 2:
        {
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWHighQuality"];
             
        }
            break;
            
        case 3:
        {
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWNewMessage"];
             
        }
            break;
        case 4:
        {
            
       //     [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWShake"];
             
            
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWAutoCheck"];
        }
            break;
        case 5:
        {
            
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWAutoCheck"];
             
        }
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    
    [settingTableView reloadData];
}



#pragma mark -



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
