//
//  JYJStatus.m
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatus.h"
#import "MJExtension.h"
#import "JYJPhoto.h"
#import "NSDate+MJ.h"
#import "RegexKitLite.h"
#import "JYJRegexResult.h"
#import "JYJEmotionAttachment.h"
#import "JYJEmotionTool.h"
#import "JYJUser.h"

@implementation JYJStatus

- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [JYJPhoto class]};
}

/**
 一、今年
 1、今天
 1分钟内：刚刚
 1个小时内：xx分钟前
 
 2、昨天
 昨天 xx:xx
 
 3、至少是前天发的
 04-23 xx:xx
 
 二、非今年
 2012-07-24
 */
- (NSString *)created_at
{
    JYJLog(@"%@", _created_at);
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    // 微博发布的具体时间
    NSDate *createdDate = [fmt dateFromString:_created_at];
    
    // 判断是否是今年
    if (createdDate.isThisYear) {
        if (createdDate.isToday) { // 是否是今天
            NSDateComponents *cmps = [createdDate deltaWithNow];
            if (cmps.hour >= 1) { // 至少是一小时前发的
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            }else if (cmps.minute >= 1){ // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            }else{
            return @"刚刚";
            }
        }else if(createdDate.isYesterday){ //昨天
        fmt.dateFormat = @"昨天 HH:mm";
         return [fmt stringFromDate:createdDate];
        }else{ // 只是是前天发的
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createdDate];
        }
    }else{ // 非今年
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:createdDate];
    }
}
/**
 * 重写set方法是为了只掉一次  
 */
- (void)setSource:(NSString *)source
{
    if (source.length > 0) {
        NSRange range;
        range.location = [source rangeOfString:@">"].location + 1;
        range.length = [source rangeOfString:@"</"].location - range.location;
        // 开始截取
        NSString *subsource = [source substringWithRange:range];
        // 头部拼接一个“来自”
        _source = [NSString stringWithFormat:@"来自%@", subsource];
    } else  {
        _source = @"来自新浪微博";
    }
}

/**
 *  根据字符串计算出所有的匹配结果（已经排号序）
 *
 *  @param text 字符串内容
 */
- (NSArray *)regexResultWithText:(NSString *)text
{
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];

    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        JYJRegexResult *rr = [[JYJRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = YES;
        [regexResults addObject:rr];
    }];
    // 匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        JYJRegexResult *rr = [[JYJRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = NO;
        [regexResults addObject:rr];
    }];
    
    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(JYJRegexResult *rr1, JYJRegexResult *rr2) {
        int loc1 = rr1.range.location;
        int loc2 = rr2.range.location;
        return [@(loc1) compare:@(loc2)];

    }];
    return regexResults;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    [self createAttributedText];
}

- (void)setUser:(JYJUser *)user
{
    _user = user;
    [self createAttributedText];

}
- (void)setRetweeted_status:(JYJStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    self.retweeted = NO;
    retweeted_status.retweeted = YES;
}
- (void)setRetweeted:(BOOL)retweeted
{
    _retweeted = retweeted;
    [self createAttributedText];

}
- (void)createAttributedText
{
    if (self.text == nil || self.user == nil) return;
    if (self.retweeted) {
        NSString *totalText = [NSString stringWithFormat:@"@%@:%@", self.user.name, self.text];
        NSAttributedString *attributedString = [self attributedStringWithText:totalText];
        self.attributedText = attributedString;
    }else{
        self.attributedText = [self attributedStringWithText:self.text];
    }
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultWithText:text];
    // 根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(JYJRegexResult *result, NSUInteger idx, BOOL *stop) {
        JYJEmotion *emotion = nil;
        if (result.isEmotion) { // 表情
            emotion = [JYJEmotionTool emotionWithDesc:result.string];
        }
        if (emotion) { // 如果有表情
          
            // 创建附件对象
            JYJEmotionAttachment *attach = [[JYJEmotionAttachment alloc] init];
            
            // 传递表情
            attach.emotion = emotion;
            
            attach.bounds = CGRectMake(0, -3, JYJStatusOriginalTextFont.lineHeight, JYJStatusOriginalTextFont.lineHeight);
            
            // 将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString appendAttributedString:attachString];
        }else{ // 非表情（直接拼接普通文本）
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
            
            // 匹配#话题#
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [result.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:*capturedRanges];
                [substr addAttribute:JYJLinkText value:*capturedStrings range:*capturedRanges];
                
            }];
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+ ?";
            [result.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:JYJStatusHighTextColor range:*capturedRanges];
                 [substr addAttribute:JYJLinkText value:*capturedStrings range:*capturedRanges];
            }];
            // 匹配超链接
            NSString *httpRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [result.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:*capturedRanges];
                 [substr addAttribute:JYJLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            [attributedString appendAttributedString:substr];
        }
    }];
    
    // 设置富文本字体
    [attributedString addAttribute:NSFontAttributeName value:JYJStatusRichTextFont range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;

}
@end
