//
//  XZWMyFriendFeedView.m
//  XZW
//
//  Created by dee on 13-10-22.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMyFriendFeedView.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "XZWQuanIssueCell.h"
#import "XZWSendPicCell.h"


#define kMBProgessHud 8888

@implementation XZWMyFriendFeedView
@synthesize delegate;
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
        
        myFeedArray = [[NSMutableArray alloc]  init];
        
        current = 1;
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
        
        
        linkString = [[NSMutableString alloc]   initWithFormat:@"%@",linkStringArg];
        
        myTableView = [[UITableView alloc]   initWithFrame:self.bounds];
        [self addSubview:myTableView];
        myTableView.backgroundColor = [UIColor clearColor];
        myTableView.separatorStyle  = UITableViewCellSelectionStyleNone;
        myTableView.delegate = self;
        myTableView.dataSource = self;
        [myTableView release];
        
        
        MBProgressHUD *mbProgessHud = [[MBProgressHUD alloc]  initWithView:self];
        mbProgessHud.tag = kMBProgessHud;
        mbProgessHud.labelText = @"加载中...";
        [self addSubview:mbProgessHud];
        [mbProgessHud release];
        
        
        
        refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - myTableView.bounds.size.height, self.frame.size.width, myTableView.bounds.size.height)];
        refreshView.delegate = self;
        [myTableView addSubview:refreshView];
        [refreshView release];
        
        [refreshView refreshLastUpdatedDate];
        
        [self loadMessageIsFirst:true];
        
    }
    
    return self;
}


