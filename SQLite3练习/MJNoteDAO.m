//
//  MJNoteDAO.m
//  SQLite3练习
//
//  Created by 孙梦翔 on 16/8/30.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJNoteDAO.h"
#import "sqlite3.h"
#import "MJNotes.h"

#define DBFILE_NAME @"NotesList.sqlite3"
@interface MJNoteDAO ()

@end
@implementation MJNoteDAO

static MJNoteDAO * sharedManager = nil;

- (instancetype)init
{
    if (self = [super init])
    {
        [self creatEditableData];
    }
    return self;
}
+ (MJNoteDAO *)sharedManager
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
  
        sharedManager = [[self alloc]init];

    });
    return sharedManager;
}

- (NSString *)applicationDocumnetsDirectoryFile
{
    NSArray * array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * string = [[array firstObject] stringByAppendingPathComponent:DBFILE_NAME];
    
    return string;
}
- (void)creatEditableData
{
    NSString * documentsPath = [self applicationDocumnetsDirectoryFile];
    
    const char * cpath = [documentsPath UTF8String];
    
    if (sqlite3_open(cpath,&db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }
    else
    {
        char * error;
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS MJNotes(cdate TEXT PRIMARY KEY,content TEXT);"];
        
        const char * cSql = [sql UTF8String];
        
        if (sqlite3_exec(db,cSql,NULL,NULL,&error) != SQLITE_OK)
        {
            sqlite3_close(db);
            NSAssert(NO, @"创建数据库失败");
        }
        sqlite3_close(db);
    }
}
- (void)creat:(MJNotes *)note
{
    NSString * filePath = [self applicationDocumnetsDirectoryFile];
    const char * cFilePath = [filePath UTF8String];
    if (sqlite3_open(cFilePath, &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    }
    else
    {
        NSString * sql = @"INSERT OR REPLACE INTO MJNotes(cdate,content) VALUES(?,?)";
        const char * cSql = [sql UTF8String];
        sqlite3_stmt * stament;
//        预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &stament, NULL) == SQLITE_OK)
        {
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSString * strDate = [formatter stringFromDate:note.date];
            const char * cStrDate = [strDate UTF8String];
            
            const char * cStrContent = [note.content UTF8String];
            
//            绑定参数
            sqlite3_bind_text(stament, 1, cStrDate, -1, NULL);
            sqlite3_bind_text(stament, 2, cStrContent, -1, NULL);
            
//            执行插入
            if (sqlite3_step(stament) != SQLITE_DONE)
            {
                NSAssert(NO, @"插入数据失败");
            }
            sqlite3_finalize(stament);
            sqlite3_close(db);
        }
    }
}

- (NSMutableArray *)findAll
{
    NSString * filePath = [self applicationDocumnetsDirectoryFile];
    const char *cFilePath = [filePath UTF8String];
    
    NSMutableArray * array = [NSMutableArray array];
    
    if (sqlite3_open(cFilePath, &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }
    else
    {
        NSString * str = @"SELECT cdate,content FROM MJNotes";
        const char * cStr = [str UTF8String];
        
        sqlite3_stmt * statement;
        if (sqlite3_prepare_v2(db, cStr, -1, &statement, NULL) == SQLITE_OK)
        {
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                char *bufDate = (char *)sqlite3_column_text(statement, 0);
                
                NSString * strDate = [[NSString alloc]initWithUTF8String:bufDate];
                
                NSDate * date = [formatter dateFromString:strDate];
                char *bufContent = (char *)sqlite3_column_text(statement, 1);
                NSString *strContent = [[NSString alloc]initWithUTF8String:bufContent];
                
                
                MJNotes *note = [[MJNotes alloc]initWithDate:date content:strContent];
                
                [array addObject:note];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return array;
}
- (void)modify:(MJNotes *)note
{
    NSString * filePath = [self applicationDocumnetsDirectoryFile];
    const char *cFilePath = [filePath UTF8String];
    
    if (sqlite3_open(cFilePath, &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }
    else
    {
        sqlite3_stmt *statement;
        
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString * strDate = [formatter stringFromDate:note.date];
        const char * cStrDate = [strDate UTF8String];
        
        const char * cStrContent = [note.content UTF8String];
        
//        绑定参数
        sqlite3_bind_text(statement, 0, cStrDate, -1, NULL);
        sqlite3_bind_text(statement, 1, cStrContent, -1, NULL);
//        执行插入
        if (sqlite3_step(statement) != SQLITE_DONE)
        {
            sqlite3_close(db);
            NSAssert(NO, @"打开数据库失败");
        }
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}
- (void)remove:(MJNotes *)note
{
    NSString *filePath = [self applicationDocumnetsDirectoryFile];
    const char* cFilePath = [filePath UTF8String];
    
    if (sqlite3_open(cFilePath, &db) != SQLITE_OK)
    {
        sqlite3_close(db);
        NSAssert(NO, @"打开数据库失败");
    }
    else
    {
        NSString *sql = @"DELETE from MJNotes where cdate =?";
        const char *cSql = [sql UTF8String];
        sqlite3_stmt *statement;
// 预处理过程
        if (sqlite3_prepare_v2(db, cSql, -1, &statement, NULL) == SQLITE_OK)
        {
            NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString * strDate = [formatter stringFromDate:note.date];
            const char * cDate = [strDate UTF8String];
            
            
//            绑定参数
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            
//            执行插入
            if (sqlite3_step(statement) != SQLITE_DONE) {
                sqlite3_close(db);
                NSAssert(NO, @"删除数据失败");
            }
      
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
}
@end
