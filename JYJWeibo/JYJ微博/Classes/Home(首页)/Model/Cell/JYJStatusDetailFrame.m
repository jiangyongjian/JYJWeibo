//
//  JYJStatusDetailFrame.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusDetailFrame.h"
#import "JYJStatusOriginalFrame.h"
#import "JYJStatusRetweetedFrame.h"
#import "JYJStatus.h"

@implementation JYJStatusDetailFrame

- (void)setStatus:(JYJStatus *)status
{
    _status = status;
    
    // 1.计算原创微博的frame
    JYJStatusOriginalFrame *originalFrame = [[JYJStatusOriginalFrame alloc] init];
    originalFrame.status = status;
    self.originalFrame = originalFrame;
    
    // 2.计算转发微博的frame
    CGFloat h = 0;
    if (status.retweeted_status) {
        JYJStatusRetweetedFrame *retweetedFrame = [[JYJStatusRetweetedFrame alloc] init];
        retweetedFrame.retweetedStatus = status.retweeted_status;
        
        // 计算转发微博frame的y值
        CGRect f = retweetedFrame.frame;
        f.origin.y = CGRectGetMaxY(originalFrame.frame);
        retweetedFrame.frame = f;
        self.retweetedFrame = retweetedFrame;
        
        h = CGRectGetMaxY(retweetedFrame.frame);
    }else{
        h = CGRectGetMaxY(originalFrame.frame);
    }
    
    // 3.自己的frame
    CGFloat x = 0;
    CGFloat y = JYJStatusCellMargin;
    CGFloat w = JYJScreenW;
    
    self.frame = CGRectMake(x, y, w, h);

}
@end
