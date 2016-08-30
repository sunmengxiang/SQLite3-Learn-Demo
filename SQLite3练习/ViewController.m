//
//  ViewController.m
//  SQLite3练习
//
//  Created by 孙梦翔 on 16/8/30.
//  Copyright © 2016年 孙梦翔. All rights reserved.
//

#import "ViewController.h"
#import "MJNotes.h"
#import "MJNoteDAO.h"

#define randomYear (arc4random_uniform(100) + 1900)
#define randomMonth (arc4random_uniform(11) + 1)
#define randomDay ( arc4random_uniform(30))
@interface ViewController ()
@property (nonatomic,strong) MJNotes * note1;
@property (nonatomic,strong) MJNotes * note2;
- (IBAction)creatNote;
- (IBAction)removeNote;
- (IBAction)findAll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)checkData
{
    MJNoteDAO * noteDAO = [MJNoteDAO sharedManager];
    
    NSArray * array = [noteDAO findAll];
    
    for (MJNotes * note in array)
    {
        NSLog(@"%@--%@",note.date,note.content);
        
    }
}
- (void)creatData
{
    MJNoteDAO * noteDAO = [MJNoteDAO sharedManager];
    
    MJNotes * note1 = [[MJNotes alloc]init];
    MJNotes * note2 = [[MJNotes alloc]init];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
  
    NSString * string1 = [NSString stringWithFormat:@"%04zd-%02zd-%02zd 10:10:10",randomYear,randomMonth,randomDay];
    NSString * string2 = [NSString stringWithFormat:@"%04zd-%02zd-%02zd 10:10:10",randomYear,randomMonth,randomDay];
    NSDate * date1 = [formatter dateFromString:string1];
    NSDate * date2 = [formatter dateFromString:string2];
    
    note1.date = date1;
    note2.date = date2;
    
    self.note2 = note2;
    self.note1 = note1;
    
    note1.content = @"welcome";
    note2.content = @"hello";
    
    [noteDAO creat:note1];
    [noteDAO creat:note2];
}
- (void)remove:(MJNotes *)note
{
    MJNoteDAO * noteDAO = [MJNoteDAO sharedManager];
    
    [noteDAO remove:note];
}
- (IBAction)creatNote
{
    [self creatData];
    
    [self checkData];
}

- (IBAction)removeNote
{
    
    [self remove:self.note1];
    
    [self checkData];
}

- (IBAction)findAll
{
    [self checkData];
}
@end