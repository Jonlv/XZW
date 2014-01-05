//
//  XZWDBOperate.m
//  XZW
//
//  Created by dee on 13-10-15.
//  Copyright (c) 2013年 xingzuowu. All rights reserved.
//

#import "XZWDBOperate.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "XZWUtil.h"


#define MSGTable  @"Msgs"

#define UserTable  @"User"


#define KnowledgeTable  @"Knowledge"

#define DreamTable @"Dream"


@implementation XZWDBOperate


+(NSString*)getDreamDBPath{
    
    
    NSString *dbPath =  [[NSBundle mainBundle]   pathForResource:@"Dream" ofType:@"db"];
     
    
    return dbPath;
}

+(NSDictionary*)getKeyFrom:(NSString*)keyString{
    
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
    FMDatabase *db = [[[FMDatabase alloc]initWithPath:[XZWDBOperate getDreamDBPath]]  autorelease];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT  name,description   FROM %@ where name ='%@'    limit 1 ",DreamTable,keyString];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *content = [rs stringForColumn:@"name"];
            
            [tempDic   setObject:content forKey:@"name"  ];
            [tempDic   setObject:[rs stringForColumn:@"description"] forKey:@"description"  ];
            
        }
        [rs  close];
        [db close];
        
        
    }else {
        
        
        
    }

    return tempDic;
    
}


+(NSDictionary*)getSearchForKey:(NSString*)keyString{
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
    FMDatabase *db = [[[FMDatabase alloc]initWithPath:[XZWDBOperate getDreamDBPath]]  autorelease];
    
    if ([db open]) {
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT  name,description   FROM %@ where name ='%@'    limit 1 ",DreamTable,keyString];
         
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *content = [rs stringForColumn:@"name"];
            
            [tempDic   setObject:content forKey:@"name"  ];
            [tempDic   setObject:[rs stringForColumn:@"description"] forKey:@"description"  ];
            
        }
        [rs  close];
     
        
        
        if (!tempDic [@"name"]) {
            
            sql = [NSString stringWithFormat:
                   @"SELECT  name,description   FROM %@ where  name like'%%%@%%'  limit 1 ",DreamTable,keyString];
            
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                NSString *content = [rs stringForColumn:@"name"];
                
                [tempDic   setObject:content forKey:@"name"  ];
                [tempDic   setObject:[rs stringForColumn:@"description"] forKey:@"description"  ];
                
            }
            [rs  close];
            
            
            
            
            
        }
        
        
        [db close];
        
        
    }else {
        
        
        
    }

    
    return tempDic;
}


+(NSArray*)getDreamCat{
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWDBOperate getDreamDBPath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        
        NSString * sql = [NSString stringWithFormat:
                          @"select distinct(catname) as catename  from %@ group by catname ",DreamTable];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
          
            
            NSString *content = [rs stringForColumn:@"catename"]; 
            
            [tempArray   addObject:content];
            
        }
        
        [rs close];
        [db close];
        
    }];

    
    return tempArray;
    
}


+(NSArray*)getDreamNameFromCat:(NSString*)catString{
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabase *db = [[[FMDatabase alloc]initWithPath:[XZWDBOperate getDreamDBPath]]  autorelease];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT  name   FROM %@ where catname='%@'   ",DreamTable,catString];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            
            NSString *content = [rs stringForColumn:@"name"];
            
            [tempArray   addObject:content];
        }
        [rs  close];
        [db close];
        
        
    }else {
        
        
        
    }
    
    
    return tempArray;
    
}




+(NSArray*)getDreamNameFromCat:(NSString*)catString  andBlock: (void (^)(NSArray*array))block{
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWDBOperate getDreamDBPath]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT  name   FROM %@ where catname ='%@'   ",DreamTable,catString];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            
            NSString *content = [rs stringForColumn:@"name"];
            
            [tempArray   addObject:content];
        }
        [rs  close];
        [db close];
        
        
        
        
    }];
    
    
    
    
    
    block(tempArray);
    
