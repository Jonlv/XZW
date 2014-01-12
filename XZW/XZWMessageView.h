//
//  XZWMessageView.h
//  XZW
//
//  Created by dee on 13-10-14.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "XZWNetworkManager.h"


@protocol MessageDelegate <NSObject>

-(void)clickMessageIndex:(NSDictionary*)messageDic;
-(void)deleteMessageIndex:(NSDictionary*)messageDic;

@end


@interface XZWMessageView : UIView <UITableViewDataSource, UITableViewDelegate,EGORefreshTableHeaderDelegate> {

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

@property (nonatomic, retain) EGORefreshTableHeaderView* refreshTableView;
@property (nonatomic, assign)  id<MessageDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg;

@end
