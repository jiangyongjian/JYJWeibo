//
//  JYJStatusFrame.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusFrame.h"
#import "JYJStatusDetailFrame.h"
#import "JYJStatus.h"

@implementation JYJStatusFrame
- (void)setStatus:(JYJStatus *)status
{
    _status = status;
    
    // 1.计算微博的具体内容（微博整体）
    [self setupDetailFrame];
    // 2.计算底部工具条
    [self setupToolbarFrame];
    // 3.计算cell的高度
    self.cellHeight = CGRectGetMaxY(self.toobarFrame);
}

/**
 *  计算微博的具体内容（微博整体）
 */
- (void)setupDetailFrame
{
    JYJStatusDetailFrame *detailFrame = [[JYJStatusDetailFrame alloc] init];
    detailFrame.status = self.status;
    self.detailFrame = detailFrame;
}
/**
 *  计算底部工具条
 */
- (void)setupToolbarFrame
{
    CGFloat toolbarX = 0;
    CGFloat toolbarY = CGRectGetMaxY(self.detailFrame.frame);
    CGFloat toolbarW = JYJScreenW;
    CGFloat toolbarH = 44;
    
    self.toobarFrame = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);
}
@end
