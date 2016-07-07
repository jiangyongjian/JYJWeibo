//
//  JYJStatusDetailFrame.h
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYJStatus, JYJStatusOriginalFrame, JYJStatusRetweetedFrame;
@interface JYJStatusDetailFrame : NSObject
@property (nonatomic, strong) JYJStatusOriginalFrame *originalFrame;
@property (nonatomic, strong) JYJStatusRetweetedFrame *retweetedFrame;
/** 微博数据 */
@property (nonatomic, strong) JYJStatus *status;

/**
 *  自己的frame
 */
@property (nonatomic, assign) CGRect frame;
@end
