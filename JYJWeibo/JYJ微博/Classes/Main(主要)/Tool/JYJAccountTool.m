//
//  JYJAccountTool.m
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#define JYJAcountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "JYJAccountTool.h"
#import "JYJAccount.h"

@implementation JYJAccountTool
/**
 *  存储账号信息
 */
+ (void)save:(JYJAccount *)account
{
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:JYJAcountFilepath];
}
/**
 *  读取账号
 */
+ (JYJAccount *)account
{
    JYJAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:JYJAcountFilepath];
    // 判断账号是否已经过期
    NSDate *now = [NSDate date];
    
    if ([now compare:account.expires_time] != NSOrderedAscending) {
        // 过期
        account = nil;
    }
    return account;
}

+ (void)accesTokenWithParam:(JYJAccessTokenParam *)param success:(void (^)(JYJAccount *))success failure:(void (^)(NSError *))failure
{
    [self postWithUrl:@"https://api.weibo.com/oauth2/access_token" param:param resultClass:[JYJAccount class] success:success failure:failure];
}

@end
