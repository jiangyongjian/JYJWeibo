//
//  JYJTabBar.h
//  JYJ微博
//
//  Created by JYJ on 15/3/15.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJTabBar;
@protocol JYJTabBarDelegate <NSObject>

@optional
- (void)tabBarDidClickedPlusButtom:(JYJTabBar *)tabBar;

@end
@interface JYJTabBar : UITabBar


@property (nonatomic, weak) id<JYJTabBarDelegate> tabBarDelegate;

@end
