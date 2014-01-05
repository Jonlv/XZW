//
//  XZWQuanList.h
//  XZW
//
//  Created by dee on 13-9-24.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"

@protocol XZWQuanTableClickDelegate <NSObject>


@optional

-(void)selectQuanID:(int)quanID;

@end


@interface XZWQuanList : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    
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
     
    
    id<XZWQuanTableClickDelegate>  delegate;
    
    
}



@property (nonatomic, retain) id    delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView        *refreshTableView;

-(void)reloadFirst;
- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg;

@end
