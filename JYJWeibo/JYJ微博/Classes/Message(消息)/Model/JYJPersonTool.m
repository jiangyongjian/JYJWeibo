//
//  JYJPersonTool.m
//  模糊查询
//
//  Created by JYJ on 15/3/31.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import "JYJPersonTool.h"
#import <sqlite3.h>
#import "JYJPerson.h"

@implementation JYJPersonTool

static sqlite3 *_db;

+ (void)initialize
{
    // 获取数据库文件的路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filename = [doc stringByAppendingPathComponent:@"persons.sqlite"];
    const char *cfilename = filename.UTF8String;
    // 1.打开数据库（如果数据库文件不存在，sqlite3——open函数会自动创建数据库文件）
    int result = sqlite3_open(cfilename, &_db);
    if (result == SQLITE_OK) { // 打开成功
        NSLog(@"成功打开数据库");
        
        // 创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_person (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, age integer NOT NULL);";
        char *erroMsg = NULL;
        result = sqlite3_exec(_db, sql, NULL, NULL, &erroMsg);
        if (result == SQLITE_OK) {
            NSLog(@"成功创表");
        }else{
            NSLog(@"创表失败 --%s--%@--%d", erroMsg, [NSString stringWithUTF8String:__FILE__], __LINE__);
        }
    }else{
        NSLog(@"打开数据库失败");
    }


}
+ (void)save:(JYJPerson *)person
{
    // 1.拼接SQL语句
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_person (name, age) VALUES ('%@', %d);", person.name, person.age];
    // 执行 sql语句
    char *erroMsg = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &erroMsg);
    if (erroMsg) {
        NSLog(@"插入数据失败--%s", erroMsg);
    }else{
        NSLog(@"成功插入数据");
    }
}
+ (NSArray *)query
{
    return [self queryWithCondition:@""];
}
// condition : 查询条件，“西”
+ (NSArray *)queryWithCondition:(NSString *)condition
{
    // 存放所有的联系人
    NSMutableArray *persons = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT id, name, age FROM t_person WHERE name like '%%%@%%' ORDER BY age ASC;", condition];
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(_db, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) { // SQL语句没有问题
        NSLog(@"查询语句没有问题");
        
        // 创建数组
        persons = [NSMutableArray array];
        
        // 每调一次sqlite3_step函数，stmt就会指向下一条记录
        while (sqlite3_step(stmt) == SQLITE_ROW) { // 找到一条记录
            // 取出数据
            
            // 取出第0列字段的值（int类型的值）
            int ID = sqlite3_column_int(stmt, 0);
            
            // 取出第1列字段的值（tex类型的值）
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            
            // 取出第2列字段的值（int类型的值）
            int age = sqlite3_column_int(stmt, 2);
            
            // 创建HMPerson对象
            JYJPerson *p = [[JYJPerson alloc] init];
            p.ID = ID;
            p.name = [NSString stringWithUTF8String:(const char *)name];
            p.age = age;
            [persons addObject:p];
        }
    } else {
        NSLog(@"查询语句有问题");
    }
    return persons;
}

@end
