//
//  JYJDropdownMenu.m
//  JYJ微博
//
//  Created by JYJ on 15/3/14.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJDropdownMenu.h"


@interface JYJDropdownMenu ()
/**
 将来用来显示内容的容器
 */
@property (nonatomic, weak) UIImageView *containerView;

@end
@implementation JYJDropdownMenu

- (UIImageView *)containerView
{
    if (!_containerView) {
        // 添加一个灰色图片控件
        UIImageView *containerView = [[UIImageView alloc] init];
        containerView.image = [UIImage resizedImage:@"popover_background"];
        
        containerView.userInteractionEnabled = YES; // 开启交互
        [self addSubview:containerView];
        self.containerView = containerView;
    }
    return _containerView;
}

- (void)setArrowPosition:(JYJDropdownMenuArrowPosition)arrowPosition
{
    _arrowPosition = arrowPosition;
    switch (arrowPosition) {
        case JYJDropdownMenuArrowPositionCenter:
            self.containerView.image = [UIImage resizedImage:@"popover_background"];
            break;
            
        case JYJDropdownMenuArrowPositionLeft:
            self.containerView.image = [UIImage resizedImage:@"popover_background_left"];
            break;
            
        case JYJDropdownMenuArrowPositionRight:
            self.containerView.image = [UIImage resizedImage:@"popover_background_right"];
            break;
    }

}

- (void)setContent:(UIView *)content
{
    _content = content;
    
    // 调整内容的位置
    content.x = 10;
    content.y = 15;
    
    // 调整内容的宽度
    self.containerView.width = CGRectGetMaxX(content.frame) + 10;
    // 设置灰色的高度
    self.containerView.height = CGRectGetMaxY(content.frame) + 11;
    // 添加内容到灰色图片上
    [self.containerView addSubview:content];
}

- (void)setContentController:(UIViewController *)contentController
{
    _contentController = contentController;
    
    self.content = contentController.view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

+ (instancetype)menu
{
    return [[self alloc] init];
}

/**
 *  显示
 */
- (void)showFrom:(UIView *)from
{
    // 1获得最上面的窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    
    // 2添加自己到窗口上去
    [window addSubview:self];
    
    // 3设置frame
    self.frame = window.bounds;
    
    // 4.调整灰色图片的位置
    // 转换坐标系
//    CGRect newFrame = [from convertRect:from.bounds toView:window];
    CGRect newFrame = [from.superview convertRect:from.frame toView:window];
    
    self.containerView.centerX = CGRectGetMidX(newFrame);
    self.containerView.y = CGRectGetMaxY(newFrame);
    
    // 通知外界,显示自己
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
    }
   
}
/**
 *  销毁
 */
- (void)dismiss
{
    [self removeFromSuperview];
    
    // 通知外界。我被人销毁了
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    } 
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self dismiss];
}
@end
