//
//  XZWMyFeedView.h
//  XZW
//
//  Created by dee on 13-10-14.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"


@protocol MyFeedViewDelegate <NSObject>


-(void)clickFeedMessageDic:(NSDictionary*)messageDic;

@end

@interface XZWMyFeedView : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    
    
    ASIHTTPRequest *getFeedRequest;
    
    NSMutableArray *myFeedArray;
    
    BOOL isLoading;
    
    BOOL isFinished;
    
    int current;
    
    NSMutableString *linkString;
    
    EGORefreshTableHeaderView *refreshView;
    
    UITableView *myTableView;
    
    int totalPage;
    
    id<MyFeedViewDelegate>       delegate;
}



@property (nonatomic, retain) id<MyFeedViewDelegate>       delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView        *refreshTableView;

- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg;


@end
