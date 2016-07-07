//
//  JYJEmotionTarBar.m
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJEmotionTarBar.h"
#import "JYJEmotionTabBarButton.h"


@interface JYJEmotionTarBar ()
@property (nonatomic, weak) JYJEmotionTabBarButton *selectedBtn;

@end

@implementation JYJEmotionTarBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBtn:@"最近" buttonType:JYJEmotionTarBarButtonTypeRecent];
        [self setupBtn:@"默认" buttonType:JYJEmotionTarBarButtonTypeDefault];
        [self setupBtn:@"Emoji" buttonType:JYJEmotionTarBarButtonTypeEmoji];
        [self setupBtn:@"浪小花" buttonType:JYJEmotionTarBarButtonTypeLxh];
    
        // 2.监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSeleted:) name:JYJEmotionDidSelectedNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)emotionDidSeleted:(NSNotification *)note
{
    if (self.selectedBtn.tag == JYJEmotionTarBarButtonTypeRecent) {
        [self btnClick:self.selectedBtn];
    }
}

/**
 *  添加按钮
 */
- (void)setupBtn:(NSString *)title buttonType:(JYJEmotionTarBarButtonType)buttonType
{
    // 1.创建按钮
    JYJEmotionTabBarButton *btn = [[JYJEmotionTabBarButton alloc] init];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = buttonType;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:btn];
    
    // 选中“默认”按钮
    if (buttonType == JYJEmotionTarBarButtonTypeDefault) {
        [self btnClick:btn];
    }
    // 设置背景图片
    NSString *image = @"compose_emotion_table_mid_normal";
    NSString *selectImage = @"compose_emotion_table_mid_selected";
    if (self.subviews.count == 1) {
        image = @"compose_emotion_table_left_normal";
        selectImage = @"compose_emotion_table_left_selected";
    }else if (self.subviews.count == 4){
        image = @"compose_emotion_table_right_normal";
        selectImage = @"compose_emotion_table_right_selected";
    }
    
    [btn setBackgroundImage:[UIImage resizedImage:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizedImage:selectImage] forState:UIControlStateDisabled];
}

- (void)btnClick:(JYJEmotionTabBarButton *)btn
{
    // 点击谁，谁就不能被点击，这个时候就不能在点了，对应的有selected
    self.selectedBtn.enabled = YES;
    btn.enabled = NO;
    self.selectedBtn = btn;
    if ([self.delegate respondsToSelector:@selector(emotionTarBar:didSelectButton:)]) {
        [self.delegate emotionTarBar:self didSelectButton:btn.tag];
    }
}

- (void)setDelegate:(id<JYJEmotionTarBarDelegate>)delegate
{
    _delegate = delegate;
    // 选中“默认”按钮
    JYJEmotionTabBarButton *defaultButton = (JYJEmotionTabBarButton *)[self viewWithTag:JYJEmotionTarBarButtonTypeDefault];
    [self btnClick:defaultButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = self.width / btnCount;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        JYJEmotionTabBarButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.height = btnH;
        btn.x = i * btnW;
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
