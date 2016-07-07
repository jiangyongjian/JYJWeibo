//
//  JYJUnreadCountParam.h
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJBaseParam.h"

@interface JYJUnreadCountParam : JYJBaseParam

/**	int64	需要获取消息未读数的用户UID，必须是当前登录用户。*/
@property (nonatomic, copy) NSString *uid;
@end
