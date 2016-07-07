//
//  JYJCommonItem.h
//  JYJ微博
//
//  Created by JYJ on 15/3/30.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//  用一个模型来描述每行的信息：图标、标题、子标题、右边的样子（箭头、文字、数字、开关、打钩）

#import <Foundation/Foundation.h>

@interface JYJCommonItem : NSObject
/**
 *  图标
 */
@property (nonatomic, copy) NSString *icon;
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  子标题
 */
@property (nonatomic, copy) NSString *subtitle;
/**
 *  右边显示的数字标记
 */
@property (nonatomic, copy) NSString *badgeValue;

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon;
+ (instancetype)itemWithTitle:(NSString *)title;

@end
