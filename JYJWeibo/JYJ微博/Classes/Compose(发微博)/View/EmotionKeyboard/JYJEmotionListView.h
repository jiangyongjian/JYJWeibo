//
//  JYJEmotionListView.h
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//  表情列表（能展示多页表情）

#import <UIKit/UIKit.h>
#import "JYJEmotion.h"
@interface JYJEmotionListView : UIView
/**
 *  需要展示的所有表情
 */
@property (nonatomic, strong) NSArray *emotions;
@end