//
//    FMDatabase *db = [[[FMDatabase alloc]initWithPath:[XZWDBOperate getDreamDBPath]]  autorelease];
//    
//    if ([db open]) {
//        NSString * sql = [NSString stringWithFormat:
//                          @"SELECT  name   FROM %@ where catname='%@'   ",DreamTable,catString];
//        
//        
//        FMResultSet * rs = [db executeQuery:sql];
//        while ([rs next]) {
//            
//            NSString *content = [rs stringForColumn:@"name"];
//            
//            [tempArray   addObject:content];
//        }
//        [rs  close];
//        [db close];
//        
//        
//        
//        
//        block(tempArray);
//        
//        
//    }else {
//        
//        
//        
//    }
    
    
    return tempArray;
    
}

 
+(NSArray*)getTenDreamNameFromCat:(NSString*)catString{
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    

    
    FMDatabase *db = [[[FMDatabase alloc]initWithPath:[XZWDBOperate getDreamDBPath]]  autorelease];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT  name   FROM %@ where catname='%@' limit 10 ",DreamTable,catString];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *content = [rs stringForColumn:@"name"];
            
            [tempArray   addObject:content];
        }
        [rs  close];
        [db close];
        
        
    }else {
        
        
        
    }

    
    return tempArray;
    
}



+(void)initDatabase{
          
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        NSString *dbString = nil;
        
        dbString = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID integer  AUTOINCREMENT PRIMARY KEY,name text, year text, month text, day text, hour text, minute text, daylight text, timezone text, longitude text, latitude text, am text, sml text,birthday text,locString text,timezoneString text)",UserTable];
        
        [db executeUpdate:  dbString];
        
        dbString = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id int unique,list_id int, message_id int,from_uid int,content text,mtime text,ids text,idcount int, is_img int,imgpath text ,isSend int, self_id integer  primary key AUTOINCREMENT ,sid int,toid int,type int,status int,me int)",MSGTable ];
        
        [db executeUpdate:  dbString ];
        
        dbString = [NSString stringWithFormat: @"CREATE TABLE IF NOT EXISTS %@(id integer   PRIMARY KEY AUTOINCREMENT,knowledgeID text ,title text,contentDesc text )",KnowledgeTable ];
        
        [db executeUpdate:  dbString ];
        
        
        
    }];
    
}


+(void)initKnowledgeWithKnowID:(int)knowID title:(NSString*)titleString titleDes:(NSString*)descString{
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:[XZWUtil getDataBase]];
 
    BOOL res =[db open];
 
    if (res==NO) {
 
        NSLog(@"open error");
 
        return;
     
    } 
    //执行语句；
     
  
    res=[db executeUpdate: [NSString stringWithFormat:@"insert into %@( knowledgeID , title  , contentDesc ) values('%d','%@','%@')",KnowledgeTable,knowID,titleString,[XZWUtil stringByEscapingXML:descString] ]];
 
    if (res==NO) {
         
        NSLog(@"insert error");
         
    }
     
    [db close];
 }


+(NSArray*)getCollectArray {
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabase *db=[FMDatabase databaseWithPath:[XZWUtil getDataBase]];
    
    BOOL res =[db open];
    
    if (res==NO) {
        
        NSLog(@"open error");
        
        return tempArray;
        
    }
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@  ",KnowledgeTable];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:@"id"]; 
            
            NSString *knowledgeID = [rs stringForColumn:@"knowledgeID"];
            NSString *content = [rs stringForColumn:@"title"];
            NSString *mtime = [rs stringForColumn:@"contentDesc"];
            
            [tempArray   addObject:@{@"id":  [NSNumber numberWithInt:Id],@"art_title":content ,  @"art_description": [XZWUtil stringByUnescapingXML:mtime],@"art_id":knowledgeID }];
            
        }
        
        [rs close];
    
    [db close];
     
    
    
    return tempArray;
    
}




+(void)deleteMessageFromUserID:(NSString *)userID{
    
    FMDatabase *db=[FMDatabase databaseWithPath:[XZWUtil getDataBase]];
    
    BOOL res =[db open];
    
    if (res==NO) {
        
        NSLog(@"open error");
        
        return;
        
    }
    //执行语句；
    
    
    
    res=[db executeUpdate: [NSString stringWithFormat:@"delete  from %@ where from_uid = %@ or toid = %@ ",MSGTable,userID,userID] ];
    
    if (res==NO) {
        
        NSLog(@"delete error");
        
    }
    
    [db close];
    
    
}


