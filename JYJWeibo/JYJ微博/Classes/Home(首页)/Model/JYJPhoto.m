//
//  JYJPhoto.m
//  JYJ微博
//
//  Created by JYJ on 15/3/18.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJPhoto.h"

@implementation JYJPhoto

- (void)setThumbnail_pic:(NSString *)thumbnail_pic
{
    _thumbnail_pic = thumbnail_pic;
    self.bmiddle_pic = [thumbnail_pic
        stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
}
@end
