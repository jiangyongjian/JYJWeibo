//
//  JYJStatusFrame.h
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYJStatusDetailFrame, JYJStatus;

@interface JYJStatusFrame : NSObject
/**
 *  子控件的frame数据
 */
@property (nonatomic, strong) JYJStatusDetailFrame *detailFrame;
@property (nonatomic, assign) CGRect toobarFrame;

/**
 *  返回自己的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  微博的数据
 */
@property (nonatomic, strong) JYJStatus *status;
@end
