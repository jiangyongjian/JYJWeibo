//
//  JYJEmotionPopView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/27.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJEmotionPopView.h"
#import "JYJEmotionView.h"

@interface JYJEmotionPopView ()

@end
@implementation JYJEmotionPopView

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"JYJEmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFromEmotionView:(JYJEmotionView *)fromEmotionView
{
    // 显示表情
    self.emotionView.emotion = fromEmotionView.emotion;
    
    // 2.添加到窗口上
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 3.设置frame
    CGFloat centerX = fromEmotionView.centerX;
    CGFloat centerY = fromEmotionView.centerY - self.height * 0.5;
    CGPoint center = CGPointMake(centerX, centerY);
    self.center = [window convertPoint:center fromView:fromEmotionView.superview];

}
- (void)dismiss
{
    [self removeFromSuperview];
}


/**
 *  当一个控件显示之前会调用一次（如果控件在显示之前没有尺寸，不会调用这个方法）
 *
 *  @param rect 控件的bounds
 */
- (void)drawRect:(CGRect)rect
{
    [[UIImage imageWithName:@"emoticon_keyboard_magnifier"] drawInRect:rect];
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
