//
//  JYJHomeStatusesResult.h
//  JYJ微博
//
//  Created by JYJ on 15/3/21.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYJHomeStatusesResult : NSObject
/**
 *  微博数组（装着JYJStatus模型）
 */
@property (nonatomic, strong) NSArray *statuses;

/**
 *  经期微博的总数
 */
@property (nonatomic, assign) int total_number;
@end
