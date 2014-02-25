//
//  XZWQuanFeedView.m
//  XZW
//
//  Created by dee on 13-10-22.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWQuanFeedView.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"
#import "XZWUtil.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWQuanIssueCell.h"

#define kMBProgessHud 8888

@implementation XZWQuanFeedView
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
        
        messageArray = [[NSMutableArray alloc]  init];
        
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
        
        
        if (getMessageRequest) {
            
            [getMessageRequest   cancel];
            [getMessageRequest release];
            getMessageRequest = nil;
            
        }
        
        
        getMessageRequest = [[ASIHTTPRequest alloc]  initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d",linkString,current]] ];
        
        
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
        
        
        getMessageRequest = [[ASIHTTPRequest alloc]  initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d",linkString,current + 1]] ];
        
        
    }
    
    
    [getMessageRequest startAsynchronous];
    
    
    [getMessageRequest setCompletionBlock:^{
        
        
        isLoading = false;
        
        NSDictionary *messageDic = [[getMessageRequest responseData]   objectFromJSONData];
        
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
                
                [messageArray setArray:messageDic[@"data"][@"data"]];
                
                
            }else
            {
                
                [messageArray addObjectsFromArray:messageDic[@"data"][@"data"]];
                
            }
            
            
            
            
            
            
            [myTableView reloadData];
            
        }
        
        
        
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        
        [hud hide:true afterDelay:.6f];
        
        
    }];
    
    [getMessageRequest setFailedBlock:^{
        
        
        
        isLoading = false;
        
        
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.f];
        
        [hud hide:true afterDelay:1.f];
        
        
    }];
    
    
}


-(void)stopLoading{
    
    if (getMessageRequest) {
        [getMessageRequest   cancel];
        [getMessageRequest release];
        getMessageRequest = nil;
        
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  [messageArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ///
    
    NSDictionary*contentDic = messageArray[indexPath.row];
    
    
    
    
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
    
    componentsDS = [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=13 color='#919191'>来自<font> <font size=13 color='#e14278'>%@</font>",contentDic[@"act_text"]] ];
    fromUL.componentsAndPlainText = componentsDS;
    
    optimumSize = [fromUL optimumSize];
    
    myframe = fromUL.frame ;
    myframe.size.height = optimumSize.height;
    fromUL.frame = myframe ;
    
    
    return   CGRectGetMaxY(contentUL.frame) + 10 + 14 +5;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    XZWQuanIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[XZWQuanIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.contentView.clipsToBounds = true;
        
        
        
    }
    
    [cell setContentDic:messageArray[indexPath.row]];
    
//    [(UIImageView*)[cell.contentView viewWithTag:334]  setImageWithURL:[NSURL URLWithString: [[messageArray  objectAtIndex:indexPath.row] objectForKey:@"avatar"] ]];
//    
//    [(UILabel*)[cell.contentView viewWithTag:3335]  setText:[[messageArray  objectAtIndex:indexPath.row] objectForKey:@"uname"]];
//    
//    [(UILabel*)[cell.contentView viewWithTag:3336]  setText:[[messageArray  objectAtIndex:indexPath.row] objectForKey:@"last_message"]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([delegate  respondsToSelector:@selector(clickFeedMessageDic:)]){
        [delegate clickFeedMessageDic:messageArray[indexPath.row]];
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