+(void)deleteMessageID:(NSString *)messageID{
    
    FMDatabase *db=[FMDatabase databaseWithPath:[XZWUtil getDataBase]];
    
    BOOL res =[db open];
    
    if (res==NO) {
        
        NSLog(@"open error");
        
        return;
        
    }
    //执行语句；
    
    
    
    res=[db executeUpdate: [NSString stringWithFormat:@"delete  from %@ where message_id = %@",MSGTable,messageID] ];
    
    if (res==NO) {
        
        NSLog(@"delete error");
        
    }
    
    [db close];
    
    
}


+(void)deleteKnowledgeID:(NSString *)knowledgeID{
    
    FMDatabase *db=[FMDatabase databaseWithPath:[XZWUtil getDataBase]];
    
    BOOL res =[db open];
    
    if (res==NO) {
        
        NSLog(@"open error");
        
        return;
        
    }
    //执行语句；
    
    
    
    res=[db executeUpdate: [NSString stringWithFormat:@"delete  from %@ where knowledgeID = %@",KnowledgeTable,knowledgeID] ];
    
    if (res==NO) {
        
        NSLog(@"delete error");
        
    }
    
    [db close]; 
    
}


+(BOOL)checkIfCollect:(NSString *)knowledgeID{
    
    FMDatabase *db=[FMDatabase databaseWithPath:[XZWUtil getDataBase]];
    
    BOOL res =[db open];
    
    if (res==NO) {
        
        NSLog(@"open error");
        
        return false;
        
    }
    //执行语句；
    
    
    
    
    int Id = 0;
    
    
    
    FMResultSet * rs = [db executeQuery:[NSString stringWithFormat:@"select count(*) as count from %@ where knowledgeID = %@",KnowledgeTable,knowledgeID]];
    while ([rs next]) {
        
          Id = [rs intForColumn:@"count"];

        
    }
    
    if (res==NO) {
        
        NSLog(@"delete error");
        
    }
    
    [db close];
 
    if (Id > 0) {
        
        return true;
        
    }else {
        
        return false;
    }
    
}







+(void)removeAllRecords{
    
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
      
        [db executeUpdate: [NSString stringWithFormat:@"delete from %@",MSGTable]];
        [db executeUpdate: [NSString stringWithFormat:@"delete from %@",UserTable]];
        
        
    } ];
    
}


// 插入 
+(BOOL)mainInsertDataFrom:(NSDictionary*)tempDic andUserID:(int)userID{
    
    FMDatabase *db=[FMDatabase databaseWithPath:[XZWUtil getDataBase]];
    
    BOOL res =[db open];
    
    if (res==NO) {
        
        NSLog(@"open error");
        
        return false;
        
    }
         
    
    int totalCount = 0 ;
    
     
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT  count(list_id) as count   FROM %@ where message_id=%d   ",MSGTable,[tempDic[@"message_id"]  intValue]];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            
            totalCount = [rs intForColumn:@"count"];
      
        }
        
    
    
    BOOL isInsert = true;
         
    
    
    if (totalCount == 0 ) {
        
        int theUserID = 0 ;
        
        
        if ([tempDic[@"me"] intValue] != 1) {
            
            theUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue];
            
        }else {
            
            theUserID = userID;
            
        }
        
        
        
        int me = tempDic[@"me"]? 1 : 0;
        
        
        NSString *dbString = [NSString stringWithFormat:@"insert into %@ (list_id , message_id , from_uid , content , mtime, me ,toid ) values (%@,%d,%@,'%@','%@', %d ,%d)  ;",MSGTable , tempDic[@"list_id"] ,[tempDic[@"message_id"]  intValue], tempDic[@"from_uid"] , tempDic[@"content"] , tempDic[@"mtime"],me , theUserID ];
        
         
        
        isInsert = [db executeUpdate:dbString];

        
        
    }
    
    
    
             
    
    [rs  close];
    [db close];
    
    return isInsert || totalCount == 0;
}


