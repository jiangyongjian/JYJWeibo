//
//  JYJEmotionTextView.h
//  JYJ微博
//
//  Created by JYJ on 15/3/28.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJTextView.h"
@class JYJEmotion;
@interface JYJEmotionTextView : JYJTextView
/**
 *  拼接表情到最后面
 */
- (void)appendEmotion:(JYJEmotion *)emotion;
/**
 *  具体的文字内容
 */
- (NSString *)realText;
@end
