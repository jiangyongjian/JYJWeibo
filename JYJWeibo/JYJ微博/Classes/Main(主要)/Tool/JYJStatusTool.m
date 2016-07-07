//
//  JYJStatusTool.m
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusTool.h"
#import "JYJHttpTool.h"
#import "MJExtension.h"

@implementation JYJStatusTool
+ (void)homeStatusesWithParam:(JYJHomeStatusesParam *)param success:(void (^)(JYJHomeStatusesResult *))success failure:(void (^)(NSError *))failure
{

    [self getWithUrl:@"https://api.weibo.com/2/statuses/home_timeline.json" param:param resultClass:[JYJHomeStatusesResult class] success:success failure:failure];
//    [JYJHttpTool get:@"https://api.weibo.com/2/statuses/home_timeline.json" params:params success:^(id responseObj) {
//        if (success) {
//            JYJHomeStatusesResult *result = [JYJHomeStatusesResult objectWithKeyValues:responseObj];
//            success(result);
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];

}

+ (void)sendStatusesWithParam:(JYJSendStatusParam *)param success:(void (^)(JYJSendStatusResult *))success failure:(void (^)(NSError *))failure
{
    [self postWithUrl:@"https://api.weibo.com/2/statuses/update.json" param:param resultClass:[JYJSendStatusResult class] success:success failure:failure];
//    // 1.封装参数
//    NSDictionary *params = param.keyValues;
//    
//    [JYJHttpTool post:@"https://api.weibo.com/2/statuses/update.json" params:params success:^(id responseObj) {
//        if (success) {
//            JYJSendStatusResult *result = [JYJSendStatusResult objectWithKeyValues:responseObj];
//            success(result);
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];

}
@end
