
//
//  JYJCommonItem.m
//  JYJ微博
//
//  Created by JYJ on 15/3/30.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJCommonItem.h"

@implementation JYJCommonItem
+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon
{
    JYJCommonItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title
{

    return [self itemWithTitle:title icon:nil];
}
@end
