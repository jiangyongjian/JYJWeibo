//
//  JYJBaseParam.m
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJBaseParam.h"
#import "JYJAccountTool.h"
#import "JYJAccount.h"

@implementation JYJBaseParam
-(id)init
{
    if (self = [super init]) {
        self.access_token = [JYJAccountTool account].access_token;
    }
    return self;
}

+ (instancetype)param
{
    return [[self alloc] init];
}
@end
