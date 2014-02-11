//
//  XZWIssueTableView.m
//  XZW
//
//  Created by dee on 13-9-25.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWIssueTableView.h"

#import "XZWUtil.h"
#import "JSONKit.h"
#import "XZWZodiacData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "RCLabel.h"
#import "MBProgressHUD.h"
#import "XZWQuanIssueCell.h"


#define kMBProgessHud 8888


#define PerPage 20


@implementation XZWIssueTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
    }
    return self;
}




- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        zhiDaoArray  = [[NSMutableArray alloc]  init];
        
        
        current = 1;
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        
        
        
        linkPreString = [[NSMutableString alloc]   initWithFormat:@"%@",linkStringArg];
        
        MBProgressHUD *mbProgessHud = [[MBProgressHUD alloc]  initWithView:self];
        mbProgessHud.tag = kMBProgessHud;
        mbProgessHud.labelText = @"加载中...";
        [self addSubview:mbProgessHud];
        [mbProgessHud release];
        
        
        
        
        [mbProgessHud show:true];
        
        
        resolveRequest = [[ASIHTTPRequest  alloc ]   initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d",linkPreString,current]]];
                 
        [resolveRequest startAsynchronous];
        isLoading = true;
        
        [resolveRequest setCompletionBlock:^{
            
            
            myTableView = [[UITableView alloc]   initWithFrame:self.bounds];
            [self addSubview:myTableView];
            myTableView.backgroundColor = [UIColor clearColor];
            myTableView.separatorStyle  = UITableViewCellSelectionStyleNone;
            myTableView.delegate = self;
            myTableView.dataSource = self;
            [myTableView release];
            
            
            UIView *footerView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
            [myTableView setTableFooterView:footerView];
            
            UILabel *ul = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)];
            ul.text = @"加载中...";
            ul.backgroundColor = [UIColor clearColor];
            ul.textAlignment = UITextAlignmentCenter ;
            [footerView addSubview:ul];
            [ul release];
            
            UIActivityIndicatorView *uaiv = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            uaiv.frame = CGRectMake(95, 5, 30, 30);
            [footerView addSubview:uaiv];
            [uaiv release];
            [uaiv startAnimating];
            
            
            
            refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - myTableView.bounds.size.height, self.frame.size.width, myTableView.bounds.size.height)];
            refreshView.delegate = self;
            [myTableView addSubview:refreshView];
            [refreshView release];
            
            [refreshView refreshLastUpdatedDate];
            
            
            [self bringSubviewToFront:mbProgessHud];
            
            
            if ([[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"status"]  intValue] == 0) {
                
                
                
                UILabel *tipsUL = [[UILabel alloc]  initWithFrame:self.bounds];
                [tipsUL setText:[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"info"]];
                tipsUL.font = [UIFont systemFontOfSize:18];
                tipsUL.textAlignment = UITextAlignmentCenter;
                myTableView.tableFooterView =tipsUL;
                [tipsUL release];
                
                
            }else {
                
                
                
                totalPage = [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"]   objectForKey:@"totalPages"]  intValue];
                
                current = [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"]   objectForKey:@"nowPage"]  intValue];
                
                
                
                if ( ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count]  == 0 ) ||  current >= totalPage     ) {
                    
                    isFinished = true;
                    
                    [myTableView.tableFooterView   setHidden:true];
                    myTableView.tableFooterView = nil;
                    
                }
                
                if ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                    
                    [zhiDaoArray setArray:[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]];
                     
                }else{
                    
                    
                    isFinished = true;
                    
                    
                    [myTableView.tableFooterView   setHidden:true];
                    myTableView.tableFooterView = nil;
                }
                
                
                
                
                
                               
                [myTableView reloadData];

                
                
            }
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
            isLoading = false;
            
            
            [mbProgessHud    hide:true afterDelay:.6f];

            
            
            
            ;}];
        
        [resolveRequest setFailedBlock:^{
            
            
            [self bringSubviewToFront:mbProgessHud];
            [mbProgessHud    hide:true afterDelay:.8f];
            
            
            [self doneLoadingTableViewData];
            isLoading = false;
            
        }];
        
        
        
    }
    return self;
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */





#pragma mark -

