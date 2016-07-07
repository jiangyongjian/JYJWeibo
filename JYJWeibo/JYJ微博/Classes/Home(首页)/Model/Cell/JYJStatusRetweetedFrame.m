//
//  JYJStatusRetweetedFrame.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusRetweetedFrame.h"
#import "JYJStatus.h"
#import "JYJUser.h"
#import "JYJStatusPhotosView.h"

@implementation JYJStatusRetweetedFrame

- (void)setRetweetedStatus:(JYJStatus *)retweetedStatus
{
    _retweetedStatus = retweetedStatus;
    // 1.昵称
//    CGFloat nameX = 0.5 * JYJStatusCellInset;
//    CGFloat nameY = JYJStatusCellInset;
//    NSString *name = [NSString stringWithFormat:@"@%@", retweetedStatus.user.name];
//    CGSize nameSize = [name sizeWithFont:JYJStatusRetweetedNameFont];
//    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    
    // 2.正文
    CGFloat textX = JYJStatusCellInset;
    CGFloat textY =  0.5 * JYJStatusCellInset;
    CGFloat maxW = JYJScreenW - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [retweetedStatus.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.textFrame = (CGRect){{textX, textY}, textSize};
    
    // 3.配图相册
    CGFloat h = 0;
    if (retweetedStatus.pic_urls.count) { //
        CGFloat photosX = textX;
        CGFloat photosY = CGRectGetMaxY(self.textFrame) + JYJStatusCellInset;
        CGSize photosSize = [JYJStatusPhotosView sizeWithPhotosCount:retweetedStatus.pic_urls.count];
        self.photosFrame = (CGRect){{photosX, photosY}, photosSize};
        h = CGRectGetMaxY(self.photosFrame) + JYJStatusCellInset;
    }else{
        h = CGRectGetMaxY(self.textFrame) + JYJStatusCellInset;
    }
    
    
    // 自己的frame
    CGFloat x = 0;
    CGFloat y = 0; // 高度 = 原创微博最大的Y值，在这里设置是，没有用的
    CGFloat w = JYJScreenW;
    self.frame = CGRectMake(x, y, w, h);
    
}

@end
