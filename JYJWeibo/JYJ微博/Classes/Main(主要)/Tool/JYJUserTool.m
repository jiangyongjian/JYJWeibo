//
//  JYJUserTool.m
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJUserTool.h"
#import "MJExtension.h"
#import "JYJHttpTool.h"

@implementation JYJUserTool
+ (void)userInfoWithParam:(JYJUserInfoParam *)param success:(void (^)(JYJUserInfoResult *))success failure:(void (^)(NSError *))failure
{
    [self getWithUrl:@"https://api.weibo.com/2/users/show.json" param:param resultClass:[JYJUserInfoResult class] success:success failure:failure];


}

+ (void)unreadCountWithParam:(JYJUnreadCountParam *)param success:(void (^)(JYJUnreadCountResult *))success failure:(void (^)(NSError *))failure
{
    [self getWithUrl:@"https://rm.api.weibo.com/2/remind/unread_count.json" param:param resultClass:[JYJUnreadCountResult class] success:success failure:failure];
}
@end
