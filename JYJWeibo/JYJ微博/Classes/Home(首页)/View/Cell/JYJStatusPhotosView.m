//
//  JYJStatusPhotosView.m
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusPhotosView.h"
#import "JYJStatusPhotoView.h"
#import "UIImageView+WebCache.h"
#import "JYJPhoto.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define JYJStatusPhotosMaxCount 9
#define JYJStatusPhotoMaxCols(photosCount) ((photosCount == 4)?2:3)
#define JYJStatusPhotoW 70
#define JYJStatusPhotoH JYJStatusPhotoW
#define JYJStatusPhotoMargin 10

@interface JYJStatusPhotosView ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, assign) CGRect lastFrame;
@end

@implementation JYJStatusPhotosView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.userInteractionEnabled = YES;
        // 预先创建9个图片控件
        for (int i = 0; i < JYJStatusPhotosMaxCount; i++) {
            JYJStatusPhotoView *photoView = [[JYJStatusPhotoView alloc] init];
            photoView.tag = i;
            [self addSubview:photoView];
            
            // 添加手势监听器（一个手势监听器， 只能对应一个View）
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
            [recognizer addTarget:self action:@selector(tapPhoto:)];
            [photoView addGestureRecognizer:recognizer];
        }
    }
    return self;
}

/**
 *  监听图片的点击
 */
- (void)tapPhoto:(UITapGestureRecognizer *)recognizer
{
    // 1.创建图片浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    
    // 2.设置图片浏览器显示的所有图片
    NSMutableArray *photos = [NSMutableArray array];
    int count = self.pic_urls.count;
    for (int i = 0; i < count; i++) {
        JYJPhoto *pic = self.pic_urls[i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        // 设置图片的路径
        photo.url = [NSURL URLWithString:pic.bmiddle_pic];
        // 设置来源于哪一个UIImageView
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    browser.photos = photos;
    
    // 3.设置默认显示的图片索引
    browser.currentPhotoIndex = recognizer.view.tag;
    
    // 4.显示浏览器
    [browser show];
}


- (void)setPic_urls:(NSArray *)pic_urls
{
    _pic_urls = pic_urls;
    
    for (int i = 0; i < JYJStatusPhotosMaxCount; i++) {
        JYJStatusPhotoView *photoView = self.subviews[i];
        if (i < pic_urls.count) { // 显示图片
            photoView.photo = pic_urls[i];
            photoView.hidden = NO;
        }else {
            photoView.hidden = YES ;
        }
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    int count = self.pic_urls.count;
    int maxCols = JYJStatusPhotoMaxCols(count);
    for (int i = 0; i < count; i++) {
        JYJStatusPhotoView *photoView = self.subviews[i];
        photoView.width = JYJStatusPhotoW;
        photoView.height = JYJStatusPhotoH;
        photoView.x = (JYJStatusPhotoMargin + JYJStatusPhotoW) * (i % maxCols);
        photoView.y = (JYJStatusPhotoMargin + JYJStatusPhotoH) * (i / maxCols);
    }
}

+ (CGSize)sizeWithPhotosCount:(int)photosCount
{
    // 一行最多多少列
    int maxCols = JYJStatusPhotoMaxCols(photosCount);
    
    // 总列数
    int totalCols = photosCount >= maxCols ? maxCols : photosCount;
    
    // 总行数
    // 知道总个数
    // 知道每一页最多显示多少个
    // 能算出一共能显示多少页
    int totalRows = (photosCount + (maxCols - 1))/ maxCols;
    
    // 计算尺寸
    CGFloat photosW = JYJStatusPhotoW * totalCols + (totalCols -1) * JYJStatusPhotoMargin;
    CGFloat photosH = (totalRows - 1) * JYJStatusPhotoMargin + JYJStatusPhotoH * totalRows;
    return CGSizeMake(photosW, photosH);

}

@end
