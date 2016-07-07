//
//  JYJEmotionTool.h
//  JYJ微博
//
//  Created by JYJ on 15/3/28.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//  管理表情数据：加载表情数据、存储表情使用记录

#import <Foundation/Foundation.h>
@class JYJEmotion;
@interface JYJEmotionTool : NSObject
/**
 *  默认表情
 */
+ (NSArray *)defaulEmotions;
/**
 *  emoji表情
 */
+ (NSArray *)emojiEmotions;
/**
 *  浪小花表情
 */
+ (NSArray *)lxhEmotions;
/**
 *  最近表情
 */
+ (NSArray *)recentEmotions;
/**
 *  根据表情文字描述找出对应的表情对象
 */
+ (JYJEmotion *)emotionWithDesc:(NSString *)desc;
/**
 *  保存最近使用的表情
 */
+ (void)addRecentEmotion:(JYJEmotion *)emotion;
@end