-(void)dealloc{
    
    [zhiDaoArray  release];
    [linkPreString release];
    
    [super dealloc];
    
}


-(void)stopLoading{
    
    if (resolveRequest) {
        [resolveRequest   cancel];
        [resolveRequest release];
        resolveRequest = nil;
        
    }
    
}


#pragma mark -


-(void)loadNewPage{
    
    
    if (isLoading) {
        
        
        return ;
    }
    
    
    if (isFinished) {
        
        return ;
    }
    
    
    if (totalPage  <=  current) {
        
        
        isFinished = true;
        
        
//        
//        [myTableView.tableFooterView   setHidden:true];
//        myTableView.tableFooterView = nil;
        
        
        return ;
    }
    
    
    if (resolveRequest) {
        
        [resolveRequest   cancel];
        [resolveRequest release];
        resolveRequest = nil;
        
    }
    
    
    
    resolveRequest = [[ASIHTTPRequest alloc]   initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d",linkPreString,current + 1]]];
    
    [resolveRequest startAsynchronous];
    
    
    [resolveRequest setCompletionBlock:^{
        // Use when fetching binary data
        
        NSData *responseData = [resolveRequest responseData];
        
        
        isLoading = false;
        
        totalPage = [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"]   objectForKey:@"totalPages"]  intValue];
        
        current = [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"]   objectForKey:@"nowPage"]  intValue];
        
        if ([[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"status"]  intValue] == 0) {
             
             
            
        }else {
            
            
            
        
        
            if ( ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count]  == 0 ) ||  current >= totalPage     ) {
                
                isFinished = true;
                
                [myTableView.tableFooterView   setHidden:true];
                myTableView.tableFooterView = nil;

                
                
            }
        
        
        if ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            
            [zhiDaoArray addObjectsFromArray:[[[responseData   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]];
            
        }
        
            
            if ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
                
                [zhiDaoArray setArray:[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]];
                
            }else{
                
                
                isFinished = true;
                
                
                [myTableView.tableFooterView   setHidden:true];
                myTableView.tableFooterView = nil;
            }
            
        
        
        
        [myTableView reloadData];
        
        
        current ++;
        
        }
        
        
    }];
    [resolveRequest setFailedBlock:^{
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        isLoading = false;
        
        
    }];
    
    
}



-(void)setSexAndReload:(int)sexArg{
    
  
    
    [self reloadFirst];
    
}

-(void)reloadFirst{
    
    
    isLoading = true;
    
    
    isFinished = false;
    
    
    current  = 1;
    
    
    if (resolveRequest) {
        
        [resolveRequest   cancel];
        [resolveRequest release];
        resolveRequest = nil;
        
    }
    
    
    resolveRequest = [[ASIHTTPRequest alloc]   initWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d",linkPreString,current]]];
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];
    [hud show:true];
    
    [resolveRequest startAsynchronous];
    
    
    [resolveRequest setCompletionBlock:^{
        // Use when fetching binary data 
        
        
        isLoading = false;
        
        
        
        if ([[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"status"]  intValue] == 0) {
            
            
            
            UILabel *tipsUL = [[UILabel alloc]  initWithFrame:self.bounds];
            [tipsUL setText:[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"info"]];
            tipsUL.font = [UIFont systemFontOfSize:18];
            tipsUL.textAlignment = UITextAlignmentCenter;
            myTableView.tableFooterView =tipsUL;
            [tipsUL release];
            
        }else {
            
             
            
            
        
            totalPage = [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"]   objectForKey:@"totalPages"]  intValue];
        
        if ( ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]] && [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count]  == 0 ) ||  current >= totalPage     ) {
            
            isFinished = true;
            
            
            [myTableView.tableFooterView   setHidden:true];
            myTableView.tableFooterView = nil;
            
        }else {
            
            UIView *footerView = [[[UIView alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
            [myTableView setTableFooterView:footerView];
            
            UILabel *ul = [[UILabel alloc]  initWithFrame:CGRectMake(0, 0, 320, 40)];
            ul.text = @"加载中...";
            ul.backgroundColor = [UIColor clearColor];
            ul.textAlignment = UITextAlignmentCenter ;
            [footerView addSubview:ul];
            [ul release];
            
            UIActivityIndicatorView *uaiv = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            uaiv.frame = CGRectMake(95, 5, 30, 30);
            [footerView addSubview:uaiv];
            [uaiv release];
            [uaiv startAnimating];
            
        }
        
        
        if ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            [zhiDaoArray setArray:[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]];
        }else {
            
            
            isFinished = true;
            
            
            [myTableView.tableFooterView   setHidden:true];
            myTableView.tableFooterView = nil;
        }
        
        //  current ++;
        
        }
        
        
        [myTableView reloadData];
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        
        
        
        [hud hide:true afterDelay:.6f];
        
    }];
    [resolveRequest setFailedBlock:^{
        
        [hud hide:true afterDelay:1.f];
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        
        isLoading = false;
        
        
    }];
    
    
}




#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	isLoading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	isLoading = NO;
	[refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:myTableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    [refreshView egoRefreshScrollViewDidScroll:scrollView];
    
    
    if (scrollView.contentOffset.y +scrollView.frame.size.height > scrollView.contentSize.height +5) {
        
        [self performSelector:@selector(loadNewPage)];
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    [self performSelector:@selector(reloadFirst) withObject:nil];
    
    
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return isLoading          ; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  [zhiDaoArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    NSString *type = zhiDaoArray[indexPath.row][@"type"];
    
    NSString *actionDescription = nil ;
    
    
    if ([type isEqualToString:@"post"]) {
        
        actionDescription = @"发表了"; 
        
        
    }else if ([type isEqualToString:@"postimage"]){
        
        actionDescription = @"上传了图片"; 
        
    }else {
        
        
    }
    

    
   RCLabel  *sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(56, 8 , 250, 20)]  autorelease];
     
    RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@" <font size=15 color='#e14278'>%@</font><font size=15 color='#919191'>%@<font>",zhiDaoArray[indexPath.row][@"user_info"][@"uname"],actionDescription] ];
    sendLabel.componentsAndPlainText = componentsDS;
    
    CGSize optimumSize = CGSizeZero ;
    
    optimumSize = [sendLabel optimumSize];
    
    CGRect myframe = sendLabel.frame ;
    myframe.size.height = optimumSize.height;
    sendLabel.frame = myframe ;

    
    UILabel *contentUL = [[[UILabel alloc]   initWithFrame:CGRectMake(60, 34, 250, 40)] autorelease];
    contentUL.numberOfLines = 0 ;
    contentUL.textColor = [UIColor grayColor];
    contentUL.backgroundColor = [UIColor clearColor];
    [contentUL  sizeThatFits:CGSizeMake(260, 3000)]; 
    
    
    contentUL.text = zhiDaoArray[indexPath.row][@"content"];
    contentUL.frame = CGRectMake(60, CGRectGetMaxY(sendLabel.frame) + 10, 250, 40);
    [contentUL  sizeToFit];

    
    if ([type isEqualToString:@"postimage"]){
     
        
        return CGRectGetMaxY(contentUL.frame) +148;
        
    }else {
        
        
        return CGRectGetMaxY(contentUL.frame) +37;
    }
    
    
     
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    XZWQuanIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[XZWQuanIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        
    }
    
 
    [cell setAvatarURLString:zhiDaoArray[indexPath.row][@"user_info"][@"avatar"] name:zhiDaoArray[indexPath.row][@"user_info"][@"uname"] type:zhiDaoArray[indexPath.row][@"type"] postImage: [zhiDaoArray[indexPath.row][@"attach_list"]   count] == 0 ? nil : [NSString stringWithFormat:@"%@data/upload/%@%@", XZWHost,zhiDaoArray[indexPath.row][@"attach_list"][0][@"save_path"],zhiDaoArray[indexPath.row][@"attach_list"][0][@"save_name"]]   date:zhiDaoArray[indexPath.row][@"publish_time"] description:zhiDaoArray[indexPath.row][@"content"]];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
//    if (delegate) {
//        
//        
//        if ([delegate    respondsToSelector:@selector(selectID:)]) {
//            
//            [delegate selectID:[[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"uid"] intValue]];
//            
//            
//        }
//        
//    }
    
    
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
