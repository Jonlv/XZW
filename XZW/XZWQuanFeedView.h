//
//  XZWQuanFeedView.h
//  XZW
//
//  Created by dee on 13-10-22.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"


@protocol QuanFeedViewDelegate <NSObject>


-(void)clickFeedMessageDic:(NSDictionary*)messageDic;

@end

@interface XZWQuanFeedView : UIView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>{
    
    
    ASIHTTPRequest *getMessageRequest;
    
    NSMutableArray *messageArray;
    
    BOOL isLoading;
    
    BOOL isFinished;
    
    int current;
    
    NSMutableString *linkString;
    
    EGORefreshTableHeaderView *refreshView;
    
    UITableView *myTableView;
    
    int totalPage;
    
}

@property (nonatomic, retain) id<QuanFeedViewDelegate>        delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView        *refreshTableView; 

- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg;

@end
