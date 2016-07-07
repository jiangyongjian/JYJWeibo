//
//  JYJStatusOriginalFrame.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusOriginalFrame.h"
#import "JYJStatus.h"
#import "JYJUser.h"
#import "JYJStatusPhotosView.h"

@implementation JYJStatusOriginalFrame

- (void)setStatus:(JYJStatus *)status
{
    _status = status;
    // 1.头像
    CGFloat iconX = JYJStatusCellInset;
    CGFloat iconY = JYJStatusCellInset;
    CGFloat iconW = 35;
    CGFloat iconH = 35;
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 2.昵称
    CGFloat nameX = CGRectGetMaxX(self.iconFrame) + JYJStatusCellInset;
    CGFloat nameY = iconY;
    CGSize nameSize = [status.user.name sizeWithFont:JYJStatusOriginalNameFont];
    self.nameFrame = (CGRect){{nameX, nameY}, nameSize};
    
    if (status.user.isVip) { // 计算会员图标的位置
        CGFloat vipX = CGRectGetMaxX(self.nameFrame) + JYJStatusCellInset;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = vipH;
        self.vipFrame = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    // 5.正文
    CGFloat textX = iconX;
    CGFloat textY = CGRectGetMaxY(self.iconFrame) + 0.5 *JYJStatusCellInset;
    CGFloat maxW = JYJScreenW - 2 * textX;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [status.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
   self.textFrame = (CGRect){{textX, textY}, textSize};
    // 4.配图相册
    CGFloat h = 0;
    if (status.pic_urls.count) { //
        CGFloat photosX = textX;
        CGFloat photosY = CGRectGetMaxY(self.textFrame) + JYJStatusCellInset;
        
        CGSize photosSize = [JYJStatusPhotosView sizeWithPhotosCount:status.pic_urls.count];
        self.photosFrame = (CGRect){{photosX, photosY}, photosSize};
        h = CGRectGetMaxY(self.photosFrame) + JYJStatusCellInset;
    }else{
        h = CGRectGetMaxY(self.textFrame) + JYJStatusCellInset;
    }
    
    
    // 自己的frame
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = JYJScreenW;
    self.frame = CGRectMake(x, y, w, h);
}
@end
