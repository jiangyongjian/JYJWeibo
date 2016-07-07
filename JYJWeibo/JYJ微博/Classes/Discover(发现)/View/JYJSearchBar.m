//
//  JYJSearchBar.m
//  JYJ微博
//
//  Created by JYJ on 15/3/14.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJSearchBar.h"

@implementation JYJSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置背景图片
        self.background = [UIImage resizedImage:@"searchbar_textfield_background"];
        // 设置内容居中
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        // 设置右边一个放大镜
        UIImageView *leftView = [[UIImageView alloc]init];
        leftView.image = [UIImage imageWithName:@"searchbar_textfield_search_icon"];
        leftView.width = leftView.image.size.width + 10;
        leftView.height = leftView.image.size.height;
        // 设置leftView的内容居中
        leftView.contentMode = UIViewContentModeCenter;
        self.leftView = leftView;
        
        // 设置左边的view永远显示
        self.leftViewMode = UITextFieldViewModeAlways;
        // 设置右边的清除按钮永远显示
        self.clearButtonMode = UITextFieldViewModeAlways;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

@end
