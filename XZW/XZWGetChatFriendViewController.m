//
//  XZWGetChatFriendViewController.m
//  XZW
//
//  Created by dee on 13-10-21.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWGetChatFriendViewController.h"
#import "pinyin.h"
#import "XZWNetworkManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "XZWUtil.h"
#import "IIViewDeckController.h"
#import "XZWChatViewController.h"
#import "XZWChatStyleTwoViewController.h"

@interface XZWGetChatFriendViewController () <UITableViewDataSource,UITableViewDelegate>{
    
     
    UITableView *myTableView;
    
    
    
    NSMutableArray *friendArray;
    
    NSMutableArray *pyArray;
    
    NSMutableDictionary *pyDic;
    
    NSMutableArray *indexArray;
    
    
    BOOL isLoading;
    
    
    ASIFormDataRequest *myFormRequest;
    
}

@end

@implementation XZWGetChatFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


NSInteger csortPerson(id p1, id p2, void *context)
{
    NSString  *v1 = [ (NSDictionary*)p1 objectForKey:@"pinyin"];
    NSString  * v2 = [ (NSDictionary*)p1 objectForKey:@"pinyin"];
    
    return [v1 compare:v2 options:NSCaseInsensitiveSearch];
}

-(NSString*)getThePinYinCharater:(NSString*)nameString{
    
    int total = [nameString length];
    char name[total]  ;
    
    for (int i = 0; i < [nameString length]; i++)
    {
        name[i] = pinyinFirstLetter([nameString characterAtIndex:i]);
        
    }
    
    return [[NSString   stringWithFormat:@"%s",name]   substringToIndex:total];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    friendArray = [[NSMutableArray alloc]   init];
    pyArray = [[NSMutableArray alloc]   init];
    pyDic = [[NSMutableDictionary alloc]   init]; 
    //UITableViewIndexSearch
    indexArray = [[NSMutableArray alloc]  init];
    
    UILabel *tipsUL = [[UILabel alloc]   initWithFrame:CGRectMake(110, 0, 320, 44)];
    [tipsUL setText:@"我的联系人"];
    tipsUL.textColor = [UIColor whiteColor];
    tipsUL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipsUL];
    [tipsUL release];
    
    UIButton *freshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [freshButton  addTarget:self action:@selector(fresh) forControlEvents:UIControlEventTouchUpInside];
    [freshButton     setImage:[UIImage imageNamed:@"fresh"] forState:UIControlStateNormal];
    freshButton.frame = CGRectMake(270, 0, 44, 44);
    [self.view addSubview:freshButton];
    
    
    myTableView = [[UITableView alloc]  initWithFrame:CGRectMake(100, 44, 220, TotalScreenHeight - 20 - 44)];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
    myTableView.backgroundColor = [UIColor clearColor];
    [myTableView setDataSource:self];
    [myTableView setDelegate:self];
    [self.view addSubview:myTableView];
    [myTableView  release];
     
    [self loadRequest];
    
    self.view.backgroundColor = [UIColor colorWithHex:0x4c4c4c];

}


-(void)fresh{
    
    [self loadRequest];
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    if ([indexArray count]  <= 0  ){
         
        [indexArray  removeAllObjects];
      //  [indexArray  addObject:UITableViewIndexSearch];
        
        [self loadRequest];
    }
    
    
    [super viewWillAppear:animated];
}


-(void)loadRequest{
    
   
    if (isLoading){
        
        return ;
    }
    
    isLoading = true;
    
    myFormRequest = [XZWNetworkManager asiWithLink:XZWContactList postDic:nil completionBlock:^{
        
        NSDictionary *tmpDic = [[myFormRequest responseString] objectFromJSONString];
        
        
        
        [friendArray    removeAllObjects];
        [pyDic  removeAllObjects];
        [pyArray removeAllObjects];
        [indexArray removeAllObjects];

        
        
        if( [tmpDic[@"status"]   intValue] == 1 ){
            
            
            if ([[tmpDic objectForKey:@"data"] count] >0) {
                
                
                
                [friendArray addObjectsFromArray:[tmpDic objectForKey:@"data"]];
                
                NSArray *charaterArray  = [NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#" ,nil];
                
                
                for (int i = 0 ; i < [friendArray count] ; i++) {
                    
                    NSDictionary *dic = [friendArray objectAtIndex:i]  ;
                    
                    NSMutableDictionary *nmd = [NSMutableDictionary dictionaryWithDictionary:dic];
                    
                    NSString *pinyinString = [self getThePinYinCharater:[dic objectForKey:@"uname"]];
                    
                    [nmd   setObject:pinyinString forKey:@"pinyin"];
                    
                    NSString *prefixString = [[pinyinString  substringToIndex:1]   uppercaseString];
                    
                    
                    NSArray *array = [pyDic   objectForKey:prefixString];
                    
                    if (array) {
                        
                        NSMutableArray *nma  = [NSMutableArray array];
                        [nma   addObjectsFromArray:array];
                        [nma  addObject: nmd];
                        
                        [pyDic  setObject:nma forKey:prefixString];
                        
                    }else {
                        
                        NSMutableArray *nma  = [NSMutableArray arrayWithObject:nmd];
                        
                        [pyDic  setObject:nma forKey:prefixString];
                        
                    }
                    
                    
                }
                
                for (NSString *indexString in charaterArray) {
                    
                    //
                    NSArray *tempArray = [pyDic objectForKey:indexString];
                    
                    if (tempArray) {
                        
                        
                        [indexArray   addObject:indexString];
                        
                        
                        [pyDic   setObject:[tempArray sortedArrayUsingFunction:csortPerson context:NULL] forKey:indexString];
                        
                        
                    }
                    
                }
                                
            }
            
            
        }else {
            
            
            
            
        }
        
        
        
        isLoading = false;
        
                     

                     
        [myTableView reloadData];

        
        
    } failedBlock:^{
    
        isLoading = false;
    
    }];
     
    
 
    
    
}


#pragma mark - table delegate &datasource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.viewDeckController toggleRightView];
    
    
    
//    if ([(XZWGetChatFriendViewController *)((UINavigationController *)(self.viewDeckController.centerController)).topViewController  isKindOfClass:NSClassFromString(@"XZWGetChatFriendViewController")]) {
    
        
        
        [(XZWChatStyleTwoViewController *)((UINavigationController *)(self.viewDeckController.centerController)).topViewController    changeUser:[[[[pyDic   objectForKey:[indexArray objectAtIndex:indexPath.section  ]]  objectAtIndex:indexPath.row]     objectForKey:@"uid"] intValue] username:[[[pyDic   objectForKey:[indexArray objectAtIndex:indexPath.section  ]]  objectAtIndex:indexPath.row]     objectForKey:@"uname"]];
        
//    }
    
    
    
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 58;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    
    return 27;
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
 
    
    NSString *key = [indexArray
                     objectAtIndex:section ];
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 203, 27)]  ;
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.text=key;
    keyLabel.textColor = [UIColor grayColor];
    keyLabel.font = [UIFont systemFontOfSize:13];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sx_tit"]];
    [imgView addSubview:keyLabel];
    imgView.backgroundColor = [UIColor clearColor];
    [keyLabel release];
    
    
    
    return [imgView   autorelease];
    
}



