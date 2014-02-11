//
//  XZWPollingObject.m
//  XZW
//
//  Created by dee on 13-10-30.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWPollingObject.h"

@implementation XZWPollingObject


- (void)getNewUnReadInstanly
{
    if (isDynPolling) {

        [pollingRequest  cancel];
        pollingRequest = nil;

        isDynPolling = false;
    }


    [XZWPollingObject cancelPreviousPerformRequestsWithTarget:self];

    [self getNewUnread];
}

- (void)getNewUnread
{
    if (isDynPolling) {

        return ;
    }


    isDynPolling = true;
    pollingRequest = [XZWNetworkManager asiWithLink:XZWGetNewCount postDic:nil completionBlock:^{


        if ( [[[pollingRequest responseString] objectFromJSONString][@"status"]   intValue] == 1   ) {

            [[NSNotificationCenter defaultCenter] postNotificationName:XZWNewMessageNotification object:[[pollingRequest responseString] objectFromJSONString][@"data"]];

        } else {

        }

        isDynPolling = false;

        [self performSelector:@selector(getNewUnread) withObject:nil afterDelay:[[NSUserDefaults standardUserDefaults] integerForKey:@"XZWNewsInterval"] * 60];

    } failedBlock:^{

        isDynPolling = false;

        [self performSelector:@selector(getNewUnread) withObject:nil afterDelay:[[NSUserDefaults standardUserDefaults] integerForKey:@"XZWNewsInterval"] * 60];
    }];
}

@end
