//
//  XZWNetworkManager.h
//  XZW
//
//  Created by Dee on 13-8-21.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "Interface.h"
#import "JSONKit.h"

@interface XZWNetworkManager : NSObject





+(id)shareInstance;

+(ASIFormDataRequest*)asiWithLink:(NSString*)linkString postDic:(NSDictionary*)postDic imageArray:(NSArray*)imageArray  andImageKey:(NSString*)keyString   completionBlock:(void (^)(void))completionBlock failedBlock:(void (^)(void))failedBlock;

+(ASIFormDataRequest*)asiWithLink:(NSString*)linkString postDic:(NSDictionary*)postDic imageData:(NSData*)imageData andImageKey:(NSString*)keyString   completionBlock:(void (^)(void))completionBlock failedBlock:(void (^)(void))failedBlock;

+(ASIFormDataRequest*)asiWithLink:(NSString*)linkString postDic:(NSDictionary*)postDic completionBlock:(void (^)(void))completionBlock failedBlock:(void (^)(void))failedBlock;

+(void)cancelRequest:(ASIHTTPRequest*)request;

+(void)cancelAndReleaseRequest:(ASIHTTPRequest*)request;

@end
