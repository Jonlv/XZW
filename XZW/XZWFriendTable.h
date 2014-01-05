//
//  XZWFriendTable.h
//  XZW
//
//  Created by dee on 13-9-18.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"

@protocol XZWFriendTableClickDelegate <NSObject>


@optional

-(void)selectID:(int)userID;

@end


@interface XZWFriendTable : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    
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
    
    id<XZWFriendTableClickDelegate>  delegate;
}


@property (nonatomic, retain) id    delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView        *refreshTableView;


-(void)reloadFirst;
-(void)setSexAndReload:(int)sexArg;
- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg;

@end
