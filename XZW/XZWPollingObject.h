//
//  XZWPollingObject.h
//  XZW
//
//  Created by dee on 13-10-30.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZWNetworkManager.h"

@interface XZWPollingObject : NSObject{

    BOOL    isDynPolling;
    ASIHTTPRequest  *pollingRequest;
    
}


-(void)getNewUnReadInstanly;

-(void)getNewUnread;

@end