-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
     
    return   indexArray;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    
//    if (title == UITableViewIndexSearch)
//	{ 
//		return -1;
//	}
    
    
    [self.view endEditing:true];
    
    return index ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    
    return [indexArray count]     ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
   
    return [[pyDic   objectForKey:[indexArray objectAtIndex:section ]] count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *topImageView = [[UIImageView alloc]    initWithFrame:CGRectMake(16, 10, 34, 34)];
        //      [topImageView setImage:[UIImage imageNamed:@"select_sort_line2.png"]];
        topImageView.layer.cornerRadius = 4.f;
        topImageView.layer.masksToBounds = true;
        topImageView.tag = 34;
        [cell.contentView addSubview:topImageView];
        [topImageView release];
        
        
        topImageView = [[UIImageView alloc]    initWithFrame:CGRectMake(0, 0, 320, 61)];
      //  [topImageView setBackgroundColor:[MyUtil setColorByR:251.f G:251.f B:251.f]];
        cell.backgroundView = topImageView ;
        [topImageView release];
        
        UILabel *ul =[[UILabel alloc]  initWithFrame:CGRectMake(60, 5, 160, 24)];
        ul.tag = 36;
        ul.textColor = UIColor.whiteColor;
        ul.highlightedTextColor = UIColor.whiteColor;
        ul.backgroundColor = UIColor.clearColor;
        ul.font = [UIFont systemFontOfSize:18];
        [cell.contentView addSubview:ul];
        [ul release];
        
        
        UIImageView *lineUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 57, 320, 1)];
        lineUIV.tag = 58;
        lineUIV.image = [UIImage imageNamed:@"table_line"];
        [cell.contentView addSubview:lineUIV];
        [lineUIV release];
        
        
        ul =[[UILabel alloc]  initWithFrame:CGRectMake(60, 28, 160, 24)];
        ul.tag = 37;
        ul.textColor = UIColor.grayColor;
        ul.highlightedTextColor = UIColor.whiteColor;
        ul.backgroundColor = UIColor.clearColor;
        ul.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:ul];
        [ul release];
        
        
        cell.contentView.backgroundColor = [UIColor colorWithHex:0x4c4c4c];
        
    }
    
    
    UIImageView *photoUIV = (UIImageView*)[cell.contentView viewWithTag:34];
    
  
        
    ((UILabel*)[cell.contentView viewWithTag:37]).text =  [[[pyDic   objectForKey:[indexArray objectAtIndex:indexPath.section  ]]  objectAtIndex:indexPath.row]     objectForKey:@"intro"]  ;
    
    
    ((UILabel*)[cell.contentView viewWithTag:36]).text =  [[[pyDic   objectForKey:[indexArray objectAtIndex:indexPath.section  ]]  objectAtIndex:indexPath.row]     objectForKey:@"uname"]  ;
        
        
    [photoUIV   setImageWithURL:[NSURL URLWithString:[[[pyDic   objectForKey:[indexArray objectAtIndex:indexPath.section  ]]  objectAtIndex:indexPath.row]     objectForKey:@"avatar"]]];
    
    
    if ( [[pyDic   objectForKey:[indexArray objectAtIndex:indexPath.section  ]] count]  - 1 == indexPath.row   ){
        
        [cell.contentView viewWithTag:58].hidden = true;
        
    }else {
        
        [cell.contentView viewWithTag:58].hidden = false;
        
    }
    
    
    
    return cell;
}




#pragma mark -

-(void)dealloc{
    [friendArray  release];
    [pyArray release];
    [pyDic release];
    [super dealloc];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
