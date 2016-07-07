//
//  JYJPersonTool.h
//  模糊查询
//
//  Created by JYJ on 15/3/31.
//  Copyright (c) 2015年 heima. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYJPerson;
@interface JYJPersonTool : NSObject
/**
 *  保存一个联系人
 */
+ (void)save:(JYJPerson *)person;
/**
 *  查询所有的联系人
 */
+ (NSArray *)query;
+ (NSArray *)queryWithCondition:(NSString *)condition;
@end
