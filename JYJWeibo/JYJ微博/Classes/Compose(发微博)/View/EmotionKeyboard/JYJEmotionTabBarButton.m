//
//  JYJEmotionTabBarButton.m
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJEmotionTabBarButton.h"

@implementation JYJEmotionTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    // 按钮高亮所做的一切操作都不存在了

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
