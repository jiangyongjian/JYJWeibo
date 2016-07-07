//
//  JYJUserInfoParam.h
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYJBaseParam.h"


@interface JYJUserInfoParam : JYJBaseParam

/**	false	int64	需要查询的用户ID。*/
@property (nonatomic, copy) NSString *uid;

@end
