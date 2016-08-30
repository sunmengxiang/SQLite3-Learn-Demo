//
//  MJNotes.m
//  coreData 练习
//
//  Created by 孙梦翔 on 16/8/30.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "MJNotes.h"

@implementation MJNotes

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_date forKey:@"date"];
    [aCoder encodeObject:_content forKey:@"content"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.date = [aDecoder decodeObjectForKey:@"date"];
    self.content = [aDecoder decodeObjectForKey:@"content"];
    
    return self;
}
- (instancetype)initWithDate:(NSDate *)date content:(NSString *)content
{
    if (self = [super init])
    {
        self.date = date;
        self.content = content;
    }
    return self;
}
@end
