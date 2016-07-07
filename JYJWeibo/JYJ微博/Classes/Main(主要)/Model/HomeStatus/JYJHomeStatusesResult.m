//
//  JYJHomeStatusesResult.m
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJHomeStatusesResult.h"
#import "MJExtension.h"
#import "JYJStatus.h"

@implementation JYJHomeStatusesResult

- (NSDictionary *)objectClassInArray
{
    return @{@"statuses" : [JYJStatus class]};
}
@end
