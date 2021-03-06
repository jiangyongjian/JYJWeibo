//
//  JYJEmotion.m
//  JYJ微博
//
//  Created by JYJ on 15/3/26.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJEmotion.h"
#import "NSString+Emoji.h"

@implementation JYJEmotion
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@ - %@", self.chs, self.png, self.code];
}
/**
 *  将Emoji表情的code，16进制转换成中文
 */
- (void)setCode:(NSString *)code
{
    _code = [code copy];
    if (code == nil) return;
    self.emoji = [NSString emojiWithStringCode:code];
}

/**
 *  当从文件中解析出一个对象的时候调用
 *  在这个方法中写清楚：怎么解析文件中的数据
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.chs = [decoder decodeObjectForKey:@"chs"];
        self.cht = [decoder decodeObjectForKey:@"cht"];
        self.png = [decoder decodeObjectForKey:@"png"];
        self.code = [decoder decodeObjectForKey:@"code"];
        self.directory = [decoder decodeObjectForKey:@"directory"];
    }
    return self;
}
/**
 *  将对象写入文件的时候调用
 *  在这个方法中学清楚：要存储哪些对象的哪些属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.chs forKey:@"chs"];
    [encoder encodeObject:self.cht forKey:@"cht"];
    [encoder encodeObject:self.png forKey:@"png"];
    [encoder encodeObject:self.code forKey:@"code"];
    [encoder encodeObject:self.directory forKey:@"directory"];
}

- (BOOL)isEqual:(JYJEmotion *)otherEmotion
{
    if (self.code) { // emoji表情
        return [self.code isEqualToString:otherEmotion.code];
    }else{
        return [self.png isEqualToString:otherEmotion.png] && [self.chs isEqualToString:otherEmotion.chs] && [self.cht isEqualToString:otherEmotion.cht];
    }
}


@end
