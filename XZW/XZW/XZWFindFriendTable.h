//
//  XZWFindFriendTable.h
//  XZW
//
//  Created by dee on 13-9-24.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"

@protocol XZWFindFriendTableClickDelegate <NSObject>


@optional

-(void)selectID:(int)userID;

@end


@interface XZWFindFriendTable : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    
    ASIHTTPRequest *resolveRequest;
    
    NSMutableArray *zhiDaoArray;
    
    BOOL isLoading;
    
    BOOL isFinished;
    
    int current;
    
    NSMutableString *linkPreString;
    
    
    EGORefreshTableHeaderView *refreshView;
    
    UITableView *myTableView;
    
    int totalPage;
    
    UIViewController *ref;
    
    int sex;
    
    id<XZWFindFriendTableClickDelegate>  delegate;
}


@property (nonatomic, retain) id    delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView        *refreshTableView;


-(void)setSexAndReload:(int)sexArg;
- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg;

@end

