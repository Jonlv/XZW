//
//  XZWMessageSettingViewController.m
//  XZW
//
//  Created by dee on 13-11-1.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSwitch.h"
#import "XZWMessageSettingViewController.h"
#import "XZWUtil.h"
#import <QuartzCore/QuartzCore.h>

@interface XZWMessageSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{

    UIPickerView *datePickView;
    
    UITableView *messageSettingUTV;
    
    UIView  *backView;
}


@end

@implementation XZWMessageSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)pop{
    
    [self.navigationController popViewControllerAnimated:true];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
     
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    
    self.title = @"消息设置";

    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self  action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
 
    messageSettingUTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight -64 ) style:UITableViewStyleGrouped];
    messageSettingUTV.showsHorizontalScrollIndicator = messageSettingUTV.showsVerticalScrollIndicator = false;
    [messageSettingUTV setDataSource:self];
    [messageSettingUTV setDelegate:self];
    messageSettingUTV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:messageSettingUTV];
    [messageSettingUTV release];
    
    
    UIView *backGroundView = [[UIView alloc]  initWithFrame:messageSettingUTV.bounds];
    [backGroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [messageSettingUTV setBackgroundView:backGroundView];
    [backGroundView release];

    
  
    [self initView];
    

    
}



-(void)confirm{
    
    [UIView animateWithDuration:.3f animations:^{
    
    
    
        backView.frame = CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight);
    
    
    }];
    
}

-(void)initView{
    
    //TotalScreenHeight - 216 - 64
    
    backView = [[UIView alloc]   initWithFrame:CGRectMake(0, TotalScreenHeight, 320, TotalScreenHeight)];
    [self.view addSubview:backView];
    [backView release];
    
    
    UIImageView *backgroundView = [[UIImageView alloc]   initWithFrame:CGRectMake(0, 0 ,  320 , 216 + 64)];
    backgroundView.userInteractionEnabled = true;
    backgroundView.backgroundColor = [UIColor colorWithHex:0x464d5b alpha:.8f];
    [backView addSubview:backgroundView];
    [backgroundView release];
    
    
    UIImageView *toolBarUIV = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"cledertop"]];
    toolBarUIV.layer.shadowOffset = CGSizeMake(0, -2);
    toolBarUIV.frame = CGRectMake(0, 0, 320, 44);
    [backgroundView addSubview:toolBarUIV];
    [toolBarUIV release];
    
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom]; 
    [confirmBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setFrame:  CGRectMake(242, 6 , 64, 31)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"calendar_btn"] forState:UIControlStateNormal];
    [backgroundView addSubview:confirmBtn];
    
    
    datePickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
    datePickView.showsSelectionIndicator = true;
    [backgroundView addSubview:datePickView];
    datePickView.delegate = self;
    datePickView.dataSource = self;
    [datePickView release];
    
    switch ([[NSUserDefaults standardUserDefaults]   integerForKey:@"XZWNewsInterval"]) {
        case 2:
        {
            
            [datePickView  selectRow:0 inComponent:0 animated:false];
        }
            break;
        case 5:
        {
            
            [datePickView  selectRow:1 inComponent:0 animated:false];
        }
            break;
        default:{
            
            [datePickView  selectRow:2 inComponent:0 animated:false];
        }
            break;
    }
}


#pragma mark -

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)] autorelease];
//    
//    UILabel *settingUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, -4, 320, 15)];
//    [headerView addSubview:settingUL];
//    settingUL.font = [UIFont systemFontOfSize:13];
//    settingUL.textColor = [UIColor grayColor];
//    [settingUL setBackgroundColor:[UIColor clearColor]];
//    [settingUL release];
//    
//    
//    NSArray *dataArray = @[@"",@"设置系统功能消息提示震动",@" ",@"自动检测新消息的间隔时间",@"包括:私信,评论,系统通知",@"设置系统功能消息提示震动",@"提示应用更新",@"",@""  ];
//    
//    settingUL.text = dataArray[section];
//    
//    return headerView;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        
        [UIView animateWithDuration:.3f animations:^{
            
            
            
            backView.frame = CGRectMake(0, TotalScreenHeight - 64 - 216 - 44, 320, TotalScreenHeight);
            
            
        }];
    }
    
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)] autorelease];
    
    UILabel *settingUL = [[UILabel alloc]  initWithFrame:CGRectMake(10, 4, 320, 15)];
    [headerView addSubview:settingUL];
    settingUL.font = [UIFont systemFontOfSize:13];
    settingUL.textColor = [UIColor grayColor];
    [settingUL setBackgroundColor:[UIColor clearColor]];
    [settingUL release];
    
    
    NSArray *dataArray = @[@"设置系统功能消息提示震动",@" ",@"自动检测新消息的间隔时间",@"包括:私信,评论,系统通知",@"设置系统功能消息提示震动",@"提示应用更新",@"",@""  ];
    
    settingUL.text = dataArray[section];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return  0;
    }
    
    return 25;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    
    int rows = 1;
    
    if (section == 1) {
        
        rows = 5;
    }
    
    
    return  rows;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    
