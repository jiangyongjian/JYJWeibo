//
//  JYJUser.h
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJUser : NSObject
/** 
 * 	友好显示名称
 */
@property (nonatomic, copy) NSString *name;
/**
 * 	用户头像地址(中图)， 50*50像素
 */
@property (nonatomic, copy) NSString *profile_image_url;

/**
 *  会员类型
 */
@property (nonatomic, assign) int mbtype;
/**
 *  会员等级
 */
@property (nonatomic, assign) int mbrank;

@property (nonatomic, assign, getter = isVip, readonly) BOOL Vip;
@end
