//
//  JYJComposePhotosView.h
//  JYJ微博
//
//  Created by JYJ on 15/3/20.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYJComposePhotosView : UIView


/**
 *  添加一张图片到相册内部
 *
 *  @param image 新添加的图片
 */
- (void)addImage:(UIImage *)image;

- (NSArray *)images;
@end