+(void)insertDataFrom:(NSArray*)dataArray andUserID:(int)userID{
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        for (NSDictionary *tempDic in dataArray) {
            
            int theUserID = 0 ;
            
            
            if ([tempDic[@"me"] intValue] != 1) {
                
                theUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue];
                
            }else {
                
                theUserID = userID;
                
            }
            
            
            
            int me = tempDic[@"me"]? 1 : 0;
            
            NSString *dbString = [NSString stringWithFormat:@"insert into %@ (list_id , message_id , from_uid , content , mtime, me ,toid ) values (%@,%d,%@,'%@','%@', %d ,%d)  ;",MSGTable , tempDic[@"list_id"] ,[tempDic[@"message_id"]  intValue], tempDic[@"from_uid"] , tempDic[@"content"] , tempDic[@"mtime"],me , theUserID  ];
            
            
            [db executeUpdate:dbString];
            
        }
        
    } ];

    
}


+(void)insertDataFrom:(NSArray*)dataArray{
     
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        for (NSDictionary *tempDic in dataArray) {
            
            
            
            
            NSString *dbString = [NSString stringWithFormat:@"insert into %@(list_id , message_id , from_uid , content , mtime, me  ) values (%@,%d,%@,'%@','%@', %d);",MSGTable , tempDic[@"list_id"] ,[tempDic[@"message_id"]  intValue], tempDic[@"from_uid"] , tempDic[@"content"] , tempDic[@"mtime"],[tempDic[@"me"] intValue] ];
            
        
            
            [db executeUpdate:dbString];
            
            
            
        }
         
    } ];

     
}





////////////



+(NSArray*)getChatArrayForChatID:(int)chatID  andTime:(long)time andBlock: (void (^)(NSArray*array))block {
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
         
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM (select *  from  %@ where  list_id = %d and mtime < %ld order by mtime desc limit 20)    order by  mtime asc  ",MSGTable,chatID,time];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:@"list_id"];
            int message_id   = [rs intForColumn:@"message_id"];
            int from_uid = [rs intForColumn:@"from_uid"];
            int me = [rs intForColumn:@"me"];
            
            NSString *content = [rs stringForColumn:@"content"];
            NSString *mtime = [rs stringForColumn:@"mtime"];
            
            [tempArray   addObject:@{@"message_id":  [NSNumber numberWithInt:message_id],@"list_id":[NSNumber numberWithInt:Id] , @"from_uid":[NSNumber numberWithInt:from_uid] ,@"content":content,@"mtime":mtime, @"me":[NSNumber numberWithInt:me]}];
            
        }
        
        [rs close];
        
    }];

    
    block(tempArray);
    
    
    return tempArray;
    
}




+(NSArray*)getChatArrayForChatID:(int)chatID andUserID:(int)userID  andTime:(long)time andBlock: (void (^)(NSArray*array))block {
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM (select *  from  %@ where  ( list_id = %d  or (from_uid = %d and toid = %d ) or (from_uid = %d and toid = %d ))   and mtime < %ld order by mtime desc limit 20)    order by  mtime asc  ",MSGTable,chatID, userID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],userID ,time];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:@"list_id"];
            int message_id   = [rs intForColumn:@"message_id"];
            int from_uid = [rs intForColumn:@"from_uid"];
            int me = [rs intForColumn:@"me"];
            
            NSString *content = [rs stringForColumn:@"content"];
            NSString *mtime = [rs stringForColumn:@"mtime"];
            
            [tempArray   addObject:@{@"message_id":  [NSNumber numberWithInt:message_id],@"list_id":[NSNumber numberWithInt:Id] , @"from_uid":[NSNumber numberWithInt:from_uid] ,@"content":content,@"mtime":mtime, @"me":[NSNumber numberWithInt:me]}];
            
        }
        
        [rs close];
        
    }];
    
    
    block(tempArray);
    
    
    return tempArray;
    
}



 
+(NSArray*)getChatArrayForChatID:(int)chatID  andBlock: (void (^)(NSArray*array))block{
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM (select *  from  %@ where  list_id = %d    order by mtime desc limit 20)    order by  mtime asc  ",MSGTable,chatID];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:@"list_id"];
            int message_id   = [rs intForColumn:@"message_id"];
            int from_uid = [rs intForColumn:@"from_uid"];
            NSString *content = [rs stringForColumn:@"content"];
            NSString *mtime = [rs stringForColumn:@"mtime"];
            int me = [rs intForColumn:@"me"];
            
            [tempArray   addObject:@{@"message_id":  [NSNumber numberWithInt:message_id],@"list_id":[NSNumber numberWithInt:Id] , @"from_uid":[NSNumber numberWithInt:from_uid] ,@"content":content,@"mtime":mtime, @"me":[NSNumber numberWithInt:me]}];
            
            
        }
        
        [rs close];
        [db close];

        
    }];
    
    
    block(tempArray);
    
    
    return tempArray;
}


