//
//  JYJStatusPhotoView.h
//  JYJ微博
//
//  Created by JYJ on 15/3/24.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//  一个HMStatusPhotoView代表1张配图

#import <UIKit/UIKit.h>
@class JYJPhoto;
@interface JYJStatusPhotoView : UIImageView
@property (nonatomic, strong) JYJPhoto *photo;
@end
