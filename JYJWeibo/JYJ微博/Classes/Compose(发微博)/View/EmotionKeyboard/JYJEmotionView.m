//
//  JYJEmotionView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/27.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJEmotionView.h"
#import "JYJEmotion.h"


@implementation JYJEmotionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setEmotion:(JYJEmotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.code) { // Emoji表情
        // 取消动画
        [UIView setAnimationsEnabled:NO];
        self.titleLabel.font = [UIFont systemFontOfSize:32];
        [self setTitle:emotion.emoji forState:UIControlStateNormal];
        [self setImage:nil forState:UIControlStateNormal];
        // 再次开启动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView setAnimationsEnabled:YES];
        });
    } else { // 表情图片
        NSString *icon = [NSString stringWithFormat:@"%@/%@",emotion.directory, emotion.png];
        UIImage *image = [UIImage imageWithName:icon];
        if (iOS7) {
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        [self setTitle:nil forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
