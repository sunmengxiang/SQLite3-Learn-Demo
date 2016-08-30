//
//  MJNotes.h
//  coreData 练习
//
//  Created by 孙梦翔 on 16/8/30.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJNotes : NSObject<NSCoding>

/** content */
@property (strong ,nonatomic) NSString * content;
/** date */
@property (strong ,nonatomic) NSDate * date;

- (instancetype)initWithDate:(NSDate *)date content:(NSString *)content;
@end
