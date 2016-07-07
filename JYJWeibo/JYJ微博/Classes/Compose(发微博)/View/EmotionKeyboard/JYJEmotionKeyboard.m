//
//  JYJEmotionKeyboard.m
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJEmotionKeyboard.h"
#import "JYJEmotionListView.h"
#import "JYJEmotionTarBar.h"
#import "JYJEmotion.h"
#import "MJExtension.h"
#import "JYJEmotionTool.h"

@interface JYJEmotionKeyboard () <JYJEmotionTarBarDelegate>
/** 表情内容 */
@property (nonatomic, weak) JYJEmotionListView *listView;

/** tabbar */
@property (nonatomic, weak) JYJEmotionTarBar *tabBar;

@end

@implementation JYJEmotionKeyboard

+ (instancetype)keyboard
{
    return [[self alloc] init];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"emoticon_keyboard_background"]];
        // 添加表情列表
        JYJEmotionListView *listView = [[JYJEmotionListView alloc] init];
        [self addSubview:listView];
        self.listView = listView;
        // 2.添加表情工具条
        JYJEmotionTarBar *tabBar = [[JYJEmotionTarBar alloc] init];
        [self addSubview:tabBar];
        tabBar.delegate = self;
        self.tabBar = tabBar;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1. tabBar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.y = self.height - self.tabBar.height;
    
    // 2.表情内容
    self.listView.width = self.width;
    self.listView.height = self.tabBar.y;
}

- (void)emotionTarBar:(JYJEmotionTarBar *)tabBar didSelectButton:(JYJEmotionTarBarButtonType)buttonType
{
    switch (buttonType) {
        case JYJEmotionTarBarButtonTypeRecent:
            self.listView.emotions = [JYJEmotionTool recentEmotions];
            break;
        case JYJEmotionTarBarButtonTypeDefault:
            self.listView.emotions = [JYJEmotionTool defaulEmotions];
            break;
        case JYJEmotionTarBarButtonTypeEmoji:
            self.listView.emotions =[JYJEmotionTool emojiEmotions];
            break;
        case JYJEmotionTarBarButtonTypeLxh:
            self.listView.emotions = [JYJEmotionTool lxhEmotions];
            break;
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
