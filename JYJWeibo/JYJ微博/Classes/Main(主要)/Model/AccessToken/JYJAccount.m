//
//  JYJAccount.m
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJAccount.h"

@implementation JYJAccount

//+ (instancetype)accountWithDict:(NSDictionary *)dict
//{
//    JYJAccount *account = [[self alloc] init];
//    account.access_token = dict[@"access_token"];
//    account.expires_in = dict[@"expires_in"];
//    account.uid = dict[@"uid"];
//    // 确定账号的过期时间：账号创建时间 + 有效期
//    NSDate *now = [NSDate date];
//    account.expires_time = [now dateByAddingTimeInterval:account.expires_in.doubleValue];
//    return account;
//}

- (void)setExpires_in:(NSString *)expires_in
{
    _expires_in =  [expires_in copy];
    
    // 确定帐号的过期时间 ： 帐号创建时间 + 有效期
    NSDate *now = [NSDate date];
    self.expires_time = [now dateByAddingTimeInterval:expires_in.doubleValue];
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.uid = [decoder decodeObjectForKey:@"uid"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.expires_time = [decoder decodeObjectForKey:@"expires_time"];
        self.name = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎么存储
 */
- (void)encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:self.access_token forKey:@"access_token"];
    [enCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [enCoder encodeObject:self.expires_time forKey:@"expires_time"];
    [enCoder encodeObject:self.uid forKey:@"uid"];
    [enCoder encodeObject:self.name forKey:@"name"];
}


@end
