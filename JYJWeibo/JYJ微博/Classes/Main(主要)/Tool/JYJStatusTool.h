//
//  JYJStatusTool.h
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJHomeStatusesParam.h"
#import "JYJHomeStatusesResult.h"
#import "JYJSendStatusParam.h"
#import "JYJSendStatusResult.h"
#import "JYJBaseTool.h"

@interface JYJStatusTool : JYJBaseTool

/**
 *  加载首页的微博数据
 *
 *  @param param  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+ (void)homeStatusesWithParam:(JYJHomeStatusesParam *)param success:(void (^)(JYJHomeStatusesResult *result))success failure:(void (^)(NSError *error))failure;

/**
 *  发没有图片的微博
 *
 *  @param param  请求参数
 *  @param success 请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param failure 请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 */

+ (void)sendStatusesWithParam:(JYJSendStatusParam *)param success:(void (^)(JYJSendStatusResult *result))success failure:(void (^)(NSError *error))failure;
@end
