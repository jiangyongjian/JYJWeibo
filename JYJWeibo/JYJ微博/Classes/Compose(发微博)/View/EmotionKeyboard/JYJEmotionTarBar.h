//
//  JYJEmotionTarBar.h
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJEmotionTarBar;
typedef enum{
    JYJEmotionTarBarButtonTypeRecent, //最近
    JYJEmotionTarBarButtonTypeDefault, // 默认
    JYJEmotionTarBarButtonTypeEmoji, // emoji
    JYJEmotionTarBarButtonTypeLxh, // 浪小花
} JYJEmotionTarBarButtonType;

@protocol JYJEmotionTarBarDelegate <NSObject>

@optional
- (void)emotionTarBar:(JYJEmotionTarBar *)tabBar didSelectButton:(JYJEmotionTarBarButtonType)buttonType;

@end

@interface JYJEmotionTarBar : UIView
@property (nonatomic, weak) id<JYJEmotionTarBarDelegate> delegate;

@end
