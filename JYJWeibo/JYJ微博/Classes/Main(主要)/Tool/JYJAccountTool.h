//
//  JYJAccountTool.h
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJAccessTokenParam.h"
#import "JYJBaseTool.h"

@class JYJAccount;

@interface JYJAccountTool : JYJBaseTool

/**
 *  存储账号信息
 */
+ (void)save:(JYJAccount *)account;
/**
*  读取账号
*/
+ (JYJAccount *)account;

/**
 *  获取accesToken
 *
 *  @param param  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+ (void)accesTokenWithParam:(JYJAccessTokenParam *)param success:(void (^)(JYJAccount *account))success failure:(void (^)(NSError *error))failure;
@end
