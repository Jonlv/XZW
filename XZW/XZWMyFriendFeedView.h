//
//  XZWMyFriendFeedView.h
//  XZW
//
//  Created by dee on 13-10-22.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"



@protocol MyFriendFeedViewDelegate <NSObject>


-(void)clickMyFriendFeedIndex:(NSDictionary*)messageDic;

@end


@interface XZWMyFriendFeedView : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    
    
    ASIHTTPRequest *getFeedRequest;
    
    NSMutableArray *myFeedArray;
    
    BOOL isLoading;
    
    BOOL isFinished;
    
    int current;
    
    NSMutableString *linkString;
    
    EGORefreshTableHeaderView *refreshView;
    
    UITableView *myTableView;
    
    int totalPage;
    
    id   delegate;
}



@property (nonatomic, retain) id<MyFriendFeedViewDelegate>        delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView        *refreshTableView;

- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg;

@end
