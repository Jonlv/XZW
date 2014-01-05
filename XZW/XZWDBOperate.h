//
//  XZWDBOperate.h
//  XZW
//
//  Created by dee on 13-10-15.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZWDBOperate : NSObject






+(void)initKnowledgeWithKnowID:(int)knowID title:(NSString*)titleString titleDes:(NSString*)descString;


+(NSArray*)getCollectArray;


+(BOOL)checkIfCollect:(NSString *)knowledgeID;



+(void)deleteMessageFromUserID:(NSString *)userID;

+(void)deleteKnowledgeID:(NSString *)knowledgeID;

+(void)deleteMessageID:(NSString *)messageID;


+(int)getMaxIDFromListID:(int)chatID;


+(BOOL)mainInsertDataFrom:(NSDictionary*)tempDic andUserID:(int)userID;

+(void)insertDataFrom:(NSArray*)dataArray andUserID:(int)userID;

+(void)insertDataFrom:(NSArray*)dataArray;
 
+(NSArray*)getChatArrayForChatID:(int)chatID  andBlock: (void (^)(NSArray*array))block;

+(NSArray*)getChatArrayForChatID:(int)chatID  andTime:(long)time andBlock: (void (^)(NSArray*array))block ;

+(void)removeAllRecords;

+(void)initDatabase;

//+(NSArray*)getChatArrayForChatID:(int)chatID ;


+(NSString*)getDreamDBPath;

+(NSDictionary*)getKeyFrom:(NSString*)keyString;


+(NSArray*)getDreamNameFromCat:(NSString*)catString  andBlock: (void (^)(NSArray*array))block;

+(int)getListIDFromUserID:(int)userID;

+(int)getMaxIDFromUserID:(int)userID;

+(NSArray*)getChatArrayForUserID:(int)userID  andTime:(long)time andBlock: (void (^)(NSArray*array))block;

+(NSArray*)getChatArrayForUserID:(int)userID  andBlock: (void (^)(NSArray*array))block;




+(NSArray*)getChatArrayForChatID:(int)chatID andUserID:(int)userID  andTime:(long)time andBlock: (void (^)(NSArray*array))block;

+(NSArray*)getChatArrayForChatID:(int)chatID  andUserID:(int)userID andBlock: (void (^)(NSArray*array))block;


+(NSArray*)getDreamCat;
+(NSArray*)getTenDreamNameFromCat:(NSString*)catString;
+(NSArray*)getDreamNameFromCat:(NSString*)catString;
+(NSDictionary*)getSearchForKey:(NSString*)keyString;

@end
