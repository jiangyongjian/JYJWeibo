//
//  JYJEmotionAttachment.m
//  JYJ微博
//
//  Created by JYJ on 15/3/28.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJEmotionAttachment.h"
#import "JYJEmotion.h"
@implementation JYJEmotionAttachment
- (void)setEmotion:(JYJEmotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageWithName:[NSString stringWithFormat:@"%@/%@", emotion.directory, emotion.png]];
}
@end
