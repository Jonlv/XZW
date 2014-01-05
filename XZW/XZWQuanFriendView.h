//
//  XZWQuanFriendView.h
//  XZW
//
//  Created by dee on 13-10-21.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"

@protocol XZWQuanTableClickDelegate <NSObject>


@optional


-(void)acceptDic:(NSDictionary*)acceptDic;

-(void)deline:(NSDictionary*)delineDic;

-(void)selectID:(int)userID;

-(void)setNewCount:(int)count;

@end

@interface XZWQuanFriendView : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    
    ASIHTTPRequest *resolveRequest;
    
    
    int pending;
    
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
    
    int quanID;
    
    id<XZWQuanTableClickDelegate>  delegate;
    
    NSMutableArray *acceptIDArray;
}


@property (nonatomic, retain) id    delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView        *refreshTableView;



-(void)acceptFinish:(int)accepID;
-(void)acceptFail:(NSString*)info;
-(void)delineFinish:(int)delineID;
-(void)delineFail:(NSString*)info;



-(void)reloadFirst;
-(void)setSexAndReload:(int)sexArg;
- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg andQuanID:(int)myQuanID;


@end
