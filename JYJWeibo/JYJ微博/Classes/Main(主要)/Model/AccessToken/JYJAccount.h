//
//  JYJAccount.h
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJAccount : NSObject <NSCoding>
//2015-03-18 18:55:19.895 JYJ微博[2328:607] 请求成功---{
//    "access_token" = "2.00CIpmtCV74e7Ea46ade6ae3EMiM7B";
//    "expires_in" = 157679999;
//    "remind_in" = 157679999;
//    uid = 2656600430;
//}
/**
 *  string 用于调用access_token ,接口获取授权后的access_token
 */
@property (nonatomic, copy) NSString *access_token;

/**
 *  string access_token 的生命周期，单位是秒
 */
@property (nonatomic, copy) NSString *expires_in;
/**
 *  access_token 过期时间
 */
@property (nonatomic, strong) NSDate *expires_time;
/**
 *  string 当前授权用户的uid
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *name;

//+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
