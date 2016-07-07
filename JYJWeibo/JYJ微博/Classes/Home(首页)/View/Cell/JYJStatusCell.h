//
//  JYJStatusCell.h
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYJStatusFrame.h"

@interface JYJStatusCell : UITableViewCell

@property (nonatomic, strong) JYJStatusFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
