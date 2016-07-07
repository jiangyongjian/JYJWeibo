//
//  JYJCommonCell.h
//  JYJ微博
//
//  Created by JYJ on 15/3/30.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYJCommonItem;

@interface JYJCommonCell : UITableViewCell
+ (instancetype)cellWtihTableView:(UITableView *)tableView;
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows;

/**
 *  cell对应的item数据
 */
@property (nonatomic, strong) JYJCommonItem *item;
@end
