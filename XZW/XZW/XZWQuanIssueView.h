//
//  XZWQuanIssueView.h
//  XZW
//
//  Created by dee on 13-10-22.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "XZWUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XZWNetworkManager.h"
#import "XZWTopContentCell.h"
#import "RCLabel.h"
#import "XZWButton.h"
#import "MBProgressHUD.h"
#import "EGORefreshTableHeaderView.h"
#import "XZWQuanIssueTopCell.h"


@protocol XZWQuanIssueViewDelegate <NSObject>


-(void)click:(NSArray*)indexArray;
 


@end


@interface XZWQuanIssueView : UIView<UITableViewDelegate,UITableViewDataSource,XZWQuanIssueTopCellDelegate,EGORefreshTableHeaderDelegate>{
    
    
    
    int quanID;
    
    UITableView *issueUTV;
    
    NSMutableArray *commentArray;
    
    NSMutableArray *additionalArray;
    
    ASIHTTPRequest *commentRequest;
    
    ASIHTTPRequest *joinRequest;
    
    ASIHTTPRequest *replyRequest;
    
    ASIHTTPRequest *likeRequest;
    
    
    
    BOOL isLoading;
    
    BOOL isFinished;
    
    int current;
    
    int totalPage;
    
    
    UITextView *commendUTV;
    
    
    UIView *replyView;
    
    UITextField *replyUTF;
    
    
    int postID,toID;
    
    int postIndex;

    UITapGestureRecognizer *tap;
    
    
    EGORefreshTableHeaderView *refreshView;
    
    
}


@property (nonatomic,assign) id<XZWQuanIssueViewDelegate> delegate;
@property (nonatomic, retain) EGORefreshTableHeaderView        *refreshTableView;

- (id)initWithFrame:(CGRect)frame andQuanID:(int)theQuanID;
- (void)loadFirst;

@end
