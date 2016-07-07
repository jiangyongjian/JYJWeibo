//
//  JYJStatusCell.m
//  JYJ微博
//
//  Created by JYJ on 15/3/22.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJStatusCell.h"
#import "JYJStatusDetailView.h"
#import "JYJStatusToolbar.h"
#import "JYJStatusFrame.h"

@interface JYJStatusCell ()
@property (nonatomic, strong) JYJStatusDetailView *detailView;
@property (nonatomic, strong) JYJStatusToolbar *toolbar;
@end

@implementation JYJStatusCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"status";
    JYJStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JYJStatusCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子控件
        // 1.添加微博具体内容
        JYJStatusDetailView *detailView = [[JYJStatusDetailView alloc] init];
        [self.contentView addSubview:detailView];
        self.detailView = detailView;
        // 2.添加工具条
        JYJStatusToolbar *toolbar = [[JYJStatusToolbar alloc] init];
        [self.contentView addSubview:toolbar];
        self.toolbar = toolbar;
        
        // 3.cell的设置
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setStatusFrame:(JYJStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 1.微博具体内容的frame
    self.detailView.detailFrame = statusFrame.detailFrame;
    
    // 2.底部工具条的frame数据
    self.toolbar.frame = statusFrame.toobarFrame;
    self.toolbar.status = statusFrame.status;

}

@end
