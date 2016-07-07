//
//  JYJCommonGroup.h
//  JYJ微博
//
//  Created by JYJ on 15/3/30.
//  Copyright (c) 2015年 JYJ. All rights reserved.
// 用一个组模型来描述每组的头信息，尾信息，这组的所有行模型

#import <Foundation/Foundation.h>

@interface JYJCommonGroup : NSObject
/**
 *  组头
 */
@property (nonatomic, copy) NSString *header;
/**
 *  组尾
 */
@property (nonatomic, copy) NSString *footer;

/**
 *  这组的所有行模型(数组中存放的都是JYJCommonItem)
 */
@property (nonatomic, strong) NSArray *items;

+ (instancetype)group;
@end
