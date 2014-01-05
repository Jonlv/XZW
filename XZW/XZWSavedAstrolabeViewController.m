//
//  XZWSavedAstrolabeViewController.m
//  XZW
//
//  Created by dee on 13-9-5.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWSavedAstrolabeViewController.h"
#import "XZWUtil.h"
#import "FMDatabase.h"
#import "XZWAstrolabeResultViewController.h"
#import "FMDatabaseQueue.h"
#import "XZWButton.h"
#import "UIButton+Extensions.h"

@interface XZWSavedAstrolabeViewController (){
    
    NSMutableArray *saveArray,*editArray;
    
    UITableView *tableUTV;
    
    
    BOOL isEditing;
    
    UIView *editView;
}

@end

@implementation XZWSavedAstrolabeViewController


- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        saveArray = [[NSMutableArray alloc]   init];
        editArray = [[NSMutableArray alloc]   init];
    }
    return self;
}


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
    
    self.title = @"已保存的星盘";
    
    
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 23, 20);
    [listButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [listButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    
//    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    listButton.frame = CGRectMake(0, 0, 23, 20);
//    [listButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
//    [listButton setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    
    
    listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    listButton.frame = CGRectMake(0, 0, 53, 30);
    listButton.contentMode = UIViewContentModeScaleToFill;
    [listButton addTarget:self action:@selector(getEdit:) forControlEvents:UIControlEventTouchUpInside];
    [listButton setBackgroundImage:[[UIImage imageNamed:@"edit_btn"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [listButton   setTitle:@"编辑" forState:UIControlStateNormal];
    [listButton   setTitle:@"取消" forState:UIControlStateSelected];
    listButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];

    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]  initWithCustomView:listButton]   autorelease];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [self loadData];
    
    
    
    tableUTV = [[UITableView alloc]  initWithFrame:CGRectMake(0, 0, 320, TotalScreenHeight -64 ) style:UITableViewStyleGrouped];
    tableUTV.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    tableUTV.delegate = self;
    tableUTV.dataSource = self;
    [self.view addSubview:tableUTV];
    [tableUTV release];
    
    
    UIView *backgroundView = [[UIView alloc]  initWithFrame:tableUTV.bounds];
    tableUTV.backgroundView =  backgroundView ;
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    [backgroundView release];
    
    [self initView];
}


-(void)initView{
    
    
    
    
    editView = [[UIView alloc]  initWithFrame:CGRectMake(0, TotalScreenHeight , 320, 44)];
    [self.view addSubview: editView];
    [editView   release];
    
    
    UIImageView *uiv = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"bt_bg"]];
    [editView addSubview:uiv];
    [uiv release];
    
    
    UIButton *selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame = CGRectMake(0, 0, 106, 40);
    [selectAllButton   addTarget:self action:@selector(selectAll) forControlEvents:UIControlEventTouchUpInside];
    [selectAllButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [selectAllButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    selectAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [editView addSubview:selectAllButton];
    
    selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame = CGRectMake(106, 0, 106, 40);
    [selectAllButton   addTarget:self action:@selector(deleteSelect) forControlEvents:UIControlEventTouchUpInside];
    [selectAllButton  setImageEdgeInsets:UIEdgeInsetsMake(0, -20 , 0, 0)];
    [selectAllButton  setImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    [selectAllButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [selectAllButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    selectAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectAllButton setTitle:@"删除" forState:UIControlStateNormal];
    [editView addSubview:selectAllButton];
    
    
    selectAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllButton.frame = CGRectMake(212, 0, 106, 40);
    [selectAllButton   addTarget:self action:@selector(unSelectAll) forControlEvents:UIControlEventTouchUpInside];
    [selectAllButton  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [selectAllButton  setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    selectAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [selectAllButton setTitle:@"取消全选" forState:UIControlStateNormal];
    [editView addSubview:selectAllButton];
    
    
    UIImageView *vUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(106, 0, 2, 43)];
    vUIV.image = [UIImage imageNamed:@"vline"];
    [editView addSubview:vUIV];
    [vUIV release];
    
    vUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(214, 0, 2, 43)];
    [editView addSubview:vUIV];
    vUIV.image = [UIImage imageNamed:@"vline"];
    [vUIV release];
}


#pragma mark -

-(void)editAction{
    
    
    [tableUTV setEditing:!tableUTV.editing animated:true];
    
}

-(void)goBack{
    
    [self.navigationController popViewControllerAnimated:true];
}


-(void)deleteRow:(int)row{
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        BOOL finish = [db executeUpdate:[NSString stringWithFormat:@"delete  from User  where id = %@", [[saveArray objectAtIndex:row]   objectForKey:@"id"]]];
        
        NSLog(@"%@~",[NSString stringWithFormat:@"delete  from User  where id = %@", [[saveArray objectAtIndex:row]   objectForKey:@"id"]]);
      
        if (finish) {
            
            [saveArray removeObjectAtIndex:row];
            
            [editArray removeObjectAtIndex:row];
            
            
        }
        
    }];
    
    
}

#pragma mark - 



-(void)getEdit:(UIButton*)sender{
    
    
    isEditing = !isEditing;
    
    sender.selected = !sender.selected;
    
    if (isEditing) {
        
        editView.frame = CGRectMake(0, TotalScreenHeight - 64 - 44 , 320, 44);
        tableUTV.frame =  CGRectMake(0, 0, 320, TotalScreenHeight - 64 - 44);
        
    }else {
        
        editView.frame = CGRectMake(0, TotalScreenHeight , 320, 44);
        tableUTV.frame =  CGRectMake(0, 0, 320, TotalScreenHeight - 64);
        
    }
    
    
    [tableUTV reloadData];
    
}



#pragma mark -

-(void)selectButton:(XZWButton*)sender{
    
    
    if (isEditing) {
        
        [editArray replaceObjectAtIndex:sender.buttonTag withObject:  @(![[editArray objectAtIndex:sender.buttonTag]  boolValue]) ] ;
        
        [tableUTV reloadData];
        
    } 
    
    
}




-(void)selectAll{
    
    [editArray  removeAllObjects];
    
    for (id object in saveArray) {
        
        [editArray   addObject:@true];
    }
    
    [tableUTV reloadData];
}


-(void)unSelectAll{
    
    [editArray  removeAllObjects];
    
    for (id object in saveArray) {
        
        [editArray   addObject:@false];
    }
    
    [tableUTV reloadData];
}




-(void)deleteSelect{
    
    
     
    
    
    
    for (int i = [editArray count] - 1 ; i >= 0 ; i--) {
        
        
        NSNumber *selectNum = editArray[i];
        
        if ([selectNum boolValue]) {
            
            [self deleteRow:i];
            
        }
        
    }
     
    
    [tableUTV performSelector:@selector(reloadData) withObject: nil afterDelay:.1f];

    

    
}



#pragma mark -



-(void)loadData{
    
    
    [saveArray  removeAllObjects];
    [editArray  removeAllObjects];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
         FMResultSet *rs  = [db executeQuery:@"select * from User"];
        
        while ([rs next]) {
            
            
            [saveArray   addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[rs intForColumn:@"id"]],@"id",[rs stringForColumn:@"name"],@"name", [rs stringForColumn:@"year"],@"year", [rs stringForColumn:@"month"],@"month", [rs stringForColumn:@"day"],@"day", [rs stringForColumn:@"hour"],@"hour", [rs stringForColumn:@"minute"],@"minute", [rs stringForColumn:@"daylight"],@"daylight", [rs stringForColumn:@"timezone"],@"timezone", [rs stringForColumn:@"longitude"],@"longitude", [rs stringForColumn:@"latitude"],@"latitude", [rs stringForColumn:@"am"],@"am", [rs stringForColumn:@"sml"],@"sml", [rs stringForColumn:@"birthday"],@"birthday", [rs stringForColumn:@"locString"],@"locString", [rs stringForColumn:@"timezoneString"],@"timezoneString", nil]];
            ;
        }

        
        
        for (int i = 0; i < [saveArray count]; i++) {
            
            [editArray     addObject:@false];
            
        }
        
    }];
    
    
}