+(NSArray*)getChatArrayForChatID:(int)chatID  andUserID:(int)userID andBlock: (void (^)(NSArray*array))block{
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM (select *  from  %@ where  list_id = %d  or (from_uid = %d and toid = %d ) or (from_uid = %d and toid = %d )  order by mtime desc limit 20)    order by  mtime asc  ",MSGTable,chatID,userID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],userID];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:@"list_id"];
            int message_id   = [rs intForColumn:@"message_id"];
            int from_uid = [rs intForColumn:@"from_uid"];
            NSString *content = [rs stringForColumn:@"content"];
            NSString *mtime = [rs stringForColumn:@"mtime"];
            int me = [rs intForColumn:@"me"];
            
            [tempArray   addObject:@{@"message_id":  [NSNumber numberWithInt:message_id],@"list_id":[NSNumber numberWithInt:Id] , @"from_uid":[NSNumber numberWithInt:from_uid] ,@"content":content,@"mtime":mtime, @"me":[NSNumber numberWithInt:me]}];
            
            
        }
        
        [rs close];
        [db close];
        
        
    }];
    
    
    block(tempArray);
    
    
    return tempArray;
}

///////////////////////////

/////////////////////////// by uid

+(int)getListIDFromUserID:(int)userID{
    
    __block int listID = -2 ;
    
    
    FMDatabase *db = [[[FMDatabase alloc]initWithPath:[XZWUtil getDataBase]]  autorelease];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                                                @"SELECT list_id  FROM  %@ where   (from_uid = %d and toid = %d ) or (from_uid = %d and toid = %d ) limit 1 ",MSGTable,userID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],userID];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            listID = [rs intForColumn:@"list_id"];
            
        }
        [rs  close];
        [db close];
        
    }else {
        
        
        
    }
    
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
//    
//    [queue inDatabase:^(FMDatabase *db) {
//        
//        NSString * sql = [NSString stringWithFormat:
//                          @"SELECT list_id  FROM  %@ where   (from_uid = %d and toid = %d ) or (from_uid = %d and toid = %d ) limit 1 ",MSGTable,userID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],userID];
//        
//        
//        FMResultSet * rs = [db executeQuery:sql];
//        while ([rs next]) {
//            
//            listID = [rs intForColumn:@"list_id"];
//            
//            
//            
//        }
//        
//        [rs close];
//        
//    }];
//    
    return listID;
}

+(int)getMaxIDFromListID:(int)chatID{
    
    __block int maxID = 0 ;
    
    FMDatabase *db = [[[FMDatabase alloc]initWithPath:[XZWUtil getDataBase]]  autorelease];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT max(message_id) as theMax FROM (select *  from  %@ where  list_id = %d    order by mtime desc limit 20)      ",MSGTable,chatID];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            maxID = [rs intForColumn:@"theMax"];
             
        }
        [rs  close];
        [db close];

        
    }else {
        
        
        
    }
    
    
    
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
//    
//    [queue inDatabase:^(FMDatabase *db) {
//        
//        NSString * sql = [NSString stringWithFormat:
//                          @"SELECT max(message_id) as theMax FROM (select *  from  %@ where  list_id = %d    order by mtime desc limit 20)      ",MSGTable,chatID];
//        
//        
//        FMResultSet * rs = [db executeQuery:sql];
//        while ([rs next]) {
//            maxID = [rs intForColumn:@"theMax"];
//            
//            
//            
//        }
//        
//        
//    }];
    
    return maxID;
}



