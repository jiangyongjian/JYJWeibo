//
//  JYJCommonCell.m
//  JYJ微博
//
//  Created by JYJ on 15/3/30.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJCommonCell.h"
#import "JYJCommonItem.h"
#import "JYJCommonArrowItem.h"
#import "JYJCommonLableItem.h"
#import "JYJCommonSwitchItem.h"
#import "JYJBadgeView.h"

@interface JYJCommonCell ()
/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *rightArrow;
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *rightSwitch;
/**
 *  标签
 */
@property (nonatomic, strong) UILabel *rightLabel;
/**
 *  提醒文字
 */
@property (nonatomic, strong) JYJBadgeView *badgeView;

@end
@implementation JYJCommonCell
#pragma mark - 懒加载右边的View
- (UIImageView *)rightArrow
{
    if (!_rightArrow) {
        _rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"common_icon_arrow"]];
    }
    return _rightArrow;
}
- (UISwitch *)rightSwitch
{
    if (!_rightSwitch) {
        _rightSwitch = [[UISwitch alloc] init];
    }
    return _rightSwitch;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        self.rightLabel.font = [UIFont systemFontOfSize:13];
        self.rightLabel.textColor = [UIColor grayColor];
    }
    return _rightLabel;
}

- (JYJBadgeView *)badgeView
{
    if (!_badgeView) {
        self.badgeView = [[JYJBadgeView alloc] init];
    }
    return _badgeView;
}

#pragma mark 初始化
+ (instancetype)cellWtihTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    JYJCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[JYJCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }

    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 设置标题的字体
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        // 去除cell默认的背景色
        self.backgroundColor = [UIColor clearColor];
        
        // 设置背景view
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
    }
    return self;
}
#pragma mark - setter
- (void)setIndexPath:(NSIndexPath *)indexPath rowsInSection:(int)rows
{
    // 1.取出背景View
    UIImageView *bgView = (UIImageView *)self.backgroundView;
    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    
    // 2.设置背景图片
    if (rows == 1) {
        bgView.image = [UIImage resizedImage:@"common_card_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
    }else if (indexPath.row == 0){ // 首行
        bgView.image = [UIImage resizedImage:@"common_card_top_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_top_background_highlighted"];
    } else if (indexPath.row == rows - 1) { //末行
        bgView.image = [UIImage resizedImage:@"common_card_bottom_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_bottom_background_highlighted"];
    } else { // 中间
        bgView.image = [UIImage resizedImage:@"common_card_middle_background"];
        selectedBgView.image = [UIImage resizedImage:@"common_card_middle_background_highlighted"];
    }
}

- (void)setItem:(JYJCommonItem *)item
{
    _item = item;
    // 1.基本数据
    self.imageView.image = [UIImage imageWithName:item.icon];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subtitle;
    
    // 2.设置右边的内容
    if (item.badgeValue) {
        self.badgeView.badgeValue = item.badgeValue;
        self.accessoryView = self.badgeView;
    }else if ([item isKindOfClass:[JYJCommonArrowItem class]]){
        self.accessoryView = self.rightArrow;
    }else if ([item isKindOfClass:[JYJCommonSwitchItem class]]){
        self.accessoryView = self.rightSwitch;
    } else if ([item isKindOfClass:[JYJCommonLableItem class]]){
        JYJCommonLableItem *labelItem = (JYJCommonLableItem *)item;
        self.rightLabel.text = labelItem.text;
        
        // 根据文字计算尺寸
        self.rightLabel.size = [labelItem.text sizeWithFont:self.rightLabel.font];
        self.accessoryView = self.rightLabel;
    }else{ // 取消右边的内容, 不然会出现循环利用的
        self.accessoryView = nil;
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.detailTextLabel.x = CGRectGetMaxX(self.textLabel.frame) + 5;
}

@end
