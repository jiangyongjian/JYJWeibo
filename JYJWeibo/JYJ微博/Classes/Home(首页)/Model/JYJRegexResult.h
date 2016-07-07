//
//  JYJRegexResult.h
//  JYJ微博
//
//  Created by JYJ on 15/3/28.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJRegexResult : NSObject

/**
 *  匹配到的字符串
 */
@property (nonatomic, copy) NSString *string;
/**
 *  匹配到的范围
 */
@property (nonatomic, assign) NSRange range;
/**
 *  这个结果是否是表情
 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;
@end
