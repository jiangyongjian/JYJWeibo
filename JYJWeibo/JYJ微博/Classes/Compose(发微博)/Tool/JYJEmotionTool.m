//
//  JYJEmotionTool.m
//  JYJ微博
//
//  Created by JYJ on 15/3/28.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//
#define JYJRecentFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recent_emotions.data"]

#import "JYJEmotionTool.h"
#import "JYJEmotion.h"
#import "MJExtension.h"

@implementation JYJEmotionTool
/** 默认表情 */
static NSArray *_defaulEmotions;
/** Emoji */
static NSArray *_emojiEmotions;
/** 浪小花表情 */
static NSArray *_lxhEmotions;
/** 最近表情 */
static NSMutableArray *_recentEmotions;


+ (NSArray *)defaulEmotions
{
    if (!_defaulEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaulEmotions = [JYJEmotion objectArrayWithFile:plist];
        [_defaulEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/default"];
    }
    return _defaulEmotions;
}
+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions = [JYJEmotion objectArrayWithFile:plist];
        [_emojiEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/emoji"];
    }
    return _emojiEmotions;
}
+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [JYJEmotion objectArrayWithFile:plist];
        [_lxhEmotions makeObjectsPerformSelector:@selector(setDirectory:) withObject:@"EmotionIcons/lxh"];
    }
    return _lxhEmotions;
}

+ (NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        // 从沙盒中加载最近使用表情
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:JYJRecentFilepath];
        if (!_recentEmotions) { // 沙盒中没有
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

// Emotion -- 文字 -- emoji 的plist里面加载的表情
+ (void)addRecentEmotion:(JYJEmotion *)emotion
{
    // 加载最近的表情数据
    [self recentEmotions];
    // 删除之前的表情(数组是不能在遍历中删除东西的)
    [_recentEmotions removeObject:emotion];
    
    // 添加到最新的表情
    [_recentEmotions insertObject:emotion atIndex:0];
    // 存到沙盒中
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:JYJRecentFilepath];
}
+ (JYJEmotion *)emotionWithDesc:(NSString *)desc
{
    if (!desc) return nil;
    
    __block JYJEmotion *foundEmotion = nil;
    // 从默认表情中找
    [[self defaulEmotions] enumerateObjectsUsingBlock:^(JYJEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]){
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    if (foundEmotion) return foundEmotion;
    
    // 从浪小花表情中查找
    [[self lxhEmotions] enumerateObjectsUsingBlock:^(JYJEmotion *emotion, NSUInteger idx, BOOL *stop) {
        if ([desc isEqualToString:emotion.chs] || [desc isEqualToString:emotion.cht]){
            foundEmotion = emotion;
            *stop = YES;
        }
    }];
    
    return foundEmotion;
}

@end