+(int)getMaxIDFromUserID:(int)userID  {
    
    __block int maxID = 0 ;
    
    
    
    FMDatabase *db = [[[FMDatabase alloc]initWithPath:[XZWUtil getDataBase]]  autorelease];
    
    if ([db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT max(message_id) as theMax FROM (select *  from  %@ where  (from_uid = %d and toid = %d ) or (from_uid = %d and toid = %d ) order by mtime desc limit 20) ",MSGTable,userID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],userID];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            maxID = [rs intForColumn:@"theMax"];
            
        }
        [rs  close];
        [db close];

        
    }else {
        
        
        
    }
    
    
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
//    
//    [queue inDatabase:^(FMDatabase *db) {
//        
//        NSString * sql = [NSString stringWithFormat:
//                          @"SELECT max(message_id) as theMax FROM (select *  from  %@ where  (from_uid = %d and toid = %d ) or (from_uid = %d and toid = %d ) order by mtime desc limit 20) ",MSGTable,userID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],userID];
//        
//        
//        FMResultSet * rs = [db executeQuery:sql];
//        while ([rs next]) {
//            maxID = [rs intForColumn:@"theMax"];
//            
//            
//            
//        }
//        [rs close];
//         
//        
//    }];
    
    
    return maxID;
}



+(NSArray*)getChatArrayForUserID:(int)userID  andTime:(long)time andBlock: (void (^)(NSArray*array))block {
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM (select *  from  %@ where    (from_uid = %d and toid = %d ) or (from_uid = %d and toid = %d )  and mtime < %ld order by mtime desc limit 20)    order by  mtime asc  ",MSGTable,userID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],userID,time];
        
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:@"list_id"];
            int message_id   = [rs intForColumn:@"message_id"];
            int from_uid = [rs intForColumn:@"from_uid"];
            int me = [rs intForColumn:@"me"];
            
            NSString *content = [rs stringForColumn:@"content"];
            NSString *mtime = [rs stringForColumn:@"mtime"];
            
            [tempArray   addObject:@{@"message_id":  [NSNumber numberWithInt:message_id],@"list_id":[NSNumber numberWithInt:Id] , @"from_uid":[NSNumber numberWithInt:from_uid] ,@"content":content,@"mtime":mtime, @"me":[NSNumber numberWithInt:me]}];
            
        }
        
        [rs close];
        
    }];
    
    
    block(tempArray);
    
    
    return tempArray;
    
}

+(NSArray*)getChatArrayForUserID:(int)userID  andBlock: (void (^)(NSArray*array))block{
    
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[XZWUtil getDataBase]];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM (select *  from  %@ where   (from_uid = %d and toid = %d ) or (from_uid = %d and toid = %d )   order by mtime desc limit 20)    order by  mtime asc  ",MSGTable,userID,[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],[[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] intValue],userID];
        
        
        NSLog(@"sql %@",sql);
        
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            int Id = [rs intForColumn:@"list_id"];
            int message_id   = [rs intForColumn:@"message_id"];
            int from_uid = [rs intForColumn:@"from_uid"];
            NSString *content = [rs stringForColumn:@"content"];
            NSString *mtime = [rs stringForColumn:@"mtime"];
            int me = [rs intForColumn:@"me"];
            
            [tempArray   addObject:@{@"message_id":  [NSNumber numberWithInt:message_id],@"list_id":[NSNumber numberWithInt:Id] , @"from_uid":[NSNumber numberWithInt:from_uid] ,@"content":content,@"mtime":mtime, @"me":[NSNumber numberWithInt:me]}];
            
            
        }
        
        [rs close];
        
    }];
    
    
    block(tempArray);
    
    
    return tempArray;
}






/////////////

@end
