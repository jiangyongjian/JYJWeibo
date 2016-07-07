//
//  JYJControllerTool.m
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJControllerTool.h"
#import "JYJTabBarController.h"
#import "JYJNewfeatureViewController.h"

@implementation JYJControllerTool

+ (void)chooseRootViewController
{

    // 如何知道第一次使用这个版本？比较上次使用情况
    //    NSString *versionkey = @"CFBundleVersion";
    NSString *versionkey = (__bridge NSString *)kCFBundleVersionKey;
    // 从沙盒中取出上次存储的软件版本号（取出用户上次的使用记录）
    NSUserDefaults *defults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defults objectForKey:versionkey];
    
    // 获得当前打开的软件版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionkey];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([currentVersion isEqualToString:lastVersion]) { // 当前版本号 == 上次使用的版本号，显示 JYJTabBarController
        UITabBarController *tabBarVc = [[JYJTabBarController alloc] init];
        window.rootViewController = tabBarVc;
    }else{ // 当前版本号！= 上次使用的版本号：显示版本新特性
        window.rootViewController = [[JYJNewfeatureViewController alloc] init];
        // 存储这次使用的软件版本
        [defults setObject:currentVersion forKey:versionkey];
        [defults synchronize];
    }
}
@end