-(void)loadMessageIsFirst:(BOOL)isFirst{
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];
    
    if (isFirst) {
        
        
        isLoading = true;
        
        
        isFinished = false;
        
        
        current  = 1;
        
        
        if (getFeedRequest) {
            
            [getFeedRequest   cancel];
            [getFeedRequest release];
            getFeedRequest = nil;
            
        }
        
        
        getFeedRequest = [[ASIHTTPRequest alloc]  initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d",linkString,current]] ];
        
        
        [hud show:true];
        
        
    }else {
        
        
        
        
        if (isLoading) {
            
            
            return ;
        }
        
        
        if (isFinished) {
            
            return ;
        }
        
        
        if (totalPage  <=  current) {
            
            
            isFinished = true;
            
            [myTableView.tableFooterView   setHidden:true];
            myTableView.tableFooterView = nil;
            
            
            return ;
        }
        
        
        getFeedRequest = [[ASIHTTPRequest alloc]  initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d",linkString,current + 1]] ];
        
        
    }
    
    
    [getFeedRequest startAsynchronous];
    
    
    [getFeedRequest setCompletionBlock:^{
        
        
        isLoading = false;
        
        NSDictionary *messageDic = [[getFeedRequest responseData]   objectFromJSONData];
        
        if ([messageDic[@"status"]  intValue] == 0 ) {
            
            
            
        }else {
            
            
            totalPage = [messageDic[@"data"][@"totalPages"] intValue];
            
            current = [messageDic[@"data"][@"nowPage"] intValue];
            
            
            if ([[[messageDic   objectForKey:@"data"] objectForKey:@"data"]  count]  == 0  ||  current >= totalPage  ) {
                
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
            
            
            if (isFirst) {
                
                [myFeedArray setArray:messageDic[@"data"][@"data"]];
                
                
            }else
            {
                
                [myFeedArray addObjectsFromArray:messageDic[@"data"][@"data"]];
                
            }
            
            
            
            
            
            
            [myTableView reloadData];
            
        }
        
        
        
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        
        [hud hide:true afterDelay:1.f];
        
        
    }];
    
    [getFeedRequest setFailedBlock:^{
        
        
        
        isLoading = false;
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        
        [hud hide:true afterDelay:1.f];
        
        
    }];
    
    
}


-(void)stopLoading{
    
    if (getFeedRequest) {
        [getFeedRequest   cancel];
        [getFeedRequest release];
        getFeedRequest = nil;
        
    }
    
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
        
        [self loadMessageIsFirst:false];
        
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [refreshView egoRefreshScrollViewDidEndDragging:scrollView];
    
    
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    [self loadMessageIsFirst:true];
    
    //	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return isLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}



#pragma mark -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(delegate){
        
        
        if ([delegate   respondsToSelector:@selector(clickMyFriendFeedIndex:)]){
        
            [delegate   clickMyFriendFeedIndex:myFeedArray[indexPath.row]];
            
        }
        
        
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  [myFeedArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     
    
    int type = [myFeedArray[indexPath.row][@"big_type"]   intValue];
    
    switch (type){
            
        case 3:{
            
            RCLabel *sendLabel;
            sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(56, 8 , 250, 20)]  autorelease];
            
            
            sendLabel.frame = CGRectMake(56, 8 , 250, 20);

            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@" <font size=15 color='#e14278'>%@</font><font size=13 color='#919191'> %@<font>",myFeedArray[indexPath.row][@"uname"],myFeedArray[indexPath.row][@"act_text"]] ];
            sendLabel.componentsAndPlainText = componentsDS;
            
            CGSize optimumSize = CGSizeZero ;
            
            optimumSize = [sendLabel optimumSize];
            
            CGRect myframe = sendLabel.frame ;
            myframe.size.height = optimumSize.height;
            sendLabel.frame = myframe ;

    
    
            return  CGRectGetMaxY(sendLabel.frame) + 89;
            
        }
            break ;
     
            
            default:
            
        {
            
            
            ///
            
            NSDictionary*contentDic = myFeedArray[indexPath.row];
            
            
            
            
            RCLabel *sendLabel;
            sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(56, 8 , 250, 20)]  autorelease];
            
            
            sendLabel.frame = CGRectMake(56, 8 , 250, 20);
            
            RTLabelComponentsStructure *componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@" <font size=15 color='#e14278'>%@</font><font size=13 color='#919191'> %@<font>",contentDic[@"uname"],contentDic[@"act_text"]] ];
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
            
            contentUL.text = contentDic[@"content"];
            contentUL.frame = CGRectMake(60, CGRectGetMaxY(sendLabel.frame) + 10, 250, 40);
            [contentUL  sizeToFit];
            
            
            
            RCLabel *fromUL = [[[RCLabel alloc] initWithFrame:CGRectMake(56, 38 , 250, 20)]  autorelease];
            
            fromUL.frame = CGRectMake(56, CGRectGetMaxY(contentUL.frame) + 10 , 250, 20);
            
            
            
            if (type == 1){
                
                
                componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#919191'>来自<font> <font size=13 color='#e14278'>%@</font>",contentDic[@"group_name"]] ];
            }else {
                
                
                componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#919191'>来自<font> <font size=13 color='#e14278'>%@</font>",contentDic[@"discuss_name"]] ];
            }
            
            fromUL.componentsAndPlainText = componentsDS;
            
            optimumSize = [fromUL optimumSize];
            
            myframe = fromUL.frame ;
            myframe.size.height = optimumSize.height;
            fromUL.frame = myframe ;
            
            
            return   CGRectGetMaxY(contentUL.frame) + 10 + 14 +5;
            
        }
            
            break;
            
    }
    
    
    
    return   64;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     

    
    
    int type = [myFeedArray[indexPath.row][@"big_type"]   intValue];
    
    switch (type){
        
            case 1:
            
        {
            static NSString * MyCustomCellIdentifier = @"myCell";
            XZWQuanIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
            if (cell == nil) {
                cell = [[[XZWQuanIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 
            }
            
            [cell  setContentDic:myFeedArray[indexPath.row]];
            
            return cell ;
            
        }
            
            break;
            
            case 2:
        {
            static NSString * MyCustomCellIdentifier = @"myCell";
            XZWQuanIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
            if (cell == nil) {
                cell = [[[XZWQuanIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 
            }
            
            [cell  setContentDic4Feed:myFeedArray[indexPath.row]];

            return cell ;
            
        }
            
            break;
            
            default:
            
            
        {
            static NSString * MyCustomCellIdentifier = @"picCell";
            XZWSendPicCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
            if (cell == nil) {
                cell = [[[XZWSendPicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                
            }
            
            [cell  setContentDic:myFeedArray[indexPath.row]];
            
            return cell ;
            
        }
            
            break;
    }
    
    
    
      
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
