//
//  XZWMyFeedView.m
//  XZW
//
//  Created by dee on 13-10-14.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWMyFeedView.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>



#define kMBProgessHud 8888

@implementation XZWMyFeedView
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

            /// 提示
		    if ([[messageDic objectForKey:@"status"] intValue] == 0) {
		        UILabel *tipsUL = [[UILabel alloc] initWithFrame:self.bounds];
		        [tipsUL setText:[messageDic objectForKey:@"info"]];
		        tipsUL.font = [UIFont systemFontOfSize:18];
		        tipsUL.textAlignment = UITextAlignmentCenter;
		        myTableView.tableFooterView = tipsUL;
		        [tipsUL release];
			}

        } else {
            
            
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
    
    if (delegate){
        
        
        if ([delegate  respondsToSelector:@selector(clickFeedMessageDic:)]){
            
            [delegate clickFeedMessageDic:myFeedArray[indexPath.row]];
            
        }
        
        
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  [myFeedArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return   64;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.contentView.clipsToBounds = true;
         
        UIImageView *headerUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(13, 13, 40, 40)];
        headerUIV.tag = 334;
        headerUIV.layer.cornerRadius = 6.f;
        headerUIV.layer.masksToBounds = YES;
        headerUIV.layer.borderWidth = 1.f;
        headerUIV.layer.borderColor = [UIColor whiteColor].CGColor;
        [cell.contentView addSubview:headerUIV];
        [headerUIV release];
        
        // name
        UILabel *myLabel = [[UILabel alloc]  initWithFrame:CGRectMake(63,  5, 230, 30)];
        myLabel.tag = 3335;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 1;
        myLabel.font = [UIFont boldSystemFontOfSize:16];
        myLabel.textColor = [XZWUtil xzwRedColor];
        [cell.contentView addSubview:myLabel];
        [myLabel release];
        
        UILabel *contentUL = [[UILabel alloc]  initWithFrame:CGRectMake(63, 30, 250, 30)];
        contentUL.backgroundColor = [UIColor clearColor];
        contentUL.numberOfLines = 1;
        contentUL.tag = 3336;
        contentUL.font = [UIFont boldSystemFontOfSize:14];
        [cell.contentView addSubview:contentUL];
        [contentUL release];
          
        UIImageView *lineUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 63, 320, 1)];
        lineUIV.image = [UIImage imageNamed:@"ys_line"];
        [cell.contentView addSubview:lineUIV];
        [lineUIV release];
        
        
    }
    
    [(UIImageView*)[cell.contentView viewWithTag:334]  setImageWithURL:[NSURL URLWithString: [[myFeedArray  objectAtIndex:indexPath.row] objectForKey:@"avatar"] ]];
    
    [(UILabel*)[cell.contentView viewWithTag:3335]  setText:[[myFeedArray  objectAtIndex:indexPath.row] objectForKey:@"fromUser"]];
    
    [(UILabel*)[cell.contentView viewWithTag:3336]  setText: [NSString stringWithFormat:@"%@   %@", [XZWUtil judgeTimeBySendTime:[NSDate dateWithTimeIntervalSince1970:[[[myFeedArray  objectAtIndex:indexPath.row] objectForKey:@"time"] longLongValue]]] ,[[myFeedArray  objectAtIndex:indexPath.row] objectForKey:@"msg"]]];
    
    return cell;
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
