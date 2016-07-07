//
//  JYJUnreadCountResult.m
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJUnreadCountResult.h"

@implementation JYJUnreadCountResult

- (int)messageCount
{
    return self.cmt + self.dm +self.mention_cmt + self.mention_status;

}
-(int)totalCount
{
    return self.messageCount + self.status + self.follower;

}
@end
