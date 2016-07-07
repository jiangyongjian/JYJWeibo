//
//  JYJDiscoverViewController.m
//  JYJ微博
//
//  Created by JYJ on 15/3/11.
//  Copyright (c) 2015年 JYJ. All rights reserved.
//

#import "JYJDiscoverViewController.h"
#import "JYJSearchBar.h"
#import "JYJCommonCell.h"
#import "JYJCommonGroup.h"
#import "JYJCommonItem.h"
#import "JYJCommonArrowItem.h"
#import "JYJCommonLableItem.h"
#import "JYJCommonSwitchItem.h"

@interface JYJDiscoverViewController ()
@property (nonatomic, strong) NSMutableArray *groups;
/** searchBar */
@property (nonatomic, weak) JYJSearchBar *searchBar;
@end

@implementation JYJDiscoverViewController

/**
 *  用一个组模型来描述每组的头信息，尾信息，这组的所有行模型
 *  用一个模型来描述每行的信息：图标、标题、子标题、右边的样子（箭头、文字、数字、开关、打钩）
 */

- (NSMutableArray *)groups
{
    if (!_groups) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}
/**
 *  屏蔽tableView的样式
 */
- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JYJSearchBar *searchBar = [[JYJSearchBar alloc] init];
    searchBar.width = 300;
    searchBar.height = 30;
    self.navigationItem.titleView = searchBar;
    self.searchBar = searchBar;
    
    // 设置tableView的属性
    self.tableView.backgroundColor = JYJGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = JYJStatusCellMargin;
    self.tableView.contentInset = UIEdgeInsetsMake( JYJStatusCellMargin - 35 , 0, 0, 0);
    // 初始化组模型
    [self setupGroups];
}

- (void)setupGroups
{
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}


- (void)setupGroup0
{
    // 1.创建组
    JYJCommonGroup *group = [JYJCommonGroup group];
    [self.groups addObject:group];
    // 2.设置组的基本数据
    group.header = @"第0组头部";
    group.footer = @"第0组尾部的详细信息";
    
    JYJCommonArrowItem *hotStatus = [JYJCommonArrowItem itemWithTitle:@"热门微博" icon:@"hot_status"];
    hotStatus.subtitle = @"笑话，娱乐，神最右都搬到这啦";
    JYJCommonItem *findPeople = [JYJCommonItem itemWithTitle:@"找人" icon:@"find_people"];
    findPeople.badgeValue = @"10";
    findPeople.subtitle = @"名人、有意思的人尽在这里";
    group.items = @[hotStatus, findPeople];
}
- (void)setupGroup1
{
    // 1.创建组
    JYJCommonGroup *group = [JYJCommonGroup group];
    [self.groups addObject:group];
    // 2.设置组的所有行数据
    JYJCommonItem *gameCenter = [JYJCommonItem itemWithTitle:@"游戏中心" icon:@"game_center"];
    JYJCommonLableItem *near = [JYJCommonLableItem itemWithTitle:@"周边" icon:@"near"];
    near.text = @"我爱你哦";
    JYJCommonSwitchItem *app = [JYJCommonSwitchItem itemWithTitle:@"应用" icon:@"app"];
    app.badgeValue = @"N";
    group.items = @[gameCenter, near, app];
}
- (void)setupGroup2
{
    // 1.创建组
    JYJCommonGroup *group = [JYJCommonGroup group];
    [self.groups addObject:group];
    // 2.设置组的所有行数据
    JYJCommonSwitchItem *video = [JYJCommonSwitchItem itemWithTitle:@"视频" icon:@"video"];
    video.badgeValue = @"1";
    JYJCommonSwitchItem *music = [JYJCommonSwitchItem itemWithTitle:@"音乐" icon:@"music"];
    JYJCommonItem *movie = [JYJCommonItem itemWithTitle:@"电影" icon:@"movie"];
    movie.subtitle = @"(10)";
    JYJCommonItem *cast = [JYJCommonItem itemWithTitle:@"播客" icon:@"cast"];
    cast.badgeValue = @"1000";
    JYJCommonArrowItem *more = [JYJCommonArrowItem itemWithTitle:@"更多" icon:@"more"];
    
    group.items = @[video, music, movie, cast, more];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    JYJCommonGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建cell
    JYJCommonCell *cell = [JYJCommonCell cellWtihTableView:tableView];
    // 取出模型，传递数据
    JYJCommonGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    
    // 设置cell所处的行号
    [cell setIndexPath:indexPath rowsInSection:group.items.count];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

@end
