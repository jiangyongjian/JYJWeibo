//
//  JYJEmotionGridView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/26.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJEmotionGridView.h"
#import "JYJEmotion.h"
#import "JYJEmotionView.h"
#import "JYJEmotionPopView.h"
#import "JYJEmotionTool.h"

@interface JYJEmotionGridView ()
@property (nonatomic, weak) UIButton *deleteButton;

@property (nonatomic, strong) NSMutableArray *emotionViews;
@property (nonatomic, strong) JYJEmotionPopView *popView;
@end

@implementation JYJEmotionGridView

- (JYJEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [JYJEmotionPopView popView];
    }
    return _popView;
}

- (NSMutableArray *)emotionViews
{
    if (!_emotionViews) {
        _emotionViews = [NSMutableArray array];
    }
    return _emotionViews;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 添加删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageWithName:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageWithName:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        // 添加一个手势识别器
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] init];
        [recognizer addTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}
/**
 *  根据触摸点返回对应的表情控件
 */
- (JYJEmotionView *)emotionViewWithPoint:(CGPoint)point
{
    __block JYJEmotionView *foundEmotionView = nil;
    [self.emotionViews enumerateObjectsUsingBlock:^(JYJEmotionView *emotionView, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(emotionView.frame, point)) {
            foundEmotionView = emotionView;
            // 停止遍历
            *stop = YES;
        }
    }];
    return foundEmotionView;
}

/**
 *  触发了长按手势
 */
- (void)longPress:(UILongPressGestureRecognizer *)recognizer
{
    // 1.捕获触摸点
    CGPoint point = [recognizer locationInView:recognizer.view];
    
    // 2.监测触摸点落在哪个表情上
    JYJEmotionView *emotionView = [self emotionViewWithPoint:point];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // 手松开
        // 移除表情弹出控件
        [self.popView dismiss];
        
        // 选中表情
        [self selectEmotion:emotionView.emotion];
    }else{ // 手没有松开
        // 显示表情弹出
        [self.popView showFromEmotionView:emotionView];
    }

}
- (void)deleteClick
{
    // 发出删除通知
    [[NSNotificationCenter defaultCenter] postNotificationName:JYJEmotionDidDeletedNotification object:nil userInfo:nil];
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    // 添加新的表情
    int count = emotions.count;
    int currentEmotionViewCount = self.emotionViews.count;
    for (int i = 0; i < count; i++) {
        JYJEmotionView *emotionView = nil;
        if (i >= currentEmotionViewCount) { //emotionView不够用
            emotionView = [[JYJEmotionView alloc] init];
            [emotionView addTarget:self action:@selector(emotionClick:) forControlEvents:UIControlEventTouchUpInside];
            emotionView.backgroundColor  = JYJRandomColor;
            [self addSubview:emotionView];
            [self.emotionViews addObject:emotionView];
        }else{ // emotionView够用
            emotionView = self.emotionViews[i];
        }
        
        // 传递模型数据
        emotionView.emotion = emotions[i];
        emotionView.hidden = NO;
    }
    // 隐藏多余的emotionView
    for (int i = count; i < currentEmotionViewCount; i++) {
        JYJEmotionView *emotionView = self.emotionViews[i];
        emotionView.hidden = YES;
    }
}
/**
 *  监听表情的点击
 */

- (void)emotionClick:(JYJEmotionView *)emotionView
{
    [self.popView showFromEmotionView:emotionView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView dismiss];
        
        // 选中表情
        [self selectEmotion:emotionView.emotion];
    });
    
}

- (void)selectEmotion:(JYJEmotion*)emotion
{
    if (emotion == nil) return;
#warning  注意：先添加的表情，再发通知
    // 保存使用记录
    [JYJEmotionTool addRecentEmotion:emotion];
    // 发出一个选中表情的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:JYJEmotionDidSelectedNotification object:nil userInfo:@{ JYJSelectedEmotion : emotion }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftInset = 15;
    CGFloat topInset = 15;
    
    // 1.添加所有表情按钮
    NSUInteger count = self.emotionViews.count;
    CGFloat emotionViewW = (self.width - 2 * leftInset) / JYJEmotionMaxCols;
    CGFloat emotionViewH = (self.height - topInset) / JYJEmotionMaxRows;
    for (int i = 0; i < count; i++) {
        UIButton *emotionView = self.emotionViews[i];
        emotionView.width = emotionViewW;
        emotionView.height = emotionViewH;
        emotionView.x = (i % JYJEmotionMaxCols) * emotionViewW + leftInset;
        emotionView.y = (i / JYJEmotionMaxCols) * emotionViewH + topInset;
    }
    
    // 2.删除按钮
    self.deleteButton.width = emotionViewW;
    self.deleteButton.height = emotionViewH;
    self.deleteButton.x = self.width - leftInset - self.deleteButton.width;
    self.deleteButton.y = self.height - self.deleteButton.height;
}




@end
