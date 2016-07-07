//
//  JYJEmotionPopView.h
//  JYJ微博
//
//  Created by JYJ on 15/3/27.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJEmotionView;

@interface JYJEmotionPopView : UIView
@property (weak, nonatomic) IBOutlet JYJEmotionView *emotionView;
+ (instancetype)popView;
/**
 *  表情弹出控件
 *
 *  @param fromEmotionView 从哪个表情上面弹出
 */
- (void)showFromEmotionView:(JYJEmotionView *)fromEmotionView;
- (void)dismiss;
@end
