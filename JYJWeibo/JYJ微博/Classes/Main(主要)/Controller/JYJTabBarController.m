//
//  JYJTabBarController.m
//  JYJ微博
//
//  Created by JYJ on 15/3/11.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJTabBarController.h"
#import "JYJHomeViewController.h"
#import "JYJMessageViewController.h"
#import "JYJDiscoverViewController.h"
#import "JYJProfileViewController.h"
#import "JYJNavigationController.h"
#import "JYJTabBar.h"
#import "JYJComposeViewController.h"
#import "JYJUserTool.h"
#import "JYJAccount.h"
#import "JYJAccountTool.h"

@interface JYJTabBarController () <JYJTabBarDelegate, UITabBarControllerDelegate>
@property (nonatomic, weak) JYJHomeViewController *home;
@property (nonatomic, weak) JYJMessageViewController *message;
@property (nonatomic, weak) JYJProfileViewController *profile;
@property (nonatomic, weak) UIViewController *lastSelectedViewController;

@end

@implementation JYJTabBarController



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.delegate = self;
    
    // 添加所有子控制器
    [self addAllChildVc];

    // 创建自定义tabBar
    [self addCustomTabBar];
    
    // 利用定时器获得用户的未读数
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(getUnreadCount) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController
{
    UIViewController *vc = [viewController.viewControllers firstObject];
    if ([vc isKindOfClass:[JYJHomeViewController class]]) {
        if (self.lastSelectedViewController == vc) {
            [self.home refresh:YES];
        } else {
            [self.home refresh:NO];
        }
    }
    self.lastSelectedViewController = vc;
}

- (void)getUnreadCount
{
    // 1.封装请求参数
    JYJUnreadCountParam *param = [[JYJUnreadCountParam alloc] init];
    param.uid = [JYJAccountTool account].uid;
    
    // 2.获取消息未读数
    [JYJUserTool unreadCountWithParam:param success:^(JYJUnreadCountResult *result) {
        // 显示微博未读数
        if (result.status == 0) {
            self.home.tabBarItem.badgeValue = nil;
        }else{
            self.home.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.status];
        }
        // 显示消息未读数
        if (result.messageCount == 0) {
            self.message.tabBarItem.badgeValue = nil;
        }else{
            self.message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.messageCount];
        }

        // 显示新粉丝数
        if (result.follower == 0) {
            self.profile.tabBarItem.badgeValue = nil;
        }else{
            self.profile.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", result.follower];
        }
        // 在图标上显示所有的未读数
        [UIApplication sharedApplication].applicationIconBadgeNumber = result.totalCount;
    
        JYJLog(@"总未读数--%d", result.totalCount);
    } failure:^(NSError *error) {
        JYJLog(@"获得未读数失败---%@", error);
    }];


}

- (void)addCustomTabBar
{
    // 调整tabBar
    JYJTabBar *customTabBar = [[JYJTabBar alloc] init];
    customTabBar.tabBarDelegate = self;
    
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];
    
}
#pragma mark - JYJTabBarDelegat
- (void)tabBarDidClickedPlusButtom:(JYJTabBar *)tabBar
{
    JYJComposeViewController *compose = [[JYJComposeViewController alloc] init];
    JYJNavigationController *nav = [[JYJNavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  添加所有子控制器
 */
- (void)addAllChildVc
{
    // 添加初始化子控制器
    JYJHomeViewController *home = [[JYJHomeViewController alloc] init];
    [self addOneChildVC:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    self.home = home;
    self.lastSelectedViewController = home;
    
    JYJMessageViewController *message = [[JYJMessageViewController alloc] init];
    [self addOneChildVC:message title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    self.message = message;
    
    JYJDiscoverViewController *discover = [[JYJDiscoverViewController alloc] init];
    [self addOneChildVC:discover title:@"发现" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    
    JYJProfileViewController *profile = [[JYJProfileViewController alloc] init];
    [self addOneChildVC:profile title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    self.profile = profile;
}


/**
 *  添加一个自控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中时的图标
 */

- (void)addOneChildVC:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    // 设置标题
    childVc.title = title;
//    childVc.tabBarItem.title = title;
//    childVc.navigationItem.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    
    //设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[UITextAttributeTextColor] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        // 声明ios7的图片不要渲染
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    
    // 添加为tabbar控制器的子控制器
    JYJNavigationController *nav = [[JYJNavigationController alloc] initWithRootViewController:childVc];
   
    [self addChildViewController:nav];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
