//
//  JYJTabBar.m
//  JYJ微博
//
//  Created by JYJ on 15/3/15.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJTabBar.h"

@interface JYJTabBar ()
@property (nonatomic, weak) UIButton *plusButton;

@end
@implementation JYJTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!iOS7) {
            self.backgroundImage = [UIImage imageWithName:@"tabbar_background"];
        }
        
        self.selectionIndicatorImage = [UIImage imageWithName:@"navigationbar_button_background"];
        
        //添加加号按钮
        [self setupPlusButton];
        
    }
    return self;
}

- (void)setupPlusButton
{
    UIButton *plusButton = [[UIButton alloc] init];
    
    //设置背景
    [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    // 设置加号图标
    [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    // 监听按钮的点击
    [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    // 添加
    [self addSubview:plusButton];
    self.plusButton = plusButton;
}

- (void)plusClick
{
    JYJLog(@"plusClick---");
    // 通知代理，我被人点击了
    if ([self.tabBarDelegate respondsToSelector:@selector(tabBarDidClickedPlusButtom:)]) {
        [self.tabBarDelegate tabBarDidClickedPlusButtom:self];
    }
}

/**
 *  布局之控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置所有tabBarButton的frame
    [self setupAllTabBarButtonsFrame];
    
    //设置plusButton的frame
    [self setupPlusButtonFrame];

}

- (void)setupPlusButtonFrame
{
    self.plusButton.size = self.plusButton.currentBackgroundImage.size;
    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}

/**
 *  设置所有tabBarButton的frame
 */
- (void)setupAllTabBarButtonsFrame
{
    int index = 0;
    
    for (UIView *tabBarButton in self.subviews) {
        // 如果不是tabBarButton，直接通过，继续查询
        if (![tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        
        // 根据索引调整位置
        [self setupTabBarButtonFrame:tabBarButton atIndex:index];
        
        
        // 遍历UITabBarButton中的所有子控件，设置按钮的颜色
//        [self setupTabBarButtonTextColor:tabBarButton atIndex:index];
        //增加索引
        index ++;
    }
}
///**
// *  设置某个安妮的文字颜色
// *
// *  @param tabBarButton 需要设置的按钮
// *  @param index        按钮所在的索引
// */
//- (void)setupTabBarButtonTextColor:(UIView *)tabBarButton atIndex:(int)index
//{
//    int selectedIndex = [self.items indexOfObject:self.selectedItem];
//    for (UILabel *lable in tabBarButton.subviews) {
//        // 如果不是lable 继续
//        if (![lable isKindOfClass:[UILabel class]]) continue;
//        // 设置字体
//        lable.font = [UIFont systemFontOfSize:10];
//        if (selectedIndex == index) { //说明这个button被选中，设置字体颜色为橙色
//            lable.textColor = [UIColor orangeColor];
//        }else{
//            lable.textColor = [UIColor blackColor];
//        }
//    }
//
//}

/**
 *  设置某个按钮的frame
 *
 *  @param tabBarButton 需要设置的按钮
 *  @param index        按钮所在的索引
 */
- (void)setupTabBarButtonFrame:(UIView *)tabBarButton atIndex:(int)index
{
    // 计算button的尺寸
    CGFloat buttonW = self.width / (self.items.count + 1);
    CGFloat buttonH = self.height;
    
    tabBarButton.width = buttonW;
    tabBarButton.height = buttonH;
    
    if (index >= 2) {
        tabBarButton.x = buttonW * (index + 1);
    }else{
        tabBarButton.x = buttonW * index;
    }
    tabBarButton.y = 0;
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