//    if (section == 0) {
//        
//        return  0;
//    }
//    
//    return 25;
//}


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
    
    
    NSArray *dataArray = @[@"消息通知震动", @[@"评论提醒",@"好友添加提醒",@"系统推送提醒",@"私信提醒",@"加入圈子验证"],@"获取新消息"];
    
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [dataArray[indexPath.section]  isKindOfClass:[NSArray class]]?  dataArray[indexPath.section][indexPath.row] : dataArray[indexPath.section]   ;
    
    
    XZWSwitch *mySwitch = (XZWSwitch *)[cell.contentView viewWithTag:3335] ;
    mySwitch.hidden = true;
    
    
    UILabel *detailUL = (UILabel *)[cell.contentView viewWithTag:334];
    detailUL.hidden = true;
    
    if (indexPath.section == 2) {
        
        detailUL.frame = CGRectMake(90, 0, 200, 44);
        
        detailUL.hidden = false;
         
        detailUL.text = @"10分钟";
        
        
        detailUL.text = [NSString stringWithFormat:@"%d分钟",[[NSUserDefaults standardUserDefaults] integerForKey:@"XZWNewsInterval"]] ;
        
        
     //   detailUL.text = [NSString stringWithFormat:@"%@",sizeString];
        
    }
    
    
    if ((indexPath.section == 0 ) ) {
        
        mySwitch.hidden = false;
        mySwitch.switchTag = 100;
        
        mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWShake"];

        
    }
    
     
    if ((indexPath.section == 1 ) ) {
        
        mySwitch.hidden = false;
        mySwitch.switchTag = indexPath.row;
        
        switch (indexPath.row) {
            case 0:
            {
                mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWNewComment"];
            }
                break ;
            case 1:
            {
                mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWNewFriend"];
            }
                break ;
            case 2:
            {
                
                mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWPush"];
            }
                break;
                
            case 3:
            {
                mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWNewMessage"];
            }
                break;
            case 4:
            {
                
                mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWValidation"];
                
            }
                break;
            case 5:
            {
                
              //  mySwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"XZWAutoCheck"];
                
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
        case 0:
        {
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWNewComment"];
            
        }
            break;
            
        case 1:
        {
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWNewFriend"];
            
        }
            break;
            
        case 2:
        {
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWPush"];
            
        }
            break;
            
        case 3:
        {
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWNewMessage"];
            
            
            
        }
            break;
        case 4:
        {
            
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWValidation"];
            
            
        }
            break;
        case 100:
        {
            [[NSUserDefaults standardUserDefaults] setBool:switchControl.on forKey:@"XZWShake"];
             
        }
            break;
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
     
}

#pragma mark - 


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *titleString = nil ;
    
    switch (row) {
        case 0:{
            titleString = @"每2分钟";
        }
            
            break;
            case 1:
        {
            
            titleString = @"每5分钟";
            
        }
            break ;
        default:{
            
            titleString = @"每10分钟";
            
        }
            break;
    }
    
    return titleString;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return 3;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    
    return 1;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    switch (row) {
        case 0:{
            
            [[NSUserDefaults standardUserDefaults]   setInteger:2 forKey:@"XZWNewsInterval"];
      
            
        } 
            break;
        case 1:{
            
            
            [[NSUserDefaults standardUserDefaults]   setInteger:5 forKey:@"XZWNewsInterval"];
        }
            break;
        case 2:{
            
            
            [[NSUserDefaults standardUserDefaults]   setInteger:10 forKey:@"XZWNewsInterval"];
        }
            break;


        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults]  synchronize];
    
    [messageSettingUTV  reloadData];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
