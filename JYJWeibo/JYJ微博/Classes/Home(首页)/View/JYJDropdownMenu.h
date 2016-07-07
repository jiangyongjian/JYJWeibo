//
//  JYJDropdownMenu.h
//  JYJ微博
//
//  Created by JYJ on 15/3/14.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JYJDropdownMenuArrowPositionCenter = 0,
    JYJDropdownMenuArrowPositionLeft = 1,
    JYJDropdownMenuArrowPositionRight = 2
} JYJDropdownMenuArrowPosition;

@class JYJDropdownMenu;
@protocol JYJDropdownMenuDelegate <NSObject>

@optional
- (void)dropdownMenuDidDismiss:(JYJDropdownMenu *)menu;
- (void)dropdownMenuDidShow:(JYJDropdownMenu *)menu;

@end

@interface JYJDropdownMenu : UIView
+ (instancetype)menu;

/**
 *  显示
 */
- (void)showFrom:(UIView *)from;

/**
 *  销毁
 */
- (void)dismiss;

/**
 *  内容
 */
@property (nonatomic, strong) UIView *content;
/**
 *  内部控制器
 */
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic, weak) id<JYJDropdownMenuDelegate> delegate;
@property (nonatomic, assign) JYJDropdownMenuArrowPosition arrowPosition;
@end
