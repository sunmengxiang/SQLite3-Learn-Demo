//
//  MJNoteDAO.h
//  SQLite3练习
//
//  Created by 孙梦翔 on 16/8/30.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "MJNotes.h"
@interface MJNoteDAO : NSObject
{
    sqlite3 * db;
}

+ (MJNoteDAO *)sharedManager;

- (NSString *)applicationDocumnetsDirectoryFile;

- (void)creatEditableData;

- (void)creat:(MJNotes *)note;

- (void)remove:(MJNotes *)note;

- (void)modify:(MJNotes *)note;

- (void)findById:(MJNotes *)note;

- (NSMutableArray *)findAll;
@end
