//
//  JYJButton.m
//  JYJ微博
//
//  Created by JYJ on 15/3/14.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJButton.h"

@implementation JYJButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 设置文字右对齐
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        //设置文字颜色
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = JYJNavigationTitleFont;
        // 设置高亮状态下不需要调整内部的图片为灰色
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}
/**
 *  设置内部图标的Frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    
    CGFloat imageY = 0;
    CGFloat imageW = self.height;
    CGFloat imageH = imageW;
    CGFloat imageX = self.width - imageW;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

/**
 *  设置内部文字的Frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = self.width - self.height;
    CGFloat titleH = self.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 计算文字的尺寸
    CGSize titleSize = [title sizeWithFont:self.titleLabel.font];
    
    // 2.计算按钮的宽度
    
    self.width = titleSize.width + self.height + 10;

}

@end
