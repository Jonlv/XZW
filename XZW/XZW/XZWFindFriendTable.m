//
//  XZWFindFriendTable.m
//  XZW
//
//  Created by dee on 13-9-24.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWFindFriendTable.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import "XZWZodiacData.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#import "MBProgressHUD.h"


#define kMBProgessHud 8888

@implementation XZWFindFriendTable
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
        
        
        resolveRequest = [[ASIHTTPRequest  alloc ]   initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d&ssex=%d",linkPreString,current,sex]]];
        
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
            ul.textAlignment = UITextAlignmentCenter ;
            [footerView addSubview:ul];
            [ul release];
            
            UIActivityIndicatorView *uaiv = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            uaiv.frame = CGRectMake(95, 5, 30, 30);
            [footerView addSubview:uaiv];
            [uaiv release];
            [uaiv startAnimating];
            
            
            totalPage = [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"]   objectForKey:@"totalPages"]  intValue];
            
            [self bringSubviewToFront:mbProgessHud];
            
            
            if ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count]  ==0 ||  [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count] < 20 ) {
                
                isFinished = true;
                
                
                [myTableView.tableFooterView   setHidden:true];
                myTableView.tableFooterView = nil;
                
                //    return  ;
                
            }
            
            
            
            [zhiDaoArray setArray:[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]];
            
            
            refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - myTableView.bounds.size.height, self.frame.size.width, myTableView.bounds.size.height)];
            refreshView.delegate = self;
            [myTableView addSubview:refreshView];
            [refreshView release];
            
            [refreshView refreshLastUpdatedDate];
            
            
            
            [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
            isLoading = false;
            
            
            [mbProgessHud    hide:true afterDelay:1.f];
            
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
    
    
    
    resolveRequest = [[ASIHTTPRequest alloc]   initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d&ssex=%d",linkPreString,current + 1,sex]]];
    
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



-(void)setSexAndReload:(int)sexArg{
    
    sex = sexArg ;
    
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
    
    
    resolveRequest = [[ASIHTTPRequest alloc]   initWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d&ssex=%d",linkPreString,current,sex]]];
    
    
    MBProgressHUD *hud =  (MBProgressHUD *) [self viewWithTag:kMBProgessHud];
    [hud show:true];
    
    [resolveRequest startAsynchronous];
    
    
    [resolveRequest setCompletionBlock:^{
        // Use when fetching binary data
        NSData *responseData = [resolveRequest responseData];
        
        
        isLoading = false;
        
        if ([[responseData objectFromJSONData]  count]  ==0 ||  [[responseData objectFromJSONData]  count] < 15 ) {
            
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
    
    return   88;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
        
        // name
        UILabel *myLabel = [[UILabel alloc]  initWithFrame:CGRectMake(95, 3, 230, 30)];
        myLabel.tag = 3335;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 1;
        myLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:myLabel];
        [myLabel release];
        
        
        
        //♂  ♀
        
        
        UIImageView *ageUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(90, 37, 81, 20)];
        ageUIV.image = [UIImage imageNamed:@"const"];
        [cell.contentView addSubview:ageUIV];
        [ageUIV release];
        
        
        
        
        UILabel *ageUL = [[UILabel alloc]   initWithFrame:ageUIV.bounds];
        ageUL.tag = 3888;
        ageUL.adjustsFontSizeToFitWidth = true;
        ageUL.backgroundColor = [UIColor clearColor];
        ageUL.textColor = [UIColor whiteColor];
        [ageUIV  addSubview:ageUL];
        [ageUL release];
        
        
        //////////
        
        // me distance
        myLabel = [[UILabel alloc]  initWithFrame:CGRectMake(182, 8, 70, 20)];
        myLabel.tag = 3336;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.numberOfLines = 1;
        myLabel.font = [UIFont systemFontOfSize:14];
        myLabel.textColor = [UIColor grayColor];
        myLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:myLabel];
        [myLabel release];
        
        
        //description
        myLabel = [[UILabel alloc]  initWithFrame:CGRectMake(95, 62, 230, 20)];
        myLabel.tag = 3334;
        myLabel.backgroundColor = [UIColor clearColor];
        myLabel.textColor = [UIColor grayColor];
        myLabel.font = [UIFont systemFontOfSize:12];
        myLabel.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:myLabel];
        [myLabel release];
        
        
        
        UIImageView *selectUIV = [[UIImageView alloc]   initWithFrame:CGRectMake(12, 6, 70, 70)];
        selectUIV.tag =3337;
        selectUIV.layer.cornerRadius = 3;
        [cell.contentView addSubview:selectUIV];
        [selectUIV release];
        
        
        
        UIImageView *lineUIV = [[UIImageView alloc]  initWithFrame:CGRectMake(0, 87, 320, 1)];
        lineUIV.image = [UIImage imageNamed:@"ys_line"];
        [cell.contentView addSubview:lineUIV];
        [lineUIV release];
        
        
    }
    
    [(UILabel*)[cell.contentView viewWithTag:3335]  setText:[[zhiDaoArray  objectAtIndex:indexPath.row] objectForKey:@"uname"]];
    [(UILabel*)[cell.contentView viewWithTag:3334]  setText:[[zhiDaoArray  objectAtIndex:indexPath.row] objectForKey:@"intro"]];
    
    
    [(UIImageView*)[cell.contentView viewWithTag:3337]  setImageWithURL:[NSURL URLWithString:[[zhiDaoArray  objectAtIndex:indexPath.row] objectForKey:@"avatar"]]];
    
    NSMutableString *ageString = [NSMutableString string];
    
    if ([[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"sex"]  intValue] ==1  ) {
        
        [ageString  appendFormat:@"♂ %@ %@",[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"age"],[[XZWZodiacData getSignArray]  objectAtIndex:  [[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"constellation"] intValue]]];
        
    }else {
        
        
        [ageString  appendFormat:@"♀ %@ %@",[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"age"],[[XZWZodiacData getSignArray]  objectAtIndex:  [[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"constellation"] intValue]]];
    }
    
    
    [(UILabel*)[cell.contentView viewWithTag:3888]  setText:ageString];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
    if (delegate) {
        
        
        if ([delegate    respondsToSelector:@selector(selectID:)]) {
            
            [delegate selectID:[[[zhiDaoArray  objectAtIndex:indexPath.row]  objectForKey:@"uid"] intValue]];
            
            
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
