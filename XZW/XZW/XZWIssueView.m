//
//  XZWIssueView.m
//  XZW
//
//  Created by dee on 13-9-25.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWIssueView.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWStarView.h"


#define kMBProgessHud 8888

@implementation XZWIssueView
@synthesize delegate;


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
            
            NSDictionary* messageDic = [[resolveRequest responseData] objectFromJSONData];
            totalPage = [[[messageDic objectForKey:@"data"] objectForKey:@"totalPages"]  intValue];
            
            current = [[[messageDic objectForKey:@"data"] objectForKey:@"nowPage"] intValue];
            
            [self bringSubviewToFront:mbProgessHud];
            
            
            if ([[[messageDic objectForKey:@"data"] objectForKey:@"data"] count] ==0 || totalPage <= current) {
                
                isFinished = true;
                
                
                [myTableView.tableFooterView   setHidden:true];
                myTableView.tableFooterView = nil;
                
                //    return  ;
                
            }
            
            
            
            [zhiDaoArray setArray:[[messageDic objectForKey:@"data"] objectForKey:@"data"]];
            
            
            refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - myTableView.bounds.size.height, self.frame.size.width, myTableView.bounds.size.height)];
            refreshView.delegate = self;
            [myTableView addSubview:refreshView];
            [refreshView release];
            
            [refreshView refreshLastUpdatedDate];

            /// 提示
		    if ([[messageDic objectForKey:@"status"]  intValue] == 0) {
		        UILabel *tipsUL = [[UILabel alloc] initWithFrame:self.bounds];
		        [tipsUL setText:[messageDic objectForKey:@"info"]];
		        tipsUL.font = [UIFont systemFontOfSize:18];
		        tipsUL.textAlignment = UITextAlignmentCenter;
		        myTableView.tableFooterView = tipsUL;
		        [tipsUL release];
			}

            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:.6f];
            isLoading = false;
            
            
            [mbProgessHud    hide:true afterDelay:.6f];
            
            [myTableView reloadData];
            
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
    
    
    [self stopLoading];
    
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
        
        
        
        [myTableView.tableFooterView   setHidden:true];
        myTableView.tableFooterView = nil;
        
        
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
        
        
        if ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count]  ==0   ) {
            
            isFinished = true;
            
            
            
            [myTableView.tableFooterView   setHidden:true];
            myTableView.tableFooterView = nil;
            
            return  ;
            
        }
        
        
        [zhiDaoArray addObjectsFromArray:[[[responseData   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]];
        
        
        
        
        [myTableView reloadData];
        
        
        current ++;
        
        
        
    }];
    [resolveRequest setFailedBlock:^{
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        isLoading = false;
        
        
    }];
    
    
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
        NSData *responseData = [resolveRequest responseData];
        
        
        isLoading = false;
        
        if ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count]  ==0  || totalPage <= current ) {
            
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
        
        [zhiDaoArray setArray:[[[responseData   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]];
        
        
        //  current ++;
        
        
        
        
        [myTableView reloadData];
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        
        
        
        [hud hide:true afterDelay:1.f];
        
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
    
    return   91;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        
        //  background
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIImageView *ageUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(0, 0, 320, 90)];
        ageUIV.contentMode = UIViewContentModeScaleAspectFill;
        ageUIV.tag =332;
        ageUIV.clipsToBounds = true;
        [cell.contentView addSubview:ageUIV];
        [ageUIV release];
        
        cell.contentView.clipsToBounds = true;
        
        
        
        UIView *grayView = [[UIView alloc]  initWithFrame:CGRectMake(0, 65, 320, 25)];
        grayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
        [cell.contentView addSubview:grayView];
        [grayView release];
        
        
         
        // name
        UILabel *myLabel = [[UILabel alloc]  initWithFrame:CGRectMake(5, 30, 310, 30)];
        myLabel.tag = 3335;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 1;
        myLabel.font = [UIFont boldSystemFontOfSize:23];
        myLabel.shadowColor = [[UIColor blackColor]  colorWithAlphaComponent:.5f];
        myLabel.shadowOffset = CGSizeMake(1, 1);
        myLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:myLabel];
        [myLabel release];
        
        
        
        //
        UIImageView *oddUIV = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"friends1"]];
        oddUIV.center = CGPointMake(200, 78);
        [cell.contentView addSubview:oddUIV];
        [oddUIV release];
        
        
        oddUIV = [[UIImageView alloc]   initWithImage:[UIImage imageNamed:@"clock"]];
        oddUIV.center = CGPointMake(236, 78);
        [cell.contentView addSubview:oddUIV];
        [oddUIV release];
        
         
        //////
        // members
        UILabel *ageUL = [[UILabel alloc]   initWithFrame:CGRectMake(215, 71, 110, 15)];
        ageUL.tag = 3888;
        ageUL.adjustsFontSizeToFitWidth = true;
        ageUL.backgroundColor = [UIColor clearColor];
        ageUL.font = [UIFont systemFontOfSize:12];
        ageUL.textColor = [UIColor whiteColor];
        [cell.contentView  addSubview:ageUL];
        [ageUL release];
        
        
        //////////
        
        // date
        myLabel = [[UILabel alloc]  initWithFrame:CGRectMake(253, 71, 70, 15)];
        myLabel.tag = 3336;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 1;
        myLabel.font = [UIFont systemFontOfSize:12];
        myLabel.textColor = [UIColor whiteColor];
        myLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:myLabel];
        [myLabel release];
        
        
  
         
        
        UIImageView *lineUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 90, 320, 1)];
        // lineUIV.image = [UIImage imageNamed:@"ys_line"];
        lineUIV.backgroundColor = [UIColor blackColor];
        [cell.contentView addSubview:lineUIV];
        [lineUIV release];
         
        
        
    }
    
     
    [(UIImageView*)[cell.contentView viewWithTag:332]  setImageWithURL:[NSURL URLWithString: [XZWHost stringByAppendingFormat:@"data/upload/%@",[[zhiDaoArray  objectAtIndex:indexPath.row] objectForKey:@"cover"]] ]];
    
    [(UILabel*)[cell.contentView viewWithTag:3335]  setText:[[zhiDaoArray  objectAtIndex:indexPath.row] objectForKey:@"title"]];
    [(UILabel*)[cell.contentView viewWithTag:3888]  setText:[[zhiDaoArray  objectAtIndex:indexPath.row] objectForKey:@"commentCount"]];
    [(UILabel*)[cell.contentView viewWithTag:3336]  setText:[[zhiDaoArray  objectAtIndex:indexPath.row] objectForKey:@"effectDate"]]; 
    
      
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
    if (delegate) {
        
        
        if ([delegate    respondsToSelector:@selector(selectIssueDic:)]) {
            
            [delegate selectIssueDic:[zhiDaoArray  objectAtIndex:indexPath.row]];
            
            
        }
        
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
