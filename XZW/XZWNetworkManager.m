//
//  XZWNetworkManager.m
//  XZW
//
//  Created by Dee on 13-8-21.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWNetworkManager.h"

  NSString *  const XZWNetUserAgent = @"Shockwave Flash";

@implementation XZWNetworkManager



+(id)shareInstance{
    
    static dispatch_once_t onceToken;
    static XZWNetworkManager *shareManager;
    
    dispatch_once(&onceToken, ^{
        
        shareManager = [[XZWNetworkManager alloc]  init];
        
    });
    
    
    return shareManager; 
}


+(ASIFormDataRequest*)asiWithLink:(NSString*)linkString postDic:(NSDictionary*)postDic imageData:(NSData*)imageData andImageKey:(NSString*)keyString   completionBlock:(void (^)(void))completionBlock failedBlock:(void (^)(void))failedBlock{

    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:linkString]];
    [request  addRequestHeader:@"User-Agent" value:XZWNetUserAgent];
     
    NSMutableString *cookieString = [NSMutableString string];
    
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        if ([cookie.name   isEqualToString:@"PHPSESSID"]) {
            
            [cookieString   appendFormat: @"%@=%@;",cookie.name,cookie.value];
        }
        
    }
    [request  addData:imageData withFileName:@"111.jpg" andContentType:@"image/jpeg" forKey:keyString  ];
    
    [request  addRequestHeader:@"Cookie" value:cookieString];
    
     
    
    if (postDic) {
        
        for (NSString *tempKey in [postDic  allKeys]) {
            
            [request   setPostValue:[postDic objectForKey:tempKey] forKey:tempKey  ];
        }
        
    }
    
	[request setRequestMethod:@"POST"];
	
	[request startAsynchronous];
    
    [request setCompletionBlock:completionBlock];
    
    [request setFailedBlock:failedBlock];
    
    return request;
    
}


+(ASIFormDataRequest*)asiWithLink:(NSString*)linkString postDic:(NSDictionary*)postDic imageArray:(NSArray*)imageArray  andImageKey:(NSString*)keyString   completionBlock:(void (^)(void))completionBlock failedBlock:(void (^)(void))failedBlock{
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:linkString]];
    [request  addRequestHeader:@"User-Agent" value:XZWNetUserAgent];
    
    NSMutableString *cookieString = [NSMutableString string];
    
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        if ([cookie.name   isEqualToString:@"PHPSESSID"]) {
            
            [cookieString   appendFormat: @"%@=%@;",cookie.name,cookie.value];
        }
        
    }
    
    
    for (int i = 0 ; i < [imageArray count]; i++) {
        
        
        [request  addData: UIImageJPEGRepresentation(imageArray[i], 1)  withFileName:@"111.jpg" andContentType:@"image/jpeg" forKey:keyString  ];
    }
    
    
//    [request buildMultipartFormDataPostBody];
    
//    NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
//	
//	// We don't bother to check if post data contains the boundary, since it's pretty unlikely that it does.
//	CFUUIDRef uuid = CFUUIDCreate(nil);
//	NSString *uuidString = [(NSString*)CFUUIDCreateString(nil, uuid) autorelease];
//	CFRelease(uuid);
//	NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
//    
//    [request addRequestHeader:@"Content-Type" value:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, stringBoundary]];

    
    [request  addRequestHeader:@"Cookie" value:cookieString];
    
    
    
    if (postDic) {
        
        for (NSString *tempKey in [postDic  allKeys]) {
            
            [request   setPostValue:[postDic objectForKey:tempKey] forKey:tempKey  ];
        }
        
    }
    
	[request setRequestMethod:@"POST"];
	
	[request startAsynchronous];
    
    [request setCompletionBlock:completionBlock];
    
    [request setFailedBlock:failedBlock];
    
    return request;
    
}






+(ASIFormDataRequest*)asiWithLink:(NSString*)linkString postDic:(NSDictionary*)postDic completionBlock:(void (^)(void))completionBlock failedBlock:(void (^)(void))failedBlock{

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:linkString]];
    [request  addRequestHeader:@"User-Agent" value:XZWNetUserAgent];
    
    
    NSMutableString *cookieString = [NSMutableString string];
    
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        
        if ([cookie.name   isEqualToString:@"PHPSESSID"]) {
            
            [cookieString   appendFormat: @"%@=%@;",cookie.name,cookie.value];
        }
        
        
        
    } 
    
    [request  addRequestHeader:@"Cookie" value:cookieString];
    
    
   // [request  retain];
    
    if (postDic) {
        
        for (NSString *tempKey in [postDic  allKeys]) {
            
            [request   setPostValue:[postDic objectForKey:tempKey] forKey:tempKey  ];
        }
        
    }
    
    
    
	[request setRequestMethod:@"POST"];
	
	[request startAsynchronous];
    
    [request setCompletionBlock:completionBlock];
    
    [request setFailedBlock:failedBlock];
    
    return request;
}


+(void)cancelRequest:(ASIHTTPRequest*)request{
    
     
//    if (request) {
//        
//        [request cancel];
//        [request clearDelegatesAndCancel];
//    }
    
}


+(void)releaseRequest:(ASIHTTPRequest*)request{
     
//    if (request) {
//        
//        [request release];
//        request = nil;
//    }
    
}


+(void)cancelAndReleaseRequest:(ASIHTTPRequest*)request{
    
//    [XZWNetworkManager cancelRequest:request];
//    [XZWNetworkManager releaseRequest:request];
    
    
}




@end
