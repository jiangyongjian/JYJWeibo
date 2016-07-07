//
//  JYJUserTool.h
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJUserInfoParam.h"
#import "JYJUserInfoResult.h"
#import "JYJUnreadCountParam.h"
#import "JYJUnreadCountResult.h"
#import "JYJBaseTool.h"

@interface JYJUserTool : JYJBaseTool
/**
 *  加载用户信息
 *
 *  @param param  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+ (void)userInfoWithParam:(JYJUserInfoParam *)param success:(void (^)(JYJUserInfoResult *result))success failure:(void (^)(NSError *error))failure;

+ (void)unreadCountWithParam:(JYJUnreadCountParam *)param success:(void (^)(JYJUnreadCountResult *result))success failure:(void (^)(NSError *error))failure;
@end
