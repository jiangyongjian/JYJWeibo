//
//  JYJStatusRetweetedView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusRetweetedView.h"
#import "JYJStatusRetweetedFrame.h"
#import "JYJStatus.h"
#import "JYJUser.h"
#import "JYJStatusPhotosView.h"
#import "JYJStatusLable.h"
@interface JYJStatusRetweetedView ()
/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameLable;
/**
 *  正文
 */
@property (nonatomic, weak) JYJStatusLable *textLable;
/** 配图 */
@property (nonatomic, weak) JYJStatusPhotosView *photosView;
@end
@implementation JYJStatusRetweetedView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage resizedImage:@"timeline_retweet_background"];
        // 1.昵称
//        UILabel *nameLable = [[UILabel alloc] init];
//        nameLable.font = JYJStatusRetweetedNameFont;
//        nameLable.textColor = JYJStatusHighTextColor;
//        [self addSubview:nameLable];
//        self.nameLable = nameLable;
        
        // 2.正文
        JYJStatusLable *textLable = [[JYJStatusLable alloc] init];
        [self addSubview:textLable];
        self.textLable = textLable;
        
        // 7.配图
        JYJStatusPhotosView *photosView = [[JYJStatusPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;

    }
    return self;
}

- (void)setRetweetedFrame:(JYJStatusRetweetedFrame *)retweetedFrame
{
    _retweetedFrame = retweetedFrame;
    self.frame = retweetedFrame.frame;
    // 取出微博数据
    JYJStatus *retweetedStatus = retweetedFrame.retweetedStatus;
    
    // 取出用户数据
//    JYJUser *user = retweetedStatus.user;
//    
//    // 1.昵称
//    self.nameLable.text = [NSString stringWithFormat:@"@%@", user.name];
//    self.nameLable.frame = retweetedFrame.nameFrame;
    
    // 2.正文
//    self.textLable.text = retweetedStatus.text;
    self.textLable.attributedText = retweetedStatus.attributedText;
    self.textLable.frame = retweetedFrame.textFrame;
    
    
    // 6.配图
    if (retweetedStatus.pic_urls.count) { // 有配图
        self.photosView.frame = retweetedFrame.photosFrame;
        self.photosView.pic_urls = retweetedStatus.pic_urls;
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
