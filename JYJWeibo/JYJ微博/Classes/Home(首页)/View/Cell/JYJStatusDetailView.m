//
//  JYJStatusDetailView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusDetailView.h"
#import "JYJStatusOriginalView.h"
#import "JYJStatusRetweetedView.h"
#import "JYJStatusDetailFrame.h"

@interface JYJStatusDetailView ()
@property (nonatomic, strong) JYJStatusOriginalView *originalView;
@property (nonatomic, strong) JYJStatusRetweetedView *retweetedView;
@end

@implementation JYJStatusDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) { // 初始化子控件
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImage:@"timeline_card_top_background"];
        // 1.添加原创微博
        JYJStatusOriginalView *originalView = [[JYJStatusOriginalView alloc] init];
        [self addSubview:originalView];
        self.originalView = originalView;

        
        // 2.添加转发微博
        JYJStatusRetweetedView *reweetedView = [[JYJStatusRetweetedView alloc] init];
        [self addSubview:reweetedView];
        self.retweetedView = reweetedView;
    }
    return self;
}


- (void)setDetailFrame:(JYJStatusDetailFrame *)detailFrame
{
    _detailFrame = detailFrame;
    
    self.frame = detailFrame.frame;
    
    // 1.设置原创微博的frame
    self.originalView.originalFram = detailFrame.originalFrame;
    
    // 2.设置转发微博的frame
    self.retweetedView.retweetedFrame = detailFrame.retweetedFrame;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
