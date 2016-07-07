//
//  JYJStatusOriginalView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusOriginalView.h"
#import "JYJStatusOriginalFrame.h"
#import "JYJStatus.h"
#import "JYJUser.h"
#import "UIImageView+WebCache.h"
#import "JYJStatusPhotosView.h"
#import "JYJStatusLable.h"

@interface JYJStatusOriginalView ()
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLable;
/** 正文 */
@property (nonatomic, weak) JYJStatusLable *textLable;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLable;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLable;

/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, weak) JYJStatusPhotosView *photosView;

@end
@implementation JYJStatusOriginalView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        // 1.昵称
        UILabel *nameLable = [[UILabel alloc] init];
        nameLable.font = JYJStatusOriginalNameFont;
        [self addSubview:nameLable];
        self.nameLable = nameLable;
        
        // 2.正文
        JYJStatusLable *textLable = [[JYJStatusLable alloc] init];
        [self addSubview:textLable];
        self.textLable = textLable;
        
        // 3.时间
        UILabel *timeLable = [[UILabel alloc] init];
        timeLable.font = JYJStatusOriginalTimeFont;
        timeLable.textColor = [UIColor orangeColor];
        [self addSubview:timeLable];
        self.timeLable = timeLable;
        
        // 4.来源
        UILabel *sourceLable = [[UILabel alloc] init];
        sourceLable.font = JYJStatusOriginalTimeFont;
        sourceLable.textColor = [UIColor lightGrayColor];
        [self addSubview:sourceLable];
        self.sourceLable = sourceLable;
        
        // 5头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        // 6会员图标
        UIImageView *vipView = [[UIImageView alloc] init];
        vipView.contentMode = UIViewContentModeCenter;
        [self addSubview:vipView];
        self.vipView = vipView;
        
        // 7.配图
        JYJStatusPhotosView *photosView = [[JYJStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
    }
    return self;
}
- (void)setOriginalFram:(JYJStatusOriginalFrame *)originalFram
{
    _originalFram = originalFram;
    
    self.frame = originalFram.frame;
    
    // 取出微博数据
    JYJStatus *status = originalFram.status;
    
    // 取出用户数据
    JYJUser *user = status.user;
    
    
    // 1.昵称
    self.nameLable.text = user.name;
    self.nameLable.frame = originalFram.nameFrame;
    if (user.isVip) { // 会员
        self.nameLable.textColor = [UIColor orangeColor];
        self.vipView.hidden = NO;
        self.vipView.frame = originalFram.vipFrame;
        self.vipView.image = [UIImage imageWithName:[NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank]];
    }else{
        self.vipView.hidden = YES;
        self.nameLable.textColor = [UIColor blackColor];
    }
    
    // 2.正文
//    self.textLable.text = status.text;
    self.textLable.attributedText = status.attributedText;
    self.textLable.frame = originalFram.textFrame;

    
#warning 需要时刻根据现在的时间字符串来计算时间label的frame
    // 3.时间
    //    self.sourceLable.frame = CGRectMake(sourceX, sourceY, sourceSize.width, sourceSize.height);
    NSString *time = status.created_at;
    self.timeLable.text = time;
    CGFloat timeX = CGRectGetMinX(self.nameLable.frame);
    CGFloat timeY = CGRectGetMaxY(self.nameLable.frame) + 0.5 * JYJStatusCellInset;
    CGSize timeSize = [time sizeWithFont:JYJStatusOriginalTimeFont];
  
    self.timeLable.frame = (CGRect){{timeX, timeY}, timeSize};
    
    // 4.来源
    self.sourceLable.text = status.source;
    CGFloat sourceX = CGRectGetMaxX(self.timeLable.frame) + JYJStatusCellInset;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:JYJStatusOriginalSourceFont];
    self.sourceLable.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    // 5.头像
    self.iconView.frame = originalFram.iconFrame;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
   // 6.配图
    if (status.pic_urls.count) { // 有配图
        self.photosView.frame = originalFram.photosFrame;
        self.photosView.pic_urls = status.pic_urls;
        self.photosView.hidden = NO;
    }else { //没有配图
        self.photosView.hidden = YES;
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
