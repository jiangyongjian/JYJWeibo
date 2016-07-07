//
//  JYJUser.m
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJUser.h"

@implementation JYJUser

- (BOOL)isVip
{
    // 是会员
    return self.mbtype > 2;
}

@end