#pragma mark - tableview



-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return @"删除";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  44;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableUTV deselectRowAtIndexPath:indexPath animated:true];
    
    
    if (isEditing) {
        
        
        return ;
    }

    XZWAstrolabeResultViewController *result= [[XZWAstrolabeResultViewController alloc]   initWithAstrolabeDic: [saveArray objectAtIndex:indexPath.row] ];
    [self.navigationController pushViewController:result animated:true];
    [result release];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        
        [self deleteRow:indexPath.row];
        
        [tableUTV reloadData];
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [saveArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];

        
        
        XZWButton *button = [XZWButton buttonWithType:UIButtonTypeCustom];
        button.frame =  CGRectMake(10, 15, 17, 17);
        //button.buttonTag = i;
        [button  setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
        [button  setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button  setHitTestEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
        [button addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 75 ;
        [cell.contentView addSubview:button];
        
        
//        showAscButton  = [UIButton buttonWithType:UIButtonTypeCustom];
//        [showAscButton addTarget:self action:@selector(showAsc) forControlEvents:UIControlEventTouchUpInside];
//        [showAscButton  setImage:[UIImage imageNamed:@"no_select"] forState:UIControlStateNormal];
//        [showAscButton  setImage:[UIImage imageNamed:@"select"] forState:UIControlStateSelected];
//        [showAscButton setFrame:CGRectMake(90, 165, 17, 17)];
//        [mainUSV addSubview:showAscButton];
    }
    
    XZWButton *button = (XZWButton *)[cell.contentView viewWithTag:75];
    [(XZWButton *)button   setButtonTag:indexPath.row];
    
    
    if (isEditing) {
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.contentView   bringSubviewToFront:button];
        
        button.hidden = false;
        cell.textLabel.text = [@"      " stringByAppendingString:[[[saveArray  objectAtIndex:indexPath.row]    objectForKey:@"name" ]   stringByAppendingString:@"的星盘"]] ;

        button.selected = [[editArray objectAtIndex:indexPath.row  ]  boolValue];
        
    }else {
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        button.hidden = true;
        cell.textLabel.text = [[[saveArray  objectAtIndex:indexPath.row]    objectForKey:@"name" ]   stringByAppendingString:@"的星盘"];

        
    }
    
    
    
    
        
    return cell;
}



-(void)dealloc{
    
    [saveArray  release];
    
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
