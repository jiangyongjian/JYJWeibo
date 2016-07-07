//
//  JYJEmotion.h
//  JYJ微博
//
//  Created by JYJ on 15/3/26.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJEmotion : NSObject <NSCoding>
/**
 *  表情文字描述
 */
@property (nonatomic, copy) NSString *chs;
/**
 *  表情文字描述繁体
 */
@property (nonatomic, copy) NSString *cht;
/**
 *  表情的png图片名
 */
@property (nonatomic, copy) NSString *png;
/**
 *  Emoji表情的编码
 */
@property (nonatomic, copy) NSString *code;

/**
 *  emoji表情的字符
 */
@property (nonatomic, copy) NSString *emoji;
/**
 *  表情的存放文件及\目录
 */
@property (nonatomic, copy) NSString *directory;
@end
