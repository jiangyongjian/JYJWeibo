//
//  JYJStatusRetweetedFrame.h
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYJStatus;
@interface JYJStatusRetweetedFrame : NSObject
/** 昵称 */
@property (nonatomic, assign) CGRect nameFrame;
/** 正文 */
@property (nonatomic, assign) CGRect textFrame;

/** 自己的frame */
@property (nonatomic, assign) CGRect frame;

/** 转发微博的数据 */
@property (nonatomic, strong) JYJStatus *retweetedStatus;

/** 配图相册 */
@property (nonatomic, assign) CGRect photosFrame;
@end
