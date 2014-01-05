//
//  XZWGiftView.h
//  XZW
//
//  Created by dee on 13-9-29.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZWNetworkManager.h"

@interface XZWGiftView : UIView<UITableViewDataSource,UITableViewDelegate>{
    
    
    ASIHTTPRequest *resolveRequest;
    
    NSMutableArray *zhiDaoArray;
    
    BOOL isLoading;
    
    BOOL isFinished;
    
    int current;
    
    NSMutableString *linkPreString;
    
    
    BOOL isSendGift;
    
    UITableView *myTableView;
    
    int totalPage;
    
   
    
}


- (id)initWithFrame:(CGRect)frame andLinkString:(NSString*)linkStringArg;

@end
