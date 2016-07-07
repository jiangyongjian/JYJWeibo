//
//  JYJStatusPhotosView.h
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJStatusPhotosView : UIView
/**
 *  图片数据（里面都是JYJPhoto模型）
 */
@property (nonatomic, strong) NSArray *pic_urls;
/**
 *  根据图片的个数计算相册的最终尺寸
 */
+ (CGSize)sizeWithPhotosCount:(int)count;
@end
