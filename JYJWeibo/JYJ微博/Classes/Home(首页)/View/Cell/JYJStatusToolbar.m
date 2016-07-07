//
//  JYJStatusToolbar.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusToolbar.h"
#import "JYJStatus.h"

@interface JYJStatusToolbar()
@property (nonatomic, strong) NSMutableArray *btns;

@property (nonatomic, strong) NSMutableArray *dividers;
@property (nonatomic, weak) UIButton *repostsBtn;
@property (nonatomic, weak) UIButton *commentsBtn;
@property (nonatomic, weak) UIButton *attitudesBtn;

@end

@implementation JYJStatusToolbar
- (NSMutableArray *)btns
{
    if (!_btns) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
- (NSMutableArray *)dividers
{
    if (!_dividers) {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImage:@"timeline_card_bottom_background"];
        
        self.repostsBtn = [self setupBtnWithIcon:@"timeline_icon_retweet" title:@"转发"];
        self.commentsBtn = [self setupBtnWithIcon:@"timeline_icon_comment" title:@"评论"];
        self.attitudesBtn = [self setupBtnWithIcon:@"timeline_icon_unlike" title:@"赞"];
        
        [self setupDivider];
        [self setupDivider];

    }
    return self;
}
/**
 *  分割线
 */
- (void)setupDivider
{
    UIImageView *divider = [[UIImageView alloc] init];
    divider.image = [UIImage imageWithName:@"timeline_card_bottom_line"];
    divider.contentMode = UIViewContentModeCenter;
    [self addSubview:divider];
    [self.dividers addObject:divider];
}

/**
 *  添加按钮
 *
 *  @param icon  图标
 *  @param title 标题
 */
- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 设置高亮时候的背景
    [btn setBackgroundImage:[UIImage resizedImage:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置间距
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self addSubview:btn];
    [self.btns addObject:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 1.设置按钮frame
    NSUInteger btnCount = self.btns.count;
    CGFloat btnH = self.height;
    CGFloat btnW = self.width / btnCount;
    for (int i = 0; i< btnCount; i++) {
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.height = btnH;
        btn.width = btnW;
        btn.x = i * btn.width;
    }
    //分割线frame
    int dividerCount = self.dividers.count;
    for (int i = 0; i < dividerCount; i++) {
        UIImageView *divider = self.dividers[i];
        divider.height = btnH;
        divider.width = 4;
        divider.centerX = (i + 1) * btnW;
        divider.centerY = btnH * 0.5;
    }

}

- (void)setStatus:(JYJStatus *)status
{

    _status = status;
    
//     status.reposts_count = 111110111;
   
    [self setBtnTitle:self.repostsBtn count:status.reposts_count defaultTitle:@"转发"];
    [self setBtnTitle:self.commentsBtn count:status.comments_count defaultTitle:@"评论"];
    [self setBtnTitle:self.attitudesBtn count:status.attitudes_count defaultTitle:@"赞"];

}

- (void)setBtnTitle:(UIButton *)btn count:(int)count defaultTitle:(NSString *)defaultTitle
{
   
    if (count >= 10000) {
        defaultTitle = [NSString stringWithFormat:@"%0.1f万", count / 10000.0];
        defaultTitle = [defaultTitle stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }else if (count > 0)
    {   defaultTitle = [NSString stringWithFormat:@"%d", count];
        
    }

    [btn setTitle:defaultTitle forState:UIControlStateNormal];

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
