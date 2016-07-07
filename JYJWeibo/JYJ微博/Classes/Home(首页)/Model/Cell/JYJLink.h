//
//  JYJLink.h
//  JYJ微博
//
//  Created by JYJ on 15/3/30.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJLink : NSObject
/**
 *  链接文字
 */
@property (nonatomic, copy) NSString *text;
/**
 *  链接范围
 */
@property (nonatomic, assign) NSRange range;
/**
 *  链接边框
 */
@property (nonatomic, strong) NSArray *rects;
@end
