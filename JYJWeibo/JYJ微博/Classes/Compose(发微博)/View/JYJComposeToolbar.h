//
//  JYJComposeToolbar.h
//  JYJ微博
//
//  Created by JYJ on 15/3/19.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    JYJComposeToolbarButtonTypeCamera, // 照相机
    JYJComposeToolbarButtonTypePicture, // 相册
    JYJComposeToolbarButtonTypeMention, // 提到@
    JYJComposeToolbarButtonTypeTrend, // 话题
    JYJComposeToolbarButtonTypeEmotion, // 表情
}JYJComposeToolbarButtonType;

@class JYJComposeToolbar;

@protocol JYJComposeToolbarDelegate <NSObject>

@optional
- (void)composeToolbar:(JYJComposeToolbar *)toolBar didClickButton:(JYJComposeToolbarButtonType)buttonType;

@end

@interface JYJComposeToolbar : UIView
@property (nonatomic, weak) id<JYJComposeToolbarDelegate> delegate;


/**
 *  设置某个按钮的图片
 *
 *  @param image      图片名
 *  @param buttonType 按钮类型
 */
//- (void)setButtonImage:(NSString *)image buttonType:(HMComposeToolbarButtonType)buttonType;

@property (nonatomic, assign, getter = isShowEmotionButton) BOOL showEmotionButton;
@end
