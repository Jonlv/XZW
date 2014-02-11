//
//  XZWMyDreamViewController.m
//  XZW
//
//  Created by dee on 13-11-7.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMyDreamViewController.h"
#import "XZWDBOperate.h"
#import "XZWDescriptionDetailViewController.h"
#import "XZWCateDetailViewController.h"


@interface XZWMyDreamViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UITextField *nameUTF;
    
    UITableView *dreamTable;
    
    NSMutableArray *dataArray;
}

@end

@implementation XZWMyDreamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)pop{
    
    [self.navigationController  popViewControllerAnimated:true];
}

-(void)dealloc{
    
    [dataArray  release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"周公解梦";
    
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self  action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];

    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
         

    [self initView];
    
	// Do any additional setup after loading the view.
}

-(void)initView
{
    UILabel *tipsUL =[[UILabel alloc]  initWithFrame:CGRectMake(5, 6, 300, 20)];
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    tipsUL.textColor = [UIColor grayColor];
    [tipsUL setText:@"请填写关键词,如：打雷、蛇"];
    [self.view  addSubview:tipsUL];
    [tipsUL release];
    
    
    UIImageView *inputUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(5, 30, 204, 26)];
    inputUIV.image = [UIImage imageNamed:@"biginput"];
    [self.view addSubview:inputUIV];
    [inputUIV release];
    
    nameUTF = [[UITextField alloc]  initWithFrame:CGRectMake(10, 32, 190, 22)];
    nameUTF.text = @"";
    nameUTF.clearsOnBeginEditing = true;
    nameUTF.returnKeyType = UIReturnKeyDone; 
    nameUTF.delegate = self;
    nameUTF.leftViewMode = UITextFieldViewModeAlways;
    nameUTF.leftView =  [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search"]]  autorelease];
    nameUTF.backgroundColor = [UIColor clearColor];
    [self.view addSubview:nameUTF];
    [nameUTF release];
    
    tipsUL =[[UILabel alloc]  initWithFrame:CGRectMake(5, 60, 300, 20)];
    [tipsUL setBackgroundColor:[UIColor clearColor]];
    tipsUL.textColor = [UIColor grayColor];
    [tipsUL setText:@"所有分类"];
    [self.view  addSubview:tipsUL];
    [tipsUL release];
    
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(219,  30 , 64, 24);
    [loginButton  setBackgroundImage:[UIImage imageNamed:@"regist" ] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [loginButton   setTitle:@"搜索" forState:UIControlStateNormal];
    [loginButton  addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    UIImageView *lineUIV = [[UIImageView alloc]    initWithFrame:CGRectMake(5, 85, 310, 3)];
    [self.view addSubview:lineUIV];
    [lineUIV release];
    
    [self getData];
    
    
    
    
    dreamTable = [[UITableView alloc]   initWithFrame:CGRectMake(0, 90, 320, TotalScreenHeight - 64 - 90) style:UITableViewStyleGrouped];
    [dreamTable setDelegate:self];
    [dreamTable setDataSource:self];
    dreamTable.backgroundColor = [UIColor clearColor];
    [dreamTable  setBackgroundView:[[[UIView alloc]  init]  autorelease]];
    [self.view addSubview:dreamTable];
    [dreamTable release];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
  
    [textField  resignFirstResponder];
    
    
    return true;
}


-(void)searchAction{
    
     
    
    NSDictionary *dic = [XZWDBOperate getSearchForKey:nameUTF.text];
    
    if (dic[@"name"]) {
        XZWDescriptionDetailViewController *detailVC =[[XZWDescriptionDetailViewController alloc]   initWithDic:dic];
        [self.navigationController pushViewController:detailVC animated:true];
        [detailVC release];
    }else {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有找到相关" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }
    
}


-(void)getData{
    
    
    dataArray = [[NSMutableArray alloc]   init];
    
    [dataArray    setArray:[XZWDBOperate getDreamCat]];
    
    for (int i = 0; i < [dataArray  count]; i++) {
        
        NSString *cateString = dataArray[i];
        
        [dataArray   replaceObjectAtIndex:i withObject:  @{@"cate":cateString,  @"array":[XZWDBOperate getTenDreamNameFromCat:cateString]} ];
        
        
        
    }
    
    
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  [dataArray count];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return   64;
//    
//}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.contentView.clipsToBounds = true;
         
        UILabel *contentUL = [[UILabel alloc]  initWithFrame:CGRectMake(73, 7, 210, 30)];
        contentUL.backgroundColor = [UIColor clearColor];
        contentUL.numberOfLines = 1;
        contentUL.tag = 3336;
        contentUL.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:contentUL];
        [contentUL release];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
         
        
    }
     
    
    cell.textLabel.text = [[dataArray  objectAtIndex:indexPath.row] objectForKey:@"cate"];
    
    NSMutableString *decrip = [NSMutableString string];
    
    NSArray *array = [[dataArray  objectAtIndex:indexPath.row] objectForKey:@"array"];
    
    for (NSString *descrptionString in array) {
        [decrip  appendFormat:@"%@/",descrptionString];
    }
    
    [(UILabel*)[cell.contentView viewWithTag:3336]  setText:decrip];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:true];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XZWCateDetailViewController * cateVC = [[XZWCateDetailViewController alloc]  initWithCateDetail:[dataArray  objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:cateVC animated:true];
    [cateVC release];
 
    
    
    
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:true];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
