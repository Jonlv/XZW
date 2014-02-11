//
//  XZWGiftView.m
//  XZW
//
//  Created by dee on 13-9-29.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWGiftView.h"
#import "XZWGiftCell.h"

@implementation XZWGiftView

- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        zhiDaoArray  = [[NSMutableArray alloc]  init];
        
        
        current = 1;
        
        
        if ([linkStringArg  rangeOfString:@"send"].location != NSNotFound) {
            
            isSendGift = true;
            
        }
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

        
        linkPreString = [[NSMutableString alloc]   initWithFormat:@"%@",linkStringArg];
        
        
        
        resolveRequest = [[ASIHTTPRequest  alloc ]   initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d&psize=20",linkPreString,current]]];
         
        
        [resolveRequest startAsynchronous];
        isLoading = true;
        
        [resolveRequest setCompletionBlock:^{
            
            
            myTableView = [[UITableView alloc]   initWithFrame:self.bounds];
            [self addSubview:myTableView];
            myTableView.backgroundColor = [UIColor clearColor];
            myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            
            
            totalPage = [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"]   objectForKey:@"totalPages"]  intValue];
             
            
            if ([[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count]  ==0 ||  [[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]  count] < 20 ) {
                
                isFinished = true;
                
                
                [myTableView.tableFooterView   setHidden:true];
                myTableView.tableFooterView = nil;
                
            }
            
            
            
            [zhiDaoArray setArray:[[[[resolveRequest responseData]   objectFromJSONData]   objectForKey:@"data"] objectForKey:@"data"]];
            
         
            isLoading = false;
            
           // current ++;
            
            [myTableView reloadData];
            
            ;}];
        
        [resolveRequest setFailedBlock:^{
            
             
            isLoading = false;
            
        }];
        
        

        
    }
    return self;
}


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
    
    
    
    resolveRequest = [[ASIHTTPRequest alloc]   initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&p=%d&psize=20",linkPreString,current + 1]]];
     
    
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
        
         
        isLoading = false;
        
        
    }];
    
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
     
    
    if (scrollView.contentOffset.y +scrollView.frame.size.height > scrollView.contentSize.height +5) {
        
        [self performSelector:@selector(loadNewPage)];
        
    }
    
}




#pragma mark -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return  [zhiDaoArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    RCLabel *sendLabel = [[[RCLabel alloc] initWithFrame:CGRectMake(70, 30 , 230, 20)]  autorelease];
         
    RTLabelComponentsStructure *componentsDS = nil;
    if (isSendGift) {
        
        
        componentsDS =  [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=15 color='#919191'>收到了<font><font size=15 color='#e14278'>%@</font><font size=15 color='#919191'>的礼物<font>",[zhiDaoArray[indexPath.row]  objectForKey:@"fromUser"]] ];
        
    }else {
        
        
        componentsDS =  [RCLabel extractTextStyle: [NSString stringWithFormat:@"<font size=15 color='#919191'>送给了<font><font size=15 color='#e14278'>%@</font><font size=15 color='#919191'><font>",[zhiDaoArray[indexPath.row]  objectForKey:@"toUser"]] ];
    }
    
    
    CGSize optimumSize = CGSizeZero ;
    
    optimumSize = [sendLabel optimumSize];
    
    CGRect myframe = sendLabel.frame ;
    myframe.size.height = optimumSize.height;
    sendLabel.frame = myframe ;
 
    
    return   CGRectGetMaxY(sendLabel.frame) + 30;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    static NSString * MyCustomCellIdentifier = @"mycell";
    XZWGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCustomCellIdentifier];
    if (cell == nil) {
        cell = [[[XZWGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCustomCellIdentifier] autorelease];
        
    }
         
    [cell setDic:zhiDaoArray[indexPath.row] isSend:isSendGift];
    
 
    return cell;
}






-(void)dealloc{
    
    [zhiDaoArray  release];
    [linkPreString release];
    
    [super dealloc];
    
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
