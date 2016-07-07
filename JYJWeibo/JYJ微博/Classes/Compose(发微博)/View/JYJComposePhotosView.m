//
//  JYJComposePhotosView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/20.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJComposePhotosView.h"

@implementation JYJComposePhotosView



- (void)addImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int count = self.subviews.count;
    // 一行最大列数
    int maxColsPerRow = 4;
    
    CGFloat margin = 10;
    
    CGFloat imageViewW = (self.width - (maxColsPerRow + 1) * margin) /  maxColsPerRow;
    CGFloat imageViewH = imageViewW;
    
    for (int i = 0; i < count; i++) {
        // 行号
        int row = i / maxColsPerRow;
        // 列号
        int col = i % maxColsPerRow;
        UIImageView *imageView = self.subviews[i];
        imageView.x = margin + col * (margin + imageViewW);
        imageView.y = row * (margin + imageViewH);
        imageView.width = imageViewW;
        imageView.height = imageViewH;
    }

}
- (NSArray *)images
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (UIImageView *imageView in self.subviews) {
        [array addObject:imageView.image];
    }
    return array;
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
