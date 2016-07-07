//
//  JYJStatusLable.m
//  JYJ微博
//
//  Created by JYJ on 15/3/30.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusLable.h"
#import "JYJLink.h"

#define JYJLinkBackgroundTag 10000

@interface JYJStatusLable ()
@property (nonatomic, weak) UITextView *textView;
@property (nonatomic, strong) NSArray *links;
@end
@implementation JYJStatusLable

- (NSArray *)links
{
    if (!_links) {
        NSMutableArray *links = [NSMutableArray array];
        [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
            NSString *linkText = attrs[JYJLinkText];
            if (linkText == nil) return;
            
            // 创建一个链接
            JYJLink *link = [[JYJLink alloc] init];
            link.text = linkText;
            link.range = range;
            
            // 处理矩形边框
            NSMutableArray *rects = [NSMutableArray array];
            // 设置选中的文字范围
            self.textView.selectedRange = range;
            
            // 算出选中的字符范围的边框
            NSArray *selectionRects = [self.textView selectionRectsForRange:self.textView.selectedTextRange];
            
            for (UITextSelectionRect *selectionRect in selectionRects) {
                if (selectionRect.rect.size.width == 0 || selectionRect.rect.size.height == 0) continue;
                [rects addObject:selectionRect];
            }
            link.rects = rects;
            [links addObject:link];
        }];
        self.links = links;
    }
    return _links;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UITextView *textView = [[UITextView alloc] init];
        // 不能编辑
        textView.editable = NO;
        // 不能滚动
        textView.scrollEnabled = NO;
        
        textView.userInteractionEnabled = NO;
        // 设置文字的内边距
        textView.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        
        textView.backgroundColor = [UIColor clearColor];
        [self addSubview:textView];
        self.textView = textView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textView.frame = self.bounds;
}


- (void)setAttributedText:(NSAttributedString *)attributedText
{
    _attributedText = attributedText;
    self.textView.attributedText = attributedText;
    self.links = nil;
}


// 事件处理
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获取触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    // 得出被点击的那个连接
    JYJLink *touchingLink = [self touchingLinkWithPoint:point];
    
    // 设置链接选中的背景
    [self showLinkBackground:touchingLink];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 获得触摸点
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    // 获得被点击的那个链接
    JYJLink *touchingLink = [self touchingLinkWithPoint:point];
    if (touchingLink) {
        // 说明手指在某个链接上面抬起，发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:JYJLinkDidSelectedNotification object:nil userInfo:@{ JYJLinkText : touchingLink.text}];
    }
    
    // 相当于触摸被取消
    [self touchesCancelled:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeAllLinkBackground];
    });

}



/**
 *  根据触摸点找出被触摸的链接
 *
 *  触摸点
 */
- (JYJLink *)touchingLinkWithPoint:(CGPoint)point
{
    __block JYJLink *touchingLink = nil;
    [self.links enumerateObjectsUsingBlock:^(JYJLink *link, NSUInteger idx, BOOL *stop) {
        for (UITextSelectionRect *selectionRect in link.rects) {
            if (CGRectContainsPoint(selectionRect.rect, point)) {
                touchingLink = link;
                break;
            }
        }
    }];
    
    return touchingLink;
}
/**
 *  显示链接的背景
 *
 *  @param link 需要显示背景的link
 */
- (void)showLinkBackground:(JYJLink *)link
{
    for (UITextSelectionRect *selectionRect in link.rects) {
        UIView *bg = [[UIView alloc] init];
        bg.tag = JYJLinkBackgroundTag;
        bg.frame = selectionRect.rect;
        bg.layer.cornerRadius = 3;
        bg.backgroundColor = [UIColor greenColor];
        [self insertSubview:bg atIndex:0];
    }
}

- (void)removeAllLinkBackground
{
    for (UIView *child in self.subviews) {
        if (child.tag == JYJLinkBackgroundTag) {
            [child removeFromSuperview];
        }
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
